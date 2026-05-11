.PHONY: dev unlink validate

PLUGIN_LOCAL_DIR := $(HOME)/.cursor/plugins/local
PLUGIN_LINK_NAME := coralogix-mcp
PLUGIN_SRC       := $(abspath plugins/coralogix-mcp)

# Default domain for local development. Override with: make dev DOMAIN=us1.coralogix.com
DOMAIN ?= eu2.coralogix.com

# ── Local development ──────────────────────────────────────────────────────────

## Set up the plugin for local testing and open Cursor.
## Usage: make dev [DOMAIN=<your-domain>]
dev:
	@mkdir -p "$(PLUGIN_LOCAL_DIR)"
	@ln -sfn "$(PLUGIN_SRC)" "$(PLUGIN_LOCAL_DIR)/$(PLUGIN_LINK_NAME)"
	@echo "Symlink: $(PLUGIN_LOCAL_DIR)/$(PLUGIN_LINK_NAME) -> $(PLUGIN_SRC)"
	@launchctl setenv CORALOGIX_DOMAIN "$(DOMAIN)"
	@echo "Set CORALOGIX_DOMAIN=$(DOMAIN) in the macOS launch environment"
	@echo ""
	@echo "Next: reload Cursor (Cmd+Shift+P -> Developer: Reload Window)"
	@echo "      then check Settings > Features > Model Context Protocol"

## Remove the local plugin symlink.
unlink:
	@rm -f "$(PLUGIN_LOCAL_DIR)/$(PLUGIN_LINK_NAME)"
	@echo "Removed $(PLUGIN_LOCAL_DIR)/$(PLUGIN_LINK_NAME)"

# ── Validation ─────────────────────────────────────────────────────────────────

## Validate plugin manifest and component frontmatter.
validate:
	node scripts/validate-template.mjs
