require './elevator'
require './floor'

class Building
    attr_reader :number_of_elevators, :number_of_floors, :elev_requests, :elevators, :floors
    def initialize(number_of_elevators, number_of_floors)
        @number_of_elevators = number_of_elevators
        @number_of_floors = number_of_floors
        #bldg keeps track of pending requests for elev's going up and down
        @up_elev_requests = []
        @down_elev_requests = []
        @floors = Hash.new
        (1..@number_of_floors).each do |floor_num|
            next_floor = Floor.new(floor_num, self)
            @floors[floor_num] = next_floor
        end 
        @elevators = Hash.new
        (1..@number_of_elevators).each do |elevator_num|
            starting_floor_num = 1
            next_elevator = Elevator.new(starting_floor_num, self, elevator_num)
            @elevators[elevator_num] = next_elevator
        end           
    end
    
    #keep track of what floor has a pending elevator request first to last in a queue
    def add_up_elev_request(floor_number)
        @up_elev_requests.push(floor_number)
    end
    
    def add_down_elev_request(floor_number)
        @down_elev_requests.push(floor_number)
    end
    
    def remove_up_elev_request(floor_number)
        @up_elev_requests.delete(floor_number)
    end
    
    def remove_down_elev_request(floor_number)
        @down_elev_requests.delete(floor_number)
    end
end
        
