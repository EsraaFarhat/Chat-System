class Chat < ApplicationRecord
    belongs_to :application
    has_many :messages, dependent: :destroy

    def next_message_number
        redlock = Redlock::Client.new([ENV['REDIS_URL'] || 'redis://localhost:6379/0'])
    
        # Retry up to 3 times with a 200ms delay between retries
        retry_options = { retries: 3, retry_delay: 200 }
    
        # Use a Redlock mutex to ensure atomicity and consistency in a distributed environment
        redlock.lock('message_number_lock', 1000, retry_options) do
          last_message = messages.order(number: :desc).first
          last_message_number = last_message&.number || 0
          last_message_number += 1
          return last_message_number
        end
    end
end
