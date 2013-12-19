class A < B; def self.create(object = User) object end end
class Zebra; def inspect; "X#{2 + self.object_id}" end end

module ABC::DEF # ::mod-abc::
  include Comparable

  # ::def-foo::
  # @param test
  # @return [String] nothing
  def foo(test)
    Thread.new do |blockvar|
      ABC::DEF.reverse(:a_symbol, :'a symbol', :<=>, 'test' + ?\012)
      answer = valid?4 && valid?CONST && ?A && ?A.ord
    end.join
  end
  # ::end-def-foo::

  def [](index) self[index] end
  def ==(other) other == self end
end # ::end-mod-abc::