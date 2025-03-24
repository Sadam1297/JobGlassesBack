require_relative 'Json_2_CSV'
require 'logger'

input_json = ARGV[0]
output_csv = ARGV[1]

log = Logger.new("log/main.log")
log.level = Logger::INFO

#call of main.rb without arguments check

if !input_json || !output_csv
    log.error("Error: Missing input_json or output_csv file.")
    #puts "log: check log files to see the error."
    exit
end

#input name check

unless File.extname(input_json) == ".json"
    log.error("Error: #{input_json} is not a .json file.")
    #puts "log: input file must be a .json file"
    exit
end

#output name check

unless File.extname(output_csv) == ".csv"
    log.error("Error: #{output_csv} is not a .csv file.")
    #puts "log: output file must be a .csv file"
    exit
end

#exist check

unless File.exist?(input_json)
    log.error("Error: Input file '#{input_json}' does not exist.")
    #puts "log: input file not found"
    exit
end
  
converter = Json_2_CSV.new(input_json, output_csv)

input = converter.read_json(input_json)

converter.write_csv(input)

puts "Conversion done. Check the log file for more information."