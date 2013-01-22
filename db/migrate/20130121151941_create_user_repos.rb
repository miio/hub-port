class CreateUserRepos < ActiveRecord::Migration
  def change
    create_table :user_repos do |t|
      t.references :user
      t.references :repo

      t.timestamps
    end
    add_index :user_repos, :user_id
    add_index :user_repos, :repo_id
  end
end
