---
name: google-docs-suggestions
description: Make native suggested edits in Google Docs for the user to accept or reject.
---

# Google Docs suggested edits
When asked to suggest an edit, make a native Google Docs suggestion I can
accept or reject.
- Authenticate for Google Drive with
  `gcloud auth login --enable-gdrive-access --force` when needed; use the
  existing login if it already works.
- Get an access token with `gcloud auth print-access-token`, keeping it in
  memory (an environment variable is fine) and sending it as a Bearer token to
  the Google Docs API. Never print, log or persist it, or put it in the
  session's context.
- Prefer connector tools when they offer suggestion mode. Otherwise call the
  Google Docs REST API with the gcloud token; don't assume the API can't make
  suggestions.
- Read
  `GET https://docs.googleapis.com/v1/documents/{documentId}?includeTabsContent=true&suggestionsViewMode=SUGGESTIONS_INLINE`
  to find the exact text, the tab's ID, UTF-16 indexes, existing suggestions
  and the revision ID. Look at overlapping suggestions before editing.
- Send the edit to
  `POST https://docs.googleapis.com/v1/documents/{documentId}:batchUpdate`
  with `writeControl.writeMode` set to `SUGGEST` and
  `writeControl.requiredRevisionId` set to the revision just read. For a
  deletion, use `deleteContentRange` with `range.tabId`, `range.startIndex`
  and `range.endIndex`. A batch update without suggestion mode edits the
  document directly.
- Check that `commentUpdateState` is `ALL_SAVED`, then read the changed area
  back with `SUGGESTIONS_INLINE` and check that the text has
  `suggestedDeletionIds` or `suggestedInsertionIds` as intended. If the
  write's outcome is uncertain or it partly failed, look at the document's
  current state before retrying.
