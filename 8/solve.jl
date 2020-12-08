using DelimitedFiles

struct Instruction
  op::Symbol
  arg::Int
end

function execute(program::Array{Instruction}, acc::Int, pointer::Int)
  if pointer > length(program)
    return (acc, nothing)
  end

  instruction = program[pointer]
  if instruction.op == :nop
    return (acc, pointer + 1)
  elseif instruction.op == :jmp
    return (acc, pointer + instruction.arg)
  elseif instruction.op == :acc
    return (acc + instruction.arg, pointer + 1)
  else
    error("Unrecognized operation")
  end
end

function parse_input(input)
  entries = readdlm(input, '\n', String)
  map(parse_instruction, entries)
end

function parse_instruction(instruction::String)
  code_str, arg_str = split(instruction, " ")
  Instruction(Symbol(code_str), parse(Int, arg_str))
end

function fix_program_naive(program::Array{Instruction})
  for (idx, instruction) in enumerate(program)
    if instruction.op == :acc
      continue
    end

    # modify the program as is
    if instruction.op == :nop
      program[idx] = Instruction(:jmp, instruction.arg)
    elseif instruction.op == :jmp
      program[idx] = Instruction(:nop, instruction.arg)
    end

    if does_it_run(program)
      return program
    end

    # reset
    program[idx] = instruction
  end
end

function does_it_run(program::Array{Instruction})
  acc = 0
  pointer = 1
  executed = Set()

  # loop while we have code to execute
  while !(pointer in executed) && (pointer != nothing)
    push!(executed, pointer)
    acc, pointer = execute(program, acc, pointer)
  end

  return pointer == nothing
end


function p1(input::String)
  program = parse_input(input)
  acc = 0
  pointer = 1
  executed = Set()

  # loop while we don't have a cycle
  while !(pointer in executed)
    push!(executed, pointer)
    acc, pointer = execute(program, acc, pointer)
  end

  return acc
end

function p2(input::String)
  program = parse_input(input)
  finite_program = fix_program_naive(program)

  acc = 0
  pointer = 1

  # loop while we have code to execute
  while pointer != nothing
    acc, pointer = execute(program, acc, pointer)
  end

  return acc
end

println("= Part 1 [TESTING] = : ", p1("test_input.txt"))
println("= Part 2 [TESTING] = : ", p2("test_input.txt"))

println("= Part 1 [REAL] = : ", p1("input.txt"))
println("= Part 2 [REAL] = : ", p2("input.txt"))
