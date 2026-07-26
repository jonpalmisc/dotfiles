--[[  init.lua  ]]

-- For maximum portability, this config supports a "lite" and "full" mode. Full
-- mode is enabled by the presence of a `local.lua` (which is ignored by Git). A
-- fresh clone defaults to lite mode: no packages, no LSP, built-in colorscheme.
local local_config = vim.fn.stdpath("config") .. "/local.lua"
local full = vim.fn.filereadable(local_config) == 1

-- Configure leader before any plugins or mappings use it.
vim.g.mapleader = ";"
vim.g.maplocalleader = ";"

--[[  CORE BEHAVIOR  ]]

vim.opt.history = 100 -- Command history size.
vim.opt.clipboard = "unnamedplus" -- Use system clipboard.

vim.opt.mouse = "a" -- Enable mouse.
vim.opt.mousescroll = "ver:1,hor:0" -- Prevent horizontal scrolling.

vim.opt.splitbelow = true -- Split below on horizontal splits.
vim.opt.splitright = true -- Split to right on vertical splits.

-- Use `fd` for finding files, if present.
if vim.fn.executable("fd") == 1 then
  function _G.FdFindFiles(cmdarg, _cmdcomplete)
    -- The `funcfunc` can be called in two separate contexts: either the
    -- user is requesting completion based on a search term, or the user has
    -- provided a specific path they want to open.
    --
    -- We should always first check if this is the latter instance, as
    -- attempting to search and match on an already-complete path can lead
    -- to confusing E345 errors.
    if #cmdarg > 0 and vim.fn.filereadable(cmdarg) == 1 then
      return { cmdarg }
    end

    local args = { "fd", "--color=never", "--type", "f", "--" }
    if #cmdarg > 0 then
      table.insert(args, cmdarg)
    end

    return vim.fn.systemlist(args)
  end

  vim.o.findfunc = "v:lua.FdFindFiles"
end

-- Use `rg` for `:grep`, if present.
if vim.fn.executable("rg") == 1 then
  vim.opt.grepprg = "rg --vimgrep"
  vim.opt.grepformat = "%f:%l:%c:%m"
end

-- Always open quickfix list after running commands that populate it.
vim.api.nvim_create_autocmd("QuickFixCmdPost", {
  pattern = "[^l]*", -- Except with `l` functions.
  callback = function()
    vim.cmd("copen")
  end,
})

--[[  EDITING EXPERIENCE  ]]

vim.cmd([[set iskeyword-=-]]) -- Treat hyphens as word separators.
vim.cmd([[set iskeyword-=_]]) -- Treat underscores as word separators.

vim.opt.backspace = { "indent", "eol", "start" } -- Sensible backspace behavior.

vim.opt.autoindent = true -- Match current indentation on new lines.
vim.opt.smartindent = true -- Use smarter auto-indent when available.

vim.opt.wrap = false -- Disable soft wrapping.
vim.opt.textwidth = 80 -- Hard-wrap at 80 columns.
vim.opt.joinspaces = false -- Single space after period on join.
vim.opt.formatoptions = vim.opt.formatoptions - "t" -- Don't auto-wrap code.

vim.api.nvim_create_autocmd("FileType", {
  pattern = "rust",
  callback = function()
    vim.opt_local.textwidth = 100
  end,
})

vim.opt.conceallevel = 0 -- Don't hide characters, e.g. in Markdown.

vim.opt.ignorecase = true -- Ignore case when searching.
vim.opt.smartcase = true -- Use case in mixed-case searches.

vim.opt.autocomplete = true -- Use built-in autocomplete.
vim.opt.complete:append("o") -- Use omnifunc.
vim.opt.completeopt = {
  "menuone", -- Always show menu.
  "noselect", -- Don't auto-select first option.
}

-- Use more natural bindings for completion.
vim.keymap.set("i", "<Tab>", function()
  return vim.fn.pumvisible() == 1 and "<C-n>" or "<Tab>"
end, { expr = true })
vim.keymap.set("i", "<S-Tab>", function()
  return vim.fn.pumvisible() == 1 and "<C-p>" or "<S-Tab>"
end, { expr = true })

--[[  FILE HANDLING  ]]

vim.opt.encoding = "utf-8" -- Always use UTF-8 internally.
vim.opt.fileencoding = "utf-8" -- Always use UTF-8 on disk.

vim.opt.backup = false -- Disable backup files.
vim.opt.swapfile = false -- Disable swap files.
vim.opt.autoread = true -- Auto-reload modified files.

