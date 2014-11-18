

module MyEnumarable

  def fillter (&block)
  result.initialize
  each { |e| result << e if block.call(e)}
  result
  end

  def map (&block)
  result.initialize
  each { |e| result << block.call(e)}
  result
  end
end

class Collection
  include MyEnumarable

  def initialize (*data)
  @data = data
  end

  def each
    @data.each { |el| yield el }
  end
end