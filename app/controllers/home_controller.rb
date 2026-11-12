class HomeController < ApplicationController
  def index
    # Step straight into the Lego app manager dashboard workspace
    redirect_to lego_sets_path
  end
end
