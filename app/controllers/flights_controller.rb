class FlightsController < ApplicationController
  respond_to :html, :js

  def show
    
  end

  def search
    @flights = Flight.search(reject_empty!(search_params))
    respond_to do |format|
        format.html { 
          render partial: 'flights/search_results', locals: { 
            flights: FlightDecorator.new(@flights)
          } 
        }
        format.js
      end
  end

  def reject_empty!(value_params)
    value_params.delete_if {|key, value| value.blank? }
    value_params.values.each do |v|
      reject_empty!(v) if v.is_a?(ActionController::Parameters)
    end
    value_params.delete_if {|key, value| value.blank? }
  end

  private
    
    def search_params
      params.require(:flight_search).permit(
        :departure_date,
        routes: [
          :departure_airport_id,
          :arrival_airport_id
        ]
      )
    end
end
