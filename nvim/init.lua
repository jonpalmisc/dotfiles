--============================================================================--
--                                                                            --
--                   B A S I C   C O N F I G U R A T I O N                    --
--                                                                            --
--============================================================================--

------- Editing/fundamentals ---------------------------------------------------

vim.opt.history = 100 -- Set max history size.

vim.opt.mouse = "" -- No mouse!

vim.opt.autoindent = true -- Indent automatically.
vim.opt.smartindent = true

vim.opt.wrap = false -- Don't wrap long lines.
vim.opt.textwidth = 80 -- Use 80 columns for hard wrapping.

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

vim.opt.encoding = "utf-8" -- Always use UTF-8.
vim.opt.fileencoding = "utf-8"

vim.opt.backup = false -- Disable backup files.
vim.opt.swapfile = false -- Don't use swapfiles.

vim.opt.hidden = true -- Enable background buffers.

vim.opt.autoread = true -- Auto-reload modified files.

------- Appearance & visual behavior -------------------------------------------

-- The combination of these two settings prevents the buffer content from
-- jumping back-and-forth horizontally when signs are added/removed.
--
vim.opt.number = true -- Show line numbers.
vim.opt.signcolumn = "number" -- Show signs in place of line numbers.

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

--============================================================================--
--                                                                            --
--                    P A C K A G E   M A N A G E M E N T                     --
--                                                                            --
--============================================================================--

local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazy_path) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazy_path,
  })
end

vim.opt.rtp:prepend(lazy_path)

require("lazy").setup({
  -- Personal color scheme.
  {
    dir = "~/Developer/Source/Personal/nvim_industrial_theme",
    lazy = false,
    priority = 1000,
    config = function()
      vim.opt.termguicolors = true
      vim.cmd("colorscheme industrial")
    end,
  },

  -- Auto-detect indentation on a per-file basis so that Neovim inserts
  -- the right amount of indentation by default during editing.
  { "tpope/vim-sleuth", lazy = false },

  -- Better and faster syntax highlighting.
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        highlight = { enable = true },
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
    end,
  },

  -- Well-maintained configurations for many common LSP servers for
  -- automatic integration with Neovim's LSP support.
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      local on_attach = function(_, buf)
        local map = vim.keymap.set

        map("n", "<localleader>gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", { buffer = true })
        map("n", "<localleader>gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { buffer = true })
        map("n", "<localleader>gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", { buffer = true })
        map("n", "<localleader>gr", "<cmd>lua vim.lsp.buf.references()<CR>", { buffer = true })
        map("n", "<localleader>lr", "<cmd>lua vim.lsp.buf.rename()<CR>", { buffer = true })
        map("n", "<localleader>la", "<cmd>lua vim.lsp.buf.code_action()<CR>", { buffer = true })
        map("n", "<localleader>ld", "<cmd>lua vim.diagnostic.open_float()<CR>", { buffer = true })

        map("i", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", { buffer = true })
      end

      local capabilities = vim.lsp.protocol.make_client_capabilities()

      -- Further-configure completion options.
      capabilities.textDocument.completion.completionItem = {
        documentationFormat = { "markdown", "plaintext" },
        snippetSupport = true,
        preselectSupport = true,
        insertReplaceSupport = true,
        labelDetailsSupport = true,
        deprecatedSupport = true,
        commitCharactersSupport = true,
        tagSupport = { valueSet = { 1 } },
        resolveSupport = {
          properties = {
            "documentation",
            "detail",
            "additionalTextEdits",
          },
        },
      }

      local lsp = require("lspconfig")

      local servers = { "clangd", "rust_analyzer", "pyright", "ts_ls", "zls" }
      for _, server in pairs(servers) do
        lsp[server].setup({
          on_attach = on_attach,
          capabilities = capabilities,
        })
      end
    end,
  },

  -- Pop-up code completion.
  {
    "saghen/blink.cmp",
    lazy = false,
    dependencies = { "rafamadriz/friendly-snippets" },
    version = "1.*",
    opts = {
      fuzzy = { implementation = "prefer_rust_with_warning" },
      keymap = { preset = "enter" },
      completion = { documentation = { auto_show = true } },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
    },
    opts_extend = { "sources.default" },
  },

  -- Generic fuzzy-finder API, provides "command palette"-like search
  -- interfaces for files, LSP symbols, etc.
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "Telescope" },
    opts = function()
      return {
        defaults = {
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
          storting_strategy = "ascending",
          selection_caret = "  ",

          layout_strategy = "bottom_pane",
          layout_config = {
            height = 12,
            prompt_position = "top",
          },
          borderchars = {
            prompt = { "─", " ", "─", " ", " ", " ", "─", "─" },
            results = { "─", " ", " ", " ", "─", "─", " ", " " },
          },
        },
      }
    end,
  },

  -- Magit-like Git interface.
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    cmd = { "Neogit" },
    opts = {
      disable_hint = true,
    },
  },

  "rktjmp/lush.nvim", -- Framework for easily building themes.
  "rktjmp/shipwright.nvim", -- Used for exporting theme to other formats.
}, {
  defaults = {
    lazy = true,
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "2html_plugin",
        "tohtml",
        "getscript",
        "getscriptPlugin",
        "gzip",
        "logipat",
        "netrw",
        "netrwPlugin",
        "netrwSettings",
        "netrwFileHandlers",
        "matchit",
        "tar",
        "tarPlugin",
        "rrhelper",
        "spellfile_plugin",
        "vimball",
        "vimballPlugin",
        "zip",
        "zipPlugin",
        "tutor",
        "rplugin",
        "syntax",
        "synmenu",
        "optwin",
        "compiler",
        "bugreport",
        "ftplugin",
      },
    },
  },
})

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

map("n", "<C-l>", ":noh<CR>zz")
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

map("n", "<leader>G", "<cmd> :Neogit <CR>")
