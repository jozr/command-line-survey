class EditQuestions < ActiveRecord::Migration
  def change
  	change_column :questions, :a, :string
    change_column :questions, :b, :string
  end
end
