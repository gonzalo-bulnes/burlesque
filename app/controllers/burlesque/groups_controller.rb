require_dependency "burlesque/application_controller"

module Burlesque
  class GroupsController < ActionController::Base

    private

    # Only allow a trusted parameter "white list" through.
    def group_params
      params.require(:group).permit(:name, :role_ids)
    end
  end
end
