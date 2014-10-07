def histogram(string)
  # Your code goes here.
  numbers = {}
  string.each_char do | letter |
    if numbers.key?(letter)
      numbers[letter] += 1
    else
      numbers[letter] = 1
    end
  end
  numbers
end

def prime?(n)
  return false if n == 1
  i = 2
  while i < Math.sqrt(n).to_i + 1
    return false if n % i == 0
    i += 1
  end
  true
end

def ordinal(n)
  case
  when n % 100 / 10 == 1 then return "#{n}th"
  when n % 10 == 1 then return "#{n}st"
  when n % 10 == 2 then return "#{n}nd"
  when n % 10 == 3 then return "#{n}rd"
  else return "#{n}th"
  end
end

def palindrome?(object)
  str = object.to_s
  str.downcase
  str.gsub("/[\s]/", "")
end

