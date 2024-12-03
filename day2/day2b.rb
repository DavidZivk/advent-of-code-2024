def safe_report_counter
  safe_reports_num = 0

  reports = []

  File.open('day2-input.txt', 'r') do |f|
    f.each do |line|
      reports.push(line.split.map(&:to_i))
    end
  end

  reports.each do |rep|
    safe_reports_num += 1 if report_safe?(rep)
  end

  safe_reports_num
end

# @param rep [Array] a single report with list of values
# @return [Boolean] whether report is safe or not
def report_safe?(rep)

  failure_at = check_report(rep)

  return true if failure_at < 0


  # TODO Refactor
  dampened_reports = rep.each_with_index.map do |element, index|
    rep[0...index] + rep[index+1..-1]
  end

  retried = dampened_reports.map do |rep|
    check_report(rep)
  end

  return retried.any? { |el| el < 0 }
end


# TODO Refactor
# @param rep [Array] a single report with list of values
# @return [Integer] index of failure point, returns -1 if no failure
def check_report(rep)
  increasing = rep[0] - rep[1] < 0

  (0..rep.length-2).each do |i|
    diff = rep[i] - rep[i+1]
    return i if !increasing && (diff < 1 || diff > 3)
    return i if increasing && (diff > -1 || diff < -3)
  end

  -1
end

puts safe_report_counter
