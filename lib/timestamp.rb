module HasTimestamps
  class Timestamp < ActiveRecord::Base
    class << self
      def create_table
        self.connection.create_table(:timestamps) do |t|
          t.integer :timestampable_id
          t.string  :timestampable_type
          t.string  :key
          t.datetime    :stamped_at
          t.timestamps
        end
      end

      def drop_table
        self.connection.drop_table(:timestamps)
      end
    end

    belongs_to :timestampable, :polymorphic => true

    validates_presence_of :key, :timestampable_id, :timestampable_type
    validates_uniqueness_of :key, :scope => [ :timestampable_id, :timestampable_type ]

    def to_param
      self.key
    end
  end
end
