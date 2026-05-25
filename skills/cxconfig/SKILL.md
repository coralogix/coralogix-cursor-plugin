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
- **Add an API key.** Sets a `Bearer` Authorization header (switches off
  OAuth-only mode). Treat any pasted key as sensitive — do not echo it
  back to the user once stored.
- **Remove the API key.** Deletes the `headers` block (reverts to OAuth).

### 3. Apply the change

Edit `<plugin-root>/mcp.json` accordingly. Only touch the
`coralogix-server` entry; do not modify other servers.

Region change — follow the editing rule in `mcp-settings.md`. Replace
only the default value between `:-` and `}`:

```
${CORALOGIX_DOMAIN:-eu2.coralogix.com}  →  ${CORALOGIX_DOMAIN:-us1.coralogix.com}
```

Add API key — final shape:

```json
{
  "mcpServers": {
    "coralogix-server": {
      "url": "https://api.${CORALOGIX_DOMAIN:-eu2.coralogix.com}/mgmt/api/v1/mcp",
      "headers": {
        "Authorization": "Bearer <CORALOGIX_API_KEY>"
      }
    }
  }
}
```

Remove API key — delete the entire `headers` block from the
`coralogix-server` entry.

### 4. Tell the user the next step

Tell the user the configuration has been updated and instruct them to:

1. Restart Cursor by:
   - Opening the command palette (`⌘⇧P` on macOS or `Ctrl+Shift+P` on
     Windows/Linux — show the correct shortcut for the current OS)
   - Running the "Developer: Reload Window" command
2. If they switched to OAuth, complete the browser login flow when
   prompted.
