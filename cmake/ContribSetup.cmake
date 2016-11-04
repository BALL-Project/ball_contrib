# -----------------------------------------------------------------------------
#   BALL - Biochemical ALgorithms Library
#   A C++ framework for molecular modeling and structural bioinformatics.
# -----------------------------------------------------------------------------
#
# Copyright (C) 1996-2012, the BALL Team:
#  - Andreas Hildebrandt
#  - Oliver Kohlbacher
#  - Hans-Peter Lenhof
#  - Eberhard Karls University, Tuebingen
#  - Saarland University, Saarbrücken
#  - others
#
#  This library is free software; you can redistribute it and/or
#  modify it under the terms of the GNU Lesser General Public
#  License as published by the Free Software Foundation; either
#  version 2.1 of the License, or (at your option) any later version.
#
#  This library is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
#  Lesser General Public License for more details.
#
#  You should have received a copy of the GNU Lesser General Public
#  License along with this library (BALL/source/LICENSE); if not, write
#  to the Free Software Foundation, Inc., 59 Temple Place, Suite 330,
#  Boston, MA  02111-1307  USA
#
# -----------------------------------------------------------------------------
# $Maintainer: Philipp Thiel $
# $Authors: Philipp Thiel $
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

# GitHub base URL that contains package repos
SET(CONTRIB_GITHUB_BASE "https://github.com/philthiel" CACHE INTERNAL "GitHub base URL where all package repos are located")

# Set system dependent git GIT branches
SET(CONTRIB_GIT_BRANCH "contrib_linux" CACHE INTERNAL "OS dependent branch of package GIT repository")
IF(MSVC)
	SET(CONTRIB_GIT_BRANCH "contrib_win")
ELSEIF(APPLE)
	SET(CONTRIB_GIT_BRANCH "contrib_osx")
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
# Search Git

FIND_PACKAGE(Git)
IF(NOT GIT_FOUND)
	MESSAGE(FATAL_ERROR "Git not found. Please install git or add it to a search path.")
ENDIF()


###############################################################################
# Search Python

# Check Python installation
SET(Python_ADDITIONAL_VERSIONS 2.7 2.6)

INCLUDE(FindPythonLibs)
IF(NOT PYTHONLIBS_FOUND)
	MESSAGE(FATAL_ERROR "No python libraries found. Required to build SIP.")
ENDIF()

INCLUDE(FindPythonInterp)
IF(NOT PYTHONINTERP_FOUND)
	MESSAGE(FATAL_ERROR "No python interpreter found. Required to build SIP and CTD2Galaxy.")
ENDIF()

EXECUTE_PROCESS(COMMAND ${PYTHON_EXECUTABLE} -c "import struct; print struct.calcsize(\"P\") * 8"
		RESULT_VARIABLE RUN_PYTHON_SUCCESS
		OUTPUT_VARIABLE PYTHON_BITSIZE)

IF(NOT RUN_PYTHON_SUCCESS EQUAL 0)
	MESSAGE(FATAL_ERROR "Could not execute python. Required to build SIP and CTD2Galaxy. Error: ${RUN_PYTHON_SUCCESS}")
ENDIF()

STRING(STRIP ${PYTHON_BITSIZE} PYTHON_BITSIZE)
IF(NOT PYTHON_BITSIZE EQUAL CONTRIB_ADDRESSMODEL)
	MESSAGE(FATAL_ERROR "Python was built for a different address model. Please install appropriate version.")
ENDIF()


