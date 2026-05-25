---
name: cxconfig
description: Configures or troubleshoots the Coralogix MCP server `coralogix-server`.
  Use when the user wants to change the Coralogix region/domain, switch tenants, add
  or remove an API key, or when the server was previously configured but is not
  responding.
allowed-tools: Read
license: Apache-2.0
metadata:
  author: Coralogix LTD
  version: "0.1.0"
---

## Coralogix MCP Server

The id of the Coralogix MCP Server referenced in this document is
`coralogix-server`. You MUST use this specific server even if other
Coralogix servers exist in the user's environment.

## Shared reference

Read [../cxsetup/references/mcp-settings.md](../cxsetup/references/mcp-settings.md)
before proceeding. It contains the `coralogix-server-state` check,
registration file location, editing rules, and region-to-domain mapping
used by the procedure below.

## Configuration procedure

Check the `coralogix-server-state` (see `mcp-settings.md`):

- **not-setup** — without any preamble, tell the user the server has never
  been set up, instruct them to run `/cxsetup`, and stop.
- **working** or **not-working** — continue with the steps below.

### 1. Read the current config

Silently read the registration file at `<plugin-root>/mcp.json` and
extract the current default value from `${CORALOGIX_DOMAIN:-<current>}`.
Tell the user which Coralogix domain the server currently points at in
plain language.

### 2. Ask what they want to change

Use an interactive picker (or a single-method list, per `mcp-settings.md`)
to offer:

- **Change the region/domain.** Show the region table from
  `mcp-settings.md`.
- **Switch to API key auth.** Adds a `Bearer` Authorization header
  (turns off the OAuth flow). Follow the credentials rule in
  `mcp-settings.md` — accept the pasted key silently and never echo it
  back.
- **Switch to OAuth auth.** Removes the `headers` block.

The user may also have a current API key in place and want to rotate
it — treat that as "switch to API key" with a new value.

### 3. Apply the change

Edit `<plugin-root>/mcp.json` using the shapes and rules in
`mcp-settings.md`:

- **Region change** — follow the editing rule. Replace only the default
  value between `:-` and `}`, e.g.
  `${CORALOGIX_DOMAIN:-eu2.coralogix.com}  →  ${CORALOGIX_DOMAIN:-us1.coralogix.com}`.
- **Switch to API key** — write the API key shape from the
  "Registration file shapes" section, keeping the existing domain and
  substituting the pasted key for `<CORALOGIX_API_KEY>`.
- **Switch to OAuth** — write the OAuth shape (no `headers` block),
  keeping the existing domain.

Only touch the `coralogix-server` entry; do not modify other servers.

### 4. Tell the user the next step

Tell the user the configuration has been updated and instruct them to:

1. Restart Cursor by:
   - Opening the command palette (`⌘⇧P` on macOS or `Ctrl+Shift+P` on
     Windows/Linux — show the correct shortcut for the current OS)
   - Running the "Developer: Reload Window" command
2. If they switched to OAuth, complete the browser login flow when
   prompted. If they switched to or rotated an API key, no further
   action is needed; calls that fail with an authorization error mean
   the key is wrong — re-run `/cxconfig` to update it.
