module Modusynth
  module Controllers
    class Memberships < Modusynth::Controllers::Base
      api_route 'post', '/' do
        membership = service.create(session:, **symbolized_params)
        render_json 'synthesizers/_membership.json', status: 201, membership:
      end

      def service
        Modusynth::Services::Memberships.instance
      end
    end
  end
end