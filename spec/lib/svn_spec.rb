require 'find'
require 'spec_helper'
require 'nokogiri'

RSpec.describe Svn do

  Find.find('/var/lib/jenkins/workspace/svn') do |item|

    if !item.include?(".svn")

      describe "svn object #{item}"

        svnfile = Svn.new

        it "#{item} should have svn:keywords properties set (author: #{svnfile.last_changed_author(item)})" do
          expect(svnfile.prop_keywords(item)).to equal(true)
        end

    end

  end

end
