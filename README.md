# Coralogix Observability MCP — Cursor plugin

Use natural language in [Cursor](https://cursor.com/) to work with your **Coralogix** telemetry and platform: logs, metrics, traces, RUM, alerts, dashboards, and more—through the **remote Coralogix MCP server**. No local MCP binary is required; the server runs in Coralogix and you connect over HTTPS.

Full setup, authentication options, and regional endpoints are documented here:

**[Coralogix MCP server — Setup](https://coralogix.com/docs/user-guides/mcp-server/setup/)**

## Quick start

1. Install the plugin from the [Cursor Marketplace](https://cursor.com/marketplace) (or copy this repo to `~/.cursor/plugins/local/coralogix-mcp/` for local testing — see [Local development](#local-development)).
2. In Cursor chat, run **`/cxsetup`**. It will ask which Coralogix region you use and which authentication method to use (**OAuth** — the default — or **API key**), then configure the MCP server for you.
3. Fully quit and reopen Cursor.
4. For OAuth, complete the browser login when prompted.

To change the region, switch between OAuth and API key, or rotate an API key later, run **`/cxconfig`**.

## What you need

- A [Coralogix](https://coralogix.com/) account and the correct **region / API endpoint** for your team ([account domain](https://coralogix.com/docs/user-guides/account-management/account-settings/coralogix-domain/))
- [Cursor](https://cursor.com/) with MCP enabled

## How connection works

The MCP server is **fully remote**—there is nothing to install on your machine beyond configuring Cursor (see [Setup](https://coralogix.com/docs/user-guides/mcp-server/setup/)).

You typically authenticate in one of two ways:

| Method | Notes |
|--------|--------|
| **OAuth (recommended)** | Browser login to Coralogix and authorize the MCP client. Cursor uses OAuth 2.1 / OIDC ([details](https://coralogix.com/docs/user-guides/mcp-server/oauth/)). |
| **API key** | Personal [Coralogix API key](https://coralogix.com/docs/user-guides/account-management/api-keys/api-keys/) sent as `Authorization: Bearer …`. Choose it during `/cxsetup`, or run `/cxconfig` to add or rotate one. Permissions follow that key ([permissions](https://coralogix.com/docs/user-guides/mcp-server/permissions/)). |

The MCP URL follows the pattern `https://api.<your-domain>/mgmt/api/v1/mcp`. The `/cxsetup` skill writes the right URL into the plugin's `mcp.json` based on your region choice:

| Domain | Region | Cloud |
|--------|--------|-------|
| `eu1.coralogix.com` | EU1 | AWS eu-west-1 (Ireland) |
| `eu2.coralogix.com` | EU2 | AWS eu-north-1 (Stockholm) |
| `us1.coralogix.com` | US1 | AWS us-east-2 (Ohio) |
| `us2.coralogix.com` | US2 | AWS us-west-2 (Oregon) |
| `us3.coralogix.com` | US3 | GCP us-central1 (Iowa) |
| `ap1.coralogix.com` | AP1 | AWS ap-south-1 (Mumbai) |
| `ap2.coralogix.com` | AP2 | AWS ap-southeast-1 (Singapore) |
| `ap3.coralogix.com` | AP3 | AWS ap-southeast-3 (Jakarta) |
| `proofpoint.coralogix.com` | Proofpoint | Dedicated tenant |
| `factset.coralogix.com` | FactSet | Dedicated tenant |

Until you run `/cxsetup`, the domain in `mcp.json` is the placeholder `not-setup` and the server will not connect. If you already registered the Coralogix MCP server manually in `~/.cursor/mcp.json`, remove or rename that entry first to avoid connecting twice.

## Using the MCP in Cursor

Once connected, ask the agent questions about your observability data or platform, for example:

```
Show me the most frequent errors for service XYZ in the past week.
```

```
When did this issue start?
```

```
Which alerts fired in the last hour?
```

After investigating an incident, you can continue with follow-ups such as summarizing impact or suggesting code fixes—the agent uses Coralogix tools when they are available.

## Skills shipped with the plugin

| Skill | Purpose |
|-------|---------|
| **`/cxsetup`** | First-time setup. Asks which Coralogix region you use and whether to authenticate via OAuth or an API key, then writes the matching config into the plugin's `mcp.json`. |
| **`/cxconfig`** | Change region later, switch between OAuth and API key, or rotate an API key. |

## Corporate proxy

If outbound traffic must go through a proxy, set standard `HTTP_PROXY` / `HTTPS_PROXY` environment variables before starting Cursor; MCP clients typically honor them (see [Setup](https://coralogix.com/docs/user-guides/mcp-server/setup/)).

## Local development

To load the plugin directly into Cursor without publishing it, copy the repo into Cursor's local plugin folder ([docs](https://cursor.com/docs/plugins#test-plugins-locally)):

```bash
make dev
```

This copies the repo to `~/.cursor/plugins/local/coralogix-mcp/`. Then reload Cursor (`Cmd+Shift+P` → **Developer: Reload Window**) and run `/cxsetup` in chat.

To remove the local install: `make unlink`.

## Support and legal

- **Coralogix MCP:** [Setup](https://coralogix.com/docs/user-guides/mcp-server/setup/), [OAuth](https://coralogix.com/docs/user-guides/mcp-server/oauth/), [Permissions](https://coralogix.com/docs/user-guides/mcp-server/permissions/)
- **Endpoints:** [Coralogix endpoints](https://coralogix.com/docs/integrations/coralogix-endpoints/)
- **Security disclosures:** [SECURITY.md](SECURITY.md)
- **License:** [LICENSE](LICENSE)
