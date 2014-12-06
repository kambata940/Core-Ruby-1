require 'minitest/autorun'

require_relative 'solution'

class SolutionTest < MiniTest::Unit::TestCase
  class Try
    private_attr_accessor :a, :b
    protected_attr_accessor :c, :d
    cattr_accessor(:clas, :empty){"NO"}
    @@clas = 42
    
    def initialize()
      @a, @b, @c, @d = 1, 2, 3, 4
    end

    def try_pirvate
      a = 10
      "#{a} #{b}"
    end

    def try_protected
      self.c = 10
      "#{c} #{d}"
    end

  end

  class A
  end

  def test_singleton_class
    test1 = A.define_singleton_class
    assert_equal(A.singleton_class, test1)
  end

  def test_def_singleton_method
    A.define_singleton_method(:shoot) do |a, b|
      "#{a} #{b}"
    end
    assert_equal(A.shoot("one", "gun"), "one gun")
  end

  def test_to_proc
    test1 = [2, 3, 4, 5].map(&'succ.succ')
    proc = "upcase.downcase.upcase.to_sym".to_proc
    test2 = proc.call("yes")
    assert_equal(:YES, test2)
    assert_equal([4, 5, 6, 7], test1)
  end

  def test_private
    assert_equal("10 2", Try.new.try_pirvate)
  end

  def test_protected
    assert_equal(Try.new.try_protected, "10 4")
  end

  def test_class_vars
    assert_equal(Try.clas, 42)
    assert_equal(Try.empty, "NO")
    Try.empty = 43
    assert_equal(Try.empty, 43)
  end

  def test_NilPatch
    assert_equal(nil.succ.dfgdfg.dfgdfg, nil)
    assert_equal(nil.respond_to?(:aaaa), true)
  end

  def base_proxy
    proxy = Proxy.new [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
  end

  def class_proxy
    Proxy
  end

  def test_proxy_call_method_static
    proxy = base_proxy
    assert_equal(1, proxy[0])
  end

  def test_proxy_repond_to
    proxy = base_proxy
    assert_equal(true, proxy.respond_to?(:to_h))
    assert_equal(false, proxy.respond_to?(:afdssdd))
  end

  User = Struct.new(:first_name, :last_name)

  class Invoce
    
    delegate(:fist_name, to: '@user')
    delegate(:last_name, to: '@user')

    def initialize(user)
      @user = user
    end

  end

  def test_delegate
    user = User.new 'Genadi', 'Samokovarov'
    invoice = Invoce.new(user)
    assert_equal('Genadi', invoice.fist_name)
    assert_equal('Samokovarov', invoice.last_name)
  end
end
