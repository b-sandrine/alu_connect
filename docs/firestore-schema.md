# Firestore Schema

Corresponding security rules: [`firestore.rules`](../firestore.rules). Composite indexes: [`firestore.indexes.json`](../firestore.indexes.json). Neither file is deployed yet — review before `firebase deploy --only firestore:rules,firestore:indexes`.

## Collections

### `users/{uid}`
Doc ID = Firebase Auth UID.

| Field | Type | Notes |
|---|---|---|
| `email` | string | immutable after creation |
| `displayName` | string | |
| `role` | string (`student` \| `startup`) | immutable after creation — drives all routing/access decisions |
| `photoUrl` | string? | |
| `hasCompletedOnboarding` | bool | |
| `createdAt` | timestamp | immutable |
| `fcmToken` | string? | current device's FCM push token |
| `fcmTokenUpdatedAt` | timestamp? | |
| `lastActiveAt` | timestamp? | presence heartbeat — see "Presence" below |

**Why it exists**: the auth-linked identity record and role gate the entire app's navigation (student vs. startup dashboards, protected routes). Kept minimal and immutable on the sensitive fields so a compromised client can't self-promote from student to startup.

### `opportunities/{id}`
Doc ID = auto-generated.

| Field | Type | Notes |
|---|---|---|
| `startupId` | string | owning user's UID |
| `startupName`, `startupLogoUrl` | string, string? | **denormalized** from `startup_profiles` |
| `title`, `description` | string | |
| `type` | string enum | internship / partTime / fullTime / contract / volunteer |
| `category` | string enum | engineering / design / marketing / business / research / other |
| `requiredSkills` | string[] | |
| `location`, `isRemote` | string, bool | |
| `deadline`, `createdAt`, `updatedAt` | timestamp | |
| `compensation` | string? | |
| `isActive` | bool | soft-delete flag; deletion sets this false rather than removing the doc |

**Why it exists**: the core listing students browse and startups manage. `startupName`/`startupLogoUrl` are denormalized onto every opportunity so rendering a list of cards never requires a join read back to `startup_profiles` — this is the single biggest read-reduction in the schema, since the opportunities list is the most-viewed screen in the app.

### `applications/{id}`
Doc ID = auto-generated.

| Field | Type | Notes |
|---|---|---|
| `opportunityId` | string | |
| `opportunityTitle` | string | **denormalized** |
| `startupId`, `startupName` | string | **denormalized** |
| `applicantId`, `applicantName` | string | |
| `coverLetter` | string | |
| `status` | string enum | `applied` -> `screening` -> `interview` -> `technicalAssessment` -> `offer` -> `accepted`; `rejected` reachable from any non-terminal stage. `pending` is a legacy alias for `applied`, kept only so documents written before the pipeline existed still parse. |
| `appliedAt` | timestamp | |
| `reviewedAt`, `reviewNote` | timestamp?, string? | set on every status change (reviewNote doubles as the reject/decline reason) |
| `statusHistory` | array of `{status, changedAt, note?}` | appended (never overwritten) on every transition — this is what powers the visual pipeline/tracker UI, not just the current `status` label |
| `interviewScheduledAt`, `interviewLocation`, `interviewNotes` | timestamp?, string?, string? | set when the startup schedules an interview |
| `offerNote` | string? | optional message accompanying an offer (stipend, start date, etc.) |

**Why it exists**: the join between a student and an opportunity. Denormalizing `opportunityTitle`/`startupName`/`applicantName` means both the student's "My Applications" list and the startup's "Applicants" list render directly from this one collection with no follow-up reads to `opportunities` or `users`.

