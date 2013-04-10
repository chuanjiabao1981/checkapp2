module Permissions
  class GuestPermission < BasePermission
    def initialize
      allow :main, [:home]
      allow :sessions,[:new,:create,:destroy]
    end
  end
end