{
  description = "Conner Ohnesorge's Neovim configuration, built with nvf";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Plugins not packaged in nixpkgs.
    gopher-nvim = {
      url = "github:olexsmir/gopher.nvim";
      flake = false;
    };
    sad-nvim = {
      url = "github:ray-x/sad.nvim";
      flake = false;
    };
    nvim-macros = {
      url = "github:kr40/nvim-macros";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    nvf,
    ...
  } @ inputs: let
    systems = ["aarch64-darwin" "x86_64-darwin" "aarch64-linux" "x86_64-linux"];
    forAllSystems = f:
      nixpkgs.lib.genAttrs systems (system:
        f (import nixpkgs {
          inherit system;
          # eyeliner.nvim has no license, so nixpkgs marks it unfree.
          config.allowUnfreePredicate = pkg: nixpkgs.lib.getName pkg == "eyeliner.nvim";
        }));
  in {
    packages = forAllSystems (pkgs: let
      vp = pkgs.vimPlugins;

      # Keys are the lazy.nvim plugin names (repo basenames). lazy.nvim loads each
      # spec from `<dir>/<name>` instead of cloning it. Adding a plugin spec under
      # lua/plugins requires adding it here.
      plugins = {
        "lazy.nvim" = vp.lazy-nvim;
        "better-escape.nvim" = vp.better-escape-nvim;
        "blink-cmp-dictionary" = vp.blink-cmp-dictionary;
        "blink.cmp" = vp.blink-cmp;
        "eyeliner.nvim" = vp.eyeliner-nvim;
        "fidget.nvim" = vp.fidget-nvim;
        "fzf-lua" = vp.fzf-lua;
        "gitsigns.nvim" = vp.gitsigns-nvim;
        "gopher.nvim" = inputs.gopher-nvim;
        "guihua.lua" = vp.guihua-lua;
        "gx.nvim" = vp.gx-nvim;
        "harpoon" = vp.harpoon2;
        "lazydev.nvim" = vp.lazydev-nvim;
        "luvit-meta" = vp.luvit-meta;
        "mini.nvim" = vp.mini-nvim;
        "mini.surround" = vp.mini-surround;
        "neoconf.nvim" = vp.neoconf-nvim;
        "neogen" = vp.neogen;
        "nightfox.nvim" = vp.nightfox-nvim;
        "nui.nvim" = vp.nui-nvim;
        "nvim-autopairs" = vp.nvim-autopairs;
        "nvim-dap" = vp.nvim-dap;
        "nvim-dap-go" = vp.nvim-dap-go;
        "nvim-dap-ui" = vp.nvim-dap-ui;
        "nvim-dap-virtual-text" = vp.nvim-dap-virtual-text;
        "nvim-lspconfig" = vp.nvim-lspconfig;
        "nvim-macros" = inputs.nvim-macros;
        "nvim-nio" = vp.nvim-nio;
        "nvim-scissors" = vp.nvim-scissors;
        "nvim-scrollbar" = vp.nvim-scrollbar;
        "nvim-treesitter" = vp.nvim-treesitter;
        "nvim-treesitter-context" = vp.nvim-treesitter-context;
        "nvim-treesitter-textobjects" = vp.nvim-treesitter-textobjects;
        "nvim-web-devicons" = vp.nvim-web-devicons;
        "oil.nvim" = vp.oil-nvim;
        "one-small-step-for-vimkind" = vp.one-small-step-for-vimkind;
        "plenary.nvim" = vp.plenary-nvim;
        "popup.nvim" = vp.popup-nvim;
        "sad.nvim" = inputs.sad-nvim;
        "snacks.nvim" = vp.snacks-nvim;
        "telescope-fzf-native.nvim" = vp.telescope-fzf-native-nvim;
        "telescope-media-files.nvim" = vp.telescope-media-files-nvim;
        "telescope-ui-select.nvim" = vp.telescope-ui-select-nvim;
        "telescope.nvim" = vp.telescope-nvim;
        "tiny-code-action.nvim" = vp.tiny-code-action-nvim;
        "todo-comments.nvim" = vp.todo-comments-nvim;
        "trouble.nvim" = vp.trouble-nvim;
        "undotree" = vp.undotree;
        "vim-dadbod" = vp.vim-dadbod;
        "vim-dadbod-completion" = vp.vim-dadbod-completion;
        "vim-dadbod-ui" = vp.vim-dadbod-ui;
        "vim-fugitive" = vp.vim-fugitive;
        "vim-go" = vp.vim-go;
        "vim-signify" = vp.vim-signify;
        "vim-sleuth" = vp.vim-sleuth;
        "vim-visual-multi" = vp.vim-visual-multi;
        "which-key.nvim" = vp.which-key-nvim;
      };

      pluginDir = pkgs.linkFarm "nvim-lazy-plugins" plugins;

      neovim =
        (nvf.lib.neovimConfiguration {
          inherit pkgs;
          modules = [
            {
              config.vim = {
                # Share config/data/state dirs (macros, snippets, undo, shada) with plain nvim.
                appname = "nvim";
                additionalRuntimePaths = [self.outPath];
                # Grammars go on packpath because the nvim-treesitter main branch
                # cannot compile parsers into the read-only store.
                startPlugins = vp.nvim-treesitter.withAllGrammars.dependencies;
                luaConfigRC.user = ''
                  vim.g.nix_plugins = "${pluginDir}"
                  dofile("${self.outPath}/init.lua")
                '';
              };
            }
          ];
        }).neovim;
    in {
      default = neovim;
      inherit neovim;
    });
  };
}
