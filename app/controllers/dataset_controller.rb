class DatasetController < ApplicationController
  before_action :authenticate_user!

  def index
    @data = 'lorem ipsum'
  end
end
