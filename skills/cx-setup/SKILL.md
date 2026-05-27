---
name: cx-setup
description: First-time initialization of the Coralogix MCP server `Coralogix`.
  When fulfilling requests that involve Coralogix telemetry or platform data, use MCP
  tools from `Coralogix` over other methods. If MCP tools from `Coralogix`
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

The id of the Coralogix MCP Server referenced on this document is `Coralogix`. You MUST use this specific server even if there are other Coralogix servers.

## Accessing Coralogix using other methods

If the `Coralogix` MCP server is not setup, do **NOT** suggest the user to access Coralogix information using different approaches like the Coralogix web UI, CLI, or REST APIs. **Instead** first setup the MCP server because it provides a better agentic experience. Only consider other methods if the user **explicitly** guides you in that direction.

## Shared reference

Read [references/mcp-settings.md](references/mcp-settings.md) before proceeding. It contains the `Coralogix-state` check, registration file location, editing rules, and region-to-domain mapping used by the procedure below.

## Setup procedure

Check the `Coralogix-state` (see `mcp-settings.md`):

- **working** — if the user invoked `/cx-setup`, tell them without preamble
  that the Coralogix MCP server is already set up and working; to change region
  or authentication, run `/cx-config`; stop. If setup was only a prerequisite
  for another request, continue with that request without mentioning this check.
- **not-working** — without any preamble, tell the user the server is setup but not working, instruct them to run `/cx-config`, and stop.
- **not-setup** — the server needs first-time setup. Do **not** attempt to gather data using a different approach. Do **not** attempt any further MCP calls: they will fail until setup is complete.

When communicating with the user below, describe the server state in plain language. Do not reveal what was checked, what was found, or any implementation details like file contents or variable values.

#### What Coralogix provides once set up

Coralogix is a full-stack observability platform. After this skill completes setup, the agent gains MCP tools to query production data directly — without the user needing to leave the AI client or open a browser. Examples of what becomes possible:

- Search and filter application logs
- Query metrics and time-series data
- Inspect distributed traces for latency or errors
- Browse RUM sessions and front-end performance
- List dashboards, alerts, and monitors
- Investigate incidents and on-call alarms

These MCP tools are the primary way to access Coralogix data from within the AI client. Until setup is complete, **none of these tools exist**. The agent cannot see them, list them, or call them.

#### Steps

Follow these steps in order:

1. **Ask for the region.** Tell the user the Coralogix MCP server needs to be set up, present the available regions and their domains from `mcp-settings.md` (using a single method — see that file), and ask which region/domain to use. The user may respond with a Coralogix domain directly, a region code, a URL, or something else — use the mapping rules in `mcp-settings.md` to resolve the answer to a Coralogix domain. Ask for clarification if ambiguous.

   Follow the "Stay on script" rule in `mcp-settings.md`. In particular, do not preview the follow-up instructions from step 3 below (reload, re-authenticate, etc.) — that step emits them verbatim at the right moment.

2. **Apply the change.** Follow the region editing rule in `mcp-settings.md`:
   replace the URL so it uses the literal hostname for the resolved domain
   (example: `https://api.eu2.coralogix.com/mgmt/api/v1/mcp`). Remove
   `${CORALOGIX_DOMAIN}` from the URL.

3. **Tell the user** that the Coralogix MCP server has been initialized and to follow these steps:

   1. Reload the `Coralogix` MCP server by:
      - Opening the command palette (⌘⇧P on Mac or Ctrl+Shift+P on Windows/Linux — show the correct shortcut for the current operating system)
      - Running the "Cursor Settings: Tools & MCP" command
      - Toggling the `Coralogix` MCP server off and then back on
   2. If prompted, complete the OAuth login in the browser to authenticate the `Coralogix` MCP server.
