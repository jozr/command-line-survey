class CreateSurveys < ActiveRecord::Migration
  def change
    create_table :surveys do |t|
    	t.column :name, :string

    	t.timestamps
    end
  end
end
