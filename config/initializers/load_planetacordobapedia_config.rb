# Load planetacordobapedia config file and store the variables for later use
# They can be accessed later from inside the app like this:
# <%= PC_CONF[:site][:title] %>

raw_config = File.read(RAILS_ROOT + "/config/planetacordobapedia.yml")
PC_CONF = YAML.load(raw_config)[RAILS_ENV]

puts "Planeta Cordobapedia config file loaded successfully"