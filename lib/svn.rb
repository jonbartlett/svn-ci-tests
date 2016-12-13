require 'nokogiri'
require 'yaml'

class Svn

  def initialize

   @config = YAML.load_file('.config.yaml')

  end

  def prop_keywords(item)

    doc = Nokogiri::XML(`#{@config["svn"]["executable_path"]} --username #{@config["svn"]["user"]} --password #{@config["svn"]["password"]} --xml proplist #{item}`)

    if doc.xpath("//property[contains(@name,'svn:keywords')]").count > 0
      true
    else
      false
    end

  end

  def proplist(item)

    Nokogiri::XML(`#{@config["svn"]["executable_path"]} --username #{@config["svn"]["user"]} --password #{@config["svn"]["password"]} --xml proplist #{item}`)

  end

  def info(item)

    `/usr/bin/svn info #{item}`

  end

  def last_changed_author(item)

    doc = Nokogiri::XML(`#{@config["svn"]["executable_path"]} --username #{@config["svn"]["user"]} --password #{@config["svn"]["password"]} --xml info #{item}`)
    doc.xpath("//author").text

  end

  def info(item)

    `/usr/bin/svn info #{item}`

  end

  def diff(branch, tag)

    Nokogiri::XML(`#{@config["svn"]["executable_path"]} diff --username #{@config["svn"]["user"]} --password #{@config["svn"]["password"]} --xml --summarize --new=#{tag}@HEAD --old=#{branch}@HEAD`)

  end

end

