class UpdateCountsWorker
    include Sidekiq::Worker
  
    def perform
        update_all_application_counts
        update_all_chat_counts
    end
  
    private
  
    def update_all_application_counts
        Application.find_each do |application|
          application.with_lock do
            application.update(chats_count: application.chats.count)
          end
        end
    end
    
    def update_all_chat_counts
      Chat.find_each do |chat|
        chat.with_lock do
          chat.update(messages_count: chat.messages.count)
        end
      end
    end
end