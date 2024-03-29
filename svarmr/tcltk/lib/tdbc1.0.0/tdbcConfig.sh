# tdbcConfig.sh --
#
# This shell script (for sh) is generated automatically by TDBC's configure
# script. It will create shell variables for most of the configuration options
# discovered by the configure script. This script is intended to be included
# by the configure scripts for TDBC extensions so that they don't have to
# figure this all out for themselves.
#
# The information in this file is specific to a single platform.
#
# RCS: @(#) $Id$

# TDBC's version number
tdbc_VERSION=1.0.0
TDBC_VERSION=1.0.0

# Name of the TDBC library - may be either a static or shared library
tdbc_LIB_FILE=tdbc100.dll
TDBC_LIB_FILE=tdbc100.dll

# String to pass to the linker to pick up the TDBC library from its build dir
tdbc_BUIID_LIB_SPEC="-L/d/CM.git/tcltk86/release/lib/tdbc1.0.0 -ltdbc100"
TDBC_BUILD_LIB_SPEC="-L/d/CM.git/tcltk86/release/lib/tdbc1.0.0 -ltdbc100"

# String to pass to the linker to pick up the TDBC library from its installed
# dir.
tdbc_LIB_SPEC="-L/d/CM.git/tcltk86/release/lib/tdbc1.0.0 -ltdbc100"
TDBC_LIB_SPEC="-L/d/CM.git/tcltk86/release/lib/tdbc1.0.0 -ltdbc100"

# Name of the TBDC stub library
tdbc_STUB_LIB_FILE="libtdbcstub100.a"
TDBC_STUB_LIB_FILE="libtdbcstub100.a"

# String to pass to the linker to pick up the TDBC stub library from its
# build directory
tdbc_BUILD_STUB_LIB_SPEC="-L/d/CM.git/tcltk86/rcompile/tdbc -ltdbcstub100"
TDBC_BUILD_STUB_LIB_SPEC="-L/d/CM.git/tcltk86/rcompile/tdbc -ltdbcstub100"

# String to pass to the linker to pick up the TDBC stub library from its
# installed directory
tdbc_STUB_LIB_SPEC="-L/d/CM.git/tcltk86/release/lib/tdbc1.0.0 -ltdbcstub100"
TDBC_STUB_LIB_SPEC="-L/d/CM.git/tcltk86/release/lib/tdbc1.0.0 -ltdbcstub100"

# Path name of the TDBC stub library in its build directory
tdbc_BUILD_STUB_LIB_PATH="/d/CM.git/tcltk86/rcompile/tdbc/libtdbcstub100.a"
TDBC_BUILD_STUB_LIB_PATH="/d/CM.git/tcltk86/rcompile/tdbc/libtdbcstub100.a"

# Path name of the TDBC stub library in its installed directory
tdbc_STUB_LIB_PATH="/d/CM.git/tcltk86/release/lib/tdbc1.0.0/libtdbcstub100.a"
TDBC_STUB_LIB_PATH="/d/CM.git/tcltk86/release/lib/tdbc1.0.0/libtdbcstub100.a"

# Location of the top-level source directories from which TDBC was built.
# This is the directory that contains doc/, generic/ and so on.  If TDBC
# was compiled in a directory other than the source directory, this still
# points to the location of the sources, not the location where TDBC was
# compiled.
tdbc_SRC_DIR="/d/CM.git/tcltk86/rcompile/tdbc"
TDBC_SRC_DIR="/d/CM.git/tcltk86/rcompile/tdbc"

# String to pass to the compiler so that an extension can find installed TDBC
# headers
tdbc_INCLUDE_SPEC="-I/d/CM.git/tcltk86/release/include"
TDBC_INCLUDE_SPEC="-I/d/CM.git/tcltk86/release/include"

# String to pass to the compiler so that an extension can find TDBC headers
# in the source directory
tdbc_BUILD_INCLUDE_SPEC="-I/d/CM.git/tcltk86/rcompile/tdbc/generic"
TDBC_BUILD_INCLUDE_SPEC="-I/d/CM.git/tcltk86/rcompile/tdbc/generic"

# Path name where .tcl files in the tdbc package appear at run time.
tdbc_LIBRARY_PATH="${exec_prefix}/lib/tdbc1.0.0"
TDBC_LIBRARY_PATH="${exec_prefix}/lib/tdbc1.0.0"

# Path name where .tcl files in the tdbc package appear at build time.
tdbc_BUILD_LIBRARY_PATH="/d/CM.git/tcltk86/rcompile/tdbc/library"
TDBC_BUILD_LIBRARY_PATH="/d/CM.git/tcltk86/rcompile/tdbc/library"

# Additional flags that must be passed to the C compiler to use tdbc
tdbc_CFLAGS=
TDBC_CFLAGS=

