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

The server id is `coralogix-server`. Use this server exclusively, even if
other Coralogix servers exist in the user's environment.

If `coralogix-server` is not set up, do **NOT** fall back to the Coralogix
web UI, CLI, or REST APIs — set up the MCP server first. Only use other
methods if the user explicitly asks for them.

## Shared reference

Read [references/mcp-settings.md](references/mcp-settings.md) before
proceeding. It contains the `coralogix-server-state` check, registration
file location, editing rules, region-to-domain mapping, and auth shapes.

## Setup procedure

Check the `coralogix-server-state` (see `mcp-settings.md`):

- **working** — continue with the user's request without mentioning this check.
- **not-working** — tell the user the server is set up but not working,
  instruct them to run `/cxconfig`, and stop.
- **not-setup** — run the steps below. Do not call any other MCP tools and
  do not gather data another way until setup completes.

When describing state to the user, use plain language. Do not reveal
file contents, paths, or variable values.

### Steps

You MUST complete each step in order. Do not skip steps 1 or 3 — even if
you think you can guess the answer, you must ask the user.

1. **Ask for the region.** Tell the user the Coralogix MCP server needs
   first-time setup, then ask which region/domain to use. Present the
   regions from the table in `mcp-settings.md` using a single method
   (interactive picker preferred). Resolve region codes, full domains,
   or URLs to a Coralogix domain per the mapping rules. Ask for
   clarification if ambiguous.

2. **Apply the region.** Edit the registration file's `url` field per
   the editing rule in `mcp-settings.md`: replace only the 9 characters
   `not-setup` between `:-` and `}` with the resolved domain. The file
   is now in the OAuth shape. Do not announce this write.

3. **Ask for the authentication method.** Using a single method (same
   constraint as step 1), offer:
   - **OAuth** (default, recommended) — browser login, no key stored.
   - **API key** — paste a Coralogix API key now.

   If the user picks OAuth or is unsure, default to OAuth and skip step 4.

4. **If API key was chosen, write the key.** Ask the user to paste it.
   Per the credentials rule in `mcp-settings.md`, accept it silently —
   never echo, confirm, or summarize the value. Add the `headers` block
   from the API key shape in `mcp-settings.md`, substituting the pasted
   key for `<CORALOGIX_API_KEY>`. Keep the domain from step 2.

5. **If API key was chosen, confirm and stop.** Tell the user the
   Coralogix MCP server is configured and ready to use, and that if
   calls later fail with an authorization error they should run
   `/cxconfig` to update the key. Do **not** ask them to restart,
   reload, or quit Cursor. Skip step 6.

6. **If OAuth was chosen, trigger the Authorize button.** Call the
   `mcp_auth` tool on the `coralogix-server` MCP server with an empty
   arguments object `{}`. This surfaces Cursor's **Authorize** button
   for the user and opens the browser login flow. Then tell the user
   the Coralogix MCP server is configured and to click the
   **Authorize** button to complete the browser login. Do **not** ask
   them to restart, reload, or quit Cursor, and do not direct them to
   Cursor Settings — the button appears inline from the `mcp_auth`
   call.
