require 'spec_helper'

describe "Signup" do

  describe "Signup page" do
    it "should have the content 'Attract new online traffic'" do
      visit signup_path
      page.should have_content('Attract new online traffic')
    end
  end

end
