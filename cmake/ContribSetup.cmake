# -----------------------------------------------------------------------------
# CONTRIB FRAMEWORK
#
# Based on CMake ExternalProjects, this repository offers functionality
# to configure, build, and install software dependencies that can be used
# by other projects.
#
# It has been developed in course of the open source
# research software BALL (Biochemical ALgorithms Library).
#
#
# Copyright 2016, the BALL team (http://www.ball-project.org)
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL ANY OF THE AUTHORS OR THE CONTRIBUTING
# INSTITUTIONS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
# OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
# OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# -----------------------------------------------------------------------------


###############################################################################
# Check build type

SET(CONTRIB_BUILD_TYPES "Release" "Debug" "RelWithDebInfo")
LIST(FIND CONTRIB_BUILD_TYPES "${CMAKE_BUILD_TYPE}" VALID_BUILD_TYPE)

IF("${CMAKE_BUILD_TYPE}" STREQUAL "")
	SET(CMAKE_BUILD_TYPE "Release")
ELSEIF(${VALID_BUILD_TYPE} EQUAL -1)
	MESSAGE(FATAL_ERROR "The specified CMAKE_BUILD_TYPE is invalid. Available build types are: ${CONTRIB_BUILD_TYPES}")
ENDIF()

MESSAGE(STATUS "Contrib build type: ${CMAKE_BUILD_TYPE}")


###############################################################################
# GitHub package repository settings

# Set GitHub base URL
IF(${DOWNLOAD_TYPE} STREQUAL "archive")
	SET(CONTRIB_GITHUB_BASE "https://api.github.com/repos/BALL-contrib" CACHE INTERNAL "GitHub base URL for archive download or cloning")
ELSE()
	SET(CONTRIB_GITHUB_BASE "git://github.com/BALL-contrib" CACHE INTERNAL "GitHub base URL for archive download or cloning")
ENDIF()


###############################################################################
# Set required paths

# Path that contains extracted sources (usually <build_dir>/src)
SET(CONTRIB_BINARY_SRC "${PROJECT_BINARY_DIR}/src" CACHE INTERNAL "Path where sources are located")

# Path that contains the contrib libraries
SET(CONTRIB_LIBRARY_PATH "${PROJECT_SOURCE_DIR}/libraries" CACHE INTERNAL "Package configuration file path")

# Install directory and required subdirectories
SET(CONTRIB_INSTALL_INC "${CONTRIB_INSTALL_PREFIX}/include" CACHE INTERNAL "Installation include prefix")
SET(CONTRIB_INSTALL_BIN "${CONTRIB_INSTALL_PREFIX}/bin" CACHE INTERNAL "Installation bin prefix")
SET(CONTRIB_INSTALL_LIB "${CONTRIB_INSTALL_PREFIX}/lib" CACHE INTERNAL "Installation lib prefix")
FILE(MAKE_DIRECTORY ${CONTRIB_INSTALL_PREFIX})
FILE(MAKE_DIRECTORY ${CONTRIB_INSTALL_BIN})
FILE(MAKE_DIRECTORY ${CONTRIB_INSTALL_INC})
FILE(MAKE_DIRECTORY ${CONTRIB_INSTALL_LIB})


###############################################################################
# Logging options for external project steps

SET(CUSTOM_BUILD_IN_SOURCE 1 CACHE STRING  "Build projects in sources. Default: 1")
SET(CUSTOM_LOG_DOWNLOAD 1 CACHE STRING  "Write download logfile step instead of printing. Default: 1")
SET(CUSTOM_LOG_UPDATE 1 CACHE STRING  "Write update/patch logfile instead of printing. Default: 1")
SET(CUSTOM_LOG_CONFIGURE 1 CACHE STRING  "Write configure logfile instead of printing. Default: 1")
SET(CUSTOM_LOG_BUILD 1 CACHE STRING  "Write build logfile instead of printing. Default: 1")
SET(CUSTOM_LOG_INSTALL 1 CACHE STRING  "Write install logfile instead of printing. Default: 1")


###############################################################################
# Set platform dependent build variables

# Determine whether this is a 32 or 64 bit build
SET(CONTRIB_ADDRESSMODEL 32 CACHE INTERNAL "Platform address model")
SET(MSBUILD "msbuild" "/m:${THREADS}" "/p:Platform=win32" "/p:Configuration=${CMAKE_BUILD_TYPE}" CACHE INTERNAL "MSbuild command including build type, number of threads and address model")

IF(CMAKE_SIZEOF_VOID_P EQUAL 8)
	SET(CONTRIB_ADDRESSMODEL 64)
	SET(MSBUILD "msbuild" "/m:${THREADS}" "/p:Platform=x64"   "/p:Configuration=${CMAKE_BUILD_TYPE}")
ENDIF()

# Set appropriate build commands for non-windows systems
IF(NOT MSVC)
	SET(MAKE_COMMAND "make" "-j${THREADS}" CACHE INTERNAL "Make command including number of threads")
	SET(MAKE_INSTALL_COMMAND "make" "install" CACHE INTERNAL "Install command")
ENDIF()


###############################################################################
# System inforamtiom

# MSVC version
IF(MSVC12)
	SET(CONTRIB_MSVC_VERSION "12.0")
	SET(CONTRIB_MSVC_VERSION_YEAR "2013")
ELSEIF(MSVC14)
	SET(CONTRIB_MSVC_VERSION "14.0")
	SET(CONTRIB_MSVC_VERSION_YEAR "2015")
ENDIF()


###############################################################################
# Search Git

FIND_PACKAGE(Git)
IF(NOT GIT_FOUND)
	MESSAGE(FATAL_ERROR "Git not found. Please install git or add it to the search path.")
ENDIF()


