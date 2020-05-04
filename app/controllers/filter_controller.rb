class FilterController < ApplicationController
  def create
    @filter = Filter.new(filter_params)
    if @filter.save
      redirect_to :back, notice: 'Your filter successful created'
    else
      redirect_to :back, alert: 'Your filter not created'
    end
  end

  private

  def filter_params
    params.require(:filter).permit(:condition, :value)
  end
end
