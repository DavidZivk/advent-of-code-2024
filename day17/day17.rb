class ChronoSpatialComputer
  attr_reader :input, :reg_a, :reg_b, :reg_c, :output

  def initialize(reg_a, reg_b, reg_c, input, ip = 0)
    @reg_a = reg_a
    @reg_b = reg_b
    @reg_c = reg_c
    @input = input
    @ip = ip
    @output = []
  end

  def combo(num)
    case num
    when 0 then 0
    when 1 then 1
    when 2 then 2
    when 3 then 3
    when 4 then @reg_a
    when 5 then @reg_b
    when 6 then @reg_c
    end
  end

  def runop(op, val)
    case op
    when 0 then adv(val)
    when 1 then bxl(val)
    when 2 then bst(val)
    when 3 then jnz(val)
    when 4 then bxc(val)
    when 5 then out(val)
    when 6 then bdv(val)
    when 7 then cdv(val)
    end
  end

  def adv(cnum)
    num = combo(cnum)
    @reg_a /= (2**num)
  end

  def bxl(lnum)
    @reg_b ^= lnum
  end

  def bst(cnum)
    num = combo(cnum)

    @reg_b = num % 8
  end

  def jnz(lnum)
    return if @reg_a.zero?

    @ip = lnum - 2
  end

  def bxc(_)
    @reg_b ^= @reg_c
  end

  def out(cnum)
    num = combo(cnum)
    @output.append(num % 8)
  end

  def bdv(cnum)
    num = combo(cnum)
    @reg_b = @reg_a / (2**num)
  end

  def cdv(cnum)
    num = combo(cnum)
    @reg_c = @reg_a / (2**num)
  end

  def run
    while @ip < @input.length
      op = @input[@ip]
      arg = @input[@ip + 1]

      runop(op, arg)
      @ip += 2
    end
    self
  end
end

def parse_input(file)
  lines = File.readlines(File.join(File.dirname(__FILE__), file))

  reg_a = lines[0].match(/\d+/).to_s.to_i
  reg_b = lines[1].match(/\d+/).to_s.to_i
  reg_c = lines[2].match(/\d+/).to_s.to_i

  input = lines[4].match(/(\d,?)+/).to_s.split(',').map(&:to_i)

  [reg_a, reg_b, reg_c, input]
end

def find_min_mirror_a(reg_b, reg_c, input)
  test_a = 0
  layer = [test_a]
  result = 0

  (1..input.length).each do |i|
    new_layer = []
    until layer.empty?
      test_a = layer.pop

      8.times do |a_add|
        cscpu = ChronoSpatialComputer.new(test_a + a_add, reg_b, reg_c, input).run

        new_layer.push((test_a + a_add) << 3) if cscpu.output == input[-i, i]
      end
    end
    result = (new_layer.min >> 3) if i == input.length
    layer = new_layer
  end

  result
end

reg_a, reg_b, reg_c, input = parse_input('day17-input.txt')

# Part 1
puts ChronoSpatialComputer.new(reg_a, reg_b, reg_c, input).run.output.join(',')

# Part 2
puts find_min_mirror_a(reg_b, reg_c, input)
