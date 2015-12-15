## BALL Third Party Dependencies
### (ball_contrib)

Third-party dependencies used by the Biochemical Algorithms Library (BALL) 
This repository is intended for end-users of BALL.
Third party libraries are mostly forks of their original repositories.

Installation requirements:

 - CMake > 2.8.12
 - git
 - Perl (Windows only)

Possible installation on OSX / Linux:

  $ git clone https://github.com/BALL-Project/ball_contrib.git  
  $ cd ball_contrib  
  $ mkdir build  
  $ cd build  
  $ cmake ..  
  $ make  

This project provides the following CMake variables:

 - PACKAGES  
   Select only a subset of third-party libraries to be installed.  
   Available packages are: boost, qt, fftw, eigen3, tbb, sip, openbabel, bison, flex, oncrpc
   * Example 1: build all dependencies (recommended)  
     $ cmake ..
   * Example 2: build only Boost  
     $ cmake .. -DPACKAGES=boost
   * Example 3: build Boost and Qt  
     $ cmake .. -DPACKAGES="boost;qt"

 - THREADS   
   Number of threads to use for build steps.  
   * Example: use four threads  
     $ cmake .. -DTHREADS=4

 If the build process succeeds, the directory <path_to_ball_contrib>/build/install
 will contain the installation of third-party dependencies and can be used to build
 BALL.  
 Therefore, you have to specify the absolute path of this install directory using one
 of the following CMake variables available from the BALL project:  
 - BALL_CONTRIB_PATH
 - CMAKE_PREFIX_PATH




