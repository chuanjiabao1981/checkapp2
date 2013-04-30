module Permissions
  class GuestPermission < BasePermission
    def initialize
      allow :main, [:overview]
      allow :sessions,[:new,:create,:destroy]
      allow "api/v1/sessions",[:create,:destroy]
    end
  end
end