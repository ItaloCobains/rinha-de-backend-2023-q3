class CreatePessoas < ActiveRecord::Migration[8.0]
  def change
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')

    create_table :pessoas, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.string :apelido, null: false, limit: 32
      t.string :nome, null: false, limit: 100
      t.date :nascimento, null: false
      t.jsonb :stack, null: false, default: []

      t.timestamps
    end
    add_index :pessoas, :nome
    add_index :pessoas, :apelido, unique: true
    add_index :pessoas, :stack, using: :gin
    add_index :pessoas, :nascimento
  end
end
