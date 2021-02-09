class RemoveDeviseFromDeveloper < ActiveRecord::Migration[5.0]
  def change
    remove_column :developers, :encrypted_password, :string
    remove_column :developers, :reset_password_token, :string
    remove_column :developers, :reset_password_sent_at, :datetime
    remove_column :developers, :remember_created_at, :datetime
    remove_column :developers, :confirmation_token, :string
    remove_column :developers, :confirmed_at, :datetime
    remove_column :developers, :confirmation_sent_at, :datetime
  end
end
