require 'find'
require 'spec_helper'

#  puts %x("echo $PATH")
#
#
RSpec.describe Svn do

  Find.find('/home/vagrant/svn/EDW/tags/CR/CR19321') do |item|

    describe "svn object #{item}"

      it "#{item} should have svn properties set" do

        svnfile = Svn.new
        output = svnfile.proplist(item)
        expect(output.include?('svn:keywords')).to equal(true)

    end

  end

end
