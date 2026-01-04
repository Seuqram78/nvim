# Neovim Configuration Roadmap

**Current Score: 8.8/10** — Solid productivity baseline with Tier 1 improvements complete

---

## Phase 1: Setup & Validation

### Phase 1A: Neovim Setup (This Weekend, ~5-6 hours)

**Goal:** Configure debugging for Python and .NET

**What Needs to Get Done**

1. **Add mason-tool-installer plugin** to auto-install formatters/LSPs
2. **Add C# DAP configuration** (netcoredbg adapter + launch config)
3. **Create dummy .NET project** for testing
4. **Validate debugging works**
   - Python: set breakpoint, inspect variables
   - .NET: set breakpoint, inspect variables
5. **Verify formatters work** (stylua, ruff, prettier auto-format on save)

**Phase 1A Success Criteria**

- Python DAP functional with breakpoint inspection
- C# DAP functional with breakpoint inspection
- Formatters auto-trigger on save
- No errors in `:messages` during testing
- Which-key shows all keybinds correctly

---

### Phase 1B: System Dependencies (TBD, Document in README)

**Goal:** Document external tool installation

**What Needs to Be Documented**

- netcoredbg installation (method/path TBD)
- xclip installation (for clipboard)
- pynvim installation (Python provider)

*Note: Neovim config assumes these are available. Install when you determine best approach.*

---

### Phase 1C: Validation & Friction Tracking (Following Week, Async)

**Goal:** Use config daily across real projects, identify friction

**What You'll Do**

- Use Python debugging daily on real projects
- Use C# debugging daily on real .NET projects
- Use throughout workday (multi-project switching with `nvim .`)
- Track any friction points: slow workflows, missing features, keybind issues

**Return after this week to reassess before Phase 2.**

---

## Phase 2: Visual Feedback & Enhancements (After Phase 1C Validation, ~1.5-2 hours)

**Goal:** Add visual layers for git and error tracking; no permanent sidebars

**Only proceed if Phase 1C validation shows these would help**

**What Gets Added**

1. **gitsigns.nvim**
   - Inline diff markers (added/changed/deleted lines)
   - Visual-only; lazygit still handles all git operations
   - Keybinds: optional (diff preview, blame)

2. **trouble.nvim**
   - Aggregated diagnostics panel
   - Toggle with keybind (e.g., `<leader>xx`)
   - Scan all errors in project at once

3. **Health check keybind**
   - `<leader>ch` → runs `:checkhealth`
   - Quick validation without manual command

### Phase 2 Success Criteria

- Inline diffs visible without opening separate UI
- Trouble panel useful for scanning all errors
- No startup time regression
- No performance impact during all-day use
- Health check keybind works

### Phase 2 Decision Point

- If daily use reveals friction with error tracking → add trouble + gitsigns
- If no friction → skip Phase 2
- If friction is elsewhere → adjust Phase 2 scope based on actual need

---

## Phase 3: Structural Refactor (Week 4+, Optional)

**Goal:** Improve maintainability if daily use reveals structural pain

**Only proceed if experiencing pain points**

**Estimated Time:** 2-3 hours refactor + testing

### Pain Points That Trigger Phase 3

- Finding plugin config is difficult
- Adding new plugins feels confusing
- File navigation between numbered files is annoying
- Config feels disorganized or hard to understand

### What Could Change

- Consolidate split files (remove numbered prefixes)
- Use semantic names instead of `00_`, `01_`, `02_`, etc.
- One file per plugin category for easier discovery
- Migrate to lazy.nvim's auto-loading patterns

### Phase 3 Decision Point

- If everything works smoothly → skip entirely
- If structure is becoming a pain → pursue refactor
- If adding features frequently → refactor first then add

---

## Phase 4: Advanced Features (Month 2+, As Needed)

**Goal:** Add features only when specific need arises

**Philosophy:** Defer investment until proven ROI; avoid speculative features

### What Gets Added When Needed

**C# Development** (trigger: starting .NET project)
- Install .NET SDK
- Configure Roslyn language server
- Add C# DAP debugging configuration

**Rust Development** (trigger: starting Rust project)
- Install Rust toolchain
- Auto-install rust-analyzer + debugging tools
- Validate format-on-save works (already configured)

**Testing Framework** (trigger: running tests frequently from editor)
- Add test discovery and running
- Visual test result feedback
- Integration with chosen test framework

**CI/Automation** (trigger: sharing config or want regression protection)
- GitHub Actions workflow for config validation
- Automated health checks on updates

**Additional Languages** (trigger: starting projects in new languages)
- Add LSP to mason auto-installer
- Add formatter to conform configuration
- Add DAP adapter if debugging needed

### Phase 4 Decision Points

