def parse_input(file)
  input = File.read(File.join(File.dirname(__FILE__), file))

  towels = input.split("\n\n")[0].split(', ')

  patterns = input.split("\n\n")[1].lines.map(&:strip)

  [towels, patterns]
end

def count_options(pattern, towels)
  options = Array.new(pattern.length + 1, 0)
  options[pattern.length] = 1

  (pattern.length - 1).downto(0) do |i|
    towels.each do |towel|
      options[i] += options[i + towel.length] if pattern[i, towel.length] == towel
    end
  end

  options[0]
end

towels, patterns = parse_input('day19-input.txt')

options = patterns.map do |pattern|
  count_options(pattern, towels)
end

# Part 1
puts options.count(&:positive?)

# Part 2
puts options.sum
