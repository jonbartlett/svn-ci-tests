require 'find'
require 'spec_helper'
require 'nokogiri'
require 'yaml'
require 'pry'

RSpec.describe Svn do

  svnfile = Svn.new
  config = YAML.load_file('.config.yaml')

  # For each file in svn working copy check keywords - perhaps change this to look at remote repo?
  Find.find(ENV['WORKSPACE']) do |item|
# binding.pry

    if !item.include?(".svn") &&
       !item.include?("svn-ci-tests") &&
       File.file?(item) &&
       config["svn"]["keywords_files"].any? { |word| item.include?(word) }

      describe "svn object #{item}"

      it "#{item} should have svn:keywords properties set (author: #{svnfile.last_changed_author(item)})" do
          expect(svnfile.prop_keywords(item)).to equal(true)
      end

    end

  end

  # Files that exist in tag but not branch
  diff_doc = svnfile.diff("#{config["svn"]["branch_url"]}","#{ENV['SVN_URL']}")

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
