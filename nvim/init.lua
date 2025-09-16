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
    "hrsh7th/nvim-cmp",
    dependencies = {
      -- Snippet engine.
      {
        "L3MON4D3/LuaSnip",
        dependencies = {
          -- Use popular snippets from VSCode.
          "rafamadriz/friendly-snippets",
        },

        config = function(_, _)
          require("luasnip.loaders.from_vscode").lazy_load()
          require("luasnip.loaders.from_vscode").lazy_load({ paths = { "./snippets" } })
        end,
      },

      "hrsh7th/cmp-nvim-lsp", -- Integrate with LSP for completion.
      "hrsh7th/cmp-nvim-lua", -- Auto-complete Neovim Lua APIs.
      "hrsh7th/cmp-buffer", -- Suggets words in the buffer as completions.
      "hrsh7th/cmp-path", -- Helps complete local filesystem paths.
      "saadparwaiz1/cmp_luasnip", -- Show snippets in the completion popup.

      -- Auto-close parentheses, etc.
      {
        "windwp/nvim-autopairs",
        config = function(_, opts)
          require("nvim-autopairs").setup({
            fast_wrap = {},
            disable_filetype = {
              "TelescopePrompt",
              "vim",
            },
          })

          require("cmp").event:on(
            "confirm_done",
            require("nvim-autopairs.completion.cmp").on_confirm_done()
          )
        end,
      },
    },
    event = "InsertEnter",
    opts = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      return {
        view = {
          entries = "native",
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = {
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }),

          ["<Tab>"] = function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end,
          ["<S-Tab>"] = function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end,
        },
        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "nvim_lua" },
          { name = "path" },
        },
      }
    end,
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

          selection_caret = "  ",
          preview = false,
          prompt_title = false,
          results_title = false,
          storting_strategy = "ascending",

          layout_strategy = "bottom_pane",
          layout_config = {
            height = 10,
            prompt_position = "bottom",
          },
          borderchars = {
            prompt = { " ", " ", "─", " ", " ", " ", "─", "─" },
            results = { "─", " ", " ", " ", "─", "─", " ", " " },
          },
        },
      }
    end,
  },

  -- Traditional-style sidebar.
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    opts = {
      filters = { dotfiles = true },
      disable_netrw = true,
      hijack_cursor = true,
      sync_root_with_cwd = true,
      update_focused_file = {
        enable = true,
        update_root = false,
      },
      view = {
        width = 30,
        preserve_window_proportions = true,
      },
      renderer = {
        root_folder_label = false,
      },
    },
  },

  -- Magit-like Git interface.
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    cmd = { "Neogit" },
    config = true,
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

map("n", "<A-k>", ":m .-2<CR>==") -- Swap line up.
map("n", "<A-j>", ":m .+1<CR>==") -- Swap line down.

map("c", "<C-a>", "<Home>")

------- Telescope --------------------------------------------------------------

map("n", "<leader>B", "<cmd> :Telescope buffers <CR>")
map("n", "<leader>P", "<cmd> :Telescope find_files <CR>")
map("n", "<leader>R", "<cmd> :Telescope live_grep <CR>")

------- Tree/sidebar -----------------------------------------------------------

map("n", "<C-b>", "<cmd> :NvimTreeToggle <CR>")

------- Neogit -----------------------------------------------------------------

map("n", "<leader>G", "<cmd> :Neogit <CR>")
