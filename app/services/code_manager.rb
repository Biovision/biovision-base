class CodeManager
  attr_accessor :user, :code

  # @param [Symbol|String] slug
  def self.handler(slug)
    class_name = "#{self.class}::#{slug.split('_').map(&:capitalize).join}"
    Object.const_get(class_name)
  end

  # @param [Code] code
  # @param [User] user
  def initialize(code, user = nil)
    @code = code
    @user = user
  end
end