class Answer < ActiveRecord::Base
	validates :user_id, :presence => true
	validates :question_id, :presence => true
	validates :answer, :presence => true, :length => { maximum: 1 }

	belongs_to :user
	belongs_to :question

	before_save :downcase_answer

private

	def downcase_answer
		answer.downcase!
	end
end