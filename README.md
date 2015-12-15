## BALL Third Party Dependencies
### (ball_contrib)

Third-party dependencies used by the Biochemical Algorithms Library (BALL). 
This repository is intended for end-users of BALL.
Third party dependencies are mostly original source tarballs but some are patched to fit our needs.

**NOTICE**: Do not use our tarballs if you need one these packages for other purposes than a BALL installation.
In such a case, please use source distributions provided by the original suppliers.

Installation requirements:  
- git 
- CMake >= 2.8.12
- Perl (Windows only)
- Python (if BALL Python support is desired)

Installation example (OSX/Linux):  
- git clone https://github.com/BALL-Project/ball_contrib.git  
- cd ball_contrib  
- mkdir build  
- cd build  
- cmake ..  
- make  

This project provides the following CMake variables:
 - PACKAGES  
   Select only a subset of third-party dependencies to be installed.  
   Available packages are: boost, qt, fftw, eigen3, tbb, sip, openbabel, bison, flex, oncrpc
   * Example 1: build all dependencies (recommended)  
     cmake ..
   * Example 2: build only Boost  
     cmake .. -DPACKAGES=boost
   * Example 3: build Boost and Qt  
     cmake .. -DPACKAGES="boost;qt"  
 - THREADS   
   Number of threads to use for build steps.  
   * Example: use four threads  
     cmake .. -DTHREADS=4  

If the build process as given in the above example succeeds, the following directory 
will contain the installation of third-party dependencies:  
- ball_contrib/build/install  

It can be used to build BALL by specifying the absolute path of this install directory using one
of the following CMake variables available from the BALL project:  
 - BALL_CONTRIB_PATH
 - CMAKE_PREFIX_PATH




