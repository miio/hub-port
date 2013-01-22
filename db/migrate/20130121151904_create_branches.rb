class CreateBranches < ActiveRecord::Migration
  def change
    create_table :branches do |t|
      t.references :repo
      t.string :name
      t.text :object

      t.timestamps
    end
    add_index :branches, :repo_id
  end
end
