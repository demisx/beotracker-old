require 'spec_helper'

describe User do
  it "is invalid without email" do
    user = build(:user, email: nil)
    expect(user).to have(1).errors_on(:email)
  end

  it "is invalid with duplicate email" do
    create(:user, email: "dmoore@colddata.com")
    user = build(:user, email: "dmoore@colddata.com")
    expect(user).to have(1).errors_on(:email)
  end

  it "is invalid without password" do 
    user = build(:user, password: nil)
    expect(user).to have(1).errors_on(:password)
  end

  it "is invalid with password less than 6 chars" do 
    user = build(:user, password: "12345")
    expect(user).to have(1).errors_on(:password)
  end
end
