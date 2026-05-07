--============================================================================--
--                                                                            --
--                   B A S I C   C O N F I G U R A T I O N                    --
--                                                                            --
--============================================================================--

------- Editing/fundamentals ---------------------------------------------------

vim.opt.history = 100 -- Command history size.

vim.opt.mouse = "a" -- Enable mouse support.
vim.opt.mousescroll = "ver:1,hor:0" -- Improve mouse/trackpad scrolling.

vim.opt.autoindent = true -- Match indentation when starting a new line.
vim.opt.smartindent = true -- Indent automatically via syntax hints.

vim.opt.wrap = false -- Don't wrap long lines.
vim.opt.textwidth = 80 -- Use 80 columns for hard wrapping.
vim.opt.formatoptions = vim.opt.formatoptions - "t" -- But don't auto-wrap code.

vim.opt.backspace = { "indent", "eol", "start" } -- Make backspace sensible.

vim.opt.clipboard = "unnamedplus" -- Integrate yank/paste with native clipboard.

vim.cmd([[set iskeyword-=-]]) -- Treat hyphens as word separators.
vim.cmd([[set iskeyword-=_]]) -- Treat underscores as word separators.

vim.opt.showmatch = true -- Highlight character pairs.
vim.opt.hlsearch = true -- Highlight search matches.

vim.opt.ignorecase = true -- Ignore case when searching.
vim.opt.smartcase = true -- Don't ignore case if the search is mixed-case.

vim.opt.conceallevel = 0 -- Don't hide characters, e.g. in Markdown

vim.opt.splitbelow = true -- Split below on horizontal splits.
vim.opt.splitright = true -- Split to right on vertical splits.

-- Configure (local) leader before any plugins or other files use it.
vim.g.mapleader = ";"
vim.g.maplocalleader = ";"

------- File handling ----------------------------------------------------------

vim.opt.encoding = "utf-8" -- Always use UTF-8 internally.
vim.opt.fileencoding = "utf-8" -- Always save files as UTF-8.

vim.opt.backup = false -- Disable backup files.
vim.opt.swapfile = false -- Don't use swapfiles.

vim.opt.hidden = true -- Enable background buffers.

vim.opt.autoread = true -- Auto-reload modified files.

------- Appearance & visual behavior -------------------------------------------

-- The combination of these two settings prevents the buffer content from
-- jumping back-and-forth horizontally when signs are added/removed.
vim.opt.number = false -- Show line numbers.
vim.opt.signcolumn = "yes:1" -- Show signs in place of line numbers.

vim.opt.cursorline = true -- Highlight line with cursor.

vim.opt.completeopt = { "menuone", "noselect" }
vim.opt.pumheight = 8 -- Limit number of popup menu items.

vim.opt.scrolloff = 6 -- Add vertical scrolling margin.

------- Performance & miscellaneous tweaks -------------------------------------

vim.opt.lazyredraw = true -- Use faster scrolling?
vim.opt.synmaxcol = 160 -- Syntax highlighting stop column (helps performance).
vim.opt.updatetime = 250 -- Run faster, allegedly.
vim.opt.shortmess = "I" -- Hide intro message.

-- Disable some provider nonsense.
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

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

--============================================================================--
--                                                                            --
--                    P A C K A G E   M A N A G E M E N T                     --
--                                                                            --
--============================================================================--

vim.pack.add({
  "https://github.com/miikanissi/modus-themes.nvim",
  "https://github.com/tpope/vim-sleuth",
  "https://github.com/windwp/nvim-autopairs",
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "master" },
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/rafamadriz/friendly-snippets",
  { src = "https://github.com/saghen/blink.cmp", version = "v1" },
  "https://github.com/nvim-lualine/lualine.nvim",
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/nvim-telescope/telescope.nvim",
  "https://github.com/NeogitOrg/neogit",
  "https://github.com/ej-shafran/compile-mode.nvim",
})

vim.opt.termguicolors = true
require("modus-themes").setup({
  dim_inactive = true,
  styles = {
    comments = { italic = true },
    keywords = { italic = false },
  },
})
vim.cmd("colorscheme modus")

require("nvim-autopairs").setup({})

