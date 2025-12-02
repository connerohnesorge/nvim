---@diagnostic disable: missing-fields
return {
  'neovim/nvim-lspconfig',
  event = { "BufReadPost", "BufNewFile" },
  on_attach = function(client, bufnr)
    require('completion').on_attach(client, bufnr)
    require('lsp_signature').on_attach()
  end,
  dependencies = {
    'j-hui/fidget.nvim',
    "folke/lazydev.nvim",
    "folke/neoconf.nvim",
    'hrsh7th/vim-vsnip',
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  },
  opts = {
    diagnostics = {
      underline = true,
      update_in_insert = false,
      virtual_text = {
        spacing = 4,
        source = "if_many",
        prefix = "●",
      },
      severity_sort = true,
    },
    ---@class lspconfig.options
    servers = {
      -- phpactor = {},
      -- volar = {},
      svelte_ls = {},
      vue_ls = {},
      -- harper_ls = {
      --   settings = {
      --     ["harper-ls"] = {
      --       userDictPath = "",
      --       fileDictPath = "",
      --       linters = {
      --         SpellCheck = true,
      --         SpelledNumbers = false,
      --         AnA = true,
      --         SentenceCapitalization = true,
      --         UnclosedQuotes = true,
      --         WrongQuotes = false,
      --         LongSentences = true,
      --         RepeatedWords = true,
      --         Spaces = true,
      --         Matcher = true,
      --         CorrectNumberSuffix = true
      --       },
      --       codeActions = {
      --         ForceStable = false
      --       },
      --       markdown = {
      --         IgnoreLinkTitle = false
      --       },
      --       diagnosticSeverity = "hint",
      --       isolateEnglish = false,
      --       dialect = "American"
      --     }
      --   }
      -- },

      -- basics_ls = {
      --   settings = {
      --     buffer = {
      --       enable = false,
      --     },
      --     path = {
      --       enable = false,
      --     },
      --     snippet = {
      --       enable = true,
      --       sources = {
      --         vim.fn.stdpath("config") .. "/snippets",
      --       },                       -- paths to package containing snippets, see examples below
      --       matchStrategy = 'fuzzy', -- or 'fuzzy'
      --     },
      --   }
      -- },
      -- nushell = {},
      astro = {},
      golangci_lint_ls = {
      },
      lua_ls = {
        settings = {
          Lua = { workspace = { checkThirdParty = false, }, },
        },
      },
      biome = {},
      oxlint = {},
      ocamlls = {},
      -- clangd = {},
      ccls = {
        init_options = {
          cache = {
            directory = ".ccls-cache",
          },
        }
      },
      -- elmls = {},
      -- basedpyright = {},
      pyrefly = {},
      protols = {
        single_file_support = false,
        cmd = { "protols", "--include-paths=/home/connerohnesorge/Documents/002Orgs/pegwings/pegwings/proto/lib,/home/connerohnesorge/Documents/002Orgs/pegwings/pegwings/proto/src" },
      },
      -- clangd = {},
      ts_ls = {},
      rust_analyzer = {},
      texlab = {},
      vhdl_ls = {},
      tailwindcss = {},
      hdl_checker = {},
      jsonls = {},
      yamlls = {},
      -- verible = {},
      dockerls = {},
      -- astro = {},
      svelte = {},
      -- htmx = {},
      -- hyprls = {},
      cssls = {},
      nixd = {
        -- formatting = {
        --   format_on_save = true,
        -- },
      },
      gopls = {
        settings = {
          gopls = {
            experimentalPostfixCompletions = true,
            analyses = {
              unusedparams = true,
              shadow = true,
            },
            staticcheck = true,
          },
        },
        init_options = {
          usePlaceholders = true,
        }
      },
      zls = {},
      templ = {},
      sqls = {},
    }
  },
  config = function(_, opts)
    vim.filetype.add({ extension = { templ = "templ" } })
    local blink = require('blink.cmp')
    for server, config in pairs(opts.servers) do
      config.capabilities = blink.get_lsp_capabilities(config.capabilities)
      vim.lsp.config(server, config)
      vim.lsp.enable(server)
    end


    vim.api.nvim_create_autocmd("LspAttach", {
      --- @param args vim.api.keyset.create_autocmd.callback_args
      callback = function(args)
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id), "must have valid client")

        if vim.bo.filetype ~= "go" then -- vim.go handles formatting
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = args.buf,
            callback = function()
              vim.lsp.buf.format({
                bufnr = args.buf,
                id = client.id,
                name = client.name,
              })
            end,
          })
        end

        local builtin = require("telescope.builtin")
        vim.keymap.set(
          'n',
          '<leader>rn',
          vim.lsp.buf.rename,
          { buffer = args.buf, desc = '[R]e[n]ame' }
        )
        vim.keymap.set(
          'n',
          '<leader>cf',
          vim.lsp.buf.format,
          { buffer = args.buf, desc = '[C]ode [F]ormat' }
        )
        -- vim.keymap.set(
        --   'n',
        --   '<leader>ca',
        --   vim.lsp.buf.code_action,
        --   { buffer = args.buf, desc = '[C]ode [A]ction' }
        -- )
        vim.keymap.set({ "n", "x" }, "<leader>ca", function()
          require("tiny-code-action").code_action()
        end, { noremap = true, silent = true })
        vim.keymap.set(
          'n',
          '<leader>ls',
          vim.lsp.buf.document_symbol,
          { buffer = args.buf, desc = '[L]ocate [S]ymbols' }
        )
        vim.keymap.set(
          'n',
          '<leader>lws',
          vim.lsp.buf.workspace_symbol,
          { buffer = args.buf, desc = '[W]orkspace [S]ymbols' }
        )
        vim.keymap.set(
          'n',
          '<leader>sh',
          vim.lsp.buf.signature_help,
          { buffer = args.buf, desc = '[S]ignature [H]elp' }
        )
        vim.keymap.set(
          'n',
          'K',
          vim.lsp.buf.hover,
          { buffer = args.buf, desc = '[H]over' }
        )
        vim.keymap.set(
          'n',
          'gd',
          builtin.lsp_definitions,
          { buffer = args.buf, desc = '[D]efinition' }
        )
        vim.keymap.set('n', '<leader>gr', builtin.lsp_references, {
          desc = '[G]oto [R]eferences'
        })
        vim.keymap.set('n', '<leader>ds', builtin.lsp_document_symbols, {
          desc = '[D]ocument [S]ymbols'
        })
        vim.keymap.set('n', '<leader>ws', builtin.lsp_workspace_symbols, {
          desc = '[W]orkspace [S]ymbols'
        })
        vim.keymap.set(
          'n',
          '<leader>li',
          builtin.lsp_implementations,
          {
            buffer = args.buf,
            desc = '[I]mplementation'
          })
        vim.keymap.set('n', '<leader>lt', vim.lsp.buf.type_definition, { buffer = args.buf, desc = '[T]ypeDefinition' })

        -- :Format command
        vim.api.nvim_create_user_command("Format", function()
          vim.lsp.buf.format({ bufnr = args.buf, async = true })
        end, {})
      end,
    })
  end,
}
