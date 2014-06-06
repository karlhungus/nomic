module Nomic
 extend self
 ROOT_PATH = File.expand_path("..", File.dirname(__FILE__))
 CONFIG_PATH = File.join(ROOT_PATH,'config')

 def github_token
  @github_token ||= load_config['github']['api_key']
 end

 def heroku_token
     @heroku_token ||= load_config['heroku']['api_key']
 end

 private 
 def load_config
     @config ||= begin 
                     filename = File.join(CONFIG_PATH, "tokens.yml")
                     YAML.load(File.read(filename))
                 end
 end
end
