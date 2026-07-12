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
| `viewCount` | int | denormalized counter, incremented via `FieldValue.increment(1)` each time a student opens the detail screen — powers the startup analytics dashboard's "Most viewed" chart without a separate views collection or per-view document |

**Why it exists**: the core listing students browse and startups manage. `startupName`/`startupLogoUrl` are denormalized onto every opportunity so rendering a list of cards never requires a join read back to `startup_profiles` — this is the single biggest read-reduction in the schema, since the opportunities list is the most-viewed screen in the app.

**View counting rule**: a dedicated `firestore.rules` branch lets *any* signed-in user (not just the owning startup) update `opportunities/{id}`, but only if the diff touches `viewCount` alone and increments it by exactly 1 — every other field stays owner-only. This keeps the counter open to write without opening the rest of the document.

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
| `interviewScheduledAt`, `interviewLocation`, `meetingLink`, `interviewNotes` | timestamp?, string?, string?, string? | set when the startup schedules an interview; `meetingLink` is optional (in-person interviews leave it unset) |
| `offerNote` | string? | optional message accompanying an offer (stipend, start date, etc.) |

**Why it exists**: the join between a student and an opportunity. Denormalizing `opportunityTitle`/`startupName`/`applicantName` means both the student's "My Applications" list and the startup's "Applicants" list render directly from this one collection with no follow-up reads to `opportunities` or `users`.

**Upcoming Interviews / calendar integration**: the student profile's "Upcoming Interviews" section is a pure client-side derivation (`upcomingInterviewsProvider`) — filters the student's own applications to `status == interview && interviewScheduledAt` in the future, sorted soonest-first. No new collection. "Add to Calendar" builds a Google Calendar deep link (`calendar.google.com/calendar/render?action=TEMPLATE&...`) from the application's date/location/meeting link and opens it via `url_launcher`; this covers Google Calendar specifically rather than a universal `.ics` file, which would need either a backend endpoint or client-side file generation with platform-specific download handling.

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
| `founded` | int? | founding year |
| `startupStage` | string | one of `StartupProfileEntity.stages` (Idea/MVP/Seed/Series A/Series B+/Growth) |
| `companySize` | string | one of `StartupProfileEntity.companySizes` (1-10/11-50/51-200/201-500/500+) |
| `mission`, `vision`, `culture` | string | optional "About Startup" sub-sections, shown alongside `description` on the profile screen |
| `founders` | array of `{id, name, role, photoUrl?, linkedinUrl?, email?}` | embedded array, not a subcollection — founders are always read/written together with the profile, never queried independently |
| `teamMembers` | array of `{id, name, role, department, photoUrl?}` | same embedded-array reasoning as `founders` |
| `galleryImages` | array of `{id, url, category, uploadedAt}` | `category` is one of `office`/`events`/`products`/`achievements`; embedded rather than a subcollection for the same reason — the gallery is small (dozens of images, not thousands) and always rendered as a whole |
| `createdAt`, `updatedAt` | timestamp | |

