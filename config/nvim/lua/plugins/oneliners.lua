return {
    { 'tpope/vim-fugitive' },
    {
	'brenoprata10/nvim-highlight-colors',
	config = function()
	    require('nvim-highlight-colors').setup({})
	end
    },
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    {
	'windwp/nvim-autopairs',
	event = "InsertEnter",
	config = true
    }
}
