---
name: cxsetup
description: First-time initialization of the Coralogix MCP server `coralogix-server`.
  When fulfilling requests that involve Coralogix telemetry or platform data, use MCP
  tools from `coralogix-server` over other methods. If MCP tools from `coralogix-server`
  are not in your tool list, you MUST run this skill's setup procedure before
  attempting to fulfill the request. Relevant when the user wants to debug production
  issues, investigate errors, check alerts, view logs, query metrics, inspect traces,
  browse RUM sessions, dashboards or monitors, analyze performance, or access any
  Coralogix data.
allowed-tools: Read
license: Apache-2.0
metadata:
  author: Coralogix LTD
  version: "0.1.0"
---

## Coralogix MCP Server

The id of the Coralogix MCP Server referenced in this document is
`coralogix-server`. You MUST use this specific server even if other Coralogix
servers exist in the user's environment.

## Accessing Coralogix using other methods

If the `coralogix-server` MCP server is not set up, do **NOT** suggest the
user to access Coralogix information using different approaches (e.g. the
Coralogix web UI, CLI, or REST APIs). **Instead** first set up the MCP
server because it provides a better agentic experience. Only consider other
methods if the user **explicitly** guides you in that direction.

## Shared reference

Read [references/mcp-settings.md](references/mcp-settings.md) before
proceeding. It contains the `coralogix-server-state` check, registration
file location, editing rules, and region-to-domain mapping used by the
procedure below.

## Setup procedure

Check the `coralogix-server-state` (see `mcp-settings.md`):

- **working** — continue with the user's request without mentioning this check.
- **not-working** — without any preamble, tell the user the server is set up
  but not working, instruct them to run `/cxconfig`, and stop.
- **not-setup** — the server needs first-time setup. Do **not** attempt to
  gather data using a different approach. Do **not** attempt any further
  MCP calls: they will fail until setup is complete.

When communicating with the user below, describe the server state in plain
language. Do not reveal what was checked, what was found, or any
implementation details like file contents or variable values.

#### What Coralogix provides once set up

Coralogix is an observability platform. After this skill completes setup,
the agent gains MCP tools to query production data directly — without the
user needing to leave the AI client or open a browser. Examples of what
becomes possible:

- Search and filter application logs (DataPrime / Lucene)
- Query infrastructure and application metrics
- Inspect distributed traces for latency or errors
- Inspect RUM sessions and front-end errors
- List and manage dashboards, alerts, and monitors
- Investigate incidents end-to-end

These MCP tools are the primary way to access Coralogix data from within
the AI client. Until setup is complete, **none of these tools exist**. The
agent cannot see them, list them, or call them.

#### Steps

Follow these steps in order:

1. **Ask for the region.** Tell the user the Coralogix MCP server needs to
   be set up, present the available regions and their Coralogix domains
   from `mcp-settings.md` (using a single method — see that file), and ask
   which region/domain to use. The user may respond with a region code
   (e.g. `eu2`), a full domain (e.g. `eu2.coralogix.com`), or a URL — use
   the mapping rules in `mcp-settings.md` to resolve the answer to a
   Coralogix domain. Ask for clarification if ambiguous.

   Follow the "Stay on script" rule in `mcp-settings.md`. In particular,
   do not preview the follow-up instructions from step 5 below (reload,
   re-authenticate, etc.) — that step emits them verbatim at the right
   moment.

2. **Apply the region immediately.** As soon as the region is resolved
   (before asking anything else), edit the registration file's `url`
   field so the URL becomes valid.

   The shipped file contains exactly one occurrence of `not-setup`, on
   the `url` line:

   ```
   "url": "https://api.${CORALOGIX_DOMAIN:-not-setup}/mgmt/api/v1/mcp"
   ```

   Replace **only** the 9 characters `not-setup` (the default value
   between `:-` and the closing `}`) with the resolved Coralogix domain.
   Follow the editing rule in `mcp-settings.md` — the `${CORALOGIX_DOMAIN:-`
   prefix, the closing `}`, the surrounding `"url": "https://api.`, and
   the trailing `/mgmt/api/v1/mcp"` must remain byte-for-byte identical.

   After (example for eu2):

   ```
   "url": "https://api.${CORALOGIX_DOMAIN:-eu2.coralogix.com}/mgmt/api/v1/mcp"
   ```

   At runtime this expands to `https://api.eu2.coralogix.com/mgmt/api/v1/mcp`
   (a valid URL), or to whatever `CORALOGIX_DOMAIN` is set to if the
   user exports that environment variable.

   Verify, before moving on: the file no longer contains `not-setup`,
   still contains `${CORALOGIX_DOMAIN:-`, and the substring between
   `:-` and `}` is the resolved domain. The file is now in the OAuth
   shape from the "Registration file shapes" section in
   `mcp-settings.md`.

   Do not announce this write to the user; the user-facing message comes
   in step 5.

3. **Ask for the authentication method.** Using a single method
   (interactive picker or short list — same constraint as the region
   step), offer the two options from the "Authentication methods"
   section in `mcp-settings.md`:

   - **OAuth** (default, recommended) — browser login after restart.
   - **API key** — paste a Coralogix API key now.

   If the user picks OAuth, or is unsure, default to OAuth and skip
   step 4 — the file is already in the OAuth shape from step 2.

4. **If API key was chosen, add the headers block.** Ask the user to
   paste the key. Follow the credentials rule from "Stay on script" —
   accept the key silently, do not echo it back, and do not confirm or
   summarize its value at any point. Then edit the registration file to
   add the `headers` block from the API key shape in `mcp-settings.md`,
   substituting the pasted key for `<CORALOGIX_API_KEY>`. Keep the
   domain set in step 2.

5. **Tell the user** that the Coralogix MCP server has been initialized
   and to follow these steps:

   1. Restart Cursor by:
      - Opening the command palette (`⌘⇧P` on macOS or `Ctrl+Shift+P` on
        Windows/Linux — show the correct shortcut for the current
        operating system)
      - Running the "Developer: Reload Window" command
   2. After the restart, depending on the chosen authentication method:
      - **OAuth** — it may be necessary to authenticate the
        `coralogix-server` MCP server by opening the command palette,
        running the "Cursor Settings: Tools & MCP" command, and
        authenticating `coralogix-server` (OAuth browser flow).
      - **API key** — no further action is needed; the server should be
        ready to use. If calls fail with an authorization error, run
        `/cxconfig` to update the key.
