require 'json'
require 'csv'
require 'logger'

class Json_2_CSV
    attr_reader :input_json, :output_csv #getter
    def initialize(input_json, output_csv)
        @input_json = input_json
        @output_csv = output_csv

        log_dir = "log"
        Dir.mkdir(log_dir) unless Dir.exist?(log_dir)
    
        date = Date.today.strftime("%Y-%m-%d")
        log_file = File.join(log_dir, "-#{date}.log")

        @log = Logger.new(log_file)
        @log.level = Logger::INFO
    end

    def read_json(files)
        begin #compulsory in that case
            @log.info("Reading json file. #{files}")
            json_string = ""
            IO.foreach(files) do |line|
                json_string << line # concatenation of each line of the file(add to eof)
            end
            parsing_json = JSON.parse(json_string) # turn json_string into a hash/array parse =/= generate
            @log.info("Json file parse successfully.")
            return parsing_json
        rescue JSON::ParserError => e
            @log.error("Error parsing json file. #{e}") # catch error parsing json
            raise
        rescue Errno::ENOENT => e
            @log.error("Error reading json file. #{e}") # catch error reading json
            raise
        end
    end

    def write_csv(data)
        begin # In that case we can erase it, but usefull to keep it for future use or extern error handling
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
end
