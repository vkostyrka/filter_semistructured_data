class DatasetController < ApplicationController
  before_action :authenticate_user!

  def index
    @dataset_formats = Dataset.file_formats.keys
    @dataset = Dataset.new
    @datasets = Dataset.where(user: current_user)
  end

  def create
    @dataset = Dataset.new(dataset_params.merge(user: current_user))
    if @dataset.save
      redirect_to root_path, notice: 'Your menu dataset successful created'
    else
      redirect_to root_path, alert: 'Your dataset not created'
    end
  end

  private

  def dataset_params
    params.require(:dataset).permit(:file_format, :file)
  end
end
