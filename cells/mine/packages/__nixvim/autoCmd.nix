{
  autoCmd = [
    {
      desc = "Check if we need to reload the file when it changed";
      event = [
        "FocusGained"
        "TermClose"
        "TermLeave"
      ];
      group = "checktime";
      command = "checktime";
    }
    # {
    #   desc = "Highlight on yank";
    #   event = [
    #     "TextYankPost"
    #   ];
    #   group = "highlight_yank";
    #   callback = "highlight.on_yank";
    # }
    {
      desc = "resize splits if window got resized";
      event = [
        "VimResized"
      ];
      group = "resize_splits";
      callback = {
        __raw = ''
          function()
            local current_tab = vim.fn.tabpagenr()
            vim.cmd("tabdo wincmd =")
            vim.cmd("tabnext " .. current_tab)
          end
        '';
      };
    }
    {
      desc = "go to last loc when opening a buffer";
      event = [
        "BufReadPost"
      ];
      group = "last_loc";
      callback = {
        __raw = ''
          function(event)
            local exclude = { "gitcommit" }
            local buf = event.buf
            if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
              return
            end
            vim.b[buf].lazyvim_last_loc = true
            local mark = vim.api.nvim_buf_get_mark(buf, '"')
            local lcount = vim.api.nvim_buf_line_count(buf)
            if mark[1] > 0 and mark[1] <= lcount then
              pcall(vim.api.nvim_win_set_cursor, 0, mark)
            end
          end
        '';
      };
    }
    {
      desc = "close some filetypes with <q>";
      event = [
        "FileType"
      ];
      group = "close_with_q";
      pattern = [
        "PlenaryTestPopup"
        "help"
        "lspinfo"
        "man"
        "notify"
        "qf"
        "query"
        "spectre_panel"
        "startuptime"
        "tsplayground"
        "neotest-output"
        "checkhealth"
        "neotest-summary"
        "neotest-output-panel"
      ];
      callback = {
        __raw = ''
          function(event)
            vim.bo[event.buf].buflisted = false
            vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
          end
        '';
      };
    }
    {
      desc = "wrap and check for spell in text filetypes";
      event = [
        "FileType"
      ];
      group = "wrap_spell";
      pattern = ["gitcommit" "markdown"];
      callback = {
        __raw = ''
          function()
            vim.opt_local.wrap = true
            vim.opt_local.spell = true
          end
        '';
      };
    }
    {
      desc = "Auto create dir when saving a file, in case some intermediate directory does not exist";
      event = [
        "BufWritePre"
      ];
      group = "auto_create_dir";
      callback = {
        __raw = ''
          function(event)
            if event.match:match("^%w%w+://") then
              return
            end
            local file = vim.loop.fs_realpath(event.match) or event.match
            vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
          end
        '';
      };
    }
    {
      event = [
        "BufWritePre"
      ];
      pattern = "*";
      callback = {
        __raw = ''
          function (args)
            require("conform").format({ bufnr = args.buf })
          end
        '';
      };
    }
  ];
}
