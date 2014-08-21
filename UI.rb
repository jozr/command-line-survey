require 'active_record'
require './lib/survey'
require './lib/question'
require './lib/answer'
require './lib/user'

database_configuration = YAML::load(File.open('./db/config.yml'))
development_configuration = database_configuration['development']
ActiveRecord::Base.establish_connection(development_configuration)

def welcome
	puts "===================== SURVEY APP ====================="
	menu
end

def menu
	choice = nil
	until choice === 'a'
		puts "PRESS 'a' TO ADD A NEW SURVEY OR 'l' TO LIST SURVEYS"
		puts "PRESS 'e' TO EDIT SURVEY OR 'd' TO DELETE A SURVEY"
		puts "PRESS 'x' TO EXIT"
		puts "~~~~~~~~~~~~~~~~~~~~~~~~~"
		choice = gets.chomp
		case choice
		when 'a'
			add_survey
		when 'l'
			list_surveys
		when 'e'
			edit_survey
		when 'd'
			delete_survey
		when 'x' 
			exit
		else
			puts "INVALID CHOICE"
		end
	end
end

def add_survey
	puts "ENTER A NEW SURVEY NAME"
	survey_name = gets.chomp
	survey = Survey.create(:name => survey_name)
	puts "#{survey.name} HAS BEEN ADDED"
	puts "~~~~~~~~~~~~~~~~~~~~~~~~~"
end

def edit_survey
	puts "ENTER A SURVEY ID TO EDIT"
	list_surveys
	survey_input = gets.chomp
	puts "ENTER THE NEW NAME"
	new_name = gets.chomp
	Survey.update(survey_input, :name => new_name)
	puts "SURVEY UPDATED"
	puts "~~~~~~~~~~~~~~~~~~~~~~~~~"
end

def delete_survey
	puts "ENTER A SURVEY ID TO DELETE"
	list_surveys
	survey_input = gets.chomp
	Survey.delete(survey_input)
	puts "SURVEY DELETED"
	puts "~~~~~~~~~~~~~~~~~~~~~~~~~"
end

def list_surveys
	puts "~~~~~~~~ SURVEYS ~~~~~~~~"
	Survey.all.each do |survey| 
		puts "#{survey.id}: #{survey.name}"
	end
	puts "~~~~~~~~~~~~~~~~~~~~~~~~~"
end

welcome
