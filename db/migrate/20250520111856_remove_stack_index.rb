class RemoveStackIndex < ActiveRecord::Migration[8.0]
  def change
    remove_index :pessoas, name: "index_pessoas_on_stack"
  end
end