require("nvim-treesitter.configs").setup({
  highlight = { enable = true },
  indent = { enable = false },
  ensure_installed = {
    "asm",
    "bash",
    "c",
    "cmake",
    "comment",
    "cpp",
    "css",
    "diff",
    "html",
    "javascript",
    "jsdoc",
    "json",
    "jsonc",
    "lua",
    "luadoc",
    "markdown",
    "markdown_inline",
    "objc",
    "printf",
    "python",
    "regex",
    "rust",
    "toml",
    "typescript",
    "vim",
    "vimdoc",
    "xml",
    "yaml",
  },
})

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    local map = vim.keymap.set

    map("n", "<localleader>gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", { buffer = ev.buf })
    map("n", "<localleader>gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { buffer = ev.buf })
    map("n", "<localleader>gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", { buffer = ev.buf })
    map("n", "<localleader>gr", "<cmd>lua vim.lsp.buf.references()<CR>", { buffer = ev.buf })
    map("n", "<localleader>lr", "<cmd>lua vim.lsp.buf.rename()<CR>", { buffer = ev.buf })
    map("n", "<localleader>la", "<cmd>lua vim.lsp.buf.code_action()<CR>", { buffer = ev.buf })
    map("n", "<localleader>ld", "<cmd>lua vim.diagnostic.open_float()<CR>", { buffer = ev.buf })

    map("i", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", { buffer = ev.buf })
  end,
})
vim.lsp.enable({ "clangd", "rust_analyzer", "pyright", "ty", "ts_ls", "zls" })

require("blink.cmp").setup({
  fuzzy = { implementation = "prefer_rust_with_warning" },
  keymap = { preset = "super-tab" },
  completion = {
    documentation = { auto_show = true },
    menu = {
      draw = {
        columns = {
          { "label", "label_description", gap = 1 },
          { "kind" },
        },
      },
    },
  },
  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
  },
})

require("lualine").setup({
  options = {
    icons_enabled = false,
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = {},
    lualine_c = { "filename" },
    lualine_x = {},
    lualine_y = {},
    lualine_z = { "location" },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { "filename" },
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
})

require("telescope").setup({
  defaults = {
    mappings = {
      i = {
        ["<esc>"] = require("telescope.actions").close,
      },
    },

    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
    },

    preview = false,
    results_title = false,
    storting_strategy = "ascending",
    selection_caret = "  ",

    layout_strategy = "bottom_pane",
    layout_config = {
      height = 12,
      prompt_position = "bottom",
    },
    borderchars = {
      prompt = { "─", " ", "─", " ", " ", " ", "─", "─" },
      results = { "─", " ", " ", " ", "─", "─", " ", " " },
    },
  },
})

require("neogit").setup({
  disable_hint = true,
  disable_signs = true,
  graph_style = "unicode",
  remember_settings = false,
  use_per_project_settings = false,
})

vim.g.compile_mode = {
  input_word_completion = true,
  bang_expansion = true,
  recompile_no_fail = true,
  buffer_name = "[Compile]",
}

--============================================================================--
--                                                                            --
--                           K E Y B I N D I N G S                            --
--                                                                            --
--============================================================================--

-- Since we use package lazy-loading based on command names, we register
-- mappings separately from package initialization so that triggering these
-- mappings can load packages on demand.

local map = vim.keymap.set

------- General/builtin --------------------------------------------------------

map("n", "<C-l>", "zz:noh<CR>")
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

map("n", "<A-k>", ":m .-2<CR>==") -- Swap line up.
map("n", "<A-j>", ":m .+1<CR>==") -- Swap line down.

map("c", "<C-a>", "<Home>")
map("c", "<C-e>", "<End>")

------- Telescope --------------------------------------------------------------

map("n", "<leader>B", "<cmd> :Telescope buffers<CR>")
map("n", "<leader>P", "<cmd> :Telescope find_files<CR>")
map("n", "<leader>O", "<cmd> :Telescope lsp_workspace_symbols<CR>")
map("n", "<leader>R", "<cmd> :Telescope live_grep<CR>")

------- Neogit -----------------------------------------------------------------

map("n", "<leader>G", "<cmd> :Neogit cwd=%:p:h <CR>")

------- Compile Mode -----------------------------------------------------------

map("n", "<leader>C", "<cmd> :Compile <CR>")
map("n", "<leader>c", "<cmd> :Recompile <CR>")
