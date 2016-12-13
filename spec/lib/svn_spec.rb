require 'find'
require 'spec_helper'
require 'nokogiri'

RSpec.describe Svn do

  svnfile = Svn.new

  # For each file in svn working copy
  Find.find('/var/lib/jenkins/workspace/SVN-CR19321') do |item|

    if !item.include?(".svn") && !item.include?("svn-ci-tests") && File.file?(item)

      describe "svn object #{item}"

        it "#{item} should have svn:keywords properties set (author: #{svnfile.last_changed_author(item)})" do
          expect(svnfile.prop_keywords(item)).to equal(true)
        end

    end

  end

  # Diff branch and tag
  diff_doc = svnfile.diff('svn://djwp07/EDW/branches/development','svn://djwp07/EDW/tags/CR/CR19321')

  # Files that exist in tag but not branch
  diff_doc.xpath("//diff/paths/path[contains(@kind,'file') and (contains(@item,'added'))]").each do | item|

    describe "svn diff #{item.content}"

    it "#{item.content} is in tag but not branch" do
    
      expect(false).to equal(true)

    end

  end

  # Files that are different in Tag to Branch
  diff_doc.xpath("//diff/paths/path[contains(@kind,'file') and (contains(@item,'modified'))]").each do | item|

    describe "svn diff #{item.content}"

    it "#{item.content} is different in tag and branch" do
    
      expect(false).to equal(true)

    end

  end



end
