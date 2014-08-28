class Survey < ActiveRecord::Base
	validates :name, :presence => true
	
	has_many :questions

	scope :sort_surveys, -> { order('name ASC') }
end