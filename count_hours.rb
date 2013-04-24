#!/usr/bin/env ruby

# 2013-04-24
# Jesse Cummins
# https://github.com/jessc

class CountHours
  def initialize(file="study_hours.txt")
    @text = File.open(file).read
  end

  def split_times(times)
    return times.split(":").map { |n| n.to_i }
  end

  def count()
    @text = @text.split("\n").reject { |line| line.match(/^[a-zA-Z#]/) || line == "" }

    mins = 0
    @text.each do |line|
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


if ARGV[0] == nil
  puts CountHours.new.count
else
  puts CountHours.new(file=ARGV[0]).count
end
