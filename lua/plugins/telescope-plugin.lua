return {
  'nvim-telescope/telescope.nvim',
  tag = 'v0.2.0',
  event = 'BufWinEnter',
  dependencies = {
    'nvim-telescope/telescope-media-files.nvim',
    'nvim-telescope/telescope-ui-select.nvim',
    'nvim-lua/popup.nvim',
    'nvim-lua/plenary.nvim',
    'nvim-lua/plenary.nvim',
    'nvim-lua/popup.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end
    },
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build =
      'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
    },
  },
  config = function()
    local telescope = require("telescope")
    local built_in = require "telescope.builtin"
    local multigrep = require("conneroisu.multigrep")
    telescope.load_extension('media_files')
    telescope.setup({
      extensions = {
        fzf = {
          fuzzy = true,
        },
        project = {
          default_action = "open",
          mappings = {
            ["<CR>"] = "open",
            ["<C-t>"] = "tabedit",
            ["<C-v>"] = "vsplit",
            ["<C-x>"] = "split",
          },
        },
        media_files = {
          -- filetypes whitelist
          filetypes = { "png", "webp", "jpg", "jpeg", "pdf", "mp4" },
          find_cmd = "rg"
        }
      },
    })
    -- bind Control + o to open recent files in normal mode
    vim.keymap.set("n", "<C-o>", built_in.oldfiles, {
      noremap = true,
      silent = true,
      desc = "Open Recent Files",
    })
    -- map telescope live_grep to leader + l + g
    vim.keymap.set("n", "<leader>lg", multigrep.multigrep, {
      desc = "Open Telescope Live Grep"
    })
    -- bind leader + f + f to open telescope in normal mode for files
    vim.keymap.set('n', '<space><space>', built_in.find_files, {
      desc = '[F]ind [F]iles'
    })
    -- See `:help telescope.builtin`
    vim.keymap.set('n', '<leader>?', built_in.oldfiles, {
      desc = '[?] Find recently opened files'
    })
    vim.keymap.set('n', '<leader><space>', built_in.buffers, {
      desc = '[ ] Find existing buffers'
    })
    vim.keymap.set('n', '<leader>gf', built_in.git_files, {
      desc = 'Search [G]it [F]iles'
    })
    vim.keymap.set('n', '<leader>sf', built_in.find_files, {
      desc = '[S]earch [F]iles'
    })
    vim.keymap.set('n', '<leader>sh', built_in.help_tags, {
      desc = '[S]earch [H]elp'
    })
    vim.keymap.set('n', '<leader>sw', built_in.grep_string, {
      desc = '[S]earch current [W]ord'
    })
    vim.keymap.set('n', '<leader>sg', built_in.live_grep, {
      desc = '[S]earch by [G]rep'
    })
    vim.keymap.set('n', '<leader>sd', built_in.diagnostics, {
      desc = '[S]earch [D]iagnostics'
    })
    vim.keymap.set('n', '<leader>sr', built_in.resume, {
      desc = '[R]esume [S]earch'
    })
  end
}
