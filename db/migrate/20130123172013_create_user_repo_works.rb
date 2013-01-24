class CreateUserRepoWorks < ActiveRecord::Migration
  def change
    create_table :user_repo_works do |t|
      t.references :user
      t.references :repo
      t.text :path

      t.timestamps
    end
    add_index :user_repo_works, :user_id
    add_index :user_repo_works, :repo_id
  end
end
