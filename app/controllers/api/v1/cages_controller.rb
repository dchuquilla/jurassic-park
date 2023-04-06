# frozen_string_literal: true

module Api
  module V1
    # Cages controller
    class CagesController < ApplicationController
      before_action :find_cage, only: %i[update show destroy dinosaurs]
      def index
        cages = Cage.all
        render json: cages, status: :ok
      end

      def show
        render json: @cage, status: :ok
      end

      def create
        cage = Cage.new(cage_params)

        if cage.save
          render json: cage, status: :created
        else
          render json: { error: cage.errors.full_messages.to_sentence },
                 status: :unprocessable_entity
        end
      end

      def update
        if @cage.update(cage_params)
          render json: @cage, status: :ok
        else
          render json: { error: @cage.errors.full_messages.to_sentence },
                 status: :unprocessable_entity
        end
      end

      def destroy
        @cage.destroy
        head :no_content
      end

      def dinosaurs
        dinosaurs = @cage.dinosaurs

        render json: { dinosaurs: dinosaurs }
      end

      private

      def cage_params
        params.require(:cage).permit(:name, :capacity, :power_status)
      end

      def find_cage
        @cage = Cage.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Cage not found' }, status: :not_found
      end
    end
  end
end
