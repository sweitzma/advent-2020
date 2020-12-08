using DelimitedFiles
using LightGraphs, SimpleWeightedGraphs

struct Rule
  color::Symbol
  children::Dict{Symbol, Int}
end

function color_str_to_sym(str::AbstractString)
  Symbol(replace(str, ' ' => '_'))
end

function parse_rules(input::String)
  entries = readdlm(input, '\n', String)
  map(parse_rule, entries)
end

function parse_rule(rule::String)
  m = match(r"^(.*) bags contain (.*)[.]$", rule)

  if m == nothing
    error("Could not parse rule")
  end

  main_color = color_str_to_sym(m.captures[1])

  child_pairs = map(parse_child, split(m.captures[2], ", "))
  present_child_pairs = filter(x -> x != nothing, child_pairs)
  children = Dict(present_child_pairs)

  Rule(main_color, children)
end

function parse_child(child::AbstractString)
  m = match(r"^(\d+) (.*) bags?$", child)

  # we get here if the bag contains no other bags
  if m == nothing
    return nothing
  end

  count = parse(Int, m.captures[1])
  color = color_str_to_sym(m.captures[2])

  color => count
end

function p1(input::String)
  rules = parse_rules(input)
  colors = map(r -> r.color, rules)
  color_to_index = Dict(val => key for (key, val) in pairs(IndexLinear(), colors))

  g = SimpleWeightedDiGraph(length(rules))
  for rule in rules
    for (color, weight) in rule.children
      dst = color_to_index[rule.color]
      src = color_to_index[color]
      add_edge!(g, src, dst, weight)
    end
  end

  distances = gdistances(g, color_to_index[:shiny_gold])
  reachable_nodes = filter(d -> d < typemax(Int64) && d > 0, distances)
  length(reachable_nodes)
end

function count_bags(color::Symbol, rules::Dict{Symbol, Rule}, memo::Dict{Symbol, Int})
  if color in keys(memo)
    return memo[color]
  end

  total = 1 # itself
  rule = rules[color]
  for (color, count) in rule.children
    total += count_bags(color, rules, memo) * count
  end

  memo[color] = total

  return total
end

function p2(input::String)
  rules = parse_rules(input)
  colors = map(r -> r.color, rules)
  color_to_index = Dict(val => key for (key, val) in pairs(IndexLinear(), colors))

  rule_dict = Dict(rule.color => rule for rule in rules)
  memo = Dict{Symbol, Int}()

  count_bags(:shiny_gold, rule_dict, memo) - 1
end

println("= Part 1 [TESTING] = : ", p1("test_input.txt"))
println("= Part 2a [TESTING] = : ", p2("test_input.txt"))
println("= Part 2b [TESTING] = : ", p2("test_input_2.txt"))

println("= Part 1 [REAL] = : ", p1("input.txt"))
println("= Part 2 [REAL] = : ", p2("input.txt"))
