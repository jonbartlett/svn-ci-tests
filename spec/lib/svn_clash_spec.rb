require 'find'
require 'spec_helper'
require 'nokogiri'
require 'yaml'
require 'pry'

RSpec.describe Svn do


  config = $config_file
  svnfile = Svn.new(config)


  project_url = ENV['CLASH_PROJECT_URL']
  project_url = "#{config["clash_check"]["project_url"]}" if project_url.to_s.empty?

  non_project_url = ENV['CLASH_NON_PROJECT_URL']
  non_project_url = "#{config["clash_check"]["non_project_url"]}" if non_project_url.to_s.empty?

  # get current non-project url revision number
  info_doc = svnfile.info("#{non_project_url}")
  current_rev = info_doc.xpath("//info/entry/@revision").text

  # compare current revision with revision on last check - get all changed/new files
  last_run_revision = config["clash_check"]["last_run_revision"]
  last_run_revision = 1 if last_run_revision.to_s.empty?
  diff_doc = svnfile.diff("#{non_project_url}@r#{last_run_revision}","#{non_project_url}@HEAD")

  # fetch contents of Project branch
  project_doc = svnfile.list("#{project_url}")

  # loop through VC files changed between current and last run revision
  diff_doc.xpath("//diff/paths/path[contains(@kind,'file')]").each do | item|

    item_file = item.content.gsub("#{non_project_url}/",'')

    # if file exists in Project branch, raise a test failure for notification in Jenkins
    describe "svn Clash Check #{item.content}"

    it "#{item.content} has been modifed in branch #{non_project_url} and is present in branch #{project_url}" do

      expect(project_doc.xpath("//lists/list/entry[contains(name,'#{item_file}')]").count).to eq(0)

    end

  end

  # write last checked revision number to .config
  config["clash_check"]["last_run_revision"] = current_rev

  if File.file?("#{ENV['WORKSPACE']}/.config.yaml")

    File.open("#{ENV['WORKSPACE']}/.config.yaml", "r+") do |f|
      f.write(config.to_yaml)
    end

  else

    File.open(".config.yaml", "r+") do |f|
      f.write(config.to_yaml)
    end

  end


end
