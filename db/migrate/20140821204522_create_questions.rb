class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
    	t.column :survey_id, :integer
    	t.column :description, :string
    	t.column :a, :integer
    	t.column :b, :integer

    	t.timestamps
    end
  end
end
