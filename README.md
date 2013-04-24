
# Count Hours

Automatically count up hours of study per day.

## Overview

This is a simple script to accurately count the number of hours studied per day.

For instance:

	#; 2013-04-24; ??? hours
	11:00-15am
	11:55-12:55pm
	studied this
	3:10-40
	3:50-4:20
	4:30-5:30
	studied that

would output 3.25.

One shortcut you can use is HH:MM-MM. You don't need to write the whole time.

## Installing

	$ git clone https://github.com/jessc/count_hours.git

## Usage

Edit study_hours.txt and add the day's times, or pass in a filename that has the times in it:

	$ ruby "count_hours.rb" "study_hours.txt"

## Contributing

 - enable multi-date input: next to each date, output each date's hours

