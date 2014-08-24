class Answer < ActiveRecord::Base
	validates :user_id, :presence => true
	validates :question_id, :presence => true
	validates :answer, :presence => true

	belongs_to :user
	belongs_to :question
end