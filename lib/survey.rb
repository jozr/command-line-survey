class Survey < ActiveRecord::Base
	validates :name, :presence => true
	
	has_many :questions

	#has_many answers through question

	scope :sort_surveys, -> { order('name ASC') }
end