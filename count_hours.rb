#!/usr/bin/env ruby

# 2013-04
# Jesse Cummins
# https://github.com/jessc
# with advice from Ryan Metzler

=begin 
# Bugs/Todo
- "11:00-12am" returns 0.2 hours instead of 1.0 hours
- add features like "11-12pm" => 1.0 hours
- could graph the times per day
- allow option to output "1:30" instead of 1.5

=end

require 'time'

class CountHours
  def initialize(file="study_hours.txt")
    @text = File.open(file).read
  end
  
  def count
    return split_dates(@text).collect do |date|
      "#{date[0]} #{count_date(date[1])} hours\n"
    end
  end

  def split_dates(text)
    regex = /^(#; \d{4}-\d{2}-\d{2};)/
    t = text.split(regex)
    # remove any intro text
    t.shift unless t.first.match(regex)
    # rejects then does [1,2,3,4] => [[1,2],[3,4]]
    # this creates a subarray for each day's [date, times]
    (t.reject { |s| s == "" }).each_slice(2).to_a
  end

  def split_times(times)
    times.split(":").map { |n| n.to_i }
  end

  def count_date(text)
    # removes blanks, comments, and lines ending with hour
    text = text.split("\n").reject do |line|
      line.match(/(^[a-zA-Z#]|(hour| $))/) || line == ""
    end


    # vvv all this stuff is probably going to be replaced
    mins = 0
    text.each do |line|
      times = line.split("-")

      a = split_times(times[0])
      b = split_times(times[1])

      # if it's am to pm, add 12 hours to pm
      b[0] += 12 if a[0] > b[0]

      mins += (b[0] - a[0]) * 60 if ((a[0] < b[0]) && (b[1] != nil))

      if b[1] == nil then mins += b[0] - a[1]
      else mins += b[1] - a[1]
      end
    end

    mins / 60.0
    # ^^^ replaced
  end

  def sum_month(month_lines)
    regex = /\d*\.\d*/

    month_lines.inject(0) do |sum, line|
      sum += line.match(regex)[0].to_f
    end
  end

  def display_month(month, month_total)
    return "#{month}: #{month_total}\n"
  end

  def per_month
    total = self.count
    # captures YYYY-MM
    regex = /^#; (\d{4}-\d{2})/

    months = {}
    total.each do |day|
      month = day.match(regex)[0]
      months[month] ||= []
      months[month] << day
    end

    months.collect do |month, month_lines|
      display_month(month, sum_month(month_lines))
    end
  end
end

=begin  
counting = ARGV[0] ? CountHours.new(file=ARGV[0]) : CountHours.new
puts counting.count
puts
puts counting.per_month
=end


def time_diff(time_string)
  first, second = time_string.split("-")
  start = first.split(":")
  endd  = second.split(":")

  if (start.length == 1 && endd.length == 1)
    first = first + ":00"
    second = second + ":00"
  elsif (start.length == 1 && endd.length == 2)
    first = first + ":00"
  elsif (start.length == 2 && endd.length == 1)
    if start[1] > endd.first
      second = second + ":00"
    else
      second = first[0] + ":" + endd.first
    end
  end
  # now first and second are definitely time objects
  # handle am-pm esque changes (11am-1pm)

  (Time.parse(second) - Time.parse(first)) / 60 / 60
end

p time_diff("9:35-10:05")
p time_diff("9-10:45pm") # error: 13.75 instead of 1.75
p time_diff("10-11") # remove am: 10-11am
p time_diff("9:00-10") # did as 9 to 9:10 minutes 
p time_diff("9:00-10am") # could detect this
p time_diff("9:30-10") # worked

