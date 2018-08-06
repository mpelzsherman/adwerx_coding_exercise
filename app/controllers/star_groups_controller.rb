class StarGroupsController < ApplicationController

  # GET /star_groups
  # GET /star_groups.json
  def index
    @star_groups ||= StarGroup.all
  end

end
