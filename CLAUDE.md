# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Nix flake-based Neovim configuration using the nixCats framework (https://github.com/BirdeeHub/nixCats-nvim). The flake defines a modular, reproducible Neovim setup that can be built and deployed across NixOS, home-manager, or as a standalone package.

## Common Commands

### Build and Run
```bash
# Build the default package
nix build

# Run neovim directly from the flake
nix run

# Enter development shell
nix develop

# Update flake inputs (nixpkgs, nixCats, etc.)
nix flake update

# Update a specific input
nix flake lock --update-input nixpkgs
nix flake lock --update-input nixCats
```

### Testing and Validation
```bash
# Check flake for errors
nix flake check

# Show flake metadata
nix flake show

# Show flake outputs
nix flake metadata
```

## Architecture

### Core Structure

The flake is organized around the **nixCats builder pattern**, which separates concerns into:

1. **Category Definitions** (flake.nix:67-136): Define what can be included in a package
   - `lspsAndRuntimeDeps`: Runtime dependencies (LSPs, formatters, tools available in PATH)
   - `startupPlugins`: Plugins loaded automatically at startup
   - `optionalPlugins`: Lazy-loadable plugins (use with `packadd`)
   - `sharedLibraries`: Libraries added to LD_LIBRARY_PATH
   - `environmentVariables`: Environment variables for runtime
   - `extraWrapperArgs`: Custom wrapper arguments
   - `python3.libraries`: Python packages for python3 provider
   - `extraLuaPackages`: Lua packages (populates LUA_PATH/LUA_CPATH)

2. **Package Definitions** (flake.nix:144-177): Define actual packages by selecting categories
   - The `nvim` package is the main configuration
   - `settings.wrapRc = true` means Lua config is wrapped into the package
   - `categories` determines which category definitions are active
   - Each category can contain booleans or arbitrary data accessible via `nixCats('path.to.value')` in Lua

3. **Outputs** (flake.nix:183-254):
   - Packages for each system (x86_64-linux, aarch64-darwin, etc.)
   - Development shells
   - NixOS modules (`nixosModules.default`)
   - Home Manager modules (`homeModules.default`)
   - Overlays for use in other flake configurations

### Key Architectural Concepts

**Category-Based Configuration**: Instead of a monolithic config, features are organized into categories that can be toggled. A category set to `true` activates all its plugins, LSPs, and dependencies. Categories can also contain structured data (see `example` category in flake.nix:166-174).

**Lua Path Reference**: The `luaPath` variable (flake.nix:33) points to the root directory where Lua configuration files should be located (currently `./.`). The nixCats framework expects a standard Neovim configuration structure here (init.lua, lua/ directory, etc.).

**Plugin Sources**: Plugins come from:
- `pkgs.vimPlugins`: Standard nixpkgs vim plugins
- `pkgs.neovimPlugins`: Plugins from flake inputs named `plugins-<name>` (see flake.nix:18-26)
- Custom overlays (currently commented out at flake.nix:48)

**Module Integration**: The flake exports both NixOS and Home Manager modules, allowing this config to be imported and customized in system/user configurations. The module namespace is set to the package name (default: `nvim`).

## Development Workflow

### Adding a New Plugin

1. For nixpkgs plugins, add to `categoryDefinitions.startupPlugins` or `optionalPlugins`:
   ```nix
   startupPlugins = {
     general = with pkgs.vimPlugins; [
       telescope-nvim
     ];
   };
   ```

2. For plugins not in nixpkgs, add a flake input named `plugins-<pluginName>`:
   ```nix
   inputs = {
     plugins-custom-plugin = {
       url = "github:author/plugin";
       flake = false;
     };
   };
   ```
   Then reference via `pkgs.neovimPlugins.custom-plugin` in category definitions.

### Adding LSPs/Tools

Add to `categoryDefinitions.lspsAndRuntimeDeps` under the appropriate category:
```nix
lspsAndRuntimeDeps = {
  general = with pkgs; [
    lua-language-server
    stylua
  ];
};
```

### Modifying Package Settings

Edit the `packageDefinitions.nvim.settings` section (flake.nix:150-158):
- `aliases`: Shell aliases for the built package
- `wrapRc`: Whether to wrap Lua config into the package
- `suffix-path` / `suffix-LD`: Append to PATH/LD_LIBRARY_PATH vs prepend

### Accessing Config from Lua

Use `nixCats('category.name')` to query active categories and their values from Lua config:
```lua
if nixCats('general') then
  -- general category is enabled
end

local exampleData = nixCats('example.toThisSet')
-- Returns the array defined in categories
```

## Important Notes

- The flake uses `nixpkgs-unstable` by default for latest packages
- `allowUnfree = true` is set in `extra_pkg_config` (flake.nix:42)
- The default package name is `nvim` (flake.nix:180) - this affects module namespaces and output names
- Neovim nightly overlay is available but commented out (flake.nix:13-15, 157)
- **Files must be tracked by git** to be included in the Nix build (use `git add` before `nix run`)
- When adding plugins that use leader key groups, add corresponding which-key group definitions to `lua/plugins/which-key.lua` spec (e.g., if adding git plugins, add `{ "<leader>g", group = "git" }`)
