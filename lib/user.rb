class User < ActiveRecord::Base
	validates :name, :presence => true
	
	has_many :answers

	scope :sort_users, -> { order('name ASC') }
end