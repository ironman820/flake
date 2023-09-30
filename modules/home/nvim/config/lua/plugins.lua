return {
  -- Auto Pairs
  {
    "windwp/nvim-autopairs",
  },
  -- Bufferline Extension
  {
    "akinsho/bufferline.nvim",
    dependencies = "nvim-tree/nvim-web-devicons"
  },
  -- Color Scheme
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
  },
  -- Git Integration
  {
    "lewis6991/gitsigns.nvim",
  },
  -- Hop
  {
    "phaazon/hop.nvim",
    lazy = true,
  },
  -- Indent Highlighting
  {
    "lukas-reineke/indent-blankline.nvim",
  },
  -- LSP Config
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v3.x",
    dependencies = {
      -- LSP Support
      "neovim/nvim-lspconfig",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      -- Autocompletion
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lua",
      -- Snippets
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
      "lvimuser/lsp-inlayhints.nvim",
    },
  },
  -- Lualine Extension
  {
    "nvim-lualine/lualine.nvim",
    dependencies = "nvim-tree/nvim-web-devicons"
  },
  -- Nvim-Surround
  {
    "kylechui/nvim-surround",
    config = function()
      require("nvim-surround").setup({})
    end
  },
  -- Nvimtree
  {
    "nvim-tree/nvim-tree.lua",
    lazy = true,
    dependencies = "nvim-tree/nvim-web-devicons",
  },
  -- Rainbow Highlighting
  {
    "HiPhish/nvim-ts-rainbow2",
  },
  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    lazy = true,
    dependencies = "nvim-lua/plenary.nvim",
  },
  -- Toggle Term
  {
    "akinsho/toggleterm.nvim",
  },
  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
  },
  -- Undo-Tree
  {
    "jiaoshijie/undotree",
    dependencies = "nvim-lua/plenary.nvim",
  },
  -- Which-key Extension
  {
    "folke/which-key.nvim",
    lazy = true,
  }
}
