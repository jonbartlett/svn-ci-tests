require 'find'
require 'spec_helper'
require 'nokogiri'
require 'yaml'

RSpec.describe Svn do

  config = $config_file
  svnfile = Svn.new(config)

  source_url = ENV['DIFF_SOURCE_URL']
  source_url = "#{config["diff_check"]["source_url"]}" if source_url.to_s.empty?

  branched_url = ENV['DIFF_BRANCHED_URL']
  branched_url = "#{config["diff_check"]["branched_url"]}" if branched_url.to_s.empty?

  # Test 2: Files that exist in tag but not branch - this should never happen
  diff_doc = svnfile.diff(source_url,branched_url)

  diff_doc.xpath("//diff/paths/path[contains(@kind,'file') and (contains(@item,'added'))]").each do | item|

    describe "svn diff #{item.content}"

    it "#{item.content} is in branched url (tag) but not source url (branch)" do

      expect(false).to equal(true)

    end

  end

  ## Test 3: Files that are different in Tag to Branch
  diff_doc.xpath("//diff/paths/path[contains(@kind,'file') and (contains(@item,'modified'))]").each do | item|

    describe "svn diff #{item.content}"

    it "#{item.content} is different in source url (branch) and branched url (tag)" do

     expect(false).to equal(true), svnfile.pretty_diff(item.content, item.content.gsub(source_url,branched_url))

    end

  end

end
