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


# This CMake script generates self-contained ball_contrib packages for Linux, OS X and Windows.
# It clones the ball_contrib repository, performs a OS-dependent download of contrib packages,
# and generates tarballs.
#
# A directory 'packaging' is generated in the current working directory.
# The final packages will be located in this directory.
#
# Additionally, the projects CMakeLists.txt is modified in order to use the contained packages
# instead of downloading them from the web.
# Thus, the generated contribs shouldn't access the internet and need no network access.
#
# PLEASE NOTE: this script needs cmake and git.


# Macro to clone and configure ball_contrib
MACRO(GENERATE_CONTRIB CONTRIB_WIN)

	# Clone ball_contrib repository
	EXECUTE_PROCESS(COMMAND git clone --depth 1 https://github.com/BALL-Project/ball_contrib.git WORKING_DIRECTORY "${PKG_DIR}")
	# Execute cmake to download packages
	EXECUTE_PROCESS(COMMAND cmake ${CONTRIB_SOURCE} -DMSVC=${CONTRIB_WIN} WORKING_DIRECTORY "${BUILD_DIR}")

	# Move contrib packages to ball_contrib source directory
	FILE(RENAME "${BUILD_DIR}/archives" "${CONTRIB_SOURCE}/archives")
	FILE(RENAME "${BUILD_DIR}/cmake/BALLContribPackages.cmake" "${CONTRIB_SOURCE}/cmake/BALLContribPackages.cmake")

	# Modify CMakeLists.txt in order to use the downloaded archives and to prevent Internet access
	FILE(READ "${CONTRIB_SOURCE}/CMakeLists.txt" FILE_CONTENT)
	STRING(REGEX REPLACE "ARCHIVES_PATH \"\"" "ARCHIVES_PATH \"\${CMAKE_SOURCE_DIR}/archives\"" MODIFIED_FILE_CONTENT_1 "${FILE_CONTENT}")
	STRING(REGEX REPLACE "SET_CONTRIB_ARCHIVES_URL" "#SET_CONTRIB_ARCHIVES_URL" MODIFIED_FILE_CONTENT_2 "${MODIFIED_FILE_CONTENT_1}")
	FILE(WRITE "${CONTRIB_SOURCE}/CMakeLists.txt" "${MODIFIED_FILE_CONTENT_2}")

	# Cleanup
	EXECUTE_PROCESS(COMMAND git rm "tools/*" WORKING_DIRECTORY "${CONTRIB_SOURCE}")
	EXECUTE_PROCESS(COMMAND git rm ".gitignore" WORKING_DIRECTORY "${CONTRIB_SOURCE}")
	EXECUTE_PROCESS(COMMAND rm ".DS_Store" WORKING_DIRECTORY "${CONTRIB_SOURCE}" ERROR_QUIET)

	# Add all changes in git repository
	EXECUTE_PROCESS(COMMAND git add --all WORKING_DIRECTORY "${CONTRIB_SOURCE}")
	# Commit added changes
	EXECUTE_PROCESS(COMMAND git commit -m "Packaging ball_contrib" WORKING_DIRECTORY "${CONTRIB_SOURCE}")

ENDMACRO()


# Macro to generate the final archives
MACRO(GENERATE_ARCHIVE SUFFIX FORMAT)

	# Read ball_contrib version
	INCLUDE("${BUILD_DIR}/cmake/ball_contrib_version.cmake")

	# Generate archive
	EXECUTE_PROCESS(COMMAND git archive master
				-o "${PKG_DIR}/ball_contrib-${BALL_CONTRIB_VERSION}${SUFFIX}.${FORMAT}"
				--prefix=ball_contrib-${BALL_CONTRIB_VERSION}${SUFFIX}/
				WORKING_DIRECTORY "${CONTRIB_SOURCE}")

ENDMACRO()

IF(NOT "${GENERATE}" MATCHES "y")
	MESSAGE(STATUS "===========================================================================")
	MESSAGE(STATUS "")
	MESSAGE(STATUS "INFO:")
	MESSAGE(STATUS "* This script generates stand-alone ball_contrib packages for all supported platforms.")
	MESSAGE(STATUS "* As a result the following tarballs are placed in <workdir>/ball_contrib_tarballs :")
	MESSAGE(STATUS "*   ball_contrib-<version>.tar.gz")
	MESSAGE(STATUS "*   ball_contrib-<version>.tar.bz2")
	MESSAGE(STATUS "*   ball_contrib-<version>_win.zip")
	MESSAGE(STATUS "")
	MESSAGE(STATUS "USAGE:")
	MESSAGE(STATUS "* $cmake -DGENERATE=y -P tools/cmake_contrib_packages.cmake")
	MESSAGE(STATUS "")
	MESSAGE(STATUS "===========================================================================")

	RETURN()
ENDIF()

# Set and create temporary working directories
SET(PKG_DIR "${CMAKE_BINARY_DIR}/ball_contrib_tarballs")
FILE(MAKE_DIRECTORY "${PKG_DIR}")
SET(BUILD_DIR "${PKG_DIR}/build")
FILE(MAKE_DIRECTORY "${BUILD_DIR}")

SET(CONTRIB_SOURCE "${PKG_DIR}/ball_contrib")


# Generate contrib for Linux / OSX
GENERATE_CONTRIB(FALSE)
GENERATE_ARCHIVE("" "tar.gz")
GENERATE_ARCHIVE("" "tar.bz2")

# Cleanup temporary working directories
FILE(REMOVE_RECURSE "${BUILD_DIR}/*")
FILE(REMOVE_RECURSE "${CONTRIB_SOURCE}")


# Generate contrib for Windows
GENERATE_CONTRIB(TRUE)
GENERATE_ARCHIVE("_win" "zip")

# Cleanup temporary working directories
FILE(REMOVE_RECURSE "${BUILD_DIR}")
FILE(REMOVE_RECURSE "${CONTRIB_SOURCE}")


