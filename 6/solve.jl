using DelimitedFiles

function parse_answers(file::String)
  entries = readdlm(file, '\n', String, skipblanks=false)
  answers = Vector{Vector{String}}()

  current_group = Vector{String}()
  for e in entries
    if e == ""
      push!(answers, current_group)
      current_group = Vector{String}()
    else
      push!(current_group, e)
    end
  end
  push!(answers, current_group)

  answers
end

function any_yes_count_per_group(group::Vector{String})
  length(Set(reduce(*, group)))
end

function all_yes_count_per_group(group::Vector{String})
  length(reduce(intersect, map(Set, group)))
end

function p1(input::String)
  group_answers = parse_answers(input)
  counts = map(any_yes_count_per_group, group_answers)
  sum(counts)
end

function p2(input::String)
  group_answers = parse_answers(input)
  counts = map(all_yes_count_per_group, group_answers)
  sum(counts)
end

println("= Part 1 [TESTING] = : ", p1("test_input.txt"))
println("= Part 2 [TESTING] = : ", p2("test_input.txt"))

println("= Part 1 [REAL] = : ", p1("input.txt"))
println("= Part 2 [REAL] = : ", p2("input.txt"))
