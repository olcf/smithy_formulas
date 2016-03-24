class PythonNumpyCrayLibsciFormula < Formula
  # Testing numpy:
  # module load python python_nose python_numpy
  # python -c 'import nose, numpy; numpy.test()'

  homepage "http://www.numpy.org/"
  additional_software_roots [ config_value("lustre-software-root")[hostname] ]

  supported_build_names /python.*_gnu.*/

  concern for_version("1.8.0") do
    included do
      url "http://downloads.sourceforge.net/project/numpy/NumPy/1.8.0/numpy-1.8.0.tar.gz"
    end
  end

  concern for_version("1.9.2") do
    included do
      url "http://downloads.sourceforge.net/project/numpy/NumPy/1.9.2/numpy-1.9.2.tar.gz"
    end
  end

  depends_on do
    [ python_module_from_build_name ]
  end

  module_commands do
    pe = "PE-"
    pe = "PrgEnv-" if cray_system?

    commands = [ "unload #{pe}gnu #{pe}pgi #{pe}cray #{pe}intel" ]
    # case build_name
    # when /gnu/
      commands << "load #{pe}gnu"
      commands << "swap gcc gcc/#{$1}" if build_name =~ /gnu([\d\.]+)/
    # when /pgi/
    #   commands << "load #{pe}pgi"
    #   commands << "swap pgi pgi/#{$1}" if build_name =~ /pgi([\d\.]+)/
    # when /intel/
    #   commands << "load #{pe}intel"
    #   commands << "swap intel intel/#{$1}" if build_name =~ /intel([\d\.]+)/
    # when /cray/
    #   commands << "load #{pe}cray"
    #   commands << "swap cce cce/#{$1}" if build_name =~ /cray([\d\.]+)/
    # en

    commands << "load cray-libsci"
    commands << "unload python"
    commands << "load #{python_module_from_build_name}"

    commands
  end

  def install
    module_list

    clibsci_prefix = module_environment_variable("cray-libsci", "CRAY_LIBSCI_PREFIX_DIR")

    FileUtils.mkdir_p "#{prefix}/lib"
    FileUtils.cp "#{clibsci_prefix}/lib/libsci_gnu.a",   "#{prefix}/lib", verbose: true
    FileUtils.cp "#{clibsci_prefix}/lib/libsci_gnu.so",  "#{prefix}/lib", verbose: true

    ENV['CC']  = 'cc'
    ENV['CXX'] = 'CC'
    ENV['OPT'] = '-O3 -funroll-all-loops'

    File.open("site.cfg", "w+") do |f|
      f.write <<-EOF.strip_heredoc
        [blas]
        blas_libs = libsci_gnu
        library_dirs = #{prefix}/lib
        include_dirs = #{clibsci_prefix}/include

        [lapack]
        language = f77
        lapack_libs = libsci_gnu
        library_dirs = #{clibsci_prefix}/lib
        include_dirs = #{clibsci_prefix}/include

        [fftw]
        libraries = fftw3
        library_dirs = /opt/fftw/3.3.0.1/x86_64/lib
        include_dirs = /opt/fftw/3.3.0.1/x86_64/include
      EOF
    end

    system "cat site.cfg"

    system_python "setup.py build"
    system_python "setup.py install --prefix=#{prefix} --compile"
  end

  modulefile do
    <<-MODULEFILE
      #%Module
      proc ModulesHelp { } {
         puts stderr "<%= @package.name %> <%= @package.version %>"
         puts stderr ""
      }
      # One line description
      module-whatis "<%= @package.name %> <%= @package.version %>"

      prereq PrgEnv-gnu PE-gnu
      prereq python
      conflict python_numpy

      <%= python_module_build_list @package, @builds %>
      set PREFIX <%= @package.version_directory %>/$BUILD

      set LUSTREPREFIX #{additional_software_roots.first}/#{arch}/<%= @package.name %>/<%= @package.version %>/$BUILD

      prepend-path LD_LIBRARY_PATH $LUSTREPREFIX/lib
      prepend-path LD_LIBRARY_PATH $LUSTREPREFIX/lib64
      prepend-path PYTHONPATH      $LUSTREPREFIX/lib/$LIBDIR/site-packages
      prepend-path PYTHONPATH      $LUSTREPREFIX/lib64/$LIBDIR/site-packages

      prepend-path PATH            $PREFIX/bin
      prepend-path LD_LIBRARY_PATH $PREFIX/lib
      prepend-path LD_LIBRARY_PATH $PREFIX/lib64
      prepend-path LD_LIBRARY_PATH /opt/gcc/4.8.2/snos/lib64
      prepend-path LD_LIBRARY_PATH /ccs/compilers/gcc/rhel6-x86_64/4.8.2/lib
      prepend-path LD_LIBRARY_PATH /ccs/compilers/gcc/rhel6-x86_64/4.8.2/lib64
      prepend-path MANPATH         $PREFIX/share/man

      prepend-path PYTHONPATH      $PREFIX/lib/$LIBDIR/site-packages
      prepend-path PYTHONPATH      $PREFIX/lib64/$LIBDIR/site-packages
    MODULEFILE
  end
end