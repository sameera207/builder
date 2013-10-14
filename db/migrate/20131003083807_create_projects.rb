class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.string :local_path
      t.string :command

      t.timestamps
    end
  end
end
