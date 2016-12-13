require 'nokogiri'

class Svn

  def prop_keywords(item)

    doc = Nokogiri::XML(`/usr/bin/svn --xml proplist #{item}`)

    if doc.xpath("//property[contains(@name,'svn:keywords')]").count > 0
      true
    else
      false
    end

  end

  def proplist(item)
    Nokogiri::XML(`/usr/bin/svn --xml proplist #{item}`)
  end

  def info(item)
    `/usr/bin/svn info #{item}`
  end

  def last_changed_author(item)

    doc = Nokogiri::XML(`/usr/bin/svn --xml info #{item}`)
    doc.xpath("//author").text

  end

  def info(item)
    `/usr/bin/svn info #{item}`
  end

  def diff(branch, tag)

    Nokogiri::XML(`/usr/bin/svn diff --xml --summarize --new=#{tag}@HEAD --old=#{branch}@HEAD`)

  end

end

