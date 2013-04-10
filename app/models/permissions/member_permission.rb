module Permissions
  class MemberPermission < BasePermission
    def initialize(user)
      allow :sessions,[:new,:create,:destroy]
      allow :users,[:index]
      allow :main,[:home]
    end
  end
end