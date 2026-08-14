return {
  "m4xshen/hardtime.nvim",
  dependencies = { "MunifTanjim/nui.nvim" },
  event = "VeryLazy",
  opts = {
    callback = function(text)
      vim.notify(text, vim.log.levels.WARN, { title = "Hardtime" })
      local ok, precognition = pcall(require, "precognition")
      if ok then
        precognition.peek()
      end
    end,
  },
}
