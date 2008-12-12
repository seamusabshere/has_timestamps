ActiveRecord::Schema.define do
  create_table :people do |t|
    t.string :name
  end
  create_table :timestamps do |t|
    t.integer :timestampable_id
    t.string :timestampable_type
    t.string :key
    t.datetime :stamped_at
  end
end
