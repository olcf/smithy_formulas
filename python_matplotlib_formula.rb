      [ "python/3.3.0", "python_numpy/1.7.1/*python3.3.0*acml5.2.0*" ]
      [ "python/2.7.3", "python_numpy/1.7.1/*python2.7.3*acml5.2.0*", "python_pygtk/*/*python2.7.3*", "python_pygobject/*/*python2.7.3*", "python_pycairo/*/*python2.7.3*"]
      [ "python_numpy/1.7.1/*python2.6.8*acml5.2.0*" ]
      [ "python/2.7.3", "python_numpy/1.7.1", "python_pygtk", "python_pygobject", "python_pycairo" ]
    patch <<-EOF.strip_heredoc
    diff --git a/setup.cfg b/setup.cfg
    new file mode 100644
    index 0000000..075c758
    --- /dev/null
    +++ b/setup.cfg
    @@ -0,0 +1,78 @@
    +#Rename this file to setup.cfg to modify matplotlib's
    +# build options.
    +
    +[egg_info]
    +
    +[directories]
    +# Uncomment to override the default basedir in setupext.py.
    +# This can be a single directory or a comma-delimited list of directories.
    +#basedirlist = /usr
    +
    +[status]
    +# To suppress display of the dependencies and their versions
    +# at the top of the build log, uncomment the following line:
    +#suppress = False
    +
    +[packages]
    +# There are a number of subpackages of matplotlib that are considered
    +# optional.  They are all installed by default, but they may be turned
    +# off here.
    +#
    +#tests = True
    +#sample_data = True
    +#toolkits = True
    +
    +[gui_support]
    +# Matplotlib supports multiple GUI toolkits, including Cocoa,
    +# GTK, Fltk, MacOSX, Qt, Qt4, Tk, and WX. Support for many of
    +# these toolkits requires AGG, the Anti-Grain Geometry library,
    +# which is provided by matplotlib and built by default.
    +#
    +# Some backends are written in pure Python, and others require
    +# extension code to be compiled. By default, matplotlib checks for
    +# these GUI toolkits during installation and, if present, compiles the
    +# required extensions to support the toolkit.
    +#
    +# - GTK 2.x support of any kind requires the GTK runtime environment
    +#   headers and PyGTK.
    +# - Tk support requires Tk development headers and Tkinter.
    +# - Mac OSX backend requires the Cocoa headers included with XCode.
    +# - Windowing is MS-Windows specific, and requires the "windows.h"
    +#   header.
    +#
    +# The other GUI toolkits do not require any extension code, and can be
    +# used as long as the libraries are installed on your system --
    +# therefore they are installed unconditionally.
    +#
    +# You can uncomment any the following lines to change this
    +# behavior. Acceptible values are:
    +#
    +#     True: build the extension. Exits with a warning if the
    +#           required dependencies are not available
    +#     False: do not build the extension
    +#     auto: build if the required dependencies are available,
    +#           otherwise skip silently. This is the default
    +#           behavior
    +#
    +gtk = True
    +#gtkagg = auto
    +#tkagg = auto
    +#macosx = auto
    +#windowing = auto
    +#gtk3cairo = auto
    +#gtk3agg = auto
    +
    +[rc_options]
    +# User-configurable options
    +#
    +# Default backend, one of: Agg, Cairo, CocoaAgg, GTK, GTKAgg, GTKCairo,
    +# FltkAgg, MacOSX, Pdf, Ps, QtAgg, Qt4Agg, SVG, TkAgg, WX, WXAgg.
    +#
    +# The Agg, Ps, Pdf and SVG backends do not require external
    +# dependencies. Do not choose GTK, GTKAgg, GTKCairo, MacOSX, or TkAgg
    +# if you have disabled the relevent extension modules.  Agg will be used
    +# by default.
    +#
    +#backend = Agg
    +#
    +
    EOF

    module load python_pygtk python_pygobject python_pycairo python_numpy
    prereq python_pygtk python_pygobject python_pycairo python_numpy

      set BUILD python3.3.0_numpy1.7.1
      set BUILD python2.7.3_numpy1.7.1
      set BUILD python2.6.8_numpy1.7.1