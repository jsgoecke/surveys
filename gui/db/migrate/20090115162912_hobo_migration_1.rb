class HoboMigration1 < ActiveRecord::Migration
  def self.up
    create_table :questions do |t|
      t.integer  :survey_id
      t.string   :name
      t.text     :question
      t.integer  :order
      t.string   :valid_responses
      t.boolean  :active
      t.datetime :created_at
      t.datetime :updated_at
    end
    
    create_table :responses do |t|
      t.integer  :question_id
      t.string   :callerid
      t.string   :guid
      t.integer  :response
      t.datetime :created_at
      t.datetime :updated_at
    end
    
    create_table :surveys do |t|
      t.string   :name
      t.text     :description
      t.boolean  :active
      t.datetime :created_at
      t.datetime :updated_at
    end
    
    create_table :users do |t|
      t.string   :crypted_password, :limit => 40
      t.string   :salt, :limit => 40
      t.string   :remember_token
      t.datetime :remember_token_expires_at
      t.string   :name
      t.string   :email_address
      t.boolean  :administrator, :default => false
      t.datetime :created_at
      t.datetime :updated_at
      t.string   :state, :default => "active"
      t.datetime :key_timestamp
    end
  end

  def self.down
    drop_table :questions
    drop_table :responses
    drop_table :surveys
    drop_table :users
  end
end
