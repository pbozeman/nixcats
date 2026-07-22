# neovim flake using nixcats
#
# Copyright (c) 2023 BirdeeHub
# Copyright (c) 2025 Patrick Bozeman

{
  description = "neovim flake using nixcats";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";

    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # neovim-nightly-overlay = {
    #   url = "github:nix-community/neovim-nightly-overlay";
    # };

    # see :help nixCats.flake.inputs If you want your plugin to be loaded by the
    # standard overlay, i.e. if it wasnt on nixpkgs, but doesnt have an extra
    # build step. Then you should name it "plugins-something" If you wish to
    # define a custom build step not handled by nixpkgs, then you should name it
    # in a different format, and deal with that in the overlay defined for
    # custom builds in the overlays directory. for specific tags, branches and
    # commits, see:
    # https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake.html#examples
  };

  # see :help nixCats.flake.outputs
  outputs =
    {
      self,
      nixpkgs,
      nixCats,
      ...
    }@inputs:
    let
      inherit (nixCats) utils;
      luaPath = ./.;
      forEachSystem = utils.eachSystem nixpkgs.lib.platforms.all;

      # the following extra_pkg_config contains any values
      # which you want to pass to the config set of nixpkgs
      # import nixpkgs { config = extra_pkg_config; inherit system; }
      # will not apply to module imports
      # as that will have your system values
      extra_pkg_config = {
        allowUnfree = true;
      };

      # management of the system variable is one of the harder parts of using
      # flakes.

      # see :help nixCats.flake.outputs.overlays
      dependencyOverlays = # (import ./overlays inputs) ++
        [
          # This overlay grabs all the inputs named in the format
          # `plugins-<pluginName>`
          # Once we add this overlay to our nixpkgs, we are able to
          # use `pkgs.neovimPlugins`, which is a set of our plugins.
          (utils.standardPluginOverlay inputs)

          # Override neo-tree-nvim with latest version from GitHub
          # to fix manual close issue:
          # https://github.com/nvim-neo-tree/neo-tree.nvim/issues/1415
          (final: prev: {
            vimPlugins = prev.vimPlugins // {
              neo-tree-nvim = prev.vimPlugins.neo-tree-nvim.overrideAttrs (old: {
                src = final.fetchFromGitHub {
                  owner = "nvim-neo-tree";
                  repo = "neo-tree.nvim";
                  rev = "20244beec28b9d79ffb75fe1b1606f4dd8d476fc";
                  hash = "sha256-Y5onzNckqFpVjglFtngrz6NhhiGvR+CbLzT8W+YnQ7Q=";
                };
              });
            };
          })

          # when other people mess up their overlays by wrapping them with
          # system, you may instead call this function on their overlay. it will
          # check if it has the system in the set, and if so return the desired
          # overlay
          # (utils.fixSystemizedOverlay inputs.codeium.overlays
          #   (system: inputs.codeium.overlays.${system}.default)
          # )
        ];

      # see :help nixCats.flake.outputs.categories
      # and
      # :help nixCats.flake.outputs.categoryDefinitions.scheme
      categoryDefinitions =
        {
          pkgs,
          settings,
          categories,
          extra,
          name,
          mkPlugin,
          ...
        }:
        {
          # to define and use a new category, simply add a new list to a set
          # here, and later, you will include categoryname = true; in the set
          # you provide when you build the package using this builder function.
          # see :help nixCats.flake.outputs.packageDefinitions for info on that
          # section.

          # lspsAndRuntimeDeps:
          # this section is for dependencies that should be available
          # at RUN TIME for plugins. Will be available to PATH within neovim terminal
          # this includes LSPs
          lspsAndRuntimeDeps = {
            general =
              with pkgs;
              [
                # Fuzzy finder tools
                fd
                fzf
                ripgrep

                # Bash
                bash-language-server
                shfmt

                # C/C++
                clang-tools

                # CMake
                cmake-format
                neocmakelsp

                # Go
                gofumpt
                goimports-reviser
                golines
                gopls

                # JavaScript/TypeScript
                prettier
                typescript-language-server

                # Lua
                lua-language-server
                stylua

                # Markdown
                markdownlint-cli2
                marksman

                # Nix
                alejandra
                nil
                nixfmt

                # Python
                black
                isort
                pyright

                # Quarto (markdown-based scientific documents)
                quarto

                # Rust
                rust-analyzer
                rustfmt

                # TeX/LaTeX
                tex-fmt

                # TOML
                taplo

                # Web (HTML, CSS, JSON, ESLint)
                vscode-langservers-extracted

                # YAML
                yaml-language-server
              ]
              # Verilog/SystemVerilog - exclude on Darwin due to bazel build issues
              ++ pkgs.lib.optionals (!pkgs.stdenv.isDarwin) [
                verible
              ];
          };

          # This is for plugins that will load at startup without using packadd:
          startupPlugins = {
            gitPlugins = with pkgs.neovimPlugins; [ ];
            general = with pkgs.vimPlugins; [
              blink-cmp
              clangd_extensions-nvim
              conform-nvim
              diffview-nvim
              friendly-snippets
              gitsigns-nvim
              indent-blankline-nvim
              lualine-nvim
              marks-nvim
              mini-nvim
              neo-tree-nvim
              nvim-lspconfig
              nvim-treesitter.withAllGrammars
              nvim-treesitter-context
              nvim-treesitter-textobjects
              nvim-ts-autotag
              nvim-web-devicons
              render-markdown-nvim
              smartyank-nvim
              snacks-nvim
              tint-nvim
              todo-comments-nvim
              tokyonight-nvim
              trouble-nvim
              ts-comments-nvim
              vim-tmux-navigator
              which-key-nvim
              yanky-nvim
            ];
          };

          # not loaded automatically at startup.
          # use with packadd and an autocommand in config to achieve lazy loading
          optionalPlugins = {
            gitPlugins = with pkgs.neovimPlugins; [ ];
            general = with pkgs.vimPlugins; [ ];
          };

          # shared libraries to be added to LD_LIBRARY_PATH
          # variable available to nvim runtime
          sharedLibraries = {
            general = with pkgs; [
              # libgit2
            ];
          };

          # environmentVariables:
          # this section is for environmentVariables that should be available at
          # RUN TIME for plugins. Will be available to path within neovim
          # terminal
          environmentVariables = {
            test = {
              CATTESTVAR = "It worked!";
            };
          };

          # If you know what these are, you can provide custom ones by category
          # here. If you dont, check this link out:
          # https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/setup-hooks/make-wrapper.sh
          extraWrapperArgs = {
            general = [
              ''--run 'mkdir -p "''${XDG_DATA_HOME:-$HOME/.local/share}/nvim/spell"' ''
            ];
            test = [
              ''--set CATTESTVAR2 "It worked again!"''
            ];
          };

          # lists of the functions you would have passed to
          # python.withPackages or lua.withPackages
          # do not forget to set `hosts.python3.enable` in package settings

          # get the path to this python environment
          # in your lua config via
          # vim.g.python3_host_prog
          # or run from nvim terminal via :!<packagename>-python3
          python3.libraries = {
            test = (_: [ ]);
          };
          # populates $LUA_PATH and $LUA_CPATH
          extraLuaPackages = {
            test = [ (_: [ ]) ];
          };
        };

      # And then build a package with specific categories from above here: All
      # categories you wish to include must be marked true, but false may be
      # omitted. This entire set is also passed to nixCats for querying within
      # the lua.

      # see :help nixCats.flake.outputs.packageDefinitions
      packageDefinitions = {
        # These are the names of your packages
        # you can include as many as you wish.
        nvim =
          { pkgs, name, ... }:
          {
            # they contain a settings set defined above
            # see :help nixCats.flake.outputs.settings
            settings = {
              suffix-path = true;
              suffix-LD = true;
              wrapRc = true;
              # IMPORTANT:
              # your alias may not conflict with your other packages.
              aliases = [ "vim" ];
              # neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${pkgs.system}.neovim;
            };
            # and a set of categories that you want
            # (and other information to pass to lua)
            categories = {
              general = true;
              gitPlugins = true;
              customPlugins = true;
              test = true;
              example = {
                youCan = "add more than just booleans";
                toThisSet = [
                  "and the contents of this categories set"
                  "will be accessible to your lua with"
                  "nixCats('path.to.value')"
                  "see :help nixCats"
                ];
              };
            };
          };
      };

      # In this section, the main thing you will need to do is change the
      # default package name to the name of the packageDefinitions entry you
      # wish to use as the default.
      defaultPackageName = "nvim";
    in

    # see :help nixCats.flake.outputs.exports
    forEachSystem (
      system:
      let
        nixCatsBuilder = utils.baseBuilder luaPath {
          inherit
            nixpkgs
            system
            dependencyOverlays
            extra_pkg_config
            ;
        } categoryDefinitions packageDefinitions;
        defaultPackage = nixCatsBuilder defaultPackageName;

        # this is just for using utils such as pkgs.mkShell
        # The one used to build neovim is resolved inside the builder
        # and is passed to our categoryDefinitions and packageDefinitions
        pkgs = import nixpkgs { inherit system; };

        # git-hooks.nix drives both the local pre-commit hook (installed via
        # the devShell shellHook) and the `checks.<system>.pre-commit` flake
        # output that CI builds. Single source of truth for formatting/lint.
        pre-commit-check = inputs.git-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            # Lua
            stylua.enable = true;

            # Nix
            nixfmt.enable = true;
            deadnix = {
              enable = true;
              settings = {
                noLambdaArg = true;
                noLambdaPatternNames = true;
              };
            };

            # Shell
            shellcheck = {
              enable = true;
              # .envrc is a direnv rc file (`use flake`), not a standalone
              # script; shellcheck flags it for a missing shebang (SC2148).
              excludes = [ "^\\.envrc$" ];
            };
            shfmt = {
              enable = true;
              settings = {
                case-indent = true;
                indent = 2;
              };
            };

            # Markdown
            prettier = {
              enable = true;
              types = [ "markdown" ];
              settings.prose-wrap = "always";
            };

            # YAML
            yamlfmt = {
              enable = true;
              # write fixes (not just lint); config is the auto-discovered
              # ./.yamlfmt file, which keeps blank lines.
              settings.lint-only = false;
            };
            yamllint = {
              enable = true;
              settings.configuration = ''
                extends: relaxed

                rules:
                  line-length:
                    max: 120
              '';
            };

            # JSON (flake.lock is nix-managed; don't touch it)
            check-json = {
              enable = true;
              excludes = [ "flake\\.lock" ];
            };

            # Secrets
            gitleaks = {
              enable = true;
              name = "gitleaks";
              description = "Scan staged changes for secrets";
              entry = "${pkgs.gitleaks}/bin/gitleaks git --pre-commit --staged --redact --no-banner --no-color";
              always_run = true;
              pass_filenames = false;
            };
          };
        };
      in
      {
        # these outputs will be wrapped with ${system} by utils.eachSystem

        # this will make a package out of each of the packageDefinitions defined
        # above and set the default package to the one passed in here.
        packages = utils.mkAllWithDefault defaultPackage;

        checks = {
          pre-commit = pre-commit-check;
        };

        # choose your package for devShell
        # and add whatever else you want in it.
        devShells = {
          default = pkgs.mkShell {
            name = defaultPackageName;
            inherit (pre-commit-check) shellHook;
            packages =
              with pkgs;
              [
                stylua
                nixfmt
              ]
              ++ pre-commit-check.enabledPackages;
            inputsFrom = [ ];
          };
        };

      }
    )
    // (
      let
        # we also export a nixos module to allow reconfiguration from
        # configuration.nix
        nixosModule = utils.mkNixosModules {
          moduleNamespace = [ defaultPackageName ];
          inherit
            defaultPackageName
            dependencyOverlays
            luaPath
            categoryDefinitions
            packageDefinitions
            extra_pkg_config
            nixpkgs
            ;
        };

        # and the same for home manager
        homeModule = utils.mkHomeModules {
          moduleNamespace = [ defaultPackageName ];
          inherit
            defaultPackageName
            dependencyOverlays
            luaPath
            categoryDefinitions
            packageDefinitions
            extra_pkg_config
            nixpkgs
            ;
        };
      in
      {
        # these outputs will be NOT wrapped with ${system}

        # this will make an overlay out of each of the packageDefinitions
        # defined above and set the default overlay to the one named here.
        overlays = utils.makeOverlays luaPath {
          inherit nixpkgs dependencyOverlays extra_pkg_config;
        } categoryDefinitions packageDefinitions defaultPackageName;

        nixosModules.default = nixosModule;
        homeModules.default = homeModule;

        inherit utils nixosModule homeModule;
        inherit (utils) templates;
      }
    );
}
