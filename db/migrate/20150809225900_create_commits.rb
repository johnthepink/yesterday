class CreateCommits < ActiveRecord::Migration
  def change
    create_table :commits do |t|
      t.string :sha
      t.string :message
      t.datetime :date_committed

      t.timestamps null: false
    end
  end
end
