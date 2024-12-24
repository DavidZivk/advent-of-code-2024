def parse_values(input)
  value_hash = {}
  input.split("\n\n")[0].lines.each do |ln|
    key, val = ln.strip.split(':')
    value_hash[key] = val.to_i
  end

  value_hash
end

def parse_gates(input)
  gate_hash = {}

  input.split("\n\n")[1].lines.each do |ln|
    gate, res = ln.strip.split(' -> ')
    if gate.include?(' AND ')
      opr1, opr2 = gate.split(' AND ')
      op = 'AND'
    elsif gate.include?(' XOR ')
      opr1, opr2 = gate.split(' XOR ')
      op = 'XOR'
    elsif gate.include?(' OR ')
      opr1, opr2 = gate.split(' OR ')
      op = 'OR'
    end

    gate_hash[res] = [opr1, op, opr2]
  end

  gate_hash
end

def parse_input(file)
  input = File.read(File.join(File.dirname(__FILE__), file))

  values = parse_values(input)
  gate_hash = parse_gates(input)

  dependencies = build_dependencies(values, gate_hash)
  operations = sort_operations(gate_hash, dependencies)

  [values, operations]
end

def build_dependencies(value_hash, gate_hash)
  dependencies = {}

  gate_hash.each do |gate, ops|
    dependencies[gate] = []

    dependencies[gate].append(ops[0]) if !value_hash.keys.include?(ops[0]) && gate_hash.keys.include?(ops[0])

    dependencies[gate].append(ops[2]) if !value_hash.keys.include?(ops[2]) && gate_hash.keys.include?(ops[2])
  end

  dependencies
end

def sort_operations(gate_hash, dependencies)
  in_degree = {}

  dependencies.each { |val, deps| in_degree[val] = deps.length }

  queue = in_degree.select { |_k, v| v.zero? }.keys
  sorted_operations = []

  until queue.empty?
    current = queue.shift

    sorted_operations.append([current, gate_hash[current]].flatten)

    gate_hash.each do |res, ops|
      if ops[0] == current || ops[2] == current
        in_degree[res] -= 1
        queue.append(res) if (in_degree[res]).zero?
      end
    end
  end

  sorted_operations
end

def gate_operation(opr1, op, opr2)
  case op
  when 'AND' then opr1 & opr2
  when 'XOR' then opr1 ^ opr2
  when 'OR' then opr1 | opr2
  end
end

def crossed_wires(file)
  values, operations = parse_input(file)

  operations.each do |op|
    result, opr1, op, opr2 = op
    values[result] = gate_operation(values[opr1], op, values[opr2])
  end

  values.select { |k, _v| k.chars.first == 'z' }.sort.reverse.map { |z| z[1] }.join.to_i(2)
end

def operation_valid?(op, operations)
  result, opr1, op, opr2 = op

  return false if result.chars.first == 'z' && op != 'XOR' && !result.include?('45')

  if result.chars.first != 'z' && op == 'XOR'
    return false if [opr1, opr2].none? { |o| o.chars.first.include?('x') || o.chars.first.include?('y') }
  end

  if [opr1, opr2].all? { |o| o.chars.first.include?('x') || o.chars.first.include?('y') } && op == 'XOR'
    if [opr1, opr2].none? { |o| o.include?('00') }
      return false if operations.none? { |op| op[1..].include?(result) && op[2] == 'XOR' }
    end
  end

  if [opr1, opr2].all? { |o| o.chars.first.include?('x') || o.chars.first.include?('y') } && op == 'AND'
    if [opr1, opr2].none? { |o| o.include?('00') }
      return false if operations.none? { |op| op[1..].include?(result) && op[2] == 'OR' }
    end
  end

  true
end

def faulty_wires(file)
  _, operations = parse_input(file)
  faulty = []

  operations.each do |op|
    faulty.append(op) unless operation_valid?(op, operations)
  end

  faulty.map(&:first).sort.join(',')
end

input_file = 'day24-input.txt'

# Part 1
puts crossed_wires(input_file)

# Part 2
puts faulty_wires(input_file)
