require 'matrix'

def parse_input(file)
  input = File.read(File.join(File.dirname(__FILE__), file))
  locks = []
  keys = []

  input.split("\n\n").each do |blk|
    lk = Vector[0, 0, 0, 0, 0]
    lock = blk[0] == '#'

    rows = blk.lines[1..-2].map(&:strip)

    rows.each do |row|
      row.chars.each_with_index { |chr, idx| lk[idx] += 1 if chr == '#' }
    end

    if lock
      locks.append(lk)
    else
      keys.append(lk)
    end
  end

  [locks, keys]
end

def count_matches(file)
  locks, keys = parse_input(file)
  matches = 0
  keys.each do |key|
    locks.each do |lock|
      matches += 1 unless (lock + key).any? { |pin| pin > 5 }
    end
  end

  matches
end

puts count_matches('day25-input.txt')
