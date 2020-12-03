using DelimitedFiles

function p1()
  input = "input.txt"
  entries = readdlm(input, '\n', String)

  n = length(entries[1])
  x = 0
  trees = 0
  for line in entries
    row = collect(line)
    tree = row[x+1] == '#'
    trees += tree
    x = mod(x + 3, n)
  end
  trees
end

function tree_counter(geology, right, down)
  n = length(geology[1])
  x = 0
  trees = 0
  for line in geology[begin:down:end]
    row = collect(line)
    tree = row[x+1] == '#'
    trees += tree
    x = mod(x + right, n)
  end
  trees
end

function p2()
  input = "input.txt"
  geo = readdlm(input, '\n', String)

  ans = 1
  ans *= tree_counter(geo, 1, 1)
  ans *= tree_counter(geo, 3, 1)
  ans *= tree_counter(geo, 5, 1)
  ans *= tree_counter(geo, 7, 1)
  ans *= tree_counter(geo, 1, 2)
  ans
end

println("= Part 1 = : ", p1())
println("= Part 2 = : ", p2())
