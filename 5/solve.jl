using DelimitedFiles

function pass_to_id(pass)
  row = pass[begin:7]
  col = pass[8:end]

  row_id = parse(Int, map(char_to_binary_char, row), base=2)
  col_id = parse(Int, map(char_to_binary_char, col), base=2)
  id = row_id * 8 + col_id
  return id
end

function char_to_binary_char(char)
  if char in "FL"
    return '0'
  elseif char in "BR"
    return '1'
  end
end

function missing_id(ids)
  # this array should have every id be it's own index
  offset = minimum(ids) - 1
  normalized_ids = ids .- offset
  sort!(normalized_ids, dims=1)

  # Ideally we binary seach but let's be lazy and do O(n), we
  # already do O(n) processing in p1 anyways.
  for (idx, val) in enumerate(normalized_ids)
    if val > idx
      return idx + offset
    end
  end
end

function p1(input)
  passes = readdlm(input, '\n', String)
  ids = map(pass_to_id, passes)
  maximum(ids)
end

function p2(input)
  passes = readdlm(input, '\n', String)
  ids = map(pass_to_id, passes)
  missing_id(ids)
end

println("= Part 1 [TESTING] = : ", p1("test_input.txt"))
println("= Part 2 [TESTING] = : ", p2("test_input.txt"))

println("= Part 1 [REAL] = : ", p1("input.txt"))
println("= Part 2 [REAL] = : ", p2("input.txt"))
