function getCurrentTimeRFC3339()
  local currentTime = os.time()
  local timezone = os.difftime(currentTime, os.time(os.date("!*t", currentTime)))
  local sign = "+"
  if timezone < 0 then
    sign = "-"
    timezone = -timezone
  end
  local tzHours = math.floor(timezone / 3600)
  local tzMinutes = math.floor((timezone % 3600) / 60)
  local formattedTime = os.date("%Y-%m-%dT%H:%M:%S", currentTime)
  return string.format("%s.000%s%02d:%02d", formattedTime, sign, tzHours, tzMinutes)
end

return {
  "epwalsh/obsidian.nvim",
  version = "*",
  lazy = true,
  event = "InsertEnter",
  ft = "markdown",
  -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
  -- event = {
  --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
  --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
  --   "BufReadPre path/to/my-vault/**.md",
  --   "BufNewFile path/to/my-vault/**.md",
  -- },
  dependencies = {
    -- Required.
    "nvim-lua/plenary.nvim",
  },
  ---@class obsidian.config.ClientOpts
  opts = {
    workspaces = {
      {
        name = "personal",
        path = "~/Documents/000Vaults/SecondBrain",
      },
      -- {
      --   name = "conneroh.com",
      --   path = "~/Documents/001Repos/conneroh.com/internal/data",
      -- },
    },

    yaml_parser = "yq",
    ui = {
      enable = false,
    },

    ---@return table
    note_frontmatter_func = function(note)
      -- Add the title of the note as an alias.
      if note.title then
        note:add_alias(note.title)
      end


      local out = { id = note.id, aliases = note.aliases, tags = note.tags }

      -- `note.metadata` contains any manually added fields in the frontmatter.
      -- So here we just make sure those fields are kept in the frontmatter.
      if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
        for k, v in pairs(note.metadata) do
          out[k] = v
        end
      end

      -- Add the created date of the note as an alias if not already present.
      if not out.created_at then
        out.created_at = getCurrentTimeRFC3339()
      end

      -- title is required for the note to be saved. (default: {filename})
      if not out.title then
        out.title = note.title
      end

      -- description is required for the note to be saved. (default: {filename})
      if not out.description then
        out.description = note.title
      end

      out.updated_at = getCurrentTimeRFC3339()

      return out
    end,
  },
  completion = {
    -- Set to false to disable completion.
    nvim_cmp = true,
    -- Trigger completion at 2 chars.
    min_chars = 1,
  },
  templates = {
    subdir = "templates",
    date_format = "%Y-%m-%d",
    time_format = "%H:%M",
    -- A map for custom variables, the key should be the variable and the value a function
    substitutions = {},
  },
}
