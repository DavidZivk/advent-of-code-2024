class ChronoSpatialComputer
  getter :input, :reg_a, :reg_b, :reg_c, :output

  def initialize(reg_a : Int128, reg_b : Int128, reg_c : Int128, input : Array(Int32), ip : Int32 = 0)
    @reg_a = reg_a
    @reg_b = reg_b
    @reg_c = reg_c
    @input = input
    @ip = ip
    @output = [] of Int128
  end

  def combo(num) : Int128
    case num
    when 0 then 0.to_i128
    when 1 then 1.to_i128
    when 2 then 2.to_i128
    when 3 then 3.to_i128
    when 4 then @reg_a
    when 5 then @reg_b
    when 6 then @reg_c
    else        999.to_i128
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
    @reg_a //= (2**num)
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

  def bxc(lnum)
    @reg_b ^= @reg_c
  end

  def out(cnum)
    num = combo(cnum)
    @output.push(num % 8.to_i128)
  end

  def bdv(cnum)
    num = combo(cnum)
    @reg_b = @reg_a // (2**num)
  end

  def cdv(cnum)
    num = combo(cnum)
    @reg_c = @reg_a // (2**num)
  end

  def run
    while @ip < @input.size
      op = @input[@ip]
      arg = @input[@ip + 1]

      runop(op, arg)
      @ip += 2
    end
    self
  end
end

def parse_input(file)
  lines = File.read_lines(File.join(File.dirname(__FILE__), file))

  reg_a = lines[0].match(/\d+/).to_s.to_i128
  reg_b = lines[1].match(/\d+/).to_s.to_i128
  reg_c = lines[2].match(/\d+/).to_s.to_i128

  input = lines[4].match(/(\d,?)+/).to_s.split(',').map(&.to_i32)

  {reg_a, reg_b, reg_c, input}
end

def find_min_mirror_a(reg_b, reg_c, input)
  test_a = 0.to_i128
  layer = [test_a]
  result = 0

  (1..input.size).each do |i|
    new_layer = [] of Int128
    until layer.empty?
      test_a = layer.pop

      8.times do |a_add|
        cscpu = ChronoSpatialComputer.new(test_a + a_add.to_i128, reg_b, reg_c, input).run

        new_layer.push((test_a + a_add) << 3) if cscpu.output == input[-i, i]
      end
    end
    result = (new_layer.min >> 3) if i == input.size
    layer = new_layer
  end

  result
end

reg_a, reg_b, reg_c, input = parse_input("day17-input.txt")

# Part 1
puts ChronoSpatialComputer.new(reg_a, reg_b, reg_c, input).run.output.join(',')

# Part 2
puts find_min_mirror_a(reg_b, reg_c, input)
