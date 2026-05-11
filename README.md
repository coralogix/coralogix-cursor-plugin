# Coralogix Observability MCP — Cursor plugin

Use natural language in [Cursor](https://cursor.com/) to work with your **Coralogix** telemetry and platform: logs, metrics, traces, RUM, alerts, dashboards, and more—through the **remote Coralogix MCP server**. No local MCP binary is required; the server runs in Coralogix and you connect over HTTPS.

Full setup, authentication options, and regional endpoints are documented here:

**[Coralogix MCP server — Setup](https://coralogix.com/docs/user-guides/mcp-server/setup/)**

## What you need

- A [Coralogix](https://coralogix.com/) account and the correct **region / API endpoint** for your team ([account domain](https://coralogix.com/docs/user-guides/account-management/account-settings/coralogix-domain/))
- [Cursor](https://cursor.com/) with MCP enabled
- The `CORALOGIX_DOMAIN` environment variable set to your account domain (see [Configuring your domain](#configuring-your-domain))

## How connection works

The MCP server is **fully remote**—there is nothing to install on your machine beyond configuring Cursor (see [Setup](https://coralogix.com/docs/user-guides/mcp-server/setup/)).

You typically authenticate in one of two ways:

| Method | Notes |
|--------|--------|
| **OAuth (recommended)** | Browser login to Coralogix and authorize the MCP client. Cursor uses OAuth 2.1 / OIDC ([details](https://coralogix.com/docs/user-guides/mcp-server/oauth/)). |
| **API key** | Personal [Coralogix API key](https://coralogix.com/docs/user-guides/account-management/api-keys/api-keys/) sent as `Authorization: Bearer …`. Permissions follow that key ([permissions](https://coralogix.com/docs/user-guides/mcp-server/permissions/)). |

The MCP URL is constructed from your Coralogix domain using the pattern `https://api.<your-domain>/mgmt/api/v1/mcp`. Set `CORALOGIX_DOMAIN` to your domain and the plugin resolves the correct endpoint automatically.

## Configuring your domain

The plugin uses the `CORALOGIX_DOMAIN` environment variable to build the MCP endpoint URL. Set it to the domain shown on your [Coralogix account settings](https://coralogix.com/docs/user-guides/account-management/account-settings/coralogix-domain/) page:

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

Add the variable to your shell profile (e.g. `~/.zshrc` or `~/.bashrc`) and restart Cursor:

```bash
export CORALOGIX_DOMAIN=eu2.coralogix.com
```

Cursor interpolates `${env:CORALOGIX_DOMAIN}` in the MCP URL at startup, so the server connects to `https://api.<CORALOGIX_DOMAIN>/mgmt/api/v1/mcp`.

## Getting started

1. Set `CORALOGIX_DOMAIN` for your region (see [Configuring your domain](#configuring-your-domain)).
2. Install this plugin from the **Cursor Marketplace** — the MCP server is registered automatically.
3. For OAuth, complete login in the browser when prompted.

If you already registered the Coralogix MCP server manually, remove or rename that entry first to avoid Cursor connecting to it twice.

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

## Corporate proxy

If outbound traffic must go through a proxy, set standard `HTTP_PROXY` / `HTTPS_PROXY` environment variables before starting Cursor; MCP clients typically honor them (see [Setup](https://coralogix.com/docs/user-guides/mcp-server/setup/)).

## What’s included

The plugin provides **default MCP registration** for Coralogix plus **rules and skills** so the agent prefers Coralogix MCP tools for observability questions instead of guessing.

## Local development

To load the plugin directly into Cursor without publishing it, run:

```bash
make dev [DOMAIN=<your-domain>]
```

This creates `~/.cursor/plugins/local/coralogix-mcp` pointing to `plugins/coralogix-mcp/` and registers `CORALOGIX_DOMAIN` with `launchctl setenv` so Cursor's GUI process picks it up. Then reload Cursor (`Cmd+Shift+P` → **Developer: Reload Window**) and check **Settings → Features → Model Context Protocol** — `coralogix-server` should appear with the resolved URL.

To remove the local symlink: `make unlink`. To validate the plugin manifest: `make validate`.

> **macOS note:** Shell profile exports (`~/.zshrc`) are not visible to apps launched from the Dock. `make dev` uses `launchctl setenv` to inject the variable into the GUI environment — this persists until you log out or explicitly unset it with `launchctl unsetenv CORALOGIX_DOMAIN`.

## Support and legal

- **Coralogix MCP:** [Setup](https://coralogix.com/docs/user-guides/mcp-server/setup/), [OAuth](https://coralogix.com/docs/user-guides/mcp-server/oauth/), [Permissions](https://coralogix.com/docs/user-guides/mcp-server/permissions/)
- **Endpoints:** [Coralogix endpoints](https://coralogix.com/docs/integrations/coralogix-endpoints/)
- **Security disclosures:** [SECURITY.md](SECURITY.md)
- **License:** [LICENSE](LICENSE)
