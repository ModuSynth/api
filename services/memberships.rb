module Modusynth
  module Services
    class Memberships < Modusynth::Services::Base
      include Singleton

      def find_or_fail_by synthesizer: nil, session: nil, **_
        membership = Modusynth::Models::Social::Membership.where(synthesizer:, account: session.account).first
        raise Modusynth::Exceptions.forbidden('auth_token') if membership.nil?
        membership
      end
    end
  end
end