module Modusynth
  module Models
    # A synthesizer is the base object of the business in our application. It creates one of the
    # interfaces where a user can create nodes and connect them to sculpt sound and produce
    # music.
    # @ author Vincent Courtois <courtois.vincent@outlook.com>
    class Synthesizer
      include Mongoid::Document
      include Mongoid::Timestamps
      include Modusynth::Models::Concerns::Ownable

      store_in collection: 'synthesizers'

      field :name, type: String

      field :slots, type: Integer, default: 50

      field :racks, type: Integer, default: 1

      field :x, type: Integer, default: 0

      field :y, type: Integer, default: 0

      field :scale, type: Float, default: 1.0

      # @!attribute [rw] voices
      #  @return [Integer] the number of polyphony voices in the synthesizer, 1 means it's monophonic.
      field :voices, type: Integer, default: 1

      has_many :modules, class_name: '::Modusynth::Models::Module', inverse_of: :synthesizer

      has_many :links, class_name: '::Modusynth::Models::Link', inverse_of: :synthesizer

      belongs_to :account, class_name: '::Modusynth::Models::Account', inverse_of: :synthesizers

      validates :name,
        presence: { message: 'required' },
        length: { minimum: 6, message: 'length'}
      
      validates :voices,
        numericality: { greater_than: 0, less_than: 257, message: 'value' }
      
      validates :slots,
        numericality: { greater_than: 0, message: 'value' }
      
      validates :racks,
        numericality: { greater_than: 0, message: 'value' }
      
      validates :scale,
        numericality: { greater_than_or_equal_to: 1.0, message: 'value' }
    end
  end
end