return {
	{
		"mfussenegger/nvim-dap",
		event = "VeryLazy",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
			"jay-babu/mason-nvim-dap.nvim",
			"theHamsta/nvim-dap-virtual-text",
		},
		config = function()
			local mason_dap = require("mason-nvim-dap")
			local dap = require("dap")
			local ui = require("dapui")
			local dap_virtual_text = require("nvim-dap-virtual-text")

			-- Keymaps
			vim.keymap.set(
				"n",
				"<leader>dt",
				dap.toggle_breakpoint,
				{ desc = "Toggle Breakpoint", nowait = true, remap = false }
			)
			vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Continue", nowait = true, remap = false })
			vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Step Into", nowait = true, remap = false })
			vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "Step Over", nowait = true, remap = false })
			vim.keymap.set("n", "<leader>du", dap.step_out, { desc = "Step Out", nowait = true, remap = false })
			vim.keymap.set("n", "<leader>dr", function()
				dap.repl.open()
			end, { desc = "Open REPL", nowait = true, remap = false })
			vim.keymap.set("n", "<leader>dl", dap.run_last, { desc = "Run Last", nowait = true, remap = false })
			vim.keymap.set("n", "<leader>db", function()
				print(vim.inspect(dap.list_breakpoints()))
			end, { desc = "List Breakpoints", nowait = true, remap = false })
			vim.keymap.set("n", "<leader>de", function()
				dap.set_exception_breakpoints({ "all" })
			end, { desc = "Set Exception Breakpoints", nowait = true, remap = false })
			vim.keymap.set("n", "<leader>dq", function()
				dap.terminate()
				ui.close()
				dap_virtual_text.toggle()
			end, { desc = "Terminate", nowait = true, remap = false })

			-- Setup
			-- Dap Virtual Text
			dap_virtual_text.setup({})

			mason_dap.setup({
				ensure_installed = { "cppdbg" },
				automatic_installation = false,
				handlers = {
					function(config)
						require("mason-nvim-dap").default_setup(config)
					end,
				},
			})

			-- Configurations
			dap.configurations = {}

			-- Dap UI

			ui.setup()

			vim.fn.sign_define("DapBreakpoint", { text = "🐞" })

			dap.listeners.before.attach.dapui_config = function()
				ui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				ui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				ui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				ui.close()
			end
		end,
	},
}
