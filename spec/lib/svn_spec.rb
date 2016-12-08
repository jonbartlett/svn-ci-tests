require 'find'
require 'spec_helper'
require 'nokogiri'

RSpec.describe Svn do

  Find.find('/home/vagrant/svn/EDW/tags/CR/CR19321') do |item|

    describe "svn object #{item}"

      svnfile = Svn.new

      it "#{item} should have svn:keywords properties set (author: #{svnfile.last_changed_author(item)})" do
        expect(svnfile.prop_keywords(item)).to equal(true)
      end

  end

end
