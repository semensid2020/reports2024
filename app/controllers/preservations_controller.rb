class PreservationsController < ApplicationController
  def index
    @preservations = Preservation.order(created_at: :desc)
  end

  def show
    @preservation = Preservation.find(params[:id])
  end

  def new
    @preservation = Preservation.new
  end

  def create
    @preservation = Preservation.new(preservation_params)
    if @preservation.save
      flash.now[:success] = 'Preservation successfully created'

      render turbo_stream: [
        turbo_stream.update('flash-messages', partial: 'shared/flash'),
        turbo_stream.update('form-errors', '')
      ]
    else
      flash.now[:alert] = 'Failed to create a new preservation.'

      render turbo_stream: [
        turbo_stream.update('flash-messages', partial: 'shared/flash'),
        turbo_stream.update('form-errors', partial: 'shared/errors', locals: { object: @preservation })
      ], status: :unprocessable_entity
    end
  end

  private

  def preservation_params
    params.require(:preservation).permit(:initial_file_link)
  end
end
