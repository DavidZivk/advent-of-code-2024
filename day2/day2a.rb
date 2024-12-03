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
  increasing = rep[0] - rep[1] < 0

  rep.each_cons(2) do |pair|
    diff = pair[0] - pair[1]
    return false if !increasing && (diff < 1 || diff > 3)
    return false if increasing && (diff > -1 || diff < -3)
  end

  true
end

puts safe_report_counter
