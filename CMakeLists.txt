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


PROJECT("BALL_contrib")

SET(BALL_CONTRIB_VERSION_MAJOR "1")
SET(BALL_CONTRIB_VERSION_MINOR "4")
SET(BALL_CONTRIB_VERSION_PATCH "3")
SET(BALL_CONTRIB_VERSION "${BALL_CONTRIB_VERSION_MAJOR}.${BALL_CONTRIB_VERSION_MINOR}.${BALL_CONTRIB_VERSION_PATCH}")



###############################################################################
###    CMake settings                                                       ###
###############################################################################

CMAKE_MINIMUM_REQUIRED(VERSION 2.8.3 FATAL_ERROR)

# Path to contrib-specific CMake modules
LIST(APPEND CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake")

# ExternalProjects package
INCLUDE(ExternalProject)

# Global system configuration
INCLUDE(BALLContribConfigure)

# Load contrib-specific macros and messages
INCLUDE(BALLContribMacros)


###############################################################################
###    Global settings                                                      ###
###############################################################################

# OPTIONAL:
# Path to directory that contains the archives of the contrib packages needed.
# This is a mechanism to install old contrib versions
# for which we don't hostthe archives anymore
SET(ARCHIVES_PATH "" CACHE PATH "Optional path to the folder containing the contrib archives.")

# URL to download the tarballs
SET(CONTRIB_ARCHIVES_URL "ftp://buildarchive.informatik.uni-tuebingen.de/ball/contrib/archives/")

# Folder to store the downloaded tarballs
SET(CONTRIB_ARCHIVES_PATH "${PROJECT_BINARY_DIR}/archives")
FILE(MAKE_DIRECTORY "${CONTRIB_ARCHIVES_PATH}")

# Install directory
SET(CONTRIB_INSTALL_BASE "${PROJECT_BINARY_DIR}/install")
FILE(MAKE_DIRECTORY "${CONTRIB_INSTALL_BASE}")

# Install directory: binaries
SET(CONTRIB_INSTALL_BIN "${CONTRIB_INSTALL_BASE}/bin")
FILE(MAKE_DIRECTORY "${CONTRIB_INSTALL_BIN}")

# Install directory: libraries
SET(CONTRIB_INSTALL_LIB "${CONTRIB_INSTALL_BASE}/lib")
FILE(MAKE_DIRECTORY "${CONTRIB_INSTALL_LIB}")

# Install directory: headers
SET(CONTRIB_INSTALL_INC "${CONTRIB_INSTALL_BASE}/include")
FILE(MAKE_DIRECTORY "${CONTRIB_INSTALL_INC}")

# Path that contains the contrib libraries
SET(CONTRIB_LIBRARY_PATH "${PROJECT_SOURCE_DIR}/libraries")
FILE(MAKE_DIRECTORY "${CONTRIB_LIBRARY_PATH}")

# Path that contains extracted sources (usually <build_dir>/src)
SET(CONTRIB_BINARY_SRC "${PROJECT_BINARY_DIR}/src")
FILE(MAKE_DIRECTORY "${CONTRIB_BINARY_SRC}")

# Logging options
SET(CUSTOM_BUILD_IN_SOURCE 1 CACHE STRING  "Build projects in sources (default 1).")
SET(CUSTOM_LOG_DOWNLOAD 1 CACHE STRING  "Write logfile for download step instead of printing (default 1).")
SET(CUSTOM_LOG_UPDATE 1 CACHE STRING  "Write logfile for update/patch step instead of printing (default 1).")
SET(CUSTOM_LOG_CONFIGURE 1 CACHE STRING  "Write logfile for configure step instead of printing (default 1).")
SET(CUSTOM_LOG_BUILD 1 CACHE STRING  "Write logfile for build step instead of printing (default 1).")
SET(CUSTOM_LOG_INSTALL 1 CACHE STRING  "Write logfile for install step instead of printing (default 1).")

# Option to specify number of threads used by make
SET(THREADS 1 CACHE STRING "Number of threads used by make steps (default 1).")

# Set contrib build type
IF(CMAKE_BUILD_TYPE STREQUAL "Debug")
	SET(CONTRIB_BUILD_TYPE "Debug")
ELSEIF(CMAKE_BUILD_TYPE STREQUAL "RelWithDebInfo")
	SET(CONTRIB_BUILD_TYPE "RelWithDebInfo")
ELSE()
	SET(CONTRIB_BUILD_TYPE "Release")
ENDIF()

# Determine whether this is a 32 or 64 bit build
IF(CMAKE_SIZEOF_VOID_P EQUAL 8)
	SET(CONTRIB_ADDRESSMODEL 64)
	SET(MSBUILD "msbuild" "/p:Platform=x64"   "/p:Configuration=${CONTRIB_BUILD_TYPE}")
ELSE()
	SET(CONTRIB_ADDRESSMODEL 32)
	SET(MSBUILD "msbuild" "/p:Platform=win32" "/p:Configuration=${CONTRIB_BUILD_TYPE}")
ENDIF()


###############################################################################
###    Select and check packages to be installed                            ###
###############################################################################

# Get list and information of available contrib packages
INCLUDE(BALLContribLibraries)

OPTION(HELP "Show help for ball_contrib installation." FALSE)
IF(HELP)
	MSG_HELP()
	RETURN(0)
ENDIF()


# Variable to be set by the user in order to select the packages to be build.
SET(PACKAGES "" CACHE STRING "Variable to control which packages are build.")

IF(PACKAGES STREQUAL "")
	# All packages selected for installation
	SET(PACKAGES "${CONTRIB_PACKAGES}")
ENDIF()


# Check if selected packages are correct and populate BUILD_PACKAGES variable
IF(MSVC)
	SET(BUILD_PACKAGES "oncrpc")
ELSE()
	SET(BUILD_PACKAGES "")
ENDIF()
VALIDATE_SELECTION()


# Iterate selected and valid packages, configure them, and add them to the download list
SET(DOWNLOAD_ARCHIVES "")
FOREACH(PACKAGE_NAME ${BUILD_PACKAGES})

	INCLUDE("${CONTRIB_LIBRARY_PATH}/${PACKAGE_NAME}.cmake")
	LIST(APPEND DOWNLOAD_ARCHIVES "${PACKAGE_NAME}")

ENDFOREACH()

# Finally, download archives
OPTION(SCP "Use scp to download library tarballs." OFF)
FETCH_PACKAGE_ARCHIVES()







