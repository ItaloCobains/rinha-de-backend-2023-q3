class AddSearchableInPessoa < ActiveRecord::Migration[8.0]
  def up
    execute <<~SQL
      ALTER TABLE pessoas
      ADD COLUMN searchable_text text
      GENERATED ALWAYS AS (concat_search(nome, apelido, stack::json)) STORED;
    SQL
  end


  def down
    execute <<~SQL
      ALTER TABLE pessoas
      DROP COLUMN searchable_text;
    SQL
  end
end
