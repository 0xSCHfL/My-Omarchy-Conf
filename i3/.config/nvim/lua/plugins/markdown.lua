return {
  {
    "LazyVim/LazyVim",
    keys = {
      {
        "<leader>mp",
        function()
          local src_buf = vim.api.nvim_get_current_buf()
          local path = vim.api.nvim_buf_get_name(src_buf)
          if path == "" then
            vim.notify("Save the markdown file before previewing", vim.log.levels.WARN)
            return
          end

          -- Toggle off
          if vim.g.markdown_preview_win and vim.api.nvim_win_is_valid(vim.g.markdown_preview_win) then
            vim.api.nvim_win_close(vim.g.markdown_preview_win, true)
            vim.g.markdown_preview_win = nil
            vim.g.markdown_preview_buf = nil
            if vim.g.markdown_preview_autocmd then
              vim.api.nvim_del_autocmd(vim.g.markdown_preview_autocmd)
              vim.g.markdown_preview_autocmd = nil
            end
            return
          end

          local width = math.min(math.floor(vim.o.columns * 0.38), 68)
          local height = math.floor(vim.o.lines * 0.42)
          local row = 1
          local col = math.max(vim.o.columns - width - 2, 0)

          local function open_preview()
            vim.cmd("silent! write")
            local buf = vim.api.nvim_create_buf(false, true)
            local win = vim.api.nvim_open_win(buf, false, {
              relative = "editor",
              width = width,
              height = height,
              row = row,
              col = col,
              style = "minimal",
              border = "rounded",
              title = " Markdown Preview ",
              title_pos = "right",
            })
            vim.wo[win].number = false
            vim.wo[win].relativenumber = false
            vim.wo[win].signcolumn = "no"

            -- Run glow in a terminal buffer so ANSI colors work
            vim.api.nvim_set_current_win(win)
            vim.fn.termopen({ "glow", "--width", tostring(width - 4), path }, {
              on_exit = function()
                if vim.api.nvim_buf_is_valid(buf) then
                  vim.bo[buf].modifiable = false
                end
              end,
            })

            vim.g.markdown_preview_win = win
            vim.g.markdown_preview_buf = buf

            -- Return focus to editor
            vim.api.nvim_set_current_win(vim.fn.win_getid(vim.fn.winnr('#')))

            vim.keymap.set("n", "q", function()
              if vim.api.nvim_win_is_valid(win) then
                vim.api.nvim_win_close(win, true)
                vim.g.markdown_preview_win = nil
                if vim.g.markdown_preview_autocmd then
                  vim.api.nvim_del_autocmd(vim.g.markdown_preview_autocmd)
                  vim.g.markdown_preview_autocmd = nil
                end
              end
            end, { buffer = buf, silent = true })
          end

          open_preview()

          -- Auto-refresh on save
          vim.g.markdown_preview_autocmd = vim.api.nvim_create_autocmd("BufWritePost", {
            buffer = src_buf,
            callback = function()
              if vim.g.markdown_preview_win and vim.api.nvim_win_is_valid(vim.g.markdown_preview_win) then
                vim.api.nvim_win_close(vim.g.markdown_preview_win, true)
                vim.g.markdown_preview_win = nil
                vim.g.markdown_preview_buf = nil
              end
              open_preview()
            end,
          })
        end,
        desc = "Markdown Preview Toggle",
      },
    },
  },
}
