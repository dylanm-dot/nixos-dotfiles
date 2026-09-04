return {
    'nvim-treesitter/nvim-treesitter',
    build = ":TSUpdate",
    branch = "master",
    config = function()
	local configs = require("nvim-treesitter.configs")
	configs.setup({
	    highlight = {
		enable = true,
	    },
	    indent = { enable = true },
	    autotage = { enable = true },
	    ensure_installed = {
		"lua",
		"javascript"
	    },
	    auto_install = false,
	})
    end
}













































