-- mini.ai - enhanced text objects for better code navigation
-- Provides text objects for functions, classes, blocks, arguments, etc.
--
-- Language-specific support via custom queries in after/queries/:
--   C/C++: @function.inner added (original uses #make-range! which mini.ai doesn't support)
--   Verilog/SystemVerilog: modules→c, always/functions/tasks→f, seq_block/generate→o
--     (.v/.sv files use systemverilog filetype/parser)
--
-- Usage examples:
--   vaf  - select around function (or always_ff/always_comb/task in verilog)
--   vif  - select inner function
--   dac  - delete around class (or module in verilog)
--   cio  - change inner block (seq_block/begin-end in verilog)
--   vib  - select inner block (port list in verilog module instantiation)
--   vab  - select around block (entire module instantiation)
--   viu  - select inner function call (usage)
--
-- Text objects:
--   f - function (always_ff/always_comb/task in verilog)
--   c - class (module in verilog)
--   o - code block (conditional, loop, seq_block/begin-end, etc.)
--   b - block (module instantiation in verilog, or seq_block/begin-end)
--   t - tags (HTML/XML)
--   d - digits
--   e - word with case
--   u - function call (usage)
--   U - function call without dot in name

local ai = require("mini.ai")

ai.setup({
  -- Number of lines within which textobject is searched
  n_lines = 500,

  custom_textobjects = {
    -- Code blocks (conditionals, loops, etc.)
    o = ai.gen_spec.treesitter({
      a = { "@block.outer", "@conditional.outer", "@loop.outer" },
      i = { "@block.inner", "@conditional.inner", "@loop.inner" },
    }),

    -- Functions
    f = ai.gen_spec.treesitter({
      a = "@function.outer",
      i = "@function.inner",
    }),

    -- Classes
    c = ai.gen_spec.treesitter({
      a = "@class.outer",
      i = "@class.inner",
    }),

    -- Brackets (default + module instantiations in Verilog)
    b = ai.gen_spec.treesitter({
      a = { "@parameter.outer", "@block.outer" },
      i = { "@parameter.inner", "@block.inner" },
    }),

    -- Tags (HTML/XML)
    t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },

    -- Digits
    d = { "%f[%d]%d+" },

    -- Word with case (useful for camelCase/PascalCase)
    e = {
      {
        "%u[%l%d]+%f[^%l%d]",
        "%f[%S][%l%d]+%f[^%l%d]",
        "%f[%P][%l%d]+%f[^%l%d]",
        "^[%l%d]+%f[^%l%d]",
      },
      "^().*()$",
    },

    -- Function call (u for "usage")
    u = ai.gen_spec.function_call(),

    -- Function call without dot in function name
    U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }),
  },
})
