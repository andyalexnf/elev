require './person'
require './building'
require './floor'

ELEV_MAX_PERSONS = 5

class Elevator
    attr_reader :num_passengers, :passengers, :current_floor, :building, :number, :direction, :capacity
    def initialize(starting_floor, building, num)
        @num_passengers = 0
        @passengers = Hash.new()
        @current_floor = starting_floor
        @direction = "stationary"
        @capacity = ELEV_MAX_PERSONS
        @building = building
        @number = num
    end
    
    def add_passenger(new_passenger)
        dest = new_passenger.floor_destination
        if @passengers.has_key?(dest)
            people_for_floor = @passengers.fetch(dest)
            people_for_floor.push(new_passenger)
            @passengers[dest] = people_for_floor
        else
            people_for_floor = [new_passenger]
            @passengers[dest] = people_for_floor
        end
        @num_passengers += 1
    end
    
    def exit_passengers(floor_number)
        if @passengers.has_key?(floor_number)
            disembarking = @passengers.delete(floor_number) #array of people exiting 
            @num_passengers -= disembarking.size()
        end
        if @num_passengers == 0
            @direction = "stationary"
        end      
    end
    #elevators move a floor every "tick" of simulation.  If it's going up/down, move up/down
    #if its currently stationary, need to decide on a direction
    def move()
        if @direction == "up"
            move_up()
        elsif @direction == "down"
            move_down()
        else
            #check if anyone is on current floor- which way do majority want to go from here?
            @direction = people_on_current_floor()
            if @direction == "up" #were more ppl on this floor wanting to go up
                move_up()
            elsif @direction == "down"
                move_down()
            else #no one on this floor, decide direction based on pending rqsts above and below...
                decide_direction()
            end
        end
    end
    #see if there are people on this floor, if so go in whatever direction the majority of them want 
    def people_on_current_floor()
        floors = @building.floors
        curr_floor = floors[@current_floor]
        wanting_up = curr_floor.up_person_queue
        wanting_down = curr_floor.down_person_queue
        if wanting_up.size() == 0 && wanting_down.size() == 0
            return "stationary"
        elsif wanting_up.size() > wanting_down.size()
            return "up"
        else # there are more or as many ppl wanting to go down
            return "down"
        end
    end
    #see if there are more requests above to go up or below to go down
    def decide_direction()
        floors = @building.floors
        requests_below = 0
        #see how many people below, wanting to go up or down
        (1..@current_floor).each do |floor_num|
            f = floors[floor_num]
            if f.button_pairs["elevator#{@number}"]["up"] == true || f.button_pairs["elevator#{@number}"]["down"] == true
                requests_below += f.up_person_queue.size() + f.down_person_queue.size()
            end
        end
        requests_above = 0
        #see how many above wanting to go down or up
        (@current_floor..@building.number_of_floors).each do |floor_num|
            f = floors[floor_num]
            if f.button_pairs["elevator#{@number}"]["down"] == true || f.button_pairs["elevator#{@number}"]["up"] == true
                requests_above += f.up_person_queue.size() + f.down_person_queue.size()
            end
        end
        if requests_above == 0 && requests_below == 0
            @direction = "stationary"
        elsif requests_above > requests_below
            @direction = "up"
            move_up()
        else #requests_above <= requests_below
            @direction = "down"
            move_down()
        end            
    end
    #move elevator up, board/disembark passengers, if it is empty, make direction stationary
    def move_up()
        floor_before_move = @building.floors[@current_floor]
        floor_before_move.board_elevator(self)
        @current_floor += 1
        exit_passengers(@current_floor)
        new_floor = @building.floors[@current_floor]
        new_floor.board_elevator(self)
        if num_passengers == 0
            @direction = "stationary"
        end 
    end
    
    def move_down()
        floor_before_move = @building.floors[@current_floor]
        floor_before_move.board_elevator(self)
        @current_floor -= 1
        exit_passengers(@current_floor)
        new_floor = @building.floors[@current_floor]
        new_floor.board_elevator(self) 
        if num_passengers == 0
            @direction = "stationary"
        end
    end   
end
