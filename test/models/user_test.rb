require 'test_helper'

class UserTest < ActiveSupport::TestCase

def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
  end
  
  test "should be valid" do
    assert @user.valid?
  end
  
  test "name should be present" do
    @user.name = " "
    assert_not @user.valid?
  end
  
    test "email should be present" do
    @user.email = " "
    assert_not @user.valid?
  end
  
  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end
  
    test "email should not be too long" do
    @user.email = "a" * 245 + "example.net"
    assert_not @user.valid?
  end 
  
  test "email validations should accept valid emails" do
    valid_emails = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                      first.last@foo.jp alice+bob@bax.cn]
    valid_emails.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end
  
  test "invalid emails should be invalid" do
    invalid_emails = %w[user@example,com user_at_foo.org user.name@example.
                        foo@bar_baz.com foo@bar+baz.com user@foobar..com]
    invalid_emails.each do |invalid_email|
      @user.email = invalid_email
      assert_not @user.valid?, "#{invalid_email.inspect} should not be valid"
    end
  end
  
  test "emails should be unique" do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
    
    duplicate_user.email = @user.email.upcase
    assert_not duplicate_user.valid?
  end
  
  test "emails should be saved lowercase" do
    custom_email = "FooOo0@BaaR.COm"
    @user.email = custom_email
    @user.save
    assert_equal @user.reload.email, custom_email.downcase
  end
  
  test "password should be nonblank" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end
  
  test "password have a min length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

end
