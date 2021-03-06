# ----------------------------------------------------------------
# Locate header files for the C++ linear algebra library Eigen.
# Eigen is a header-only template library. By default we check for the
# Eigen files in the --with-eigen-include=xxx argument provided to
# configure, or if those don't exist in the $EIGEN_INC/Eigen directory,
# or in /usr/include.  
dnl
# Note: Eigen is installed (by default) at the location
# /path/to/eigen/Eigen, i.e. with path ending in capital 'Eigen'.
# You should specify --with-eigen-include=/path/to/eigen
# during configure, or set your $EIGEN_INC environment variable
# to /path/to/eigen.
# ----------------------------------------------------------------

AC_DEFUN([CONFIGURE_EIGEN], 
[
  AC_ARG_ENABLE(eigen,
                AC_HELP_STRING([--enable-eigen],
                               [build with Eigen linear algebra support]),
		[case "${enableval}" in
		  yes)  enableeigen=yes ;;
		   no)  enableeigen=no ;;
 		    *)  AC_MSG_ERROR(bad value ${enableval} for --enable-eigen) ;;
		 esac],
		 [enableeigen=$enableoptional])


  if (test $enableeigen = yes); then
  
    # User-specific include path
    AC_ARG_WITH(eigen-include,
                AC_HELP_STRING([--with-eigen-include=PATH],[Specify the path for EIGEN header files]),
                witheigeninc=$withval,
                witheigeninc=no)
  
    # Fall back on default paths to Eigen's include files
    if (test $witheigeninc != no); then
      EIGEN_INC="$witheigeninc"

    elif test "x$EIGEN_INC" != x -a -f $EIGEN_INC/Eigen/Eigen; then
      echo "Environment EIGEN_INC=$EIGEN_INC"

    elif test "x$EIGEN3_INCLUDE" != x -a -f $EIGEN3_INCLUDE/Eigen/Eigen; then
      EIGEN_INC=$EIGEN3_INCLUDE
      echo "Environment EIGEN_INC=$EIGEN_INC"
      

    elif test -f /usr/include/eigen3/Eigen/Eigen ; then
      EIGEN_INC="/usr/include/eigen3"

    else
      EIGEN_INC="/usr/include"
    fi
  
    # Initialize Makefile/config.h substitution variables
    EIGEN_INCLUDE=""
  
    # Properly let the substitution variables
    if (test $enableeigen = yes); then
    
       # Check for existence of a header file in the specified location.  Note: here
       # we are checking for the header file "Eigen" in the Eigen directory.
       eigenincFound=no;
       AC_CHECK_HEADERS($EIGEN_INC/Eigen/Eigen, eigenincFound=yes)
  
       if (test x$eigenincFound = xno); then
         AC_MSG_RESULT(Eigen header files not found!)
         enableeigen=no;
       fi
  
       # If the Eigen headers were found, continue.
       if (test x$enableeigen = xyes); then
         EIGEN_INCLUDE="-I$EIGEN_INC"
         AC_DEFINE(HAVE_EIGEN, 1, [Flag indicating whether the library will be compiled with Eigen support])
         AC_MSG_RESULT(<<< Configuring library with Eigen support >>>)
       fi
    fi
  fi
  
  # Substitute the substitution variables
  AC_SUBST(EIGEN_INCLUDE)
])
