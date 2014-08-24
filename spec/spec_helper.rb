require 'active_record'
require 'rspec'

database_configuration = YAML::load(File.open('./db/config.yml'))
test_configuration = database_configuration['test']
ActiveRecord::Base.establish_connection(test_configuration)

RSpec.configure do |config|
	config.after(:each) do
		Survey.all.each { |survey| survey.destroy }
	end
end