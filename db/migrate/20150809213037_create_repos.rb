class CreateRepos < ActiveRecord::Migration
  def change
    create_table :repos do |t|
      t.integer :repo_id
      t.string :repo_name
      t.integer :owner_id
      t.string :owner_name

      t.timestamps null: false
    end
  end
end
