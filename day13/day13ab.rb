require 'matrix'

def solve_equation(a1, b1, c1, a2, b2, c2)
  coeff_matrix = Matrix[[a1, b1], [a2, b2]]
  constants = Matrix.column_vector([c1, c2])

  if coeff_matrix.determinant.zero?
    augmented_matrix = Matrix.hstack(coeff_matrix, constants)
    rank_coeff = coeff_matrix.rank
    rank_aug = augmented_matrix.rank
    return 'Infinite solutions' if rank_coeff == rank_aug

    return 'No solution'
  end

  solution = coeff_matrix.inverse * constants

  x = solution[0, 0]
  y = solution[1, 0]

  [x, y]
end

def count_tokens(part_2: false)
  input = File.read(File.join(File.dirname(__FILE__), 'day13-input.txt'))

  tokens = 0

  input.lines.each_slice(4) do |rows|
    a1, a2 = rows[0].scan(/\d+/).map(&:to_i)
    b1, b2 = rows[1].scan(/\d+/).map(&:to_i)

    if part_2
      c1, c2 = rows[2].scan(/\d+/).map { |num| num.to_i + 10_000_000_000_000 }
    else
      c1, c2 = rows[2].scan(/\d+/).map(&:to_i)
    end

    sol = solve_equation(a1, b1, c1, a2, b2, c2)

    next unless (sol[0]&.denominator == 1) && (sol[1]&.denominator == 1)
    next if !part_2 && (!(0..100).member?(sol[0]&.numerator) || !(0..100).member?(sol[1]&.numerator))

    tokens += sol[0].numerator * 3
    tokens += sol[1].numerator
  end

  tokens
end

puts count_tokens
puts count_tokens(part_2: true)
