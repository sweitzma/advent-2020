using DelimitedFiles

function parse_input(input::String)
  adapters = readdlm(input, '\n', Int)
  adapters = sort(adapters, dims=1)
  built_in = adapters[end] + 3
  vcat(adapters, [built_in])
end

function p1(input::String)
  seq = parse_input(input)

  skips = Dict(1 => 0, 2 => 0, 3 => 0)

  output = 0
  for joltage in seq
    skips[joltage - output] += 1
    output = joltage
  end

  skips[1] * skips[3]
end

function p2(input::String)
  seq = parse_input(input)
  seq_lookup = Set(seq)

  memo = zeros(Int64, maximum(seq))

  for i in 1:maximum(seq)
    if !(i in seq_lookup)
      continue
    end

    if i == 1
      memo[i] = 1
    elseif i == 2
      memo[i] = memo[i - 1] + 1
    elseif i == 3
      memo[i] = memo[i - 1] + memo[i - 2] + 1
    else
      memo[i] = memo[i - 1] + memo[i - 2] + memo[i - 3]
    end
  end

  memo[end]
end

println("= Part 1a [TESTING] = : ", p1("test_input.txt"))
println("= Part 1b [TESTING] = : ", p1("test_input_2.txt"))
println("= Part 2a [TESTING] = : ", p2("test_input.txt"))
println("= Part 2b [TESTING] = : ", p2("test_input_2.txt"))

println("= Part 1 [REAL] = : ", p1("input.txt"))
println("= Part 2 [REAL] = : ", p2("input.txt"))
