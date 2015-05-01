require './building'
require './elevator'
require './floor'
require './person'

class Simulation
    def initialize(building)
        @building = building
    end
    def add_person_to_floor(destination, floor_number)
        passenger = Person.new(destination)
        floor = @building.floors[floor_number]
        floor.add_person_to_line(passenger)
    end
    
    def beginning_state
        puts "###Beginning Positions###"
        elevators = @building.elevators
        num_elevators = @building.number_of_elevators
        num_floors = @building.number_of_floors
        floors = @building.floors
        num_floors.downto(1).each do |floor|
            flr = floors[floor]
            up = flr.up_person_queue.size()
            down = flr.down_person_queue.size()
            (1..num_elevators).each do |elev|
                elevator = elevators[elev]
                if elevator.current_floor == floor
                    print "e#{elevator.number}[#{elevator.num_passengers}]   "
                else
                    print "-----   "
                end
            end
            print "going up: #{up}  "
            print "going down: #{down}  "
            puts "\n"
        end
        puts "\n"
    end
        
    def clock_tick()
        elevators = @building.elevators
        num_floors = @building.number_of_floors
        num_elevators = @building.number_of_elevators
        floors = @building.floors
        (1..num_elevators).each do |elev|
            elevator = elevators[elev]
            elevator.move()
        end
        num_floors.downto(1).each do |floor|
            flr = floors[floor]
            up = flr.up_person_queue.size()
            down = flr.down_person_queue.size()
            (1..num_elevators).each do |elev|
                elevator = elevators[elev]
                if elevator.current_floor == floor
                    print "e#{elevator.number}[#{elevator.num_passengers}]   "
                else
                    print "-----   "
                end
            end
            print "going up: #{up}  "
            print "going down: #{down}  "
            puts "\n"
        end
        puts "\n"
    end
end
