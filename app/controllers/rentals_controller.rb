class RentalsController < ApplicationController

    def rental
        @station = Station.find_by(identifier: "21")
        render('rental')
      end

    def receipt
    end

    def purchase_confirm
    end

    def current_ride
    end


end