#Using numbers 1 to 6 for the code for now, for the sake of simplicity during development
#Bonus) serialization?

require 'pry'
require_relative 'code_handling'

class Mastermind
  include CodeHandling
  attr_accessor :secret_code, :cpu_final
  #@@COLOR_LIST = ['red', 'green', 'blue', 'purple', 'yellow', 'dusky']

  def initialize
    @secret_code = generate_code
    @cpu_final = Array.new(4)
  end

  def intro
    puts "Welcome to Mastermind!\n\nThis is a game about guessing the secret, 4-digit code, using numbers 1 to 6."
    puts "You will get feedback on your guesses. You have up to 12 guesses to get it right.\n\n"
    puts "Would you like to be the codebreaker, or the codemaker?"

    acceptable = false
    until acceptable
      input = gets.chomp
      if input.downcase == "codebreaker" || input.downcase == "breaker"
        acceptable = true
        puts "Very well! Now generating a random code for you to solve... Good luck!\n[Enter]"
        gets
        player_main
      elsif input.downcase == "codemaker" || input.downcase == "maker"
        acceptable = true
        puts "In that case, I'll need you to provide a code for me to solve!"
        self.secret_code = player_code
        puts "[Debug] Your code is: #{secret_code}"
        puts "All set? Then it's time for me to start guessing! [Enter]"
        gets
        cpu_main
      else
        puts "Please type either '(code)breaker' or '(code)maker'"
      end
    end
  end

  def player_main
    turn_count = 1
    while turn_count <= 12 do
      puts "[Turn #{turn_count}]"
      #run a #turn that will return whether or not the guess is a win
      winner = turn

      if winner
        puts "Congrats, you guessed the code!"
        break
      elsif turn_count >= 12
        puts "You're out of guesses! Would you like to play again with a new code?"
        input = gets.chomp
        if input.downcase == "yes" || input.downcase == "y"
          secret_code = generate_code
          main
        end
      end
      turn_count += 1
    end
  end

  #for use when player is codebreaker
  #doesn't check for only numbers; inputting letters will just make for a wrong guess
  def turn
    acceptable = false
    until acceptable
      print "Make a guess: "
      input = gets.chomp.split("")

      if input.length == 4
        acceptable = true
      else
        puts "The secret code is four digits long; your guess should be, too!"
      end
    end
    compare_codes(input)
  end

  #for use when computer is codebreaker
  def cpu_main
    turn_count = 1
    while turn_count <= 12 do
      #generate a random guess, then replace any values that were established as correct from previous guesses
      guess = generate_code
      cpu_final.each_with_index do |value, idx|
        unless value == nil
          guess[idx] = value
        end
      end

      puts "[Turn #{turn_count}]\nMy guess is... #{guess}!"
      winner = compare_codes(guess)
      gets
      if winner
        puts "I did it, I solved the code! You were fun to play with, want to go again?"
        input = gets.chomp
        if input.downcase == "yes" || input.downcase == "y"
          self.secret_code = player_code
          self.cpu_final = Array.new(4)
          cpu_main
        end
        break
      elsif turn_count >= 12
        puts "You got me! I couldn't solve the code in time. Did you want to play again?"
        input = gets.chomp
        if input.downcase == "yes" || input.downcase == "y"
          self.secret_code = player_code
          self.cpu_final = Array.new(4)
          cpu_main
        end
      end
      turn_count += 1
    end
  end

end

game = Mastermind.new
puts "[Debug] Secret code is: #{game.secret_code}"
game.intro
