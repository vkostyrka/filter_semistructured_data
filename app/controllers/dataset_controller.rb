class DatasetController < ApplicationController
  before_action :authenticate_user!

  def index
    @datasets = Dataset.where(user: current_user)
  end

  def show
    @dataset = Dataset.find(params[:id])

    redirect_to root_path, alert: "It's not your dataset" unless current_user.id == @dataset.user_id

    @filters = @dataset.filters.each(&:filter_name)
    @headers = @dataset.headers

    params[:count] ||= 10
    params[:filter] ||= '0'

    @counts = @dataset.counts

    @data = if params[:filter] == '0'
              @dataset.all_data(params[:count].to_i)
            else
              Filter.get_filtered_data(params[:filter], @dataset, params[:count].to_i)
            end

    respond_to do |format|
      format.html
      format.json { render json: { data: @data } }
    end
  end

  def create
    @dataset = Dataset.new(dataset_params.merge(user: current_user))
    if @dataset.save
      @dataset.update(count_row: @dataset.calculate_rows)
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
