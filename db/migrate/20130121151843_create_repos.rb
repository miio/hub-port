class CreateRepos < ActiveRecord::Migration
  def change
    create_table :repos do |t|
      t.string :name
      t.string :owner
      t.text :object
      t.text :work_path

      t.timestamps
    end
  end
end
