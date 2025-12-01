-- BASICS
local o = vim.opt
o.swapfile, o.undofile, o.undodir = false, true, os.getenv("HOME") .. "/.vim/undo"
o.foldmethod, o.foldmarker = "marker", "{{{,}}}"
vim.keymap.set("n", "gn", "<cmd>bn!<CR>")
vim.keymap.set("n", "gp", "<cmd>bp!<CR>")

-- CP RUNNER (Autocmd + Keymap)
vim.api.nvim_create_autocmd("FileType", { pattern = { "cpp", "python" }, callback = function(args)
	local cmds = { cpp = ":w<CR>:!ccr % in<CR>", python = ":w<CR>:!python3 % < in<CR>" }
	vim.keymap.set("n", "<C-k>", cmds[args.match], { buffer = true })
end })

-- LAZY BOOTSTRAP
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- PLUGINS & CONFIG
require("lazy").setup({
	"neovim/nvim-lspconfig", "hrsh7th/nvim-cmp", "hrsh7th/cmp-nvim-lsp", "L3MON4D3/LuaSnip",
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			require("mason").setup()
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "pylsp", "clangd" },
				handlers = { function(s) require("lspconfig")[s].setup({}) end }
			})
		end
	},
	{   -- Treesitter
		"nvim-treesitter/nvim-treesitter", build = ":TSUpdate",
		dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
		main = "nvim-treesitter.configs", -- allows using 'opts' instead of full config func
		opts = {
			auto_install = true, highlight = { enable = true },
			ensure_installed = { "c", "lua", "vim", "python", "cpp" },
			textobjects = { select = {
				enable = true, lookahead = true,
				keymaps = {
					["af"] = "@function.outer", ["if"] = "@function.inner",
					["ac"] = "@class.outer", ["ic"] = "@class.inner"
				}
			}}
		}
	}
})

-- KEYMAPS
pcall(function() require("config.keymaps").setup() end)
