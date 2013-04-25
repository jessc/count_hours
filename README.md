
# Count Hours

Automatically count up hours of study per day.

## Overview

This is a simple script to accurately count the number of hours studied per day.

For instance, a file containing:

	#; 2012-12-31; ??? hours
	11:00-12:00pm
	#; 2013-01-01; ??? hours
	2:45-3:45pm
	10:00-11:00
	#; 2013-02-01; ??? hours
	9:00-30pm
	9:35-10:05
	10:10-40
	10:50-11:20
	#; 2013-02-02; ??? hours
	4:15-45pm
	4:50-5:20

would output 

	#; 2012-12-31; 1.0 hours
	#; 2013-01-01; 2.0 hours
	#; 2013-02-01; 2.0 hours
	#; 2013-02-02; 1.0 hours

	#; 2012-12: 1.0
	#; 2013-01: 2.0
	#; 2013-02: 3.0

One shortcut you can use is HH:MM-MM. You don't need to write the whole time.

There is one gotcha to be aware of: "5:00-6pm" returns 0.2 hours instead of 1.0 hours. Please use "5:00-6:00am".

## Installing

	$ git clone https://github.com/jessc/count_hours.git

## Usage

Edit study_hours.txt and add the day's times, or pass in a filename that has the times in it:

	$ ruby "count_hours.rb" "study_hours.txt"

## Contributing
 - fix the "11:00-12am" gotcha
 - add features like "11-12pm" => 1.0 hours
 - fix bugs at top of count_hours.rb
