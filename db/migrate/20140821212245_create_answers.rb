class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
    	t.column :user_id, :integer
    	t.column :question_id, :integer
    	t.column :answer, :string, :limit => 1

    	t.timestamps
    end
  end
end
