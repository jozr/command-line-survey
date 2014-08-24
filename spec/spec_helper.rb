require 'active_record'
require 'rspec'
require './lib/user'
require './lib/survey'
require './lib/question'
require './lib/answer'
require 'shoulda-matchers'

database_configuration = YAML::load(File.open('./db/config.yml'))
test_configuration = database_configuration['test']
ActiveRecord::Base.establish_connection(test_configuration)

RSpec.configure do |config|
	config.after(:each) do
		Survey.all.each { |i| i.destroy }
		User.all.each { |i| i.destroy }
		Question.all.each { |i| i.destroy }
		Answer.all.each { |i| i.destroy }
	end
end