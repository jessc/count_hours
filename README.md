
# Count Hours

Automatically count up hours of study per day.

## Overview

This is a simple script to accurately count the number of hours studied per day.

For instance, a file containing:

	#; 2013-04-23;
	5:05-35pm
	5:40-55
	6:55-7:25
	studied this
	#; 2013-04-24; ??? hours
	11:00-15am
	11:55-12:55pm
	studied that
	3:10-40
	3:50-4:20
	4:30-5:30
	studied something enlightening

would output 

	#; 2013-04-23; 1.25 hours
	#; 2013-04-24; 3.25 hours

One shortcut you can use is HH:MM-MM. You don't need to write the whole time.

There is one gotcha to be aware of: "11:00-12am" returns 0.2 hours instead of 1.0 hours. Please use "11:00-12:00am".

## Installing

	$ git clone https://github.com/jessc/count_hours.git

## Usage

Edit study_hours.txt and add the day's times, or pass in a filename that has the times in it:

	$ ruby "count_hours.rb" "study_hours.txt"

## Contributing
 - fix the "11:00-12am" gotcha
 - add features like "11-12pm" => 1.0 hours
 - fix bugs at top of count_hours.rb
