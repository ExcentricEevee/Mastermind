module CodeHandling
  #Randomly generates a secret code, intended for CPU codemaker
  def generate_code
    code = []
    4.times { code << (rand(6)+1).to_s }
    code
  end

  def player_code
    code = []

    until false
      print "Please enter a 4-digit code using numbers 1 to 6:"
      input = gets.chomp
      #needs to NOT work even if just one number matches the case; instead should fail if just one doesn't
      #ugh let's forget it for now and assume the input will be acceptable
      if !(input.match(/[1-6]/))
        puts "Please only use numbers 1 through 6."
      elsif !(input.length == 4)
        puts "Please be sure your code is exactly 4-digits long."
      else
        code = input.split("")
        return code
      end
    end
  end

  #how well does the guess stack up to the secret code?
  def compare_codes(guess)
    #make a reference that won't destroy the original secret code
    secret = secret_code.clone

    exact = check_exact(guess, secret)
    if exact == 4
      #tell the caller we have a winner
      return true
    else
      partial = check_partial(guess, secret)
      puts "Correct value and position: #{exact}\nCorrect value, wrong position: #{partial}\n\n"
      return false
    end
  end

  def check_exact(guess, secret)
    exact = 0
    guess.each_with_index do |value, idx|
      if value == secret[idx]
        #value and position are both correct
        exact += 1
        #put correct answer into CPU's final guess. 
        #Please note that using 'cpu_final' here causes this file to depend on Mastermind
        cpu_final[idx] = value
        #don't double count a value
        secret[idx] = nil
      end
    end

    exact
  end

  def check_partial(guess, secret)
    partial = 0
    guess.each_with_index do |value, idx|
      unless value == nil
        if secret.include?(value)
          #value is correct but in wrong position
          partial += 1
          index = secret.find_index(value)
          secret[index] = nil
        end
      end
    end

    partial
  end

end
