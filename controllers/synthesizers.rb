# frozen_string_literal: true

module Modusynth
  module Controllers
    class Synthesizers < Modusynth::Controllers::Base
      api_route 'get', '/' do
        results = service.list(@session.account).map do |synthesizer|
          Modusynth::Decorators::Synthesizer.new(synthesizer).to_h
        end
        halt 200, results.to_json
      end

      api_route 'get', '/:id', ownership: true do
        halt 200, decorate(@resource).to_json
      end

      api_route 'put', '/:id', ownership: true do
        halt 200, decorate(service.update(@resource, body_params)).to_json
      end

      api_route 'post', '/' do
        synthesizer = service.create(account: @session.account, **symbolized_params)
        halt 201, decorate(synthesizer).to_json
      end

      api_route 'delete', '/:id' do
        service.remove_if_owner(id: params[:id], account: @session.account)
        halt 204
      end

      def service
        Modusynth::Services::Synthesizers.instance
      end

      def decorate(item)
        Modusynth::Decorators::Synthesizer.new(item).to_h
      end
    end
  end
end
