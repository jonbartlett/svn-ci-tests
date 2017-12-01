require 'find'
require 'spec_helper'
require 'nokogiri'
require 'yaml'

RSpec.describe Svn do

  config = $config_file
  svnfile = Svn.new(config)

  # If configured to run checks directly on SVN repo - this can be slow
  if config["keyword_check"]["run_remote"] = 'true'

    # Use Env Var "SVN_URL" if defined else use config from '.config'
    #  SVN_URL env var will be defined if running from Jenkins
    svn_path = ENV['KEYWORD_URL']
    svn_path = "#{config["keyword_check"]["svn_url"]}" if svn_path.to_s.empty?

    tag_doc = svnfile.list(svn_path)

    tag_doc.xpath("//lists/list/entry[contains(@kind,'file')]/name").each do | item|

      if config["keyword_check"]["files"].any? { |word| item.text.include?(word) }

        describe "svn object #{item.text}"

        it "#{item.text} should have svn:keywords properties set" do
          expect(svnfile.prop_keywords("#{svn_path}/#{item.text}")).to equal(true)
        end

      end

    end

  else

    # check files in local svn working copy (as with Jenkins)
    Find.find(ENV['WORKSPACE']) do |item|

      if !item.include?(".svn") &&
         !item.include?("svn-ci-tests") &&
         File.file?(item) &&
         config["keyword_check"]["files"].any? { |word| item.include?(word) }

        describe "svn object #{item}"

        it "#{item} should have svn:keywords properties set (author: #{svnfile.last_changed_author(item)})" do
            expect(svnfile.prop_keywords(item)).to equal(true)
        end

      end

    end

  end

end
