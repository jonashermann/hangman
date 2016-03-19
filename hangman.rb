class Hangman
 require'yaml'     # to serialize in yaml string
    def initialize
	   @secret_word = pick_word
     @count = 0
     @misses = []
     @correct = []
     @word_to_display = []
     j = @secret_word.length
     j.times{@word_to_display << "_"}
    end

    def play_game
    	puts"THE HANGMAN GAME START..."
    	puts ""
    	puts"Would you like to: "
      puts" 1- Restart your last game"
      puts" 2- Start a new game"
      print"Choose option 1 or 2: "
      option = gets.chomp.to_i
      if option == 1 
        puts"Under which name did you saved your game?"
        rep = gets.chomp.downcase
        while !File.exists?rep
         puts"This file doesn't exists"
         print"Enter a new name for restoring your game:"
         rep = gets.chomp.downcase 
        end
            if File.exists?rep
              return restore_game(rep)
            end
      end
      if option == 2
        return turn
      end   
    end


   def pick_word
   	   i  = 0 #index du mot à trouver
  	dico  = "5desk.txt"
  	words = File.readlines(dico)
  	words = words.select{|word| word.length >= 5 && word.length <= 12}
        i = rand(words.length)
          secret_word = words[i].sub(/\n/, '').downcase
    return secret_word
  	end

  	def turn
        turn = 10
       
      while @count < turn
             
        puts"Would you want to save your game?(y/n)"
        rep = gets.chomp.downcase
        while rep != "y" && rep != "n" 
         print"Please.Your answer should be 'y' or 'n': "
         rep = gets.chomp.downcase
        end 
        if rep == "y"
          return save_game(self)  #serialize here
        end
        if rep == "n"
        puts "" 
  		  print"guess a letter: "
        letter = gets.chomp.downcase
        display_game(letter)
        check_word
        end
        if @count == 9
          puts"YOU LOSE"
        end
       @count += 1
      end
    
  	end

    def display_game(guessed_letter)
      table_position = [] #to populate index of occurences
      if @secret_word.split('').include?guessed_letter
        @correct.push(guessed_letter)
        @secret_word.split('').each_with_index do |c,i|
          if c == guessed_letter
            table_position << i
          end
        end 
        table_position.each do|i|
             
             @word_to_display[i] = guessed_letter
         end
         return show
      else
        @misses.push(guessed_letter)
        return show
      end
    end

     def show
      puts "#{@word_to_display.join(" ")}"
      puts""
      puts"Correct:#{@correct.join(',')}"
      puts"Misses:#{@misses.join(',')}"
     end

     def save_game(current_game)
       puts "Enter the file's name(of your choice) to save your game:"
       name_file = gets.chomp
        
        unless File.exists?name_file 
             File.open(name_file, "w")do |f|
                YAML.dump(current_game, f) 
           end
         else
             puts "This file already exists"
             save_game(current_game)
        end 
         
     end

     def restore_game(game)
        restored_game = File.open(game){|f|  YAML.load f}
        return restored_game.turn
     end
     def check_word
       if @word_to_display.join == @secret_word
         puts"YOU WIN in #{@count} turns"
       end
     end
   
end
h = Hangman.new
h.play_game