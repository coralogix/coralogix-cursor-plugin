.PHONY: dev unlink

PLUGIN_LOCAL_DIR := $(HOME)/.cursor/plugins/local
PLUGIN_NAME      := coralogix-mcp
PLUGIN_SRC       := $(abspath .)
PLUGIN_DEST      := $(PLUGIN_LOCAL_DIR)/$(PLUGIN_NAME)

# ── Local development ──────────────────────────────────────────────────────────

## Copy the plugin into Cursor's local plugins folder for testing.
## After running, reload Cursor and run /cx-setup in chat to pick your region.
dev:
	@mkdir -p "$(PLUGIN_LOCAL_DIR)"
	@rm -rf "$(PLUGIN_DEST)"
	@mkdir -p "$(PLUGIN_DEST)"
	@cp -R "$(PLUGIN_SRC)/.cursor-plugin" \
	       "$(PLUGIN_SRC)/mcp.json" \
	       "$(PLUGIN_SRC)/rules" \
	       "$(PLUGIN_SRC)/skills" \
	       "$(PLUGIN_SRC)/README.md" \
	       "$(PLUGIN_DEST)/"
	@echo "Installed plugin at $(PLUGIN_DEST)"
	@echo ""
	@echo "Next:"
	@echo "  1. Reload Cursor (Cmd+Shift+P -> Developer: Reload Window)"
	@echo "  2. In chat, run: /cx-setup    (picks your Coralogix region)"

## Remove the local plugin install.
unlink:
	@rm -rf "$(PLUGIN_DEST)"
	@echo "Removed $(PLUGIN_DEST)"