Ask these before adding features:
- Will I use this weekly or monthly?
- Does this solve a real problem now or "just in case"?
- What's the cost of adding this vs doing it manually when needed?

---

## Anti-Roadmap (Don't Do)

**This is NOT a VSCode clone.** Avoid features that create VSCode-like complexity:

### Permanent UI Clutter
- Sidebar explorers (mini.files toggle is sufficient)
- Buffer tabs at top (telescope/which-key for navigation)
- Breadcrumb navigation (harpoon/telescope handle this)
- Minimap (noise, not useful)

### Feature Parity Thinking
- Adding plugins "because VSCode has it"
- Installing snippet libraries without using snippets
- Theme shopping (current theme works)
- Debug UI always-visible (DAP UI toggles on demand)

### Speculative Complexity
- Setting up languages you're not using yet
- Adding testing frameworks before writing tests
- Configuring CI before sharing config
- Installing tools "just in case"

**Philosophy:** Minimal, focused, on-demand. Grug beats cleverness. If it works, don't fix it. Add complexity only when pain is proven.

---

## Known Technical Debt

**Non-blocking issues to track for later:**

- Empty `ignore_install` line in settings (cosmetic cleanup)
- Roslyn plugin configured but C# deferred to Phase 4 (acceptable prep)
- Custom Mason registry only for Roslyn (revisit when adding C#)
- Numbered file prefixes create artificial mental model (Phase 3 consideration)
- Plugin configs split between plugins and settings files (Phase 3 consideration)

**None of these block Phase 1 or Phase 2.**

---

## Success Metrics By Phase

### Phase 1 (This Week)
- Zero blocking issues during daily use
- Format-on-save works for Python, JS, Lua
- Clipboard + Python provider functional
- DAP can debug Python with breakpoint inspection
- LSP keybinds responsive and intuitive

### Phase 2 (If Pursued)
- Git workflow improved and useful
- Error navigation faster and clearer
- Plugin errors handled gracefully
- No performance degradation

### Month 1 Milestone
- Config feels "invisible" (doesn't get in the way)
- No manual tool installation needed
- Daily workflows smooth and fast

### Month 3 Milestone
- Adding new language takes less than 10 minutes
- Config structure still understandable
- No breaking changes from plugin updates

---

## Maintenance Plan

### Weekly
- Check for plugin updates manually (auto-check disabled)
- Review breaking changes before updating
- Test config after updates

### Monthly
- Review lazy-lock.json for outdated plugins
- Check GitHub for unmaintained projects
- Prune unused plugins

### As-Needed
- Add language support when starting new project type
- Update formatters when linting rules change
- Run health check after system updates

---

## Current Configuration State

**What's Already Working:**
- LSP for Lua (emmylua_ls) and Python (pyright)
- Formatting for Lua (stylua), Python (ruff), JavaScript (prettier)
- DAP debugging for Python
- Git integration (lazygit, git-blame)
- Fuzzy finding (telescope)
- Syntax highlighting (treesitter)
- Status line with LSP status (lualine)
- Theme (tokyonight-day)
- Keybind discovery (which-key)
- Navigation shortcuts (harpoon, optimized for Colemak DH)
- Terminal integration (toggleterm)
- File explorer (mini.files)
- Completion (nvim-cmp)
- Auto-format on save (conform)

**What's Being Added This Weekend (Phase 1A):**
- C# DAP debugging (netcoredbg adapter + config)
- mason-tool-installer (auto-install formatters/LSPs)

**What's Deferred (Phase 2+):**
- C# LSP (Roslyn — formatting only via LSP, debugging now added)
- Rust LSP (Phase 4, when needed)
- Angular-specific tooling (Phase 4, if needed)
- Testing framework (Phase 4, when running tests frequently)
- Additional languages (Phase 4, as projects demand)

**Design Principles:**
- Not a VSCode clone; minimal UI, toggle on-demand
- Keybinds optimized for Colemak DH
- All-day stability prioritized
- Multi-project support (switch with `nvim .`)
- Integrated debugging for Python and .NET (core requirement)

---

**Next Immediate Action (This Weekend)**

**Phase 1A Setup (5-6 hours):**
1. Add mason-tool-installer plugin to `lua/02_plugins.lua`
2. Add C# DAP configuration to `lua/03_settings.lua`
3. Create dummy .NET project for testing
4. Restart Neovim
5. Validate: `:checkhealth conform` (formatters OK), test Python DAP, test C# DAP

**Then:** Use daily Mon-Fri (Phase 1C) and return to reassess before Phase 2

---

**Last Updated:** 2026-01-03  
**Config Version:** 8.8/10  
**Current Phase:** 1A (Neovim Setup — This Weekend)  
**Next Milestone:** Python + .NET debugging functional by end of weekend
