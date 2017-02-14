require 'nokogiri'
require 'yaml'

class Svn

  def initialize

   @config = YAML.load_file('.config.yaml')

  end

  def prop_keywords(item)

    doc = Nokogiri::XML(`#{@config["svn"]["executable_path"]} --username #{@config["svn"]["user"]} --password #{@config["svn"]["password"]} --xml proplist #{item}`)

    !doc.xpath("//property[contains(@name,'svn:keywords')]").count.zero?

  end

  def proplist(item)

    Nokogiri::XML(`#{@config["svn"]["executable_path"]} --username #{@config["svn"]["user"]} --password #{@config["svn"]["password"]} --xml proplist #{item}`)

  end

  def info(item)

    `#{@config["svn"]["executable_path"]} info #{item}`

  end

  def last_changed_author(item)

    Nokogiri::XML(`#{@config["svn"]["executable_path"]} --username #{@config["svn"]["user"]} --password #{@config["svn"]["password"]} --xml info #{item}`).xpath("//author").text

  end

  def diff(branch, tag)

    Nokogiri::XML(`#{@config["svn"]["executable_path"]} diff --username #{@config["svn"]["user"]} --password #{@config["svn"]["password"]} --xml --summarize --new=#{tag}@HEAD --old=#{branch}@HEAD`)

  end

  def pretty_diff(branch_file, tag_file)

    `#{@config["svn"]["executable_path"]} diff --username #{@config["svn"]["user"]} --password #{@config["svn"]["password"]} --new=#{tag_file}@HEAD --old=#{branch_file}@HEAD`

  end

end

