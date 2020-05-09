class FilterController < ApplicationController
  def create
    @filter = Filter.new(filter_params)
    if @filter.save
      redirect_to dataset_index_path(filter_params[:id]), notice: 'Your filter successful created'
    else
      redirect_to dataset_index_path(filter_params[:id]), alert: 'Your filter not created'
    end
  end

  private

  def filter_params
    params.require(:filter).permit(:condition, :value, :column_name, :dataset_id)
  end
end
