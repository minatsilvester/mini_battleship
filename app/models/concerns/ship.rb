class Ship
  attr_accessor :position, :hit

	def initialize(position, hit)
		@position = position
		@hit = hit
	end

	def check_hit(x, y)
		if self.hit.length == 3
			# If the hit coordinates have lenght of three, it means the ship has already sunk
			{message: "sunk"}
		elsif self.hit.length < 3 && self.hit.include?([x, y])
			# If the hit coordinates have lenght less than three, 
			# And the coordinate has already been hit so it is present in hit array
			{message: "hit"}
		elsif self.hit.length < 3
			# If the hit coordinates have lenght less than three, 
			# And the coordinate has not been hit update the hit array
			# Send the updated message
			self.hit.push([x, y])
			if self.hit.length == 3
				{message: "sunk"}
			else
				{message: "hit"}
			end
		end
	end
end