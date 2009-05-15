module HasTimestamps
  def self.included(base) #:nodoc:
    base.extend(ClassMethods)
  end

  module ClassMethods
    def has_timestamps(opts = {})
      class_eval do
        def save_or_destroy_timestamps
          timestamps.each do |timestamp|
            if timestamp.stamped_at.acts_like?(:time) or timestamp.stamped_at.is_a?(Date) or timestamp.stamped_at.is_a?(DateTime)
              timestamp.save
            elsif !timestamp.new_record?
              timestamp.destroy
            end
          end
        end
        after_save :save_or_destroy_timestamps
        
        def timestamp(key)
          timestamps[key.to_s] = Time.now
        end
        
        def timestamped?(key)
          !timestamps[key.to_s].blank?
        end
      end

      has_many :timestamps, opts.merge(:class_name => '::Timestamp', :as => :timestampable) do
        def [](key)
          t = fetch_timestamp(key, false)
          t.stamped_at unless t.nil?
        end

        def []=(key, stamped_at)
          fetch_timestamp(key).stamped_at = stamped_at
        end

        def find_by_key(key)
          proxy_owner.timestamps.to_a.find { |timestamp| timestamp.key == key.to_s }
        end

        private

        def fetch_timestamp(key, build_if_nil = true)
          t = find_by_key(key)
          t = build_timestamp(key) if t.nil? and build_if_nil
          t
        end

        def build_timestamp(key)
          build(:key => key.to_s)
        end
      end
    end
  end
end

ActiveRecord::Base.class_eval { include HasTimestamps }
