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

  depends_on do
    [ python_module_from_build_name, "cblas/20110120/*acml*" ]
    # case build_name
    # when /gnu/
    # when /pgi/
    #   commands << "load #{pe}pgi"
    #   commands << "swap pgi pgi/#{$1}" if build_name =~ /pgi([\d\.]+)/
    # when /intel/
    #   commands << "load #{pe}intel"
    #   commands << "swap intel intel/#{$1}" if build_name =~ /intel([\d\.]+)/
    # when /cray/
    #   commands << "load #{pe}cray"
    #   commands << "swap cce cce/#{$1}" if build_name =~ /cray([\d\.]+)/
    # end
    commands << "load #{python_module_from_build_name}"
    acml_prefix = module_environment_variable("acml", "ACML_BASE_DIR")

    File.open("site.cfg", "w+") do |f|
      f.write <<-EOF.strip_heredoc
        [blas]
        blas_libs = cblas, acml
        library_dirs = #{prefix}/lib
        include_dirs = #{cblas.prefix}/include

        [lapack]
        language = f77
        lapack_libs = acml
        library_dirs = #{acml_prefix}/lib
        include_dirs = #{acml_prefix}/include

        [fftw]
        libraries = fftw3
        library_dirs = /opt/fftw/3.3.0.1/x86_64/lib
        include_dirs = /opt/fftw/3.3.0.1/x86_64/include
      EOF
    system "cat site.cfg"
    system_python "setup.py build"
    system_python "setup.py install --prefix=#{prefix} --compile"
    <%= python_module_build_list @package, @builds %>
    set LUSTREPREFIX /lustre/atlas/sw/xk7/<%= @package.name %>/<%= @package.version %>/$BUILD

    prepend-path PYTHONPATH      $LUSTREPREFIX/lib/$LIBDIR/site-packages
    prepend-path PYTHONPATH      $LUSTREPREFIX/lib64/$LIBDIR/site-packages

    prepend-path LD_LIBRARY_PATH /opt/gcc/4.8.2/snos/lib64
    prepend-path LD_LIBRARY_PATH /ccs/compilers/gcc/rhel6-x86_64/4.8.2/lib
    prepend-path LD_LIBRARY_PATH /ccs/compilers/gcc/rhel6-x86_64/4.8.2/lib64
