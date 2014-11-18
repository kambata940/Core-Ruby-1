class Vector2D
  attr_accessor :x, :y

  def initialize(x, y)
    @x, @y = x, y
  end

  def +(other)
    other = Vector2D.new(other,other) if other.is_a? Numeric 
    Vector2D.new(@x + other.x, @y + other.y)
  end

  def -(other)
    other = Vector2D.new(other,other) if other.is_a? Numeric
    Vector2D.new(@x - other.x, @y - other.y)
  end

  def *(number)
    Vector2D.new(@x * number, @y * number) if number.is_a? Numeric
  end


  def /(number)
    Vector2D.new(@x / number, @y / number) if number.is_a? Numeric
  end

  def self.e
    Vector2D.new(1, 0)
  end

  def self.s
    Vector2D.new(0, 1)
  end

  def +@
    Vector2D.new(@x, @y)
  end

  def -@
    Vector2D.new(-@x, -@y)
  end
end

class Vector
  
  def initialize(*x)
    @n = x.length
    @x = x
  end
end




end