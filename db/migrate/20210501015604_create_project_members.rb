class CreateProjectMembers < ActiveRecord::Migration[5.2]
  def change
    create_table :project_members do |t|
      t.string :email
      t.integer :user_id
      t.integer :project_id
      t.integer :sender_id 
      t.integer :recipient_id 
      t.string :token

      t.timestamps
    end
  end
end