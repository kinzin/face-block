class ChangeAstrosignToEmail < ActiveRecord::Migration
  def up
    rename_column :users, :astrological_sign, :email
  end

  def down
    rename_column :users, :email, :astrological_sign
  end
end




