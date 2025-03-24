require 'json'
require 'csv'
require 'logger'

class Converter_Json_2_CSV
    attr_reader :input_json, :output_csv
    def initialize(input_json, output_csv)
        @input_json = input_json
        @output_csv = output_csv

        @log = Logger.new("log/Converter_Json_2_CSV.log")
        @log.level = Logger::INFO
    end

    def read_json(files)
        @log.info("Reading json file. #{files}")
        json_string = ""
        IO.foreach(files) do |line|
            json_string << line
        end
        parsing_json = JSON.parse(json_string)
        @log.info("Json file parse successfully.")
        return parsing_json
    rescue JSON::ParserError => e
        @log.error("Error parsing json file. #{e}")
        raise
    rescue Errno::ENOENT => e
        @log.error("Error reading json file. #{e}")
        raise
    end

    def write_csv(data)
        @log.info("Writing to CSV file: #{@output_csv}")
        CSV.open(@output_csv, "w") do |csv|
            csv << ["profile_id", "email", "tags", "social_id", "picture"]

            data.each do |profile|
                next unless profile.is_a?(Hash)
                tags = profile["tags"]&.join("|") || ''
                profile["profiles"].each do |network , social|
                    csv << [
                        profile["id"],
                        profile["email"],
                        tags,
                        social["id"],
                        social["picture"],
                    ]
                end
            end
        end
        @log.info("CSV file write successfully.")
    rescue => e
        @log.error("Error writing to CSV file. #{e}")
        raise
    end
end

  
# def saluer(nom, adresse)
#     puts "Bonjour, #{nom} !"
#     if (adresse == "vlg")
#         puts "37 avenue de la république"
#   end
# end
  
#   saluer(ARGV[0], ARGV[1])