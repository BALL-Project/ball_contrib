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
###    Set variables and create necessary directories                       ###
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
FILE(MAKE_DIRECTORY "${CONTRIB_PACKAGE_PATH}")

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

# Path that contains extracted sources (usually <build_dir>/src)
SET(CONTRIB_BINARY_SRC "${PROJECT_BINARY_DIR}/src")

# Path that contains configured patch file
SET(CONTRIB_BINARY_PATCHES "${PROJECT_BINARY_DIR}/patches")

# Logging options
SET(CUSTOM_BUILD_IN_SOURCE 1 CACHE STRING  "Build projects in sources (default 1).")
SET(CUSTOM_LOG_DOWNLOAD 1 CACHE STRING  "Write logfile for download step instead of printing (default 1).")
SET(CUSTOM_LOG_UPDATE 1 CACHE STRING  "Write logfile for update/patch step instead of printing (default 1).")
SET(CUSTOM_LOG_CONFIGURE 1 CACHE STRING  "Write logfile for configure step instead of printing (default 1).")
SET(CUSTOM_LOG_BUILD 1 CACHE STRING  "Write logfile for build step instead of printing (default 1).")
SET(CUSTOM_LOG_INSTALL 1 CACHE STRING  "Write logfile for install step instead of printing (default 1).")


###############################################################################
###    Select and check packages to be installed                            ###
###############################################################################

# Contrib packages needed to build BALL_core are listed in CORE_PACKAGES
SET(CORE_PACKAGES "boost" "eigen3" "lpsolve" "tbb" "openbabel" "fftw" "qt4" "sip")

# Contrib packages needed to build BALL_core are listed in VIEW_PACKAGES
SET(VIEW_PACKAGES "glew")

# Contrib packages needed to build BALL completely  are listed in CONTRIB_PACKAGES
SET(CONTRIB_PACKAGES "${CORE_PACKAGES};${VIEW_PACKAGES}")

# Variable to be set by the user in order to specify the packages to be build
SET(WITH_PACKAGES "help" CACHE STRING "Variable to control which packages are build.")

# Internal variable used to store the validated selection of packages to be installed
SET(BUILD_PACKAGES "")

IF(WITH_PACKAGES STREQUAL "help")
	MSG_HELP()
	RETURN(0)
ENDIF()

IF(WITH_PACKAGES STREQUAL "list")
	MSG_LIST("${CONTRIB_PACKAGES}")
	RETURN(0)
ENDIF()

IF(WITH_PACKAGES STREQUAL "all")

	SET(BUILD_PACKAGES "${CONTRIB_PACKAGES}")

ELSEIF(WITH_PACKAGES STREQUAL "core")

	SET(BUILD_PACKAGES "${CORE_PACKAGES}")

ELSE()

	FOREACH(p ${WITH_PACKAGES})

		LIST(FIND CONTRIB_PACKAGES ${p} VALID_ITEM)

		IF(VALID_ITEM STREQUAL "-1")
			MSG_LIST("${CONTRIB_PACKAGES}")
			MESSAGE(FATAL_ERROR "No valid contrib package: ${p}")
			RETURN(0)
		ELSE()
			LIST(APPEND BUILD_PACKAGES ${p})
		ENDIF()
	ENDFOREACH()

ENDIF()


# Cross dependencies between contrib packages have to be specified manually
# Important: prepend the required package to the list

	# Currently no cross dependency


# Cleanup list
LIST(REMOVE_DUPLICATES BUILD_PACKAGES)


# Add and check for GNU patch
# On windows it will be downloaded as a binary from GnuWin32 using the ExternalProject mechanism
LIST(INSERT BUILD_PACKAGES 0 "patch")

IF(OS_WINDOWS)
	SET(PROGRAM_PATCH "${CONTRIB_BINARY_SRC}/patch/bin/patch.exe")
ELSE()
	FIND_PROGRAM(PROGRAM_PATCH "patch")
	IF(NOT PROGRAM_PATCH)
		MESSAGE(FATAL_ERROR "Cannot find 'patch' on your system. Please install patch and add the directory to your PATH environment variable!")
	ENDIF()
ENDIF()


# Iterate list of selected and valid packages and include them now
FOREACH(p ${BUILD_PACKAGES})

	SET(PACKAGE_NAME "${p}")
	INCLUDE("${CONTRIB_LIBRARY_PATH}/${PACKAGE_NAME}/configure_package.cmake")

ENDFOREACH()


