class AddTokenExpiresAtToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :token_expires_at, :datetime
  end
end
