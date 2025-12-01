local M = {}

function M.setup()
  -- ================= CMP Setup =================
  local cmp = require("cmp")
  cmp.setup({
    snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body)
      end
    },
    mapping = cmp.mapping.preset.insert({
      ["<C-j>"] = cmp.mapping.select_next_item(),
      ["<C-k>"] = cmp.mapping.select_prev_item(),
      -- ["<CR>"] = cmp.mapping.confirm({ select = true }),
      -- ["<C-Space>"] = cmp.mapping.complete(),
    }),
    sources = {
      { name = "nvim_lsp" },
      { name = "luasnip" },
    }
  })

  -- ================= LSP Keymaps =================
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(ev)
      local opts = { buffer = ev.buf }
      local keymap = vim.keymap.set

      keymap("n", "gd", vim.lsp.buf.definition, opts)
      keymap("n", "gr", vim.lsp.buf.references, opts)
      keymap("n", "K", vim.lsp.buf.hover, opts)
      keymap("n", "<space>rn", vim.lsp.buf.rename, opts)
      keymap("n", "<space>ca", vim.lsp.buf.code_action, opts)
      keymap("n", "<space>e", vim.diagnostic.open_float, opts)
      keymap("n", "<space>q", vim.diagnostic.setloclist, opts)
    end,
  })
end

return M
