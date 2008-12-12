module ActiveRecord #:nodoc:
  module Acts #:nodoc:
    module HasTimestamps
      def self.included(base) #:nodoc:
        base.extend(ClassMethods)
      end

      module ClassMethods
        def has_timestamps(opts = {})
          class_eval do
            def save_or_destroy_timestamps
              timestamps.each do |timestamp|
                if timestamp.stamped_at.is_a?(Time)
                  timestamp.save
                elsif !timestamp.new_record?
                  timestamp.destroy
                end
              end
            end
            after_save :save_or_destroy_timestamps
            
            def timestamp!(key)
              timestamps[key.to_s] = ActiveRecord::Base.default_timezone == :utc ? Time.now.utc : Time.now
            end
            
            def timestamped?(key)
              !timestamps[key.to_s].blank?
            end
          end

          has_many :timestamps, opts.merge(:as => :timestampable) do
            def [](key)
              fetch_timestamp(key).stamped_at
            end

            def []=(key, stamped_at)
              fetch_timestamp(key).stamped_at = stamped_at
            end

            def find_by_key(key)
              proxy_owner.timestamps.to_a.find { |timestamp| timestamp.key == key.to_s }
            end

            private

            def fetch_timestamp(key)
              find_by_key(key) || build_timestamp(key)
            end

            def build_timestamp(key)
              build(:key => key.to_s)
            end
          end
        end
      end
    end
  end
end
