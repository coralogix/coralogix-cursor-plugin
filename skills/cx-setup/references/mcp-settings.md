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

## Determine `Coralogix-state`

Silently determine the `Coralogix-state` of the `Coralogix`
MCP server using **only** the steps below (also, do NOT use any other
Coralogix MCP server). Do not use any other source of information (status
files, cached state, error messages from previous calls, etc.) to
determine the `Coralogix-state`:

1. Resolve which MCP server identifier to use for the probe (see
   **Resolving the MCP server for probes** below), then try a lightweight
   MCP call (for example `get_datetime` with no arguments).
2. If the server returns actual, non-empty, non-generic Coralogix-specific
   data (tools, resources, or content) → `Coralogix-state` is
   **working**.
3. If the MCP call fails or returns an empty or generic response (like
   "no resources found", empty tool list, or any other content-free
   response), silently read the registration file (see below for its
   location) and apply **Setup completeness** (below):
   - **not-setup** — only when setup is **not** complete per that section.
   - **not-working** — otherwise.

Do not tell the user which `Coralogix-state` was determined, what
was checked, or what was found — just follow the skill's instructions for
that state.

### Resolving the MCP server for probes

The logical server name is always `Coralogix`. The identifier passed to
MCP tools in the agent runtime may differ (for example a plugin-prefixed
id). A failed probe with the message that the server does not exist is
**not** proof that Coralogix is down — resolve the runtime id and retry
once before continuing to step 3:

1. Call with server `Coralogix` first.
2. If that fails because the server name is unknown, silently read MCP
   server metadata in the agent's MCP descriptor area: find the entry
   whose `serverName` is `Coralogix` and use its `serverIdentifier` for
   one retry of the same lightweight call.
3. Only treat the probe as failed after both attempts (or after a
   non-"unknown server" error on the first attempt).

Do **not** infer **working** from tool descriptor files on disk alone.
Only a successful live MCP response counts as **working**.

### Setup completeness

Used in step 3 above when the probe fails. Setup is **not** complete
(**not-setup**) only when **both** are true:

1. The registration file's domain default (between `:-` and `}` in the
   Coralogix URL template) is still `not-setup`.
2. `CORALOGIX_DOMAIN` is unset, empty, or not a valid Coralogix domain
   (see the region table; `*.coralogix.com` dedicated tenants count).

If the file still has the `not-setup` default but `CORALOGIX_DOMAIN` is
set to a valid domain, the user has configured the region outside the
registration file — state is **not-working**, not **not-setup**. Suggest
`/cx-config` (or completing `/cx-setup` to persist the domain in the
file), not `/cx-setup` alone.

If the file already contains a real domain default, state is
**not-working** regardless of the environment variable.

### Effective domain (for `/cx-config` and troubleshooting)

When telling the user which region or domain the server uses, report the
**effective** domain — the one Cursor actually connects with:

1. If `CORALOGIX_DOMAIN` is set to a valid Coralogix domain, use that.
2. Otherwise use the registration file's domain default from the URL
   template (between `:-` and `}`).

Describe the result in plain language (region name and domain). Do not
mention environment variables or file internals to the user.

## Registration file

Both this reference file (`<plugin-root>/skills/cx-setup/references/mcp-settings.md`)
and the MCP registration file (`<plugin-root>/mcp.json`) are located in
`<plugin-root>`, the plugin's root directory. The registration file
contains a URL with one shell-style template variable:

```
${CORALOGIX_DOMAIN:-<current domain>}
```

### Editing rule

The variable has the form `${NAME:-default}`. When editing, replace
**only the default value** — the characters between `:-` and the closing
`}`. The `${`, the variable name `CORALOGIX_DOMAIN`, the `:-` separator,
and the closing `}` must remain byte-for-byte identical. Everything
outside the `${...}` — the `"url": "https://api.` prefix and the
`/mgmt/api/v1/mcp"` path — also stays untouched.

This matters: Cursor expands `${CORALOGIX_DOMAIN:-<default>}` at runtime
to the value of the `CORALOGIX_DOMAIN` environment variable, falling
back to `<default>` when the variable is unset. If you damage the
`${...}` wrapper (drop the `${`, change the variable name, lose the
`:-`, etc.), Cursor will use the literal string verbatim and the URL
will not resolve.

Examples:

Replacing the default value:

```
"url": "https://api.${CORALOGIX_DOMAIN:-not-setup}/mgmt/api/v1/mcp"
              becomes
"url": "https://api.${CORALOGIX_DOMAIN:-eu2.coralogix.com}/mgmt/api/v1/mcp"
```

Switching regions later (same rule):

```
${CORALOGIX_DOMAIN:-eu2.coralogix.com}  →  ${CORALOGIX_DOMAIN:-us1.coralogix.com}
```

The valid final URL when `CORALOGIX_DOMAIN` is unset is, e.g.,
`https://api.eu2.coralogix.com/mgmt/api/v1/mcp`. If after your edit the
file still contains `not-setup`, or no longer contains `${CORALOGIX_DOMAIN:-`
followed by a real domain followed by `}`, the edit is wrong — re-do it.

### The `not-setup` sentinel

A fresh installation has `not-setup` as the default domain:

```
${CORALOGIX_DOMAIN:-not-setup}
```

This value prevents the MCP server from connecting when no override is
present (it resolves to an invalid hostname). It exists only before
first-time setup and is replaced by `/cx-setup` with a real Coralogix
domain. Once replaced, it never returns to `not-setup`.

If `CORALOGIX_DOMAIN` is set to a valid domain while the file still
shows `not-setup`, the server may already work at runtime, but the
registration file is out of date — treat state as **not-working**, not
**not-setup**, and persist the domain via `/cx-setup` or `/cx-config`.

## Region-to-domain mapping

The following table shows the Coralogix region codes and their respective
domains:

| Region     | Domain                   | Cloud                                |
| ---------- | ------------------------ | ------------------------------------ |
| eu1        | eu1.coralogix.com        | AWS eu-west-1 (Ireland)              |
| eu2        | eu2.coralogix.com        | AWS eu-north-1 (Stockholm)           |
| us1        | us1.coralogix.com        | AWS us-east-2 (Ohio)                 |
| us2        | us2.coralogix.com        | AWS us-west-2 (Oregon)               |
| us3        | us3.coralogix.com        | GCP us-central1 (Iowa)               |
| ap1        | ap1.coralogix.com        | AWS ap-south-1 (Mumbai)              |
| ap2        | ap2.coralogix.com        | AWS ap-southeast-1 (Singapore)       |
| ap3        | ap3.coralogix.com        | AWS ap-southeast-3 (Jakarta)         |
| proofpoint | proofpoint.coralogix.com | Dedicated tenant                     |
| factset    | factset.coralogix.com    | Dedicated tenant                     |

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
