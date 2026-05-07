# Coralogix Observability MCP — Cursor plugin

Use natural language in [Cursor](https://cursor.com/) to work with your **Coralogix** telemetry and platform: logs, metrics, traces, RUM, alerts, dashboards, and more—through the **remote Coralogix MCP server**. No local MCP binary is required; the server runs in Coralogix and you connect over HTTPS.

Full setup, authentication options, and regional endpoints are documented here:

**[Coralogix MCP server — Setup](https://coralogix.com/docs/user-guides/mcp-server/setup/)**

## What you need

- A [Coralogix](https://coralogix.com/) account and the correct **region / API endpoint** for your team ([account domain](https://coralogix.com/docs/user-guides/account-management/account-settings/coralogix-domain/))
- [Cursor](https://cursor.com/) with MCP enabled

## How connection works

The MCP server is **fully remote**—there is nothing to install on your machine beyond configuring Cursor (see [Setup](https://coralogix.com/docs/user-guides/mcp-server/setup/)).

You typically authenticate in one of two ways:

| Method | Notes |
|--------|--------|
| **OAuth (recommended)** | Browser login to Coralogix and authorize the MCP client. Cursor uses OAuth 2.1 / OIDC ([details](https://coralogix.com/docs/user-guides/mcp-server/oauth/)). |
| **API key** | Personal [Coralogix API key](https://coralogix.com/docs/user-guides/account-management/api-keys/api-keys/) sent as `Authorization: Bearer …`. Permissions follow that key ([permissions](https://coralogix.com/docs/user-guides/mcp-server/permissions/)). |

Adjust the MCP **URL** so it matches your **Coralogix domain** (US1, US2, EU1, EU2, AP1, …). The [Setup](https://coralogix.com/docs/user-guides/mcp-server/setup/) guide lists regions and shows how to substitute the correct host. In general the management API—and MCP—use a hostname of the form `api.<your-domain>`, for example:

`https://api.eu2.coralogix.com/mgmt/api/v1/mcp`

The plugin ships a default **EU2** endpoint in its bundled MCP configuration; change it to match your account ([domain settings](https://coralogix.com/docs/user-guides/account-management/account-settings/coralogix-domain/)).

## Getting started

1. Install this plugin from the **Cursor Marketplace**.
2. **Register the MCP server** in Cursor using the URL for your region. The docs show adding a `coralogix-server` entry under `mcpServers` in `.cursor/mcp.json` — follow **[Setup — Connecting with Cursor](https://coralogix.com/docs/user-guides/mcp-server/setup/)** for the exact JSON (OAuth vs API key).
3. Open **MCP settings** in Cursor and **enable** the Coralogix server.
4. For OAuth, complete login in the browser when prompted.

If you already registered Coralogix MCP manually, avoid duplicating the same server name or URL so Cursor does not connect twice.

## Using the MCP in Cursor

Once connected, ask the agent questions about your observability data or platform, for example:

```
Show me the most frequent errors for service XYZ in the past week.
```

```
When did this issue start?
```

```
List dashboards that mention payments.
```

After investigating an incident, you can continue with follow-ups such as summarizing impact or suggesting code fixes—the agent uses Coralogix tools when they are available.

## Corporate proxy

If outbound traffic must go through a proxy, set standard `HTTP_PROXY` / `HTTPS_PROXY` environment variables before starting Cursor; MCP clients typically honor them (see [Setup](https://coralogix.com/docs/user-guides/mcp-server/setup/)).

## What’s included

The plugin provides **default MCP registration** for Coralogix plus **rules and skills** so the agent prefers Coralogix MCP tools for observability questions instead of guessing. Adjust the MCP URL if your region differs from the default.

## Support and legal

- **Coralogix MCP:** [Setup](https://coralogix.com/docs/user-guides/mcp-server/setup/), [OAuth](https://coralogix.com/docs/user-guides/mcp-server/oauth/), [Permissions](https://coralogix.com/docs/user-guides/mcp-server/permissions/)
- **Endpoints:** [Coralogix endpoints](https://coralogix.com/docs/integrations/coralogix-endpoints/)
- **Security disclosures:** [SECURITY.md](SECURITY.md)
- **License:** [LICENSE](LICENSE)
