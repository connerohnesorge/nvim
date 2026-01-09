return {
  "saghen/blink.cmp",
  version = 'v1.2.0',
  dependencies = {
    { 'echasnovski/mini.nvim', version = false },
    {
      'Kaiser-Yang/blink-cmp-dictionary',
      dependencies = { 'nvim-lua/plenary.nvim' }
    }
  },
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    fuzzy = {
      prebuilt_binaries = {
        force_version = "v1.2.0"
      },
    },
    sources = {
      default = { "dictionary", "path", "lsp", "snippets", "buffer", "lazydev" },

      providers = {
        -- dont show LuaLS require statements when lazydev has items
        path = {
          opts = {
            show_hidden_files_by_default = true,
          },
        },
        lsp = {
          fallbacks = { "path", "buffer", "snippets" },
        },
        lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", fallbacks = { "lsp" } },
        dictionary = {
          module = 'blink-cmp-dictionary',
          name = 'Dict',
          -- Make sure this is at least 2.
          -- 3 is recommended
          min_keyword_length = 3,
          opts = {
            dictionary_files = function()
              if vim.bo.filetype == 'markdown' then
                local bufname = vim.api.nvim_buf_get_name(0)
                if bufname:match("^/tmp/claude%-prompt%-.+%.md$") then
                  return { vim.fn.expand('~/.config/nvim/dictionary/markdown-claude.dict') }
                end
                return { vim.fn.expand('~/.config/nvim/dictionary/markdown.dict') }
              end
              return { vim.fn.expand('~/.config/nvim/dictionary/words.dict') }
            end,
            -- options for blink-cmp-dictionary
          }
        }
      },
    },
    enabled = function()
      return true
    end,
    completion = {
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 10,
      },

      menu = {
        auto_show = function(ctx) return ctx.mode ~= 'cmdline' end,
        draw = {
          columns = {
            { "label",     "label_description", gap = 1 },
            { "kind_icon", "kind" }
          },
          components = {
            kind_icon = {
              ellipsis = false,
              text = function(ctx)
                local kind_icon, _, _ = require('mini.icons').get('lsp', ctx.kind)
                return kind_icon
              end,
              -- Optionally, you may also use the highlights from mini.icons
              highlight = function(ctx)
                local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
                return hl
              end,
            }
          },
        },
      },
    },
    signature = {
      enabled = true,
      window = {
        show_documentation = true,
      },
    },
  },
  opts_extend = { "sources.default" }
}
