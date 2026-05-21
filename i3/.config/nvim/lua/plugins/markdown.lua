return {
  {
    "toppair/peek.nvim",
    build = "deno task --quiet build:fast",
    keys = {
      {
        "<leader>mp",
        function()
          local peek = require("peek")
          if peek.is_open() then
            peek.close()
          else
            peek.open()
            vim.defer_fn(function()
              vim.fn.jobstart({ vim.fn.expand("~/.local/bin/i3-peek-preview-float") }, { detach = true })
            end, 100)
          end
        end,
        desc = "Markdown Preview Toggle",
      },
      {
        "<leader>mP",
        function()
          local file = vim.fn.expand("%:p")
          if file == "" or vim.fn.filereadable(file) == 0 then
            vim.notify("Current buffer is not a readable file", vim.log.levels.WARN)
            return
          end

          if vim.fn.executable("glow") == 0 then
            vim.notify("glow is not installed. Run: sudo pacman -S glow", vim.log.levels.ERROR)
            return
          end

          if vim.bo.modified then
            vim.cmd("silent write")
          end

          local preview_width = 68
          vim.cmd("botright vertical new")
          vim.cmd("vertical resize " .. preview_width)
          vim.bo.bufhidden = "wipe"
          vim.bo.filetype = "glowpreview"
          vim.wo.number = false
          vim.wo.relativenumber = false
          vim.wo.signcolumn = "no"
          vim.wo.winfixwidth = true

          vim.fn.termopen({ "glow", "--pager", "--width", tostring(preview_width - 2), file })
          vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = true, silent = true })
          vim.cmd("startinsert")
        end,
        desc = "Markdown Preview Right Split (Glow)",
      },
    },
    opts = {
      auto_load = false,
      app = vim.fn.expand("~/.local/bin/i3-peek-browser"),
    },
  },
}
