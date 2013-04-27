#!/usr/bin/env ruby

# 2013-04
# Count hours for each day.
# 2013-04
# Jesse Cummins
# https://github.com/jessc
# with advice from Ryan Metzler

=begin 
# Bugs/Todo
- "11:00-12am" returns 0.2 hours instead of 1.0 hours
- add features like "11-12pm" => 1.0 hours
- could graph the times per day
- allow option to output "1:30"
  or "1 hour 30 minutes" instead of "1.5 hours"
- set minute increments
=end

require 'time'

class CountHours
  def initialize(file="study_hours.txt")
    @text = File.open(file).read
  end

  def count
    split_into_dates(@text).map do |item|
      date, times = item[0], item[1]
      "#{date} #{count_date(times)} hours\n"
    end
  end

  def split_into_dates(text)
    regex = /^(#; \d{4}-\d{2}-\d{2};)/
    t = text.split(regex)
    # remove any intro text
    t.shift unless t.first.match(regex)
    # rejects empty then does [1,2,3,4] => [[1,2],[3,4]]
    # this creates a subarray for each day's [date, times]
    (t.reject { |s| s == "" }).each_slice(2).to_a
  end

  def split_times(times)
    times.split(":").map { |n| n.to_i }
  end

  def time_diff2(time_string)
    start, finish = time_string.split("-")
    # p start, finish
    start_h_m = start.split(":")
    fin_h_m = finish.split(":")

    if fin_h_m[-1].match(/am|pm|AM|PM/)
      am_or_pm = true
      fin_h_m = fin_h_m[0...-2]
    end

    mins = 0
    if (start_h_m.length == 1 && fin_h_m == 1)
      start += ":00"
      finish += ":00"
    end
    # yeah, this is difficult to do:
    # if (start_h_m > fin_h_m)
    #   fin_h_m += 12 #hours
    # end
  end
# 10:15 > 1

# edge cases:
# "9-10"         => ["9", "10"]
# "9-10am"       => ["9", "10am"]
# "10-1pm"       => ["10", "1pm"]
# "10-1"         => ["10", "1"]
# "10:30-1:30pm" => ["10:30", "1:30pm"]
# "9:00-10"      => ["9:00", "10"]
# "9:00-10am"    => ["9:00", "10am"]
# "9:30-10"      => ["9:30", "10"]
# "9-10:30pm"    => ["9", "10:30pm"]
## "9:35-10:05"  => ["9:35", "10:05"]


  def time_diff(time_string)
    start, finish = time_string.split("-")
    start_h_m = start.split(":")
    fin_h_m = finish.split(":")

    if (start_h_m.length == 1 && fin_h_m.length == 1)
      start += ":00"
      finish += ":00"
    elsif (start_h_m.length == 1 && fin_h_m.length == 2)
      start += ":00"
    elsif (start_h_m.length == 2 && fin_h_m.length == 1)
      if start_h_m[1] > fin_h_m.first
        finish += ":00"
      else
        finish = start[0] + ":" + fin_h_m.first
      end
    end
    # now first and second are definitely time objects
    # handle am-pm esque changes (11-1pm)

    (Time.parse(second) - Time.parse(first)) / 60 / 60
  end

  def count_date(text)
    # removes blanks, comments, and lines ending with hour
    text = text.split("\n").reject do |line|
      line.match(/(^[a-zA-Z#]|(hour| $))/) || line == ""
    end

    mins = 0
    text.each { |line| mins += time_diff(line) }
    mins
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

    months.map do |month, month_lines|
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


counting = CountHours.new
time_diff = counting.method("time_diff2")
# p time_diff.("9:35-10:05")
# p time_diff.("9-10:30pm") # error: 13.5 instead of 1.50
# p time_diff.("9-10")
# p time_diff.("9-10am") # first remove am so: 9-10
# p time_diff.("9:00-10") # did as 9:00-9:10
# p time_diff.("9:00-10am") # could detect this
# p time_diff.("9:30-10") # worked
# p time_diff.("10-1pm")
# p time_diff.("10-1")

