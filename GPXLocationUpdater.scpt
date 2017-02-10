--> function to replace a particular char in a string with an other one
on replace_chars(this_text, search_string, replacement_string)
	set AppleScript's text item delimiters to the search_string
	set the item_list to every text item of this_text
	set AppleScript's text item delimiters to the replacement_string
	set this_text to the item_list as string
	set AppleScript's text item delimiters to ""
	return this_text
end replace_chars

on run arg
--> arg is a collection of the command line parameters
	
	set xmlPathParam to item 1 of arg --> first param is the location of the gpx file
	set sleepParam to item 2 of arg --> second param is the time (seconds) to sleep between each iteration

	tell application "System Events"
		tell XML file xmlPathParam
			tell XML element "gpx"
				set wptElements to every XML element whose name = "wpt" -->put wpt elements in a collection for later use
			end tell
	end tell
	
	tell process "Simulator"
		set frontmost to true
			repeat with c from 1 to count of wptElements
				set wptElement to item c of wptElements
				tell wptElement
					set lon to value of XML attribute "lon" of wptElement --> putting the lon value of the wpt element in a variable for later use
					set lat to value of XML attribute "lat" of wptElement --> putting the lan value of the wpt element in a variable for later use
				end tell
					
				click menu item "Custom Location…" of menu of menu item "Location" of menu "Debug" of menu bar 1
				set popup to window "Custom Location"
				set value of text field 1 of popup to my replace_chars(lat, ".", ",")
				set value of text field 2 of popup to my replace_chars(lon, ".", ",")
				click button "OK" of popup
					
				delay sleepParam --> sleep to simulate 'natural' movement
			end repeat
		end tell
	end tell
end run