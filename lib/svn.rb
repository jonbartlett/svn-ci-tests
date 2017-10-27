require 'nokogiri'
require 'yaml'

class Svn

  def initialize(config_file)

   @config = config_file

  end

  def prop_keywords(item)

    doc = Nokogiri::XML(`#{@config["svn"]["executable_path"]} --username #{@config["svn"]["user"]} --password #{@config["svn"]["password"]} --xml proplist #{item}`)

    !doc.xpath("//property[contains(@name,'svn:keywords')]").count.zero?

  end

  def proplist(item)

    Nokogiri::XML(`#{@config["svn"]["executable_path"]} --username #{@config["svn"]["user"]} --password #{@config["svn"]["password"]} --xml proplist #{item}`)

  end

  def info(item)

    Nokogiri::XML(`#{@config["svn"]["executable_path"]} --xml --username #{@config["svn"]["user"]} --password #{@config["svn"]["password"]} info #{item}`)

  end

  def last_changed_author(item)

    Nokogiri::XML(`#{@config["svn"]["executable_path"]} --username #{@config["svn"]["user"]} --password #{@config["svn"]["password"]} --xml info #{item}`).xpath("//author").text

  end

  def diff(old, new)

    Nokogiri::XML(`#{@config["svn"]["executable_path"]} diff --username #{@config["svn"]["user"]} --password #{@config["svn"]["password"]} --xml --summarize --new=#{new} --old=#{old}`)

  end

  def pretty_diff(branch_file, tag_file)

    `#{@config["svn"]["executable_path"]} diff --username #{@config["svn"]["user"]} --password #{@config["svn"]["password"]} --new=#{tag_file}@HEAD --old=#{branch_file}@HEAD`

  end

  def list(path)

    Nokogiri::XML(`#{@config["svn"]["executable_path"]} list --xml -R --username #{@config["svn"]["user"]} --password #{@config["svn"]["password"]} #{path}`)

  end

end
