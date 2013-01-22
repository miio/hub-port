class CreateIssues < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.references :repo
      t.string :title
      t.text :object

      t.timestamps
    end
    add_index :issues, :repo_id
  end
end
