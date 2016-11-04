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
- A compiler (e.g. gcc/g++, clang, MSVC) 
- Python (if Python support is required)

Installation example OSX/Linux:  
  `$ git clone https://github.com/BALL-Project/ball_contrib.git`   
  `$ cd ball_contrib`  
  `$ mkdir build`  
  `$ cd build`  
  `$ cmake ..`  
  `$ make`  
 
 Installation example Windows:  
  `$ git clone https://github.com/BALL-Project/ball_contrib.git`   
  `$ cd ball_contrib`  
  `$ md build`  
  `$ cd build`  
  `$ cmake .. -G "Visual Studio 14 2015 Win64"`  
  `$ msbuild BALL_contrib.sln`  

Available CMake variables:
 - **PACKAGES**  
   Select only a subset of third-party dependencies to be installed.  
   Available packages are: boost, qt5, fftw, eigen3, tbb, sip, openbabel.
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
 - **DOWNLOAD_TIMEOUT**  
   Timout (seconds) for a single package download. Default: 420.  
   If package downloads fail, try to increase this timeout.  
   
Available CMake options:
 - **SKIP_QTWEBENGINE**  
   Do not build Qt5 module QtWebEngine, which is required only for the PresentaBALL and BALLaxy plugins. This extremely speeds up building Qt5.
