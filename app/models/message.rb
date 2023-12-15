class Message < ApplicationRecord
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    belongs_to :chat

    validates :body, presence: true

    settings index: { number_of_shards: 1, number_of_replicas: 0 } do
        mappings dynamic: 'false' do
            indexes :body, analyzer: 'english'
            indexes :chat_id, type: 'integer'
            indexes :created_at, type: 'date'
        end
    end

    def as_indexed_json(options = {})
        as_json(only: [:body, :chat_id, :number, :created_at])
    end

    def self.search(query, chat_id)
        __elasticsearch__.search(
          {
            query: {
              bool: {
                must: [
                  { match: { body: query } },
                  { match: { chat_id: chat_id } }
                ]
              }
            },
            sort: [
                { created_at: { order: 'desc' } }
            ]
          },
          _source_includes: ['body', 'number', 'created_at']
        )
    end
end
