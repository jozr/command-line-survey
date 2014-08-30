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
	puts "(s)urvey designer, (u)ser, (f)igures, e(x)it"
	main_choice = gets.chomp
	if main_choice == 's'
		designer_menu
	elsif main_choice == 'u'
		user_menu
	elsif main_choice == 'f'
		figure_menu
	elsif main_choice == 'x'
		puts "======================= GOODBYE ======================"
		exit
	else
		puts "INVALID CHOICE"
	end
end

		
def designer_menu
	puts "PRESS 'a' TO ADD A NEW SURVEY OR 'l' TO LIST SURVEYS"
	puts "PRESS 'e' TO EDIT SURVEY OR 'd' TO DELETE A SURVEY"
	puts "PRESS 'aq' TO ADD A NEW QUESTION OR 'lq' TO LIST QUESTIONS"
	puts "PRESS 'eq' TO EDIT A QUESTION OR 'dq' TO DELETE A QUESTION"
	puts "PRESS 'vu' TO VIEW STORED USERS"
	puts "PRESS 'eu' TO EDIT A USER NAME OR 'du' TO DELETE A USER"
	puts "PRESS 'x' TO EXIT"
	puts "~~~~~~~~~~~~~~~~~~~~~~~~~"
	choice = gets.chomp
	if choice == 'a'
		add_survey
	elsif choice == 'l'
		only_list_surveys
	elsif choice == 'e'
		edit_survey
	elsif choice == 'd'
		delete_survey
	elsif choice == 'aq'
		add_question
	elsif choice == 'lq'
		only_list_questions
	elsif choice == 'eq'
		edit_question
	elsif choice == 'dq'
		delete_question
	elsif choice == 'vu'
		only_list_users
	elsif choice == 'eu'
		edit_user
	elsif choice == 'du'
		delete_user
	elsif choice == 'x' 
		puts "======================= GOODBYE ======================"
		exit
	else
		puts "INVALID CHOICE"
	end
end

def user_menu
	user_login
	puts "PRESS 'ts' TO TAKE A SURVEY"
	puts "PRESS 'x' TO EXIT"
	choice = gets.chomp
	case choice
	when 'ts'
		take_survey
	when 'x'
		puts "======================= GOODBYE ======================"
		exit
	else
		puts "INVALID CHOICE"
	end
end

def figure_menu

end

def user_login
	@user_id = nil
	puts "PRESS 'e' FOR EXISTING USER OR 'a' TO ADD USER"
	choice = gets.chomp
	if choice == 'a'
		add_user
	elsif choice == 'e'
		list_users
		puts "CHOOSE USERNAME ID:"
		user_input = gets.chomp
		if User.find_by(:id => user_input) == nil
			puts "INVALID ENTRY"
			user_login
		else	
			user = User.find_by(:id => user_input)
			@user_id = user.id
		end
	else
		puts "INVALID OPTION"
	end	
end

def add_user
	puts "ENTER A NEW USER:"
	user_input = gets.chomp
	user = User.new(:name => user_input)
	if user.save
		@user_id = user.id
		puts "#{user.name} HAS BEEN ADDED"
		puts "~~~~~~~~~~~~~~~~~~~~~~~~~"
	else
		user.errors.full_messages.each { |message| puts message }
		puts "~~~~~~~~~~~~~~~~~~~~~~~~~"
		add_user
	end
end

def only_list_users
	list_users
	designer_menu
end

def list_users
	puts "~~~~~~~~~ USERS ~~~~~~~~~"
	User.sort_users.each do |user|
		puts "#{user.id}: #{user.name}"
	end
	puts "~~~~~~~~~~~~~~~~~~~~~~~~~"
end

def edit_user
	puts "ENTER A USER ID TO EDIT:"
	list_users
	user_input = gets.chomp
	puts "ENTER THE NEW NAME:"
	new_name = gets.chomp
	user = User.update(user_input, :name => new_name)
	if user.save 
		puts "USER UPDATED"
		puts "~~~~~~~~~~~~~~~~~~~~~~~~~"
		designer_menu
	else
		user.errors.full_messages.each { |message| puts message }
		puts "~~~~~~~~~~~~~~~~~~~~~~~~~"
		edit_user
	end
