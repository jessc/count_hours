#!/usr/bin/env ruby

# 2013-04-25
# Jesse Cummins
# https://github.com/jessc

=begin 
# Bugs/Todo
- "11:00-12am" returns 0.2 hours instead of 1.0 hours
- add features like "11-12pm" => 1.0 hours

=end

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
    return (t.reject { |s| s == "" }).each_slice(2).to_a
  end

  def split_times(times)
    return times.split(":").map { |n| n.to_i }
  end

  def count_date(text)
    # removes blanks, comments, and lines ending with hour
    text = text.split("\n").reject do |line|
      line.match(/(^[a-zA-Z#]|(hour| $))/) || line == ""
    end

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

    return mins / 60.0
  end
end


unless ARGV[0]
  puts CountHours.new.count
else
  puts CountHours.new(file=ARGV[0]).count
end

