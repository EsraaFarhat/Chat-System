class Application < ApplicationRecord
    has_many :chats, dependent: :destroy
    
    validates :token, presence: true, uniqueness: true
    validates :name, presence: true

    def next_chat_number
        redlock = Redlock::Client.new([ENV['REDIS_URL'] || 'redis://localhost:6379/0'])
    
        # Retry up to 3 times with a 200ms delay between retries
        retry_options = { retries: 3, retry_delay: 200 }
    
        # Use a Redlock mutex to ensure atomicity and consistency in a distributed environment
        redlock.lock('chat_number_lock', 1000, retry_options) do
          last_chat = chats.order(number: :desc).first
          last_chat_number = last_chat&.number || 0
          last_chat_number += 1
          return last_chat_number
        end
    end
end
