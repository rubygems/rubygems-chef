require 'spec_helper'

describe 'rubygems-ruby::rubygems' do

  describe command('gem -v') do
    it { should return_stdout(/2\.2\.2/) }
  end

end
