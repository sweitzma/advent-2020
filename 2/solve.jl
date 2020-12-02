using DelimitedFiles

function p1()
  input = "input.txt"
  entries = readdlm(input, ' ', String)
  valid = 0

  for line in eachrow(entries)
    limits, char, pswd = line
    lower_lim, upper_lim = map(x -> parse(Int, x), split(limits, '-'))
    count = sum(collect(pswd) .== char[begin])

    if count >= lower_lim && count <= upper_lim
      valid = valid + 1
    end
  end

  valid
end

function p2()
  input = "input.txt"
  entries = readdlm(input, ' ', String)
  valid = 0

  for line in eachrow(entries)
    indices, char, pswd = line
    idx1, idx2 = map(x -> parse(Int, x), split(indices, '-'))
    count = sum(collect(pswd)[[idx1, idx2]] .== char[begin])

    if count == 1
      valid = valid + 1
    end
  end

  valid
end

println("= Part 1 = : ", p1())
println("= Part 2 = : ", p2())
