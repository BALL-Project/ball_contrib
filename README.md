## BALL Third Party Dependencies
### (ball_contrib)
Third-party libraries used by the Biochemical Algorithms Library (BALL)

This repository is intended for end-users of BALL.

Third party libraries are mostly forks of their original repositories.

Installation requirements:

 - CMake > 2.8.3
 - git

Possible installation on OSX / Linux:

  $ git clone https://github.com/BALL-Project/ball_contrib.git

  $ cd ball_contrib

  $ mkdir build

  $ cd build

  $ cmake ..

  $ make

  If the build process succeeds, the directory <path_to_ball_contrib>/build/install
  will contain the installation of all third-party libraries and can be used to build
  BALL by setting either one of the following CMake variables CMAKE_PREFIX_PATH or 
  BALL_CONTRIB_PATH to this directory.

The cmake project provides the following variables:

  - WITH_PACKAGES:   Select only a subset of third-party libraries to be installed.

  - N_MAKE_THREADS:  number of parallel threads to use for build steps


