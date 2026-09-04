local selected_theme_file = vim.fn.expand("~/nixos-dotfiles/config/theme/selected/selected-theme")

local colorscheme_map = {
  ["gruvbox"]     = "gruvbox",
  ["tokyo-night"] = "tokyonight",
  ["rose-pine"]   = "rose-pine",
}

local function apply_theme()
  local ok, lines = pcall(vim.fn.readfile, selected_theme_file)
  local theme_name = ok and lines[1]
  local colorscheme = colorscheme_map[theme_name]
  local applied = pcall(vim.cmd.colorscheme, colorscheme)
  if not applied then
    vim.cmd.colorscheme("default")
  end
end

if vim.env.NVIM_LISTEN_ADDRESS == nil then
  local sock_dir = vim.fn.expand("~/.cache/nvim-sockets")
  vim.fn.mkdir(sock_dir, "p")
  local sock = sock_dir .. "/" .. tostring(vim.fn.getpid()) .. ".sock"
  vim.fn.serverstart(sock)
end

vim.api.nvim_create_user_command("ReloadTheme", apply_theme, {})

vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    local sock = vim.v.servername
    if sock and sock ~= "" then
      pcall(vim.fn.delete, sock)
    end
  end,
})

apply_theme()
