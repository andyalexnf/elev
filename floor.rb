require './person'
require './building'

class Floor
    attr_reader :position_in_bldg, :up_person_queue, :down_person_queue, :button_pairs, :up_request_pending, :down_request_pending
    def initialize(position_in_bldg, building)
        @position_in_bldg = position_in_bldg
        @up_person_queue = []
        @down_person_queue = []
        @building = building #building that floor is a part of
        num_button_pairs = @building.number_of_elevators
        @button_pairs = Hash.new()
        (1..num_button_pairs).each do |i|
            pair = Hash.new()
            pair["up"] = false
            pair["down"] = false
            @button_pairs["elevator#{i}"] = pair
        end
        @up_request_pending = false
        @down_request_pending = false
    end
    
    def add_person_to_line(next_in_line)
        direction = ""
        if next_in_line.floor_destination > @position_in_bldg
            direction = "up"
            @up_person_queue.push(next_in_line)
        else
            direction = "down"
            @down_person_queue.push(next_in_line)
        end
        make_request(direction)
    end  
    
    def make_request(direction)
        #if person wants to go up/down and no pending up/down requests
        #have been made, choose elevator at random and press up/down button
        elev_num = rand(@building.number_of_elevators) + 1
        if direction == "up" && @up_request_pending == false
            @button_pairs["elevator#{elev_num}"]["up"] = true
            @up_request_pending = true
            @building.add_up_elev_request(@position_in_bldg)
        else
            @button_pairs["elevator#{elev_num}"]["down"] = true
            @down_request_pending = true
            @building.add_down_elev_request(@position_in_bldg)
        end            
    end 
    #check what direction elevator is going and board people waiting to go that direction 
    def board_elevator(elevator)
        elevator_direction = elevator.direction
        elevator_num = elevator.number
        if elevator.direction == "up"
            #board_people(elevator, @up_person_queue, @up_request_pending)
            board_people_up(elevator)
            @button_pairs["elevator#{elevator_num}"]["up"] = false
        elsif elevator.direction == "down"
            #board_people(elevator, @down_person_queue, @down_request_pending)
            board_people_down(elevator)
            @button_pairs["elevator#{elevator_num}"]["down"] = false
        end
    end 
    def board_people_down(elevator)
        while elevator.num_passengers < elevator.capacity && @down_person_queue.size() > 0
            front_person = @down_person_queue.shift()
            elevator.add_passenger(front_person)
        end
        #if people still waiting to go that direction after elevator is full, push up/down
        if @down_person_queue.size() > 0
            make_request(elevator.direction)
        #otherwise, there is no longer anyone waiting
        else
            @down_request_pending = false
            remove_elev_request(elevator.direction)
        end            
    end  
    def board_people_up(elevator)
        while elevator.num_passengers < elevator.capacity && @up_person_queue.size() > 0
            front_person = @up_person_queue.shift()
            elevator.add_passenger(front_person)
        end
        #if people still waiting to go that direction after elevator is full, push up/down
        if @up_person_queue.size() > 0
            make_request(elevator.direction)
        #otherwise, there is no longer anyone waiting
        else
            @up_request_pending = false
            remove_elev_request(elevator.direction)
        end            
    end  
    
    def remove_elev_request(direction)
        if direction == "up"
            @building.remove_up_elev_request(@position_in_bldg)
        else
            @building.remove_down_elev_request(@position_in_bldg)
        end
   end
            
end
