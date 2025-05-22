class RefazPessoas < ActiveRecord::Migration[8.0]
  def up
    drop_table :pessoas
    create_table "pessoas", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
      t.string "apelido", limit: 32, null: false
      t.string "nome", limit: 100, null: false
      t.date "nascimento", null: false
      t.jsonb "stack", default: [], null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.virtual "searchable_text", type: :tsvector, as: "(to_tsvector('english', coalesce(nome, '') || ' ' || coalesce(apelido, '') || ' ' || coalesce(stack::text, '')))", stored: true
      t.index [ "apelido" ], name: "index_pessoas_on_apelido", unique: true
      t.index [ "searchable_text" ], name: "index_pessoas_on_searchable_text_trgm_gin", using: :gin
    end
  end

  def down
    raise IrreversibleMigration
  end
end
