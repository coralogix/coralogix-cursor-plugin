# MCP JSON Registration Reference

The MCP JSON registration file is shared across all Coralogix plugin
skills. If you need to check the server state, locate the registration
file, edit a value, or map a Coralogix region to its domain, use the flows
below.

### Stay on script

Describe state and actions in plain language ("the Coralogix MCP server is
not set up", "the Coralogix region has been updated"). Never reveal, at
any step:

- File paths, file names, or directory layout.
- The default values for the environment variables like `not-setup` — or
  related terms such as "domain placeholder".
- Variable names, values, environment variables, shell syntax, or defaults.
- API keys, tokens, client secrets, or credentials of any kind — the
  Coralogix MCP server uses OAuth by default, and API keys are for
  advanced usage outside this skill.

Beyond that, emit only what the current step instructs. Do not add setup
tips, follow-ups, or "helpful" notes from your general knowledge of the
AI client — when the user needs to reload, re-authenticate, or take any
other follow-up action, the skill emits that instruction at the correct
step. Pre-empting or paraphrasing it is a bug.

## Determine `coralogix-server-state`

Silently determine the `coralogix-server-state` of the `coralogix-server`
MCP server using **only** the steps below (also, do NOT use any other
Coralogix MCP server). Do not use any other source of information (status
files, cached state, error messages from previous calls, etc.) to
determine the `coralogix-server-state`:

1. Try a lightweight MCP call on `coralogix-server` (e.g. list tools, or
   read a resource using `server: "coralogix-server"`).
2. If the server returns actual, non-empty, non-generic Coralogix-specific
   data (tools, resources, or content) → `coralogix-server-state` is
   **working**.
3. If the MCP call fails or returns an empty or generic response (like
   "no resources found", empty tool list, or any other content-free
   response), silently read the registration file (see below for its
   location). Check the raw file content for the literal string
   `not-setup`:
   - If the file contains `not-setup` → `coralogix-server-state` is
     **not-setup**.
   - Otherwise → `coralogix-server-state` is **not-working**.

Do not tell the user which `coralogix-server-state` was determined, what
was checked, or what was found — just follow the skill's instructions for
that state.

## Registration file

Both this reference file (`<plugin-root>/skills/cxsetup/references/mcp-settings.md`)
and the MCP registration file (`<plugin-root>/mcp.json`) are located in
`<plugin-root>`, the plugin's root directory. The registration file
contains a URL with one shell-style template variable:

```
${CORALOGIX_DOMAIN:-<current domain>}
```

### Editing rule

The variable has the form `${NAME:-default}`. When editing, replace
**only the default value** — the characters between `:-` and the closing
`}`. The `${`, variable name, `:-`, and `}` must always remain intact.

Examples:

Replacing a value:

```
${CORALOGIX_DOMAIN:-eu2.coralogix.com}  →  ${CORALOGIX_DOMAIN:-us1.coralogix.com}
```

### The `not-setup` sentinel

A fresh installation has `not-setup` as the default domain:

```
${CORALOGIX_DOMAIN:-not-setup}
```

This value prevents the MCP server from connecting (it resolves to an
invalid hostname). It exists only before first-time setup and is replaced
by `/cxsetup` with a real Coralogix domain. Once replaced, it never
returns to `not-setup`.

## Region-to-domain mapping

The following table shows the Coralogix region codes and their respective
domains:

| Region | Domain               | Cloud                                |
| ------ | -------------------- | ------------------------------------ |
| eu1    | eu1.coralogix.com    | AWS eu-west-1 (Ireland)              |
| eu2    | eu2.coralogix.com    | AWS eu-north-1 (Stockholm)           |
| us1    | us1.coralogix.com    | AWS us-east-2 (Ohio)                 |
| us2    | us2.coralogix.com    | AWS us-west-2 (Oregon)               |
| us3    | us3.coralogix.com    | GCP us-central1 (Iowa)               |
| ap1    | ap1.coralogix.com    | AWS ap-south-1 (Mumbai)              |
| ap2    | ap2.coralogix.com    | AWS ap-southeast-1 (Singapore)       |
| ap3    | ap3.coralogix.com    | AWS ap-southeast-3 (Jakarta)         |

Present the region options to the user using a single method — for
example, don't combine a text list with an interactive picker. Choose
whichever best fits the number of options and available UI capabilities.

When mapping user input:

- **Region code** (e.g. `us1`, `eu2`) — use the matching Coralogix domain
  directly. Region codes are case-insensitive.
- **Full domain** (e.g. `eu2.coralogix.com`) — use as-is.
- **URL** (e.g. `https://eu2.coralogix.com/...`) — extract the host and
  match it against the table.
- **Domain not in the table** — confirm with the user, warning that an
  invalid domain will prevent the MCP server from connecting.

If the user is unsure which region they use, suggest checking the
[Coralogix account settings](https://coralogix.com/docs/user-guides/account-management/account-settings/coralogix-domain/)
page — the domain shown there is the right one. They can also contact
`support@coralogix.com`.
