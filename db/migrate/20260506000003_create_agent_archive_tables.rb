class CreateAgentArchiveTables < ActiveRecord::Migration[8.1]
  def change
    create_table :agents do |t|
      t.string :codename, null: false
      t.integer :level, null: false
      t.boolean :active, null: false

      t.timestamps
    end
    add_index :agents, :codename, unique: true

    create_table :skills do |t|
      t.string :name, null: false
      t.string :category

      t.timestamps
    end
    add_index :skills, :name, unique: true

    create_table :missions do |t|
      t.references :agent, null: false, foreign_key: true
      t.string :title, null: false
      t.string :status, null: false

      t.timestamps
    end

    create_table :agent_skills do |t|
      t.references :agent, null: false, foreign_key: true
      t.references :skill, null: false, foreign_key: true

      t.timestamps
    end
    add_index :agent_skills, [ :agent_id, :skill_id ], unique: true
  end
end
