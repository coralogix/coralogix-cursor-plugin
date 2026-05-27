---
name: cx-config
description: Configures or troubleshoots the Coralogix MCP server `Coralogix`.
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
`Coralogix`. You MUST use this specific server even if other
Coralogix servers exist in the user's environment.

## Shared reference

Read [../cx-setup/references/mcp-settings.md](../cx-setup/references/mcp-settings.md)
before proceeding. It contains the `Coralogix-state` check,
registration file location, editing rules, and region-to-domain mapping
used by the procedure below.

## Configuration procedure

Check the `Coralogix-state` (see `mcp-settings.md`):

- **not-setup** — without any preamble, tell the user the server has never
  been set up, instruct them to run `/cx-setup`, and stop.
- **working** or **not-working** — continue with the steps below.

### 1. Read the current config

Silently read the registration file at `<plugin-root>/mcp.json` and
determine the **effective** domain per `mcp-settings.md` (environment
override if set, otherwise the file's domain default). Also note whether
auth is OAuth (no `headers` block) or API key (`headers.Authorization`).
Tell the user which Coralogix domain the server currently points at and
which auth mode is in use, in plain language.

### 2. Ask what they want to change

Use an interactive picker (or a single-method list, per `mcp-settings.md`)
to offer:

- **Change the region/domain.** Show the region table from
  `mcp-settings.md`.
- **Switch to API key auth.** Adds a `Bearer` Authorization header
  (turns off the OAuth flow). Follow the credentials rule in
  `mcp-settings.md` — accept the pasted key silently and never echo it
  back.
- **Replace the API key.** Only offer this when the current config
  already has a `headers` block. Replaces the existing `Bearer` value
  with a newly pasted key. Follow the same credentials rule — accept
  the pasted key silently and never echo it back.
- **Switch to OAuth auth.** Removes the `headers` block.

### 3. Apply the change

Edit `<plugin-root>/mcp.json` using the shapes and rules in
`mcp-settings.md`:

- **Region change** — follow the editing rule. Replace only the default
  value between `:-` and `}`, e.g.
  `${CORALOGIX_DOMAIN:-eu2.coralogix.com}  →  ${CORALOGIX_DOMAIN:-us1.coralogix.com}`.
- **Switch to API key** — write the API key shape from the
  "Registration file shapes" section, keeping the existing domain and
  substituting the pasted key for `<CORALOGIX_API_KEY>`.
- **Replace API key** — keep the existing API key shape and domain;
  only substitute the pasted key for the current `Bearer` value.
- **Switch to OAuth** — write the OAuth shape (no `headers` block),
  keeping the existing domain.

Only touch the `Coralogix` entry; do not modify other servers.

### 4. Tell the user the next step

Tell the user the configuration has been updated and instruct them to:

1. Reload the `Coralogix` MCP server by:
   - Opening the command palette (`⌘⇧P` on macOS or `Ctrl+Shift+P` on
     Windows/Linux — show the correct shortcut for the current OS)
   - Running the "Cursor Settings: Tools & MCP" command
   - Toggling the `Coralogix` MCP server off and then back on
2. If they switched to OAuth, complete the browser login flow when
   prompted. If they switched to or rotated an API key, no further
   action is needed; calls that fail with an authorization error mean
   the key is wrong — re-run `/cx-config` to update it.

## Registration file shapes

`Coralogix` supports two authentication shapes in `mcp.json`.
When applying step 3, write the file using one of the two shapes below.
Keep the `${CORALOGIX_DOMAIN:-<domain>}` template intact per the
editing rule in `mcp-settings.md`, and only ever modify the
`Coralogix` entry.

### OAuth (default)

No `headers` block. Cursor handles the browser login flow on first
connection; no credentials are stored in the file.

```json
{
  "mcpServers": {
    "Coralogix": {
      "url": "https://api.${CORALOGIX_DOMAIN:-<domain>}/mgmt/api/v1/mcp"
    }
  }
}
```

### API key (Bearer)

`headers` block with an `Authorization: Bearer …` value. Substitute the
pasted key for `<CORALOGIX_API_KEY>` — write it straight into the file
and never echo, summarize, or confirm the value back. Do **not** use
`${CORALOGIX_API_KEY:-}` with an empty default; that silently sends an
empty bearer when the env var is unset.

```json
{
  "mcpServers": {
    "Coralogix": {
      "url": "https://api.${CORALOGIX_DOMAIN:-<domain>}/mgmt/api/v1/mcp",
      "headers": {
        "Authorization": "Bearer <CORALOGIX_API_KEY>"
      }
    }
  }
}
```

To switch from OAuth to API key, add the `headers` block. To switch
back, delete the entire `headers` block. The domain stays unchanged
unless the user is also changing region.
