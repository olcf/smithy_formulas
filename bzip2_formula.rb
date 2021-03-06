class Bzip2Formula < Formula
  homepage "http://www.bzip.org/"
  url "http://www.bzip.org/1.0.6/bzip2-1.0.6.tar.gz"
  modules do
    case build_name
    when /gnu/   then ["gcc"]
    when /pgi/   then ["pgi"]
    when /intel/ then ["intel"]
    end
  end

  def install
    module_list
    case build_name
    when /gnu/
      cc = "gcc"
    when /intel/
      cc = "icc"
    when /pgi/
      cc = "pgcc -noswitcherror"
    else
      cc = "gcc"
    end
    system "make CC='#{cc}'"
    system "make install PREFIX=#{prefix}"
  end

  modulefile <<-MODULEFILE.strip_heredoc
    #%Module
    proc ModulesHelp { } {
      puts stderr "<%= @package.name %> <%= @package.version %>"
      puts stderr ""
    }
    module-whatis "<%= @package.name %> <%= @package.version %>"
    set PREFIX <%= @package.prefix %>
    prepend-path PATH      $PREFIX/bin
    prepend-path MANPATH   $PREFIX/share/man
    MODULEFILE
end
