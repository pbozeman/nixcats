-- Custom filetype detection
-- Override verilog filetype to use systemverilog (since that's the treesitter parser name)

vim.filetype.add({
  extension = {
    v = "systemverilog",
    sv = "systemverilog",
    svh = "systemverilog",
    vh = "systemverilog",
  },
})
