require 'spec_helper'
require 'pry'
require 'csv'
require 'yaml'

RSpec.describe Svn do

  config = $config_file
  svnfile = Svn.new(config)

  monitor_url = ENV['MONITOR_URL']
  monitor_url = "#{config["monitor"]["monitor_url"]}" if monitor_url.to_s.empty?

  write_csv = false
  write_csv = true if config["monitor"]["write_csv"]
  csv_rows = Array.new

  # get current url revision number
  info_doc = svnfile.info(monitor_url)
  current_rev = info_doc.xpath("//info/entry/@revision").text

  # compare current revision with revision on last check - get all changed/new files
  last_run_revision = config["monitor"]["last_run_revision"]
  last_run_revision = 1 if last_run_revision.to_s.empty?
  diff_doc = svnfile.diff("#{monitor_url}@r#{last_run_revision}","#{monitor_url}@HEAD")

  # loop through VC files changed between current and last run revision
  diff_doc.xpath("//diff/paths/path[contains(@kind,'file')]").each do | item|

    describe "svn Monitor #{item.content}"

    if write_csv

      csv_row = Array.new
      csv_row << item.content  # file svn path
      csv_row << item.xpath("@item").text # action (added, modified, etc.)

      csv_rows << csv_row

    end

    it "#{item.content} has been #{item.xpath("@item").text} in svn url #{monitor_url}." do

      # always fail as way of reporting error
      expect(1).to eq(0)

    end

  end

  # write last checked revision number to .config
  config["monitor"]["last_run_revision"] = current_rev

  if File.file?("#{ENV['WORKSPACE']}/.config.yaml")

    File.open("#{ENV['WORKSPACE']}/.config.yaml", "r+") do |f|
      f.write(config.to_yaml)
    end

  else

    File.open(".config.yaml", "r+") do |f|
      f.write(config.to_yaml)
    end

  end

  # write csv output
  if write_csv && !ENV['CI_REPORTS'].to_s.empty? && csv_rows.count > 0

    CSV.open("#{ENV['CI_REPORTS']}/report.csv", "w") do |csv|
      csv << ["Files modified in:", monitor_url]
      csv << ["Object","Action"]

      csv_rows.each { |x|
        csv << [x[0], x[1]]
      }
    end

  end


end

