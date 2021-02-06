class AddConfirmableToDevelopers < ActiveRecord::Migration[5.0]
  def change
    ## Devise Confirmable columns
    add_column :developers, :confirmation_token, :string
    add_column :developers, :confirmed_at, :datetime
    add_column :developers, :confirmation_sent_at, :datetime
  end
end
