module Permissions
  class GuestPermission < BasePermission
    def initialize
      allow :main, [:overview]
      allow :sessions,[:new,:create,:destroy]
    end
  end
end