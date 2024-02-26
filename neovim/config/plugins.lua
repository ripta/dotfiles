vim.g.plugin_home = vim.fn.stdpath('data') .. '/site/pack/packer'

-- bootstrap_packer(): ensure the plugin manager (packer) is installed by
-- git-cloning it. The return value is false if packer was already installed,
-- or true if this is the first time packer was installed.
--
-- Once installed, packer manages packer itself; see the `init(use)` function
-- farther down in this file.
--
-- XXX(ripta): what if installation fails?
local function bootstrap_packer()
  local dir = vim.g.plugin_home .. '/opt/packer.nvim'

  if vim.loop.fs_stat(dir) then
    -- vim.api.nvim_echo({ { 'packer.nvim is installed', 'Type' } }, true, { })
    return false
  end

  vim.api.nvim_echo({ { 'Installing packer.nvim...', 'Type' } }, true, { })

  local repo = 'https://github.com/wbthomason/packer.nvim'
  local cmd = string.format('!git clone --depth=1 %s %s', repo, dir)
  vim.cmd(cmd)
  return true
end

local first_time = bootstrap_packer()
vim.cmd('packadd packer.nvim')

local packer = require('packer')
local util = require('packer.util')

local function init(use)
  -- Impatient should always be first
  use {
    'lewis6991/impatient.nvim',
    config = function()
      require('impatient')
    end,
  }

  -- Packer can manage packer
  use { 'wbthomason/packer.nvim', opt = true }

  -- Solarized colorscheme
  use {
    'maxmx03/solarized.nvim',
    config = function()
      vim.opt.background = 'dark'
      vim.cmd.colorscheme('solarized')
    end,
  }
  use { 'tjdevries/colorbuddy.nvim' }
  use {
    'svrana/neosolarized.nvim',
    after = 'colorbuddy.nvim',
    config = function()
      local neo = require('neosolarized').setup({
        background_set = true,
      })
      neo.Group.link('WarningMsg', neo.groups.Comment)
    end,
  }

  -- Package manager for LSP, DAP, linters, and formatters
  use {
    'williamboman/mason.nvim',
    config = function()
      require('mason').setup()
    end,
  }
  use {
    'williamboman/mason-lspconfig.nvim',
    config = function()
      require('mason-lspconfig').setup({
        automatic_installation = true,
      })
    end,
  }

  -- Pictograms for nvim's language server popups
  use { 'onsails/lspkind-nvim', event = 'VimEnter' }

  -- Autocompletion
  use {
    'hrsh7th/nvim-cmp',
    after = 'lspkind-nvim',
    config = function()
      local cmp = require('cmp')
      cmp.setup({
        completion = {
          completeopt = 'menu,menuone,noinsert',
        },
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'nvim_lua' },
          { name = 'buffer'   },
          { name = 'path'     },
        })
      })
    end,
  }
  use { 'hrsh7th/cmp-nvim-lsp', after = 'nvim-cmp' }
  use { 'hrsh7th/cmp-path',     after = 'nvim-cmp' }
  use { 'hrsh7th/cmp-buffer',   after = 'nvim-cmp' }
  use { 'hrsh7th/cmp-omni',     after = 'nvim-cmp' }
  use {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = function()
        require("nvim-autopairs").setup()
    end,
  }
  use {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end,
  }

  -- Quickstart configs for nvim's language server
  use {
    'neovim/nvim-lspconfig',
    after = 'cmp-nvim-lsp',
    config = function()
      local cfg = require('lspconfig')

      cfg.gopls.setup {}
      cfg.rust_analyzer.setup {
        settings = {
          ['rust-analyzer'] = {
            cargo = { allFeatures = true },
            checkOnSave = {
              command = 'clippy',
              extraArgs = { '--no-deps' },
            },
          },
        },
      }
      cfg.terraformls.setup {}
      cfg.tsserver.setup {}
      cfg.yamlls.setup {}
    end,
  }

  -- Incremental syntax highlighter
  use {
    'nvim-treesitter/nvim-treesitter',
    event = 'BufReadPost',
    run = function()
      local fn = require('nvim-treesitter.install').update({ with_sync = true })
      fn()
    end,
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = {
          -- Required since neovim-0.8.0 https://github.com/nvim-treesitter/nvim-treesitter/issues/3092
          -- although 'help' is not available
          'c', 'lua', 'vim',

          -- Customized groups of languages
          'bash', 'cpp', 'css', 'diff',
          'gitignore', 'go', 'graphql', 'html',
          'java', 'javascript', 'json',
          'markdown', 'perl', 'python', 'regex',
          'rust', 'sql', 'svelte', 'terraform', 'toml', 'tsx',
          'typescript', 'vimdoc', 'yaml',
        },
        sync_install = true,
        auto_install = true,
        highlight = {
          enable = true,
        },
        indent = {
          enable = true,
          -- disable = { 'python' },
        },
      })
    end,
  }

  -- Fuzzy finder
  use { 'nvim-lua/plenary.nvim' }
  use {
    'nvim-telescope/telescope.nvim',
    config = function()
      pcall(require('telescope').load_extension, 'fzf')

      local ts = require('telescope.builtin')
      vim.keymap.set('n', '<leader>fb', ts.buffers,    { desc = '[f]uzzy [b]uffers' })
      vim.keymap.set('n', '<leader>ff', ts.find_files, { desc = '[f]uzzy [f]iles'   })
      vim.keymap.set('n', '<leader>fg', ts.live_grep,  { desc = '[f]uzzy [g]rep'    })
      vim.keymap.set('n', '<leader>fh', ts.oldfiles,   { desc = '[f]uzzy [h]istory' })
    end
  }

  -- Snazzier statusline
  use {
    'nvim-lualine/lualine.nvim',
    event = 'VimEnter',
    config = function()
      require('lualine').setup({
        options = {
          icons_enabled = true,
          theme = 'auto',
          section_separators = '',
          component_separators = '',
          disabled_filetypes = {},
          always_divide_middle = true,
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'branch' },
          lualine_c = {
            { 'filename', path = 1 },
          },
          lualine_x = {
            'encoding',
            {
              'fileformat',
              symbols = {
                unix = 'unix',
                dos = 'win',
                mac = 'mac',
              },
            },
            'filetype',
          },
          lualine_y = { 'progress' },
          lualine_z = {
            'location',
            {
              'diagnostics',
              sources = { 'nvim_diagnostic' },
            },
            {
              require('statusline.trailing_space'),
              color = 'WarningMsg',
            },
          },
        },
        tabline = {},
        extensions = { 'oil' },
      })
    end,
  }

  -- File tree explorer
  use {
    'stevearc/oil.nvim',
    config = function()
      local oil = require('oil')
      oil.setup()
      vim.keymap.set('n', '<leader>ft', oil.open_float, { desc = '[f]ile [t]ree' })
    end,
  }

  -- Snazzier bufferline
  use {
    'kyazdani42/nvim-web-devicons',
    event = 'VimEnter',
  }
  use {
    'akinsho/bufferline.nvim',
    tag = 'v3.*',
    requires = 'nvim-tree/nvim-web-devicons',
    config = function()
      require('bufferline').setup({
        options = {
          numbers = 'buffer_id',
          close_command = 'bdelete! %d',
          indicator = {
            icon = "▎",
            style = "icon",
          },
          buffer_close_icon = "",
          modified_icon = "●",
          close_icon = "",
          left_trunc_marker = "",
          right_trunc_marker = "",
          max_name_length = 18,
          max_prefix_length = 15,
          tab_size = 10,
          diagnostics = false,
        },
      })
    end,
  }

  -- Autodetect tabstop and shiftwidth
  use { 'tpope/vim-sleuth' }

  -- Golang-specific plugins
  --- use { 'ray-x/guihua.lua' }
  --- use {
  ---   'ray-x/go.nvim',
  ---   after = {
  ---     'guihua.lua',
  ---     'nvim-lspconfig',
  ---     'nvim-treesitter',
  ---   },
  ---   config = function()
  ---     require('go').setup()
  ---   end,
  ---   build = function()
  ---     require('go.install').update_all_sync()
  ---   end,
  ---   event = { 'CmdlineEnter' },
  ---   ft = { 'go', 'gomod' },
  --- }
end

packer.startup {
  init,
  config = {
    compile_path = util.join_paths(vim.fn.stdpath('data'), 'site/lua/packer_compiled.lua'),
  },
}

if first_time then
  packer.sync()
else
  local ok, _ = pcall(require, 'packer_compiled')
  if not ok then
    local msg = 'Could not find packer_compiled.lua; run ":PackerSync"'
    vim.notify(msg, vim.log.levels.ERROR, { title = 'plugins.lua' })
  end
end

vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
  pattern = '*/neovim/config/plugins.lua',
  group = vim.api.nvim_create_augroup('packer_autocompile', { clear = true }),
  callback = function(ctx)
      local cmd = 'source ' .. ctx.file
      vim.cmd(cmd)
      vim.cmd('PackerCompile')
      vim.notify('PackerCompile succeeded', vim.log.levels.INFO, { title = 'plugins.lua' })
  end,
})

return packer
