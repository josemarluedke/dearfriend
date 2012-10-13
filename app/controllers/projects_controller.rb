class ProjectsController < ApplicationController
  inherit_resources
  actions :show
  respond_to :html, :json
end
