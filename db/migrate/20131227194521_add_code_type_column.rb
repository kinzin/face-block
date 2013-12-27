class AddCodeTypeColumn < ActiveRecord::Migration
  def change
    add_column :posts, :code_type, :string, :default => "none"
  end
end
