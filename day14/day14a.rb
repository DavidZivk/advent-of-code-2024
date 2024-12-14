def count_robots
  input = File.read(File.join(File.dirname(__FILE__), 'day14-input.txt'))

  width = 101
  height = 103

  quadrants = [0, 0, 0, 0]

  input.lines.each do |line|
    start_x, start_y, vx, vy = line.scan(/-?\d+/).map(&:to_i)

    pos_x = (start_x + 100 * vx) % width
    pos_y = (start_y + 100 * vy) % height

    if pos_x < width / 2 && pos_y < height / 2
      quadrants[0] += 1
    elsif pos_x > width / 2 && pos_y < height / 2
      quadrants[1] += 1
    elsif pos_x < width / 2 && pos_y > height / 2
      quadrants[2] += 1
    elsif pos_x > width / 2 && pos_y > height / 2
      quadrants[3] += 1
    end
  end

  quadrants.inject(&:*)
end

puts count_robots