**Founders/Team/Gallery as embedded arrays, not subcollections**: unlike bookmarks (which needed a subcollection specifically to enable a reverse "who bookmarked X" query), nothing here needs to be queried independently of its parent profile — a founder is never looked up on its own, so an embedded array keeps reads to the single profile fetch already happening, at the cost of the whole array being rewritten on every edit (acceptable at realistic counts: a handful of founders, tens of team members, dozens of gallery images, well under Firestore's 1MB document cap). Each item carries a client-generated `id` (via the `uuid` package) purely so the UI can target it for edit/remove within the array — Firestore never sees these ids as document ids.

**Storage paths**: `founder_photos/{profileId}/{founderId}.jpg`, `team_photos/{profileId}/{memberId}.jpg`, `startup_gallery/{profileId}/{imageId}.jpg` — all public-read, write-restricted to the owning startup via a `firestore.get()` cross-service check against `startup_profiles/{profileId}.ownerId` (same pattern as `chat_images`'s participant check).

**Why it exists, and why it's separate from `users`**: a startup's public-facing company page (logo, tagline, verification badge) has a different read audience — any student browsing — than the private auth record. Keeping it separate means `users/{uid}` stays small and rarely-read-by-others, while `startup_profiles` can grow richer (more fields, more public reads) without bloating the identity doc every client fetches on every auth check.

**Startup Profile module, Pass 1 (header + about)**: `founded`/`startupStage`/`companySize`/`mission`/`vision`/`culture` were added additively to support the redesigned header (logo, verification badge, industry/location/founded line, stage/size/website chips) and About section. Later passes add Founders, Team Members, Gallery (new substructures), Active-Opportunities view tracking + an Analytics Dashboard (`fl_chart`), and Applicant Management Notes/Rating — none of which require restructuring this collection further.

### `student_profiles/{id}`
Doc ID = auto-generated (mirrors `startup_profiles`, not doc-id-as-owner-UID).

| Field | Type | Notes |
|---|---|---|
| `ownerId` | string | owning user's UID |
| `photoUrl` | string? | |
| `university`, `degree`, `yearOfStudy`, `location` | string | |
| `bio`, `careerInterests`, `personalStatement` | string | |
| `skills` | string[] | |
| `resumeUrl` | string? | Storage download URL |
| `resumeFileName` | string? | original filename the student uploaded, shown in the UI since the Storage object itself is always named `{profileId}.pdf` |
| `resumeUploadedAt` | timestamp? | |
| `portfolioUrl`, `githubUrl`, `linkedinUrl`, `behanceUrl`, `dribbbleUrl`, `mediumUrl`, `personalWebsiteUrl` | string? | fixed set of optional link fields (not a dynamic array) since the platforms are a known, small, unchanging list — displayed as clickable cards on the profile |
| `projects` | array of `{id, name, description, technologies, githubUrl?, liveDemoUrl?, imageUrls}` | embedded array, not a subcollection — same reasoning as `startup_profiles.founders`/`teamMembers`: a project is never queried independently of its owner's profile, so keeping it embedded avoids an extra read. `technologies`/`imageUrls` are themselves arrays nested inside each project entry |
| `createdAt`, `updatedAt` | timestamp | |

**Why it exists, and why it's separate from `users`**: same reasoning as `startup_profiles` — a rich, publicly-readable profile (bio, skills, education) shouldn't bloat the auth identity doc, and a startup will eventually need to read an applicant's profile.

**Verification badge**: unlike `startup_profiles.isVerified` (an admin-granted flag), the student verification checkmark is `completionPercentage >= 100`, computed client-side on `StudentProfileEntity` from how many of its fields are filled (now including `resumeUrl`, `hasPortfolioLinks`, and `projects`) — no separate Firestore field needed.

**Project images**: stored at `project_images/{profileId}/{projectId}/{imageId}.jpg` — each image gets its own client-generated ID (via the `uuid` package) so a project can hold multiple images, added or removed independently without disturbing the others.

**Resume**: stored at `resumes/{profileId}.pdf` in Firebase Storage — a fixed, deterministic path per profile so "Replace" is just a fresh upload to the same path (no orphaned old files to clean up). "Preview" and "Download" both open `resumeUrl` via `url_launcher`; Flutter has no cross-platform way to force a true forced-download versus inline-view distinction without extra platform-specific code, so both actions currently do the same thing — the browser/OS decides how to present the PDF, which for a Storage-served file is typically inline in a new tab.

### `users/{uid}/bookmarks/{opportunityId}`
Doc ID = the bookmarked opportunity's ID — one tiny doc per bookmark, not an array-in-doc.

| Field | Type | Notes |
|---|---|---|
| `opportunityId` | string | duplicated as a field (not just the doc ID) so `collectionGroup('bookmarks').where('opportunityId', ==)` can filter across every user's subcollection |
| `createdAt` | timestamp | |

**Why it exists, and why a subcollection**: kept separate from `users` purely so toggling a bookmark never rewrites the user's core profile doc. This *replaced* an earlier array-in-doc design (`bookmarks/{uid}.opportunityIds`) specifically to fix two limits that design had: Firestore's 1MB document size cap bounding the array's practical size, and there being no way to query "which users bookmarked opportunity X." The subcollection shape removes both — unbounded count per user, and a `collectionGroup('bookmarks')` query now powers the startup analytics dashboard's per-opportunity "Bookmarks" stat (see `firestore.indexes.json`'s `COLLECTION_GROUP` index on `opportunityId`).

**Migration**: `BookmarkRemoteDatasource.migrateLegacyBookmarksIfNeeded(userId)` runs once per sign-in (wired through `bookmarkMigrationProvider`, watched from `appRouterProvider` the same way `presenceHeartbeatProvider` is) — it lifts any existing `bookmarks/{uid}.opportunityIds` array into the new subcollection the first time it finds the subcollection empty, then no-ops on every subsequent call. The legacy top-level `bookmarks/{uid}` doc is left in place (harmless, unread by the app after migration) rather than deleted, and its `firestore.rules` entry is kept read/write-able only so this migration can still reach it.

**Read exposure tradeoff**: the `collectionGroup` count query requires a broad rule (`match /{path=**}/bookmarks/{bookmarkId} { allow read: if isSignedIn(); }`) since Firestore evaluates rules per-document even for aggregate queries. This is safe because `.count()` never returns document data to the client — only the numeric total — so no user's individual bookmark list is exposed, only "how many bookmarked this opportunity."

### `users/{uid}/recently_viewed/{opportunityId}`
Doc ID = the viewed opportunity's ID — same shape as `bookmarks`, so re-viewing just overwrites the timestamp instead of creating duplicate history entries.

| Field | Type | Notes |
|---|---|---|
| `opportunityId` | string | |
| `viewedAt` | timestamp | overwritten on every view; the student's "Recently Viewed" list is `orderBy('viewedAt', descending: true).limit(10)` |

**Why it exists, and why separate from `opportunities.viewCount`**: `viewCount` (see the `opportunities` section) is an aggregate counter with no per-user history — it answers "how many views total," not "who viewed what, when." This subcollection answers the latter, powering each student's own "Recently Viewed" section. Both are recorded from the same trigger (`OpportunityDetailScreen._maybeRecordView`, fired once per screen visit, students only) but are otherwise independent — one write updates the aggregate, a separate write updates personal history. No `collectionGroup` rule needed here (unlike bookmarks) since nothing ever needs to query "who viewed opportunity X" across all users — it stays owner-only.

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

### Startup Analytics Dashboard — no new collection

The Analytics Dashboard (`/startup-analytics`) is a **derived view**, not a new collection: `startup_analytics_provider.dart` composes the same `opportunities` (by `startupId`) and `applications` (by `startupId`) streams the rest of the startup dashboard already reads, plus a batched `student_profiles` fetch (chunked `whereIn` on `ownerId`, mirroring `getOpportunitiesByIds`) for the distinct applicant IDs, to derive:

- **Applications per month** — client-side grouping of `applications.appliedAt` by month.
- **Most viewed internships** — `opportunities` sorted by `viewCount`.
- **Acceptance rate** — `accepted / (accepted + rejected)` among applications with a terminal decision.
- **Top skills / applicant locations** — frequency count over the fetched applicants' `student_profiles.skills` / `.location`.

No extra reads happen on every dashboard visit beyond the one batched profile fetch — everything else rides streams the app already subscribes to.

## Query & index design

Firestore requires a composite index for every distinct combination of equality filters + `orderBy` on different fields. The opportunities list lets a user combine `type`, `category`, and `isRemote` filters simultaneously — supporting every combination server-side would need up to 8 composite indexes purely for that one screen, which is index-combinatorics overkill for this app's scale.

**Chosen approach — hybrid server/client filtering**:
- Server-side (Firestore query): `isActive == true`, optionally the **single most-recently-changed** structured filter (`type` **or** `category` **or** `isRemote`), `orderBy(createdAt desc)`, `.limit(pageSize)`.
- Client-side (applied to the already-small, already-filtered page): free-text search (Firestore can't do substring search natively regardless of index strategy), plus any *additional* structured filters beyond the one applied server-side.
- Pagination: the first page stays live via `.snapshots()` (realtime updates for the default view); subsequent pages are fetched once via `.get()` with a `startAfterDocument` cursor.

This needs exactly 4 composite indexes on `opportunities` (`isActive+createdAt`, `isActive+type+createdAt`, `isActive+category+createdAt`, `isActive+isRemote+createdAt`) plus one more for the startup's own postings list (`startupId+createdAt`), and 3 on `applications` (`applicantId+appliedAt`, `opportunityId+appliedAt`, `startupId+appliedAt`) — all captured in `firestore.indexes.json`.