end

def delete_user
	puts "ENTER A USER ID TO DELETE:"
	list_users
	user_input = gets.chomp
	if User.find_by(:id => user_input) == nil
		puts "INVALID ENTRY"
		delete_user
	else	
		User.delete(user_input)
		puts "USER DELETED"
		puts "~~~~~~~~~~~~~~~~~~~~~~~~~"
		designer_menu
	end
end

def take_survey
	puts "ENTER A SURVEY ID TO TAKE:"
	list_surveys
	survey_input = gets.chomp
	questions = Question.where(:survey_id => survey_input)
	counter = 0
	questions.each do |question|
		counter += 1
		puts "~~~~~~ QUESTION #{counter} ~~~~~~"
		puts "#{question.description}"
		puts "(a) #{question.a}"
		puts "(b) #{question.b}"
		answer_input = gets.chomp
		if answer_input == 'a' || answer_input == 'b'
			Answer.create(:user_id => @user_id, :question_id => question.id, :answer => answer_input)
		else 
			puts "INVALID CHOICE"
		end
	end
	puts "~~~~~~~ THANK YOU ~~~~~~~"
	user_menu
end

def add_survey
	puts "ENTER A NEW SURVEY NAME:"
	survey_name = gets.chomp
	survey = Survey.new(:name => survey_name)
	if survey.save
		puts "#{survey.name} HAS BEEN ADDED"
		puts "~~~~~~~~~~~~~~~~~~~~~~~~~"
		designer_menu
	else
		survey.errors.full_messages.each { |message| puts message }
		puts "~~~~~~~~~~~~~~~~~~~~~~~~~"
		add_survey
	end
end

def only_list_surveys
	list_surveys
	designer_menu
end

def list_surveys
	puts "~~~~~~~~ SURVEYS ~~~~~~~~"
	Survey.sort_surveys.each do |survey| 
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
	survey = Survey.update(survey_input, :name => new_name)
	if survey.save
		puts "SURVEY UPDATED"
		puts "~~~~~~~~~~~~~~~~~~~~~~~~~"
		designer_menu
	else
		survey.errors.full_messages.each { |message| puts message }
		puts "~~~~~~~~~~~~~~~~~~~~~~~~~"
		edit_survey
	end
end

def delete_survey
	puts "ENTER A SURVEY ID TO DELETE:"
	list_surveys
	survey_input = gets.chomp
	if Survey.find_by(:id => survey_input) == nil
		puts "INVALID ENTRY"
		delete_survey
	else	
		Survey.delete(survey_input)
		puts "SURVEY DELETED"
		puts "~~~~~~~~~~~~~~~~~~~~~~~~~"
		designer_menu
	end
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
	question = Question.new(:survey_id => survey_input, :description => description_input, :a => a_input, :b => b_input)
	if question.save
		puts "#{question.description} ADDED"
		puts "~~~~~~~~~~~~~~~~~~~~~~~~~"
		designer_menu
	else
		question.errors.full_messages.each { |message| puts message }
		puts "~~~~~~~~~~~~~~~~~~~~~~~~~"
		add_question
	end
end

def only_list_questions
	list_questions
	designer_menu
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
	question = Question.update(question_input, :description => description_input, :a => a_input, :b => b_input)
	if question.save
		puts "QUESTION UPDATED"
		puts "~~~~~~~~~~~~~~~~~~~~~~~~~"
		designer_menu
	else
		question.errors.full_messages.each { |message| puts message }
		puts "~~~~~~~~~~~~~~~~~~~~~~~~~"
		edit_question
	end
end

def delete_question
	list_questions
	puts "ENTER A QUESTION ID"
	question_input = gets.chomp
	if Question.find_by(:id => question_input) == nil
		puts "INVALID ENTRY"
		delete_question
	else	
		Question.delete(question_input)
		puts "SURVEY DELETED"
		puts "~~~~~~~~~~~~~~~~~~~~~~~~~"
		designer_menu
	end
end

welcome
