require 'csv'

class DatasetController < ApplicationController
  before_action :authenticate_user!

  def index
    @datasets = Dataset.where(user: current_user)
  end

  def show
    @dataset = Dataset.find(params[:id])
    @filters = @dataset.filters.each(&:filter_name)
    @headers = get_dataset_headers(@dataset)
    @data = if params[:filter]
              Filter.get_filtered_data(params[:filter])
            else
              get_all_dataset(@dataset)
            end
    redirect_to root_path, alert: "It's not your dataset" unless current_user.id == @dataset.user_id
    respond_to do |format|
      format.html
      format.json { render json: { data: @data } }
    end
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

  def get_dataset_headers(dataset)
    if dataset.csv?
      CSV.open(dataset.file.file.file, 'r', &:first)
    elsif dataset.json?
      JSON.parse(File.read(dataset.file.file.file))[0].keys
    else
      raise 'Unknown format'
    end
  end

  def get_all_dataset(dataset)
    if dataset.csv?
      CSV.read(@dataset.file.file.file)
    elsif dataset.json?
      JSON.parse(File.read(Dataset.last.file.file.file)).map(&:values)
    else
      raise 'Unknown format'
    end
  end

  def dataset_params
    params.require(:dataset).permit(:file_format, :file)
  end
end
