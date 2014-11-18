class Hash
  def pick(*keys)
    dup.pick!
  end

  def pick!(*keys)
    select! { |key| keys.include? (key)  }
  end

  def except(*keys)
  select { |key| !keys.include? (key)  }
  end

  def except!(*keys)
  select! { |key| !keys.include? (key)  }
  end

  def compact_values
  reject {|key,value| value == nil or value == false}
  end

  def compact_values!
  reject! {|key,value| value == nil or value == false}
  end

  def defaults(hash)
  merge(hash) {|key, v1, v2| v1}
  end

  def defaults!(hash)
  merge!(hash) {|key, v1, v2| v1}
  end
end