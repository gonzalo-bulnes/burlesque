require_dependency "burlesque/application_controller"

module Burlesque
  class RolesController < ActionController::Base

    private

    # Only allow a trusted parameter "white list" through.
    def group_params
      params.require(:group).permit(:name)
    end
  end
end
