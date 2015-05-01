require './person'
require './floor'
require './elevator'
require './building'
require './simulate'

puts "which simulation would you like to run? (type 1 thru 7)"
choice = gets.chomp
if choice == "1" 
    #first simulation: building with 1 elevator and 3 floors
    #elevators should stay on 1st floor (no passengers)
    puts "SIMULATION ONE"
    puts "\n"
    building_one = Building.new(1, 3)
    simulation_one = Simulation.new(building_one)
    simulation_one.beginning_state()
    (1..3).each do |i|
        puts "###Tick#{i}###"
        simulation_one.clock_tick()
    end
    puts "\n"
elsif choice == "2"
    #second simulation: building w/1 elevator, 3 floors, and 
    #1 passenger on 1st floor who wants to go to 3rd floor
    #elevator should go up 1 floor per tick and stop on 3rd 
    puts "SIMULATION TWO"
    puts "\n"
    building_two = Building.new(1,3)
    simulation_two = Simulation.new(building_two)
    simulation_two.add_person_to_floor(3,1)
    simulation_two.beginning_state()
    (1..3).each do |i|
        puts "###Tick#{i}###"
        simulation_two.clock_tick()
    end
elsif choice == "3"
    #3rd simulation: building w/1 elev, 5 floors, a passenger
    #on 2nd flr wanting to go up to flr 4, a passenger on 3rd flr
    #wanting to go up to flr 4, and passenger on 5 wanting to
    #go down to flr 2 -- should get 2 ppl going up bring them to their
    #dest's then go up and get person going down
    puts "SIMULATION THREE"
    building_three = Building.new(1, 5)
    simulation_three = Simulation.new(building_three)
    simulation_three.add_person_to_floor(4, 2)
    simulation_three.add_person_to_floor(4, 3)
    simulation_three.add_person_to_floor(2, 5)
    simulation_three.beginning_state()
    (1..8).each do |i|
        puts "###Tick#{i}###"
        simulation_three.clock_tick()
    end
    puts "\n"
elsif choice == "4"
    #p on 2, wants to go up to 4, p on 3 wants to go up to 4.  After they
    #are deliverd, elev should wait on 4.  Then 2 ppl show up on 5, wanting to 
    #go down to 1, and 1 person appears on 2, wanting to go up to 5.  Elev should
    #pick up ppl on 5, go down, then pick up person on 2 and go up
    puts "SIMULATION FOUR"
    building_four = Building.new(1, 5)
    sim_four = Simulation.new(building_four)
    sim_four.add_person_to_floor(4, 2)
    sim_four.add_person_to_floor(4, 3)
    sim_four.beginning_state()
    (1..3).each do |i|
        puts "###Tick#{i}###"
        sim_four.clock_tick()
    end
    #now the 2 ppl enqueue on 5, wanting to go down to 1 and 1 person enqueues on 2
    #wanting to go up to 5.  More ppl above, deal with them first, then it will attend to person on 2
    sim_four.add_person_to_floor(1, 5)
    sim_four.add_person_to_floor(1, 5)
    sim_four.add_person_to_floor(5, 2)
    (1..10).each do |i|
        puts "###Tick#{i + 3}###"
        sim_four.clock_tick()
    end
    puts "\n"
    
elsif choice == "5"
    #this simulation shows how elevator behaves if it's at capacity 
    puts "SIMULATION FIVE"
    building_five = Building.new(1, 5)
    sim_five = Simulation.new(building_five)
    #add 6 ppl to floor 1 wanting to go up to 5 (capacity is 5).  It should bring 5 of them
    #up, then come back for the 1 over capacity and bring that person up
    (0..5).each do
        sim_five.add_person_to_floor(5, 1)
    end
    sim_five.beginning_state()
    (1..12).each do |i|
        puts "###Tick#{i}###"
        sim_five.clock_tick()
    end
    puts "\n"
elsif choice == "6"
    #This simulation shows what happens with 2 elevators
    puts "SIMULATION SIX"
    building_six = Building.new(2, 5)
    sim_six = Simulation.new(building_six)
    #put 3 ppl on floor 3 who want to go up to 5, and 3 ppl on flr 3 who want to go down to 1
    (0..2).each do
        sim_six.add_person_to_floor(5, 3)
    end
    (0..2).each do
        sim_six.add_person_to_floor(1, 3)
    end
    #one elevator should attend to the ppl going up, the other to the ppl going down
    (1..5).each do |i|
        puts "###Tick{i}###"
        sim_six.clock_tick()
    end
    puts "\n"
else #choice == "7"
    puts "SIMULATION SEVEN"
    building_seven = Building.new(3, 5)
    sim_seven = Simulation.new(building_seven)
    #5 ppl flr 3 want to go up to 5, 5 ppl on flr 3 want to go down to 1, 5 ppl on flr 4, want 1
    #all 3 elevators should go to work!
    (0..4).each do
        sim_seven.add_person_to_floor(5, 3)
    end
    (0..4).each do
        sim_seven.add_person_to_floor(1, 3)
    end 
    (0..4).each do
        sim_seven.add_person_to_floor(1, 4)
    end
    sim_seven.beginning_state()
    (1..5).each do |i|
        puts "###Tick{i}###"
        sim_seven.clock_tick()
    end
end
    
    


















