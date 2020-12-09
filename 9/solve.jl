using DelimitedFiles

function parse_input(input::String)
  entries = readdlm(input, '\n', Int)
  entries
end

function check_valid(preamble::Array{Int}, element::Int)
  halfs = Set(preamble)
  other_halfs = Set(element .- preamble)
  match = intersect(halfs, other_halfs)
  return length(match) > 0
end

function bad_element(seq::Array{Int}, preamble_size::Int)
  pre_start = 1
  pre_end = preamble_size
  pre = seq[pre_start:pre_end]
  for element in seq[pre_end+1:end]
    valid = check_valid(pre, element)
    if !valid
      return element
    end

    pre_start += 1
    pre_end += 1
    pre = seq[pre_start:pre_end]
  end
end

# Naive brute force, runs fast enough on my input though
function find_contiguous_set_slow(seq::Array{Int}, sum_to::Int)
  for (i,val) in enumerate(seq)
    j = i + 1
    while j <= length(seq) && sum(seq[i:j]) < sum_to
      j += 1
    end

    if sum(seq[i:j]) == sum_to
      return seq[i:j]
    end
  end
end

function encryption_weakness(contig::Array{Int})
  maximum(contig) + minimum(contig)
end

function p1(input::String, n::Int)
  seq = parse_input(input)
  bad_element(seq, n)
end

function p2(input::String, n::Int)
  seq = parse_input(input)
  sum_to = bad_element(seq, n)
  contig = find_contiguous_set_slow(seq, sum_to)
  encryption_weakness(contig)
end

println("= Part 1 [TESTING] = : ", p1("test_input.txt", 5))
println("= Part 2 [TESTING] = : ", p2("test_input.txt", 5))

println("= Part 1 [REAL] = : ", p1("input.txt", 25))
println("= Part 2 [REAL] = : ", p2("input.txt", 25))
