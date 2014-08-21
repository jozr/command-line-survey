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
	loop do 
		puts "PRESS (s)urvey designer OR (u)ser"
		main_choice = gets.chomp

		if main_choice == 's'
			puts "PRESS 'a' TO ADD A NEW SURVEY OR 'l' TO LIST SURVEYS"
			puts "PRESS 'e' TO EDIT SURVEY OR 'd' TO DELETE A SURVEY"
			puts "PRESS 'aq' TO ADD A NEW QUESTION OR 'lq' TO LIST QUESTIONS"
			puts "PRESS 'eq' TO EDIT A QUESTION OR 'dq' TO DELETE A QUESTION"
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
			when 'aq'
				add_question
			when 'lq'
				list_questions
			when 'eq'
				edit_question
			when 'dq'
				delete_question
			when 'x' 
				exit
			else
				puts "INVALID CHOICE"
			end
		end
	end
end

def add_survey
	puts "ENTER A NEW SURVEY NAME:"
	survey_name = gets.chomp
	survey = Survey.create(:name => survey_name)
	puts "#{survey.name} HAS BEEN ADDED"
	puts "~~~~~~~~~~~~~~~~~~~~~~~~~"
end

def list_surveys
	puts "~~~~~~~~ SURVEYS ~~~~~~~~"
	Survey.all.each do |survey| 
		puts "#{survey.id}: #{survey.name}"
	end
	puts "~~~~~~~~~~~~~~~~~~~~~~~~~"
end

def edit_survey
	puts "ENTER A SURVEY ID TO EDIT:"
	list_surveys
	survey_input = gets.chomp
	puts "ENTER THE NEW NAME"
	new_name = gets.chomp
	Survey.update(survey_input, :name => new_name)
	puts "SURVEY UPDATED"
	puts "~~~~~~~~~~~~~~~~~~~~~~~~~"
end

def delete_survey
	puts "ENTER A SURVEY ID TO DELETE:"
	list_surveys
	survey_input = gets.chomp
	Survey.delete(survey_input)
	puts "SURVEY DELETED"
	puts "~~~~~~~~~~~~~~~~~~~~~~~~~"
end

def add_question
	puts "ENTER A SURVEY ID TO ADD A QUESTION TO:"
	list_surveys
	survey_input = gets.chomp
	puts "ENTER A NEW QUESTION"
	description_input = gets.chomp
	puts "ADD FIRST OF TWO ANSWERS"
	a_input = gets.chomp
	puts "ADD SECOND ANSWER"
	b_input = gets.chomp
	question = Question.create(:survey_id => survey_input, :description => description_input, :a => a_input, :b => b_input)
	puts "QUESTION ADDED"
	puts "~~~~~~~~~~~~~~~~~~~~~~~~~"
end

def list_questions
	puts "ENTER A SURVEY ID TO SEE ITS QUESTIONS:"
	list_surveys
	survey_input = gets.chomp
	questions = Question.where(:survey_id => survey_input)
	puts "~~~~~~~ QUESTIONS ~~~~~~~"
	questions.each { |question| puts "#{question.id}: #{question.description}" }
	puts "~~~~~~~~~~~~~~~~~~~~~~~~~"
end

def edit_question
	list_questions
	puts "ENTER A QUESTION ID"
	question_input = gets.chomp
	puts "ENTER A NEW DESCRIPTION"
	description_input = gets.chomp
	puts "ENTER A NEW FIRST ANSWER"
	a_input = gets.chomp
	puts "ENTER A NEW SECOND ANSWER"
	b_input = gets.chomp
	Question.update(question_input, :description => description_input, :a => a_input, :b => b_input)
	puts "QUESTION UPDATED"
	puts "~~~~~~~~~~~~~~~~~~~~~~~~~"
end

def delete_question
	list_questions
	puts "ENTER A QUESTION ID"
	question_input = gets.chomp
	Question.delete(question_input)
	puts "QUESTION DELETED"
	puts "~~~~~~~~~~~~~~~~~~~~~~~~~"
end


welcome
