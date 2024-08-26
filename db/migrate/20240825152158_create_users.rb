class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users, id:false do |t|
      t.string :id, primary_key:true
      t.string :name
      t.string :email
      t.string :password_digest
    end
    
    create_table :posts, id:false do |t|
      t.string :id, primary_key:true
      t.string :name
      t.string :user_id
      t.text :content
    end
    
    create_table :comments, id:false do |t|
      t.string :id, primary_key:true
      t.text :content
      t.integer :user_id
      t.integer :post_id
    end
  end
end