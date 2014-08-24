class Question < ActiveRecord::Base
	validates :survey_id, :presence => true
	validates :description, :presence => true
	validates :a, :presence => true
	validates :b, :presence => true

	belongs_to :survey
	has_many :answers
end