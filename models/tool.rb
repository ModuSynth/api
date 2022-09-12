module Modusynth
  module Models
    # Represents a tool able to create new nodes when instanciated.
    # Nodes have an interior world comprised of Web Audio API nodes
    # and links between them. They expose parameters and ports linked
    # to inner elements so that the user can interact with them.
    #
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    class Tool
      include Mongoid::Document
      include Mongoid::Timestamps
      include Mongoid::EmbeddedErrors

      field :name, type: String

      # @!attribute [rw] slots
      # @return [Integer] The number of slots the tool will take in each rack.
      field :slots, type: Integer

      embeds_many :inner_nodes, class_name: '::Modusynth::Models::Tools::InnerNode'

      embeds_many :inner_links, class_name: '::Modusynth::Models::Tools::InnerLink'
      
      validates :name,
        presence: { message: 'required' },
        length: { minimum: 3, message: 'length', if: :name? }

      validates :slots,
        presence: { message: 'required' },
        numericality: { greater_than: 0, message: 'value', if: :slots? }
    end
  end
end