using DelimitedFiles

println("= Part 1 =")

input = "input.txt"
entries = readdlm(input, '\n', Int)

dict = Dict()
for n in entries
  key = 2020 - n
  if haskey(dict, n)
    println(key * n)
    break 
  else
    dict[key] = n
  end
end

println("= Part 2 =")
dict = Dict()
for n in entries
  for m in entries
    key = 2020 - n - m
    val = n * m
    dict[key] = val
  end
end

for n in entries
  if haskey(dict, n)
    println(dict[n] * n)
    break 
  end
end
