class CreateBuilds < ActiveRecord::Migration
  def change
    create_table :builds do |t|
      t.references :project
      t.string :branch_name
      t.datetime :started_at
      t.datetime :completed_at

      t.timestamps
    end
  end
end
