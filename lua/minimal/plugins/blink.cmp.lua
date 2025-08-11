return {
  {
    -- Autocompletion
    "saghen/blink.cmp",
    event = "VimEnter",
    version = "1.*",
    dependencies = {
      -- AI
      {
        "Exafunction/windsurf.nvim",
        dependencies = {
          "nvim-lua/plenary.nvim",
          "hrsh7th/nvim-cmp",
        },
        config = function()
          local codeium = require("codeium")
          codeium.setup({
            enable_cmp_source = true,
            virtual_text = {
              enabled = true,
              key_bindings = {
                accept = "<S-Tab>",
              },
            },
          })
          local augroup = vim.api.nvim_create_augroup("Codeium", {})
          -- Auto command to disable codium when using oil
          vim.api.nvim_create_autocmd("BufEnter", {
            group = augroup,
            pattern = "*",
            callback = function()
              if vim.bo.filetype == "oil" then codeium.disable() end
            end,
          })
          vim.api.nvim_create_autocmd("BufLeave", {
            group = augroup,
            pattern = "*",
            callback = function()
              if vim.bo.filetype == "oil" then codeium.enable() end
            end,
          })
        end,
      },

      -- Snippet Engine
      {
        "L3MON4D3/LuaSnip",
        version = "2.*",
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then return end
          return "make install_jsregexp"
        end)(),
        dependencies = {
          -- `friendly-snippets` contains a variety of premade snippets.
          --    See the README about individual language/framework/plugin snippets:
          --    https://github.com/rafamadriz/friendly-snippets
          {
            "rafamadriz/friendly-snippets",
            config = function()
              -- VSCode style snippets
              require("luasnip.loaders.from_vscode").lazy_load()

              -- React SnippetsS
              require("luasnip").filetype_extend("javascript", { "javascriptreact" })
              require("luasnip").filetype_extend("javascript", { "html" })
            end,
          },
        },
        config = function()
          local ls = require("luasnip")
          vim.keymap.set({ "i" }, "<C-K>", function() ls.expand({}) end, { silent = true })
          vim.keymap.set({ "i", "s" }, "<C-L>", function() ls.jump(1) end, { silent = true })
          vim.keymap.set({ "i", "s" }, "<C-J>", function() ls.jump(-1) end, { silent = true })
          vim.keymap.set({ "i", "s" }, "<C-E>", function()
            if ls.choice_active() then ls.change_choice(1) end
          end, { silent = true })
        end,
      },
    },
    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
      keymap = {
        preset = "default",
        ["<C-y>"] = { "select_and_accept" },
      },

      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = "mono",
      },

      completion = {
        -- By default, you may press `<c-space>` to show the documentation.
        -- Optionally, set `auto_show = true` to show the documentation after a delay.
        documentation = { auto_show = true, auto_show_delay_ms = 500 },
      },

      sources = {
        default = { "lsp", "buffer", "path", "snippets", "lazydev", "codeium" },
        providers = {
          lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
          codeium = { name = "Codeium", module = "codeium.blink", async = true },
          neopyter = {
            name = "Neopyter",
            module = "neopyter.blink",
            ---@type neopyter.BlinkCompleterOption
            opts = {},
          },
        },
      },
      snippets = { preset = "luasnip" },

      -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
      -- which automatically downloads a prebuilt binary when enabled.
      --
      -- By default, we use the Lua implementation instead, but you may enable
      -- the rust implementation via `'prefer_rust_with_warning'`
      --
      -- See :h blink-cmp-config-fuzzy for more information
      fuzzy = { implementation = "lua" },

      -- Shows a signature help window while you type arguments for a function
      signature = { enabled = true },
    },
  },
}
