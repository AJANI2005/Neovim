return {
  "Vigemus/iron.nvim",
  config = function()
    local iron = require("iron.core")
    local view = require("iron.view")
    local common = require("iron.fts.common")

    iron.setup({
      config = {
        -- Whether a repl should be discarded or not
        scratch_repl = true,
        -- Your repl definitions come here
        repl_definition = {
          sh = {
            -- Can be a table or a function that
            -- returns a table (see below)
            command = { "zsh" },
          },
          python = {
            command = { "python3" }, -- or { "ipython", "--no-autoindent" }
            format = common.bracketed_paste_python,
            block_dividers = { "# %%", "#%%" },
          },
        },
        -- set the file type of the newly created repl to ft
        -- bufnr is the buffer id of the REPL and ft is the filetype of the
        -- language being used for the REPL.
        repl_filetype = function(bufnr, ft)
          return ft
          -- or return a string name such as the following
          -- return "iron"
        end,
        -- How the repl window will be displayed
        -- See below for more information
        repl_open_cmd = view.split.vertical.rightbelow("%40"),

        -- repl_open_cmd can also be an array-style table so that multiple
        -- repl_open_commands can be given.
        -- When repl_open_cmd is given as a table, the first command given will
        -- be the command that `IronRepl` initially toggles.
        -- Moreover, when repl_open_cmd is a table, each key will automatically
        -- be available as a keymap (see `keymaps` below) with the names
        -- toggle_repl_with_cmd_1, ..., toggle_repl_with_cmd_k
        -- For example,
        --
        -- repl_open_cmd = {
        --   view.split.vertical.rightbelow("%40"), -- cmd_1: open a repl to the right
        --   view.split.rightbelow("%25")  -- cmd_2: open a repl below
        -- }
      },
      -- Iron doesn't set keymaps by default anymore.
      -- You can set them here or manually add keymaps to the functions in iron.core
      -- If the highlight is on, you can change how it looks
      -- For the available options, check nvim_set_hl
      highlight = {
        italic = true,
      },
      ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
    })
    -- Keymaps
    local augroup = vim.api.nvim_create_augroup("Iron", {})

    vim.api.nvim_create_autocmd("BufLeave", {
      group = augroup,
      pattern = "*.py",
      callback = function() end,
    })

    vim.api.nvim_create_autocmd("BufEnter", {
      group = augroup,
      pattern = "*.py",
      callback = function()
        local wk = require("which-key")
        local core = require("iron.core")
        local bufrn = vim.api.nvim_get_current_buf()

        wk.add({
          { "<leader>rt", function() core.repl_for("python") end, desc = "Toggle REPL", buffer = bufrn },
          { "<leader>rR", core.repl_restart, desc = "Restart REPL", buffer = bufrn },
          { "<leader>re", core.send_motion, desc = "Send Motion", buffer = bufrn },
          { "<leader>rv", core.mark_visual, desc = "Visual Send", buffer = bufrn },
          { "<leader>rf", core.send_file, desc = "Send File", buffer = bufrn },
          { "<leader>rl", core.send_line, desc = "Send Line", buffer = bufrn },
          { "<leader>rp", core.send_paragraph, desc = "Send Paragraph", buffer = bufrn },
          { "<leader>ru", core.send_until_cursor, desc = "Send Until Cursor", buffer = bufrn },
          { "<leader>rm", core.send_mark, desc = "Send Mark", buffer = bufrn },
          { "<leader>rb", function() core.send_code_block(false) end, desc = "Send Code Block", buffer = bufrn },
          { "<leader>rn", function() core.send_code_block(true) end, desc = "Send Code Block + Move", buffer = bufrn },
          { "<leader>rx", core.mark_motion, desc = "Mark Motion", buffer = bufrn },
          { "<leader>ry", core.mark_visual, desc = "Mark Visual", buffer = bufrn },
          { "<leader>rd", core.remove_mark, desc = "Remove Mark", buffer = bufrn },
          { "<leader>r<cr>", core.cr, desc = "Carriage Return", buffer = bufrn },
          { "<leader>ri", core.interrupt, desc = "Interrupt", buffer = bufrn },
          { "<leader>rq", core.exit, desc = "Exit", buffer = bufrn },
          { "<leader>rX", function() core.send("python", "clear") end, desc = "Clear", buffer = bufrn },
        }, { group = "[R]epl Python" })
      end,
    })
  end,
}