**Transition validation**: strict stage-adjacency (e.g. you can't jump straight from `applied` to `offer`) is enforced in the app layer (`ApplicationController`), not in `firestore.rules` — Firestore's rules language isn't well-suited to expressing a full state machine, and over-fitting the rules to it risks fragile rules that block legitimate operations. The rules instead provide a coarser backstop: the owning startup can update a non-terminal application's status/history/interview/offer fields but never the applicant's original content (`applicantId`/`opportunityId`/`coverLetter`/`appliedAt`); a separate rule lets the applicant themselves flip `offer` -> `accepted`/`rejected` (responding to their own offer) and nothing else; `accepted`/`rejected` are immutable once set.

### `startup_profiles/{id}`
Doc ID = auto-generated (not the owner's UID — see below).

| Field | Type | Notes |
|---|---|---|
| `ownerId` | string | owning user's UID |
| `companyName`, `tagline`, `description` | string | |
| `industry`, `location` | string | |
| `website`, `logoUrl` | string? | |
| `isVerified` | bool | |
| `createdAt`, `updatedAt` | timestamp | |

**Why it exists, and why it's separate from `users`**: a startup's public-facing company page (logo, tagline, verification badge) has a different read audience — any student browsing — than the private auth record. Keeping it separate means `users/{uid}` stays small and rarely-read-by-others, while `startup_profiles` can grow richer (more fields, more public reads) without bloating the identity doc every client fetches on every auth check.

### `bookmarks/{uid}`
Doc ID = the bookmarking user's UID. One document per user.

| Field | Type | Notes |
|---|---|---|
| `opportunityIds` | string[] | array-in-doc, mutated via `arrayUnion`/`arrayRemove` |

**Why it exists**: kept separate from `users` purely so toggling a bookmark never rewrites the user's core profile doc (different write frequency, different concern).

**Known scaling ceiling**: this is an array-in-document design, not a subcollection. It's simple and cheap for realistic bookmark counts (tens per user) but has two real limits: (1) Firestore's 1MB document size cap bounds the array's practical size, and (2) there's no way to query "which users bookmarked opportunity X" without a different structure. If bookmark counts or that reverse-query need ever become real, migrate to `users/{uid}/bookmarks/{opportunityId}` subcollection docs (doc ID = opportunity ID, body = `{createdAt}`) — each bookmark becomes its own tiny doc, unbounded count, and a `collectionGroup('bookmarks')` query becomes possible for "most bookmarked" features. Not done this pass: it requires rewriting the bookmark datasource/repository/provider layer plus migrating any already-bookmarked users' data.

### `conversations/{id}`
Doc ID = **deterministic**: the two participants' UIDs, sorted and joined with `_` (not auto-generated) — makes "find or create the thread between these two users" a direct doc read instead of a query.

| Field | Type | Notes |
|---|---|---|
| `participantIds` | string[2] | `array-contains` powers "my conversations"; immutable after creation |
| `participantNames`, `participantPhotoUrls` | `{uid: string}`, `{uid: string?}` | **denormalized** — list screen never joins back to `users`/`startup_profiles` |
| `contextOpportunityId`, `contextOpportunityTitle` | string? | which opportunity/application prompted the thread, set once at creation, display-only |
| `lastMessageText`, `lastMessageSenderId`, `lastMessageAt` | string?, string?, timestamp? | **denormalized** preview — avoids reading the `messages` subcollection just to render the list |
| `lastReadAt` | `{uid: timestamp}` | powers both read receipts (compare a message's `sentAt` against the *other* participant's entry) and unread badges (`lastMessageAt > lastReadAt[myUid]`) — zero per-message writes |
| `typingUserIds`, `typingUpdatedAt` | string[], `{uid: timestamp}` | typing state lives on the conversation doc itself; the timestamp lets the UI treat entries older than ~5s as stale even if a crashed client never cleared them |
| `createdAt` | timestamp | |

**Why it exists**: one thread per (student, startup) pair, not per-opportunity — messaging the same startup about a second opportunity stays in the existing conversation, matching how real platforms work; `contextOpportunityId` just labels which conversation started why.

#### `conversations/{id}/messages/{id}`
| Field | Type | Notes |
|---|---|---|
| `senderId` | string | |
| `text`, `imageUrl` | string?, string? | exactly one is set per message |
| `sentAt` | timestamp | |

Immutable once sent (no edit/delete) — standard chat simplification. No per-message read tracking; read status is derived from the parent conversation's `lastReadAt`.

**Presence (online / last seen)**: reuses `users/{uid}.lastActiveAt` rather than a new collection or Realtime Database. A heartbeat writes it periodically while the app is foregrounded; "online" is computed client-side as "updated within the last 60s" wherever it's shown. This is deliberately approximate — a killed (not gracefully backgrounded) app can show "online" for up to the heartbeat window — chosen over adding Realtime Database's `onDisconnect()` (which would give accurate, server-detected presence) to avoid a second Firebase service, console setup step, and rules file for presence accuracy alone, given this app's scale.

## Query & index design

Firestore requires a composite index for every distinct combination of equality filters + `orderBy` on different fields. The opportunities list lets a user combine `type`, `category`, and `isRemote` filters simultaneously — supporting every combination server-side would need up to 8 composite indexes purely for that one screen, which is index-combinatorics overkill for this app's scale.

**Chosen approach — hybrid server/client filtering**:
- Server-side (Firestore query): `isActive == true`, optionally the **single most-recently-changed** structured filter (`type` **or** `category` **or** `isRemote`), `orderBy(createdAt desc)`, `.limit(pageSize)`.
- Client-side (applied to the already-small, already-filtered page): free-text search (Firestore can't do substring search natively regardless of index strategy), plus any *additional* structured filters beyond the one applied server-side.
- Pagination: the first page stays live via `.snapshots()` (realtime updates for the default view); subsequent pages are fetched once via `.get()` with a `startAfterDocument` cursor.

This needs exactly 4 composite indexes on `opportunities` (`isActive+createdAt`, `isActive+type+createdAt`, `isActive+category+createdAt`, `isActive+isRemote+createdAt`) plus one more for the startup's own postings list (`startupId+createdAt`), and 3 on `applications` (`applicantId+appliedAt`, `opportunityId+appliedAt`, `startupId+appliedAt`) — all captured in `firestore.indexes.json`.
