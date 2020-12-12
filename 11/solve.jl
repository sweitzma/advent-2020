using DelimitedFiles: readdlm
using IterTools: product

function parse_input(input::String)
  entries = readdlm(input, '\n', String)
  hcat(map(collect, entries)...)
end

function take_step(grid::Array{Char, 2}, wide_view::Bool)
  next_grid = copy(grid)

  for idx in CartesianIndices(grid)
    next_grid[idx] = next_state(grid, idx, wide_view)
  end

  next_grid
end

function next_state(grid::Array{Char, 2}, idx::CartesianIndex{2}, wide_view::Bool)
  neighbors = occupied_seats(grid, idx, wide_view)

  leave_thresh = 4 + wide_view
  seat = grid[idx]
  if seat == 'L' && neighbors == 0
    return '#'
  elseif seat == '#' && neighbors >= leave_thresh
    return 'L'
  else
    return seat
  end
end

function occupied_seats(grid::Array{Char, 2}, seat_idx::CartesianIndex{2}, wide_view::Bool)
  count = 0

  for ij in product(-1:1, -1:1)
    idx_delta = CartesianIndex(ij)
    if idx_delta == CartesianIndex(0,0)
      continue
    end

    idx = seat_idx + idx_delta

    # move in the looking direction while within bounds and on floor
    while within_bounds(grid, idx) && grid[idx] == '.' && wide_view
      idx += idx_delta
    end

    count += (within_bounds(grid, idx) && grid[idx] == '#')
  end

  count
end

function within_bounds(grid::Array{Char, 2}, idx::CartesianIndex{2})
  try
    grid[idx]
    true
  catch
    false
  end
end

function get_steady_state(grid::Array{Char, 2}, wide_view::Bool)
  next = take_step(grid, wide_view)
  while all(next != grid)
    grid = next
    next = take_step(grid, wide_view)
  end
  grid
end

function p1(input::String)
  grid = parse_input(input)
  steady_grid = get_steady_state(grid, false)
  sum(steady_grid .== '#')
end

function p2(input::String)
  grid = parse_input(input)
  steady_grid = get_steady_state(grid, true)
  sum(steady_grid .== '#')
end

println("= Part 1 [TESTING] = : ", p1("test_input.txt")) # 37
println("= Part 2 [TESTING] = : ", p2("test_input.txt")) # 26

println("= Part 1 [REAL] = : ", p1("input.txt")) # 2261
println("= Part 2 [REAL] = : ", p2("input.txt"))
