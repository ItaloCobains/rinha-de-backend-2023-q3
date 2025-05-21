class RemoveAllIndexesFromPessoas < ActiveRecord::Migration[8.0]
  def change
    remove_index :pessoas, name: "idx_pessoas_concat_trgm_gist"
    remove_index :pessoas, name: "index_pessoas_on_apelido"
    remove_index :pessoas, name: "index_pessoas_on_nascimento"
    remove_index :pessoas, name: "index_pessoas_on_nome"
  end
end
