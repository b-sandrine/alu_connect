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

## Query & index design

Firestore requires a composite index for every distinct combination of equality filters + `orderBy` on different fields. The opportunities list lets a user combine `type`, `category`, and `isRemote` filters simultaneously — supporting every combination server-side would need up to 8 composite indexes purely for that one screen, which is index-combinatorics overkill for this app's scale.

**Chosen approach — hybrid server/client filtering**:
- Server-side (Firestore query): `isActive == true`, optionally the **single most-recently-changed** structured filter (`type` **or** `category` **or** `isRemote`), `orderBy(createdAt desc)`, `.limit(pageSize)`.
- Client-side (applied to the already-small, already-filtered page): free-text search (Firestore can't do substring search natively regardless of index strategy), plus any *additional* structured filters beyond the one applied server-side.
- Pagination: the first page stays live via `.snapshots()` (realtime updates for the default view); subsequent pages are fetched once via `.get()` with a `startAfterDocument` cursor.

This needs exactly 4 composite indexes on `opportunities` (`isActive+createdAt`, `isActive+type+createdAt`, `isActive+category+createdAt`, `isActive+isRemote+createdAt`) plus one more for the startup's own postings list (`startupId+createdAt`), and 3 on `applications` (`applicantId+appliedAt`, `opportunityId+appliedAt`, `startupId+appliedAt`) — all captured in `firestore.indexes.json`.
