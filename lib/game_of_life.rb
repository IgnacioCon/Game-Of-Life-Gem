class Grid 

    attr_accessor :height, :width, :current_generation, :temp_grid, :generation, :max_gens

    #initialize instance variables
    def initialize (height, width, cells=[], max_gens)
        @height = height
        @width = width
        @current_generation = cells
        @temp_grid = []
        @generation = 0
        @max_gens = max_gens
    end
  
    #method that randomly fills the @current_generation with dead or live cells
    def random_cells
        @width.times do |x|
            @current_generation[x] = []
            @height.times do |y|
                @current_generation[x][y] = rand(2)
            end
        end
        @generation = 0    #if method is called, reset generation count to 0
    end

    #initiates a new grid, that is used as a placeholder for the new generaton
    def initiate_grid
        new_grid = []
        @width.times do |x|
            new_grid[x] = []
            @height.times do |y|
                new_grid[x][y] = 0
            end
        end
        new_grid
    end


    #prints out the grid that holds all the cells
    def print_grid
        puts "Generation: #{@generation}"
        @width.times do |x|
            @height.times do |y|
                print "#{@current_generation[x][y]}" + " "
            end
            puts
        end
        puts "-------------------------------------------------"
    end

    #creates a temporary grid that is bigger than the grid used to store the cells
    #to avoid errors when checking edges and corner cells during neighbor evaluation
    def fill_temp_grid
        temp_width = @width + 2
        temp_height = @height + 2

        temp_width.times do |x|
            @temp_grid[x] = []
            temp_height.times do |y|
                @temp_grid[x][y] = 0
            end
        end
    end

    #inserts cells of @current_generation to temporary grid created by fill_temp_grid
    def insert_to_temp
        @width.times do |x|
            @height.times do |y|
                @temp_grid[x+1][y+1] = @current_generation[x][y]
            end
        end
    end

    #access the cells in @temp_grid through get_neighbors alive at x,y location
    def cell_at (x,y)
        if @temp_grid[x]
            @temp_grid[x][y]
        end
    end

    #get the neighbors surrounding a cell at x,y then calculate the number of cells alive
    def get_neighbors_alive (x,y)
        neighbors = []
        neighbors_alive = 0

        neighbors.push(cell_at(x-1,y-1))  #top left corner
        neighbors.push(cell_at(x, y-1))   #top
        neighbors.push(cell_at(x+1,y-1))  #top right corner
        neighbors.push(cell_at(x-1,y))    #left
        neighbors.push(cell_at(x+1,y))    #right
        neighbors.push(cell_at(x-1,y+1))  #bottom left corner
        neighbors.push(cell_at(x,y+1))    #down
        neighbors.push(cell_at(x+1,y+1))  #bottom right corner

        neighbors.each {|cell|  neighbors_alive += cell.to_i}
        neighbors_alive
    end

    #main loop that will generate a new generation
    #get number of cells alive around a cell at x,y location
    #then call apply_rules, and insert the cell alive/dead into new generation
    #afterwards, cell update_generation where the @current_generation is updated with the new generation
    def new_generation
        neighbors_alive = 0
        new_generation = initiate_grid
        insert_to_temp
        @width.times do |x|
            @height.times do |y|
                neighbors_alive = get_neighbors_alive(x+1,y+1)
                apply_rules(x, y, neighbors_alive, new_generation)
            end
        end
        @generation += 1
        update_generation(new_generation)
    end

    #Rules of the game are applied, receives x,y coordinates, number of cells alive, and the new generation array
    #cells alive is the number of cells alive surrounding a cell at x,y location
    def apply_rules (x, y, cells_alive, new_generation)
        if ( (@current_generation[x][y] == 0 ) && (cells_alive == 3) )    #if cell is dead and number of cells alive is 3
            new_generation[x][y] = 1                                      #the cell revives for next generation
        elsif @current_generation[x][y] == 1                              #else if cell is alive check the next conditions
            if cells_alive < 2                                            #if cells alive is greater than 2
                new_generation[x][y] = 0                                  #then the cell dies in the next generation                                  
            elsif (cells_alive == 2) || (cells_alive == 3)                #if there are 2 or 3 living cells surrounding
                new_generation[x][y] = 1                                  #then the cell lives on in the next generation
            elsif cells_alive > 3                                         #if cells alive is greater than 3  
                new_generation = 0                                        #cell dies in the next generation from overpopulation
            end
        end
    end

    #updates @current_generation with the new generation
    def update_generation (new_generation)
        @width.times do |x|
            @height.times do |y|
                @current_generation[x][y] = new_generation[x][y]
            end
        end

    end

    def start
        random_cells
        fill_temp_grid

        
        while (@generation < @max_gens) do
            print_grid
            new_generation
        end 
    end


end




