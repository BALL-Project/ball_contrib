## Third Party Dependencies
### (contrib)

Third-party dependencies used by the Biochemical Algorithms Library (BALL). 
This repository is intended for end-users of BALL.
Third party dependencies are mostly original source tarballs but some are patched to fit our needs.

**NOTICE**: Do not use our tarballs if you need one of these packages for other purposes than a BALL installation.
In such a case, please use source distributions provided by the original suppliers.

Installation requirements:  
- git 
- CMake >= 2.8.12
- Perl (ActivePerl on Windows)
- Python (if BALL Python support is required)

Installation example (OSX/Linux):  
  `$ git clone https://github.com/BALL-Project/ball_contrib.git`   
  `$ cd ball_contrib`  
  `$ mkdir build`  
  `$ cd build`  
  `$ cmake ..`  
  `$ make`  

Available CMake variables:
 - **PACKAGES**  
   Select only a subset of third-party dependencies to be installed.  
   Available packages are: boost, qt5, fftw, eigen3, tbb, sip, openbabel
   * Example 1: build all dependencies (recommended)  
     `cmake ..`
   * Example 2: build only Boost  
     `cmake .. -DPACKAGES=boost`  
   * Example 3: build Boost and Qt  
     `cmake .. -DPACKAGES="boost;qt"`  
 - **THREADS**   
   Number of threads to use for build steps.  
   * Example: use four threads  
     `cmake .. -DTHREADS=4`  
 - **CONTRIB_INSTALL_PREFIX**  
   Installation target directory. Default: ball_contrib/build/install
   
Available CMake options:
 - **SKIP_QTWEBENGINE**
   Do not build Qt5 module QtWebEngine (required only for the PresentaBALL and BALLaxy plugins). This extremely speeds up building Qt5.
