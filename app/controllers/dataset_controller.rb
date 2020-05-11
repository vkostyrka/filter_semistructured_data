require 'csv'

class DatasetController < ApplicationController
  before_action :authenticate_user!

  def index
    @datasets = Dataset.where(user: current_user)
  end

  def show
    @dataset = Dataset.find(params[:id])
    @filters = @dataset.filters.each(&:filter_name)
    @headers = CSV.open(@dataset.file.file.file, 'r', &:first)
    @data = if params[:filter]
              GetFilteredDataService.build(params[:filter])
            else
              # show all file
              CSV.read(@dataset.file.file.file)
            end
    redirect_to root_path, alert: "It's not your dataset" unless current_user.id == @dataset.user_id
  end

  def create
    @dataset = Dataset.new(dataset_params.merge(user: current_user))
    if @dataset.save
      redirect_to root_path, notice: 'Your menu dataset successful created'
    else
      redirect_to root_path, alert: 'Your dataset not created'
    end
  end

  def destroy
    @dataset = Dataset.find(params[:id])
    redirect_to root_path, alert: "It's not your dataset" unless current_user.id == @dataset.user_id
    if @dataset.destroy
      redirect_to root_path, notice: 'Your dataset successfully deleted'
    else
      redirect_to root_path, notice: "Your dataset wasn't deleted"
    end
  end

  private

  def dataset_params
    params.require(:dataset).permit(:file_format, :file)
  end
end
