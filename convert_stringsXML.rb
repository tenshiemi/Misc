def readXML(inputName)
	result = Array.new()
	File.open(inputName).each_line { |line|
		line = line.strip
		# Checks to see if it's a string key
		first = line.index('<string key')
		# Skips the line if it's not a string key
		if first != nil
			result << line
		end
	}
	return result
end

def process(lines)
	result = Array.new()
	lines.each { |line|
		# Removes everything before the Key
		line.slice!(0..line.index('"'))
		# Removes everything after the Value
		line.slice!(line.index('<')..-1)
		# Commas were causing column splits in Excel so I replaced them with a fake escape entity
		line.gsub!(',', '&cm;')
		# Uses a comma to split the data in to columns
		line.gsub!('">', ',')
		result << line
	}
	return result
end

def translateName(inputName)
	return inputName.slice(0..-4) + "csv"
end

def writeCSV(outputName, strings)
	output = File.new(outputName, "w+")
	strings.each { |line|
		output.puts(line)
	}
end

puts "Enter the name of the Strings file you would like to process:"
inputName = gets.chomp
lines = readXML(inputName)
strings = process(lines)
outputName = translateName(inputName)
puts outputName
writeCSV(outputName, strings)