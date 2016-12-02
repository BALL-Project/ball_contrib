## Contrib: Third Party Dependencies

Third party dependencies used amongst others by the Biochemical ALgorithms Library (BALL). 
Sources are based on original tarballs and are patched to fit our needs.

**Requirements**  
- git 
- CMake (version >= 3)
- Perl (ActivePerl on Windows)
- A compiler (e.g. gcc/g++, clang, MSVC) 
- Python (version >= 2.6)

**Installation**  
- *Example OSX/Linux*  
  `$ git clone https://github.com/BALL-Project/ball_contrib.git`   
  `$ cd ball_contrib`  
  `$ mkdir build`  
  `$ cd build`  
  `$ cmake ..`  
  `$ make`  
 
- *Example Windows*  
  `$ git clone https://github.com/BALL-Project/ball_contrib.git`   
  `$ cd ball_contrib`  
  `$ md build`  
  `$ cd build`  
  `$ cmake .. -G "Visual Studio 14 2015 Win64"`  
  `$ msbuild BALL_contrib.sln`  

- *IMPORTANT BUILD NOTE*  
Do not use the '-j' flag for make and the /maxcpucount switch for MSbuild!
The behaviour is undefined and will most likely break your build.
If you want to allow multiple build threads please specify the number during the
CMake configuration run using the command line option -DTHREADS=n_threads  

**Available CMake variables**  
 - *PACKAGES*  
   Select only a subset of third-party dependencies to be installed.  
   Available packages are: boost, qt5, fftw, eigen3, tbb, sip, openbabel.
   * Example 1: build all dependencies (recommended)  
     `cmake ..`
   * Example 2: build only Boost  
     `cmake .. -DPACKAGES=boost`  
   * Example 3: build Boost and Qt5  
     `cmake .. -DPACKAGES="boost;qt5"`  
 - *THREADS*   
   Number of threads to use in the build steps.  
 - *CONTRIB_INSTALL_PREFIX*  
   Installation target directory. Default: ball_contrib/build/install  
 - *DOWNLOAD_TIMEOUT*  
   Timout (seconds) for a single package download. Default: 420.  
   If package downloads fail, try to increase this timeout.  
   
**Available CMake options**  
 - *SKIP_QTWEBENGINE*  
   Do not build Qt5 module QtWebEngine, which is required only for the PresentaBALL and BALLaxy plugins. This extremely speeds up building Qt5.
