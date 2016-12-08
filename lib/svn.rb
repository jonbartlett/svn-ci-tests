class Svn

  def proplist(item)
    `/usr/bin/svn proplist #{item}`
  end

  def info(item)
    `/usr/bin/svn info #{item}`
  end

end