vim.opt.hidden = true -- Enable background buffers.

--[[  APPEARANCE  ]]

vim.opt.number = false -- Hide line numbers.
vim.opt.signcolumn = "yes:1" -- Use constant & fixed-width sign column.

vim.opt.pumheight = 8 -- Make popup menu 8 lines high.

vim.opt.scrolloff = 6 -- Add vertical scroll margin.

vim.opt.hlsearch = true -- Highlight search pattern.
vim.opt.showmatch = true -- Highlight character pairs.

vim.opt.cursorline = true -- Highlight line with cursor.

vim.opt.colorcolumn = "+1" -- Show fill column indicator.

-- Show trailing whitespace as a red background (instead of dots).
vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
  callback = function()
    vim.api.nvim_set_hl(0, "Whitespace", { bg = "#cc3333", fg = "#cc3333" })
  end,
})

vim.opt.wildoptions = "pum" -- Use popup menu for command completion.

vim.opt.termguicolors = true -- Use better colors in terminal.

--[[  PERFORMANCE  ]]

vim.opt.synmaxcol = 160 -- Don't syntax highlight past 160 characters.

-- Reduce idle time debounce; makes plugins that use the `CursorHold`
-- autocommand more responsive.
vim.opt.updatetime = 250

vim.opt.shortmess:append("I") -- Hide intro/startup message.

-- Disabel unused providers (faster startup).
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

-- Disable unused built-in plugins.
vim.g.loaded_2html_plugin = 1
vim.g.loaded_gzip = 1
vim.g.loaded_matchit = 1
vim.g.loaded_rrhelper = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1

--[[  PACKAGE MANAGEMENT  ]]

if full then
  vim.pack.add({
    "https://github.com/miikanissi/modus-themes.nvim",
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/windwp/nvim-autopairs",
    "https://github.com/nvim-mini/mini.pick",
    "https://github.com/sindrets/diffview.nvim",
    "https://github.com/NeogitOrg/neogit",
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/tpope/vim-sleuth",
  })

  require("modus-themes").setup({
    styles = {
      comments = { italic = true },
      keywords = { italic = false },
    },
  })
  vim.cmd("colorscheme modus")

  require("nvim-autopairs").setup({})
  require("mini.pick").setup()
  require("diffview").setup({})

  require("neogit").setup({
    disable_hint = true,
    graph_style = "unicode",
    remember_settings = false,
    use_per_project_settings = false,
  })
end

--[[  LSP  ]]

if full then
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(ev)
      local map = vim.keymap.set
      local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))

      if client:supports_method("textDocument/completion") then
        vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
      end

      map("n", "<localleader>gD", vim.lsp.buf.declaration, { buffer = ev.buf })
      map("n", "<localleader>gd", vim.lsp.buf.definition, { buffer = ev.buf })
      map("n", "<localleader>gi", vim.lsp.buf.implementation, { buffer = ev.buf })
      map("n", "<localleader>gr", vim.lsp.buf.references, { buffer = ev.buf })
      map("n", "<localleader>lr", vim.lsp.buf.rename, { buffer = ev.buf })
      map("n", "<localleader>la", vim.lsp.buf.code_action, { buffer = ev.buf })
      map("n", "<localleader>ld", vim.diagnostic.open_float, { buffer = ev.buf })
      map("i", "<C-k>", vim.lsp.buf.signature_help, { buffer = ev.buf })
    end,
  })

  vim.lsp.enable({ "clangd", "rust_analyzer", "ty", "ts_ls" })
end

--[[  KEYBINDINGS  ]]

local map = vim.keymap.set

-- Quickly find files.
map("n", "<leader>P", ":find ")

-- Make `C-l` center & clear highlight.
map("n", "<C-l>", "zz:noh<CR>")

-- Re-center after `C-u` and `C-d`.
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- Emacs-style line permutation.
map("n", "<A-k>", ":m .-2<CR>==")
map("n", "<A-j>", ":m .+1<CR>==")

-- Add some readline bindings in command mode.
map("c", "<C-a>", "<Home>")
map("c", "<C-e>", "<End>")

-- Quick binding for grep.
map("n", "<leader>R", ":silent grep ")

-- Quick binding for Neogit.
map("n", "<leader>G", "<cmd> :Neogit <CR>")

--[[  LOCAL OVERRIDES  ]]

if full then
  dofile(local_config)
end
