class DatasetController < ApplicationController
  before_action :authenticate_user!

  def index
    @datasets = Dataset.where(user: current_user)
  end

  def show
    @dataset = Dataset.find(params[:id])

    redirect_to root_path, alert: "It's not your dataset" unless current_user.id == @dataset.user_id

    @filters = @dataset.filters.where.not(filtered_id: [0]).each(&:filter_name)
    @headers = @dataset.headers
    @counts = @dataset.counts

    @data = prepare_data(params, @dataset)

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

  def stats
    dataset = Dataset.find(params[:id])

    redirect_to root_path, alert: "It's not your dataset" unless current_user.id == dataset.user_id

    column = params[:column]

    all_data = prepare_data(params, dataset)
    index_header = dataset.headers.find_index(column)
    column_data = all_data.map { |row| row[index_header] }

    if array_consist_only_numbers?(column_data)
      sample = DescriptiveStatistics::Stats.new(column_data.map(&:to_f))

      data = {
        min: sample.min.round(3),
        max: sample.max.round(3),
        median: sample.median.round(3),
        mode: sample.mode.round(3),
        variance: sample.variance.round(3)
      }
      render json: { data: data }
    else
      render json: { error: 'Use only digit data for stats block' }
    end
  end

  private

  def dataset_params
    params.require(:dataset).permit(:file_format, :file)
  end

  def array_consist_only_numbers?(list)
    list.each do |item|
      return false unless s_is_number?(item)
    end
    true
  end

  def s_is_number?(str)
    str !~ /\D/
  end

  def prepare_data(params, dataset)
    params[:count] ||= 10

    if params[:filter].nil? || params[:filter] == '0'
      dataset.all_data(params[:count].to_i)
    else
      Filter.get_filtered_data(params[:filter], dataset, params[:count].to_i)
    end
  end
end
