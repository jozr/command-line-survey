class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
    	t.column :survey_id, :int
    	t.column :description, :string
    	t.column :a, :int
    	t.column :b, :int

    	t.timestamps
    end
  end
end
