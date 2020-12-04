using DelimitedFiles

function valid_passport(passport)
  necessary_keys = Set(["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"])
  length(intersect(Set(keys(passport)), necessary_keys)) >= 7
end

function stricter_valid_passport(passport)
  necessary_keys = Set(["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"])
  if length(intersect(Set(keys(passport)), necessary_keys)) < 7
    return false
  end

  byr = parse(Int, passport["byr"])
  if byr < 1920 || byr > 2002
    return false
  end

  iyr = parse(Int, passport["iyr"])
  if iyr < 2010 || iyr > 2020
    return false
  end

  eyr = parse(Int, passport["eyr"])
  if eyr < 2020 || eyr > 2030
    return false
  end

  hgt_unit = passport["hgt"][end-1:end]
  hgt_amt = parse(Int, passport["hgt"][begin:end-2])
  if hgt_unit == "in" && (hgt_amt < 59 || hgt_amt > 76)
    return false
  elseif hgt_unit == "cm" && (hgt_amt < 150 || hgt_amt > 193)
    return false
  elseif !(hgt_unit in Set(["in", "cm"]))
    return false
  end

  if !occursin(r"^#([a-f]|[0-9]){6}$", passport["hcl"])
    return false
  end

  if !(passport["ecl"] in Set(["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]))
    return false
  end

  if !occursin(r"^[0-9]{9}$", passport["pid"])
    return false
  end

  true
end

function parse_passports(file)
  entries = readdlm(file, '\n', String, skipblanks=false)
  passport_strings = Vector{String}()
  current_passport = ""
  for e in entries
    if e == ""
      push!(passport_strings, current_passport[2:end])
      current_passport = ""
    else
      current_passport *= (" " * e)
    end
  end
  push!(passport_strings, current_passport[2:end])

  passports = Vector{Dict}()
  for p in passport_strings
    passport = Dict()
    for keyval in split(p, ' ')
      key, val = split(keyval, ':')
      passport[key] = val
    end
    push!(passports, passport)
  end

  passports
end

function p1(input)
  passports = parse_passports(input)
  sum(map((p) -> valid_passport(p), passports))
end

function p2(input)
  passports = parse_passports(input)
  sum(map((p) -> stricter_valid_passport(p), passports))
end

println("= Part 1 [TESTING] = : ", p1("test_input.txt"))
println("= Part 2 [TESTING] = : ", p2("test_input.txt"))

println("= Part 1 [REAL] = : ", p1("input.txt"))
println("= Part 2 [REAL] = : ", p2("input.txt"))
