; Verilog/SystemVerilog textobjects for mini.ai
;
; Maps verilog constructs to standard captures:
;   - modules/classes -> c (class)
;   - always blocks/functions/tasks -> f (function)
;   - seq_block/generate blocks -> o (block)
;
; Note: Using same node for .inner and .outer (like C++ function_body_declaration)
; since mini.ai requires both to be defined

; Classes (modules in verilog, classes in SystemVerilog)
(module_declaration) @class.outer
(module_declaration) @class.inner

(class_declaration) @class.outer
(class_declaration) @class.inner

; Functions (always blocks, functions, and tasks)
(always_construct) @function.outer

; For always_comb/always_latch (no timing control, has seq_block)
; Inner is the statements inside begin/end (not the begin/end keywords themselves)
(always_construct
  (statement
    (statement_item
      (seq_block
        (statement_or_null) @function.inner))))

; For always_ff with timing control and begin/end
; Inner is the statements inside begin/end (not the begin/end keywords themselves)
(always_construct
  (statement
    (statement_item
      (procedural_timing_control_statement
        (statement_or_null
          (statement
            (statement_item
              (seq_block
                (statement_or_null) @function.inner))))))))

; For always_ff with timing control but no begin/end (single statement)
; Inner is just the statement
(always_construct
  (statement
    (statement_item
      (procedural_timing_control_statement
        (statement_or_null
          (statement) @function.inner)))))

(function_body_declaration) @function.outer
(function_body_declaration) @function.inner

(task_body_declaration) @function.outer
(task_body_declaration) @function.inner

; Blocks (seq_block, generate)
; outer includes begin/end, inner is just the statements between
(seq_block) @block.outer

; Inner block: just the statements, not begin/end keywords
(seq_block
  (statement_or_null) @block.inner)

(generate_block) @block.outer
(generate_block) @block.inner

; Conditionals
(conditional_statement) @conditional.outer
(conditional_statement) @conditional.inner

; Loops
(loop_statement) @loop.outer
(loop_statement) @loop.inner

; Interfaces (SystemVerilog)
(interface_declaration) @class.outer
(interface_declaration) @class.inner

; Module instantiations
; vib - inner: just the port list
; vab - around: the entire instantiation including module name and instance name
(module_instantiation) @parameter.outer
(list_of_port_connections) @parameter.inner
