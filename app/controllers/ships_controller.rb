class ShipsController < ApplicationController
	before_action :load_objects, only: [:hit]
  
	def create
		positions = params[:positions]

		invalid_coordinates = positions.select { |position| position.any? { |coordinate| coordinate > 10 } }

		if invalid_coordinates.length == 0
			ships = []
			positions.each do |position|
				x = position[0]
				top_y = position[1]
				ships.push(
					{
						position: [[x, top_y], [x,top_y-1], [x, top_y-2]],
						hit: []
					}
				)
			end
	
			write_to_file(ships)
	
			render :json => {message: "ok"}
		else
			render :json => {message: "Received Invalid coordinates"}
		end
	end

	def hit
		x = params[:x]
		y = params[:y]
		
		# Get the ship with this particluar coordinate present
		# Since objects cannot overlap thare can only be one object for a guven coordinate
		ship = (@ships.select { |ship| ship.position.include?([x, y])}).first
		if ship.nil?
			render :json => {message: "miss"}
		else
			# Remove the object since it might through changes
			@ships.delete(ship)

			# Will return message and update object
			message = ship.check_hit(x, y)


			new_ships_data = []

			# Add it back so that the array now has updated state opf the object
			@ships.push(ship)
			@ships.each do |ship|
				new_ships_data.push(
					{
						position: ship.position,
						hit: ship.hit
					}
				)
			end

			write_to_file(@ships)
			render :json => message
		end
		
	end


	private
	def load_objects
		file = File.open(Rails.root.join('db', 'json_data', 'ships.json'))
		data = JSON.load file

		@ships = []

		data["ships"].each do |ship|
			@ships.push(Ship.new(ship["position"], ship["hit"]))
		end
	end

	def write_to_file(ships)
		# Storing state in a JSON file since i don't have a DB
		File.write(Rails.root.join('db', 'json_data', 'ships.json'), {ships: ships}.to_json)
	end
end
