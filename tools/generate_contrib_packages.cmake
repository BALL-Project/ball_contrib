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
# PLEASE NOTE: this script needs cmake, git, gnutar, and zip to be installed.


MACRO(GENERATE_CONTRIB CONTRIB_WIN)

	# Clone ball_contrib repository
	EXECUTE_PROCESS(COMMAND git clone --depth 1 https://github.com/BALL-Project/ball_contrib.git WORKING_DIRECTORY "${PKG_DIR}")
	# Execute cmake to download packages
	EXECUTE_PROCESS(COMMAND cmake ../.. -DMSVC=${CONTRIB_WIN} WORKING_DIRECTORY "${BUILD_DIR}")

	# Move contrib packages to ball_contrib source directory
	FILE(RENAME "${BUILD_DIR}/archives" "${PKG_DIR}/ball_contrib/archives")

	# Modify CMakeLists.txt in order to use the downloaded archives and to prevent Internet access
	FILE(READ "${PKG_DIR}/ball_contrib/CMakeLists.txt" FILE_CONTENT)
	STRING(REGEX REPLACE "ARCHIVES_PATH \"\"" "ARCHIVES_PATH \"\${CMAKE_SOURCE_DIR}/archives\"" MODIFIED_FILE_CONTENT "${FILE_CONTENT}")
	STRING(REGEX REPLACE "SET_CONTRIB_ARCHIVES_URL" "#SET_CONTRIB_ARCHIVES_URL" MODIFIED_FILE_CONTENT "${FILE_CONTENT}")
	FILE(WRITE "${PKG_DIR}/ball_contrib/CMakeLists.txt" "${MODIFIED_FILE_CONTENT}")

ENDMACRO()


# Create temporary working directories
SET(PKG_DIR "${CMAKE_BINARY_DIR}/packaging")
FILE(MAKE_DIRECTORY "${PKG_DIR}")
SET(BUILD_DIR "${PKG_DIR}/build")
FILE(MAKE_DIRECTORY "${BUILD_DIR}")


# Generate contrib for Linux / OSX
GENERATE_CONTRIB(FALSE)

# Generate tar.gz
EXECUTE_PROCESS(COMMAND gnutar cjf "${PKG_DIR}/ball_contrib.tar.bz2" "ball_contrib/" WORKING_DIRECTORY "${PKG_DIR}")
# Generate tar.bz2
EXECUTE_PROCESS(COMMAND gnutar czf "${PKG_DIR}/ball_contrib.tar.gz"  "ball_contrib/" WORKING_DIRECTORY "${PKG_DIR}")

# Cleanup temporary working directories
FILE(REMOVE_RECURSE "${PKG_DIR}/build/*")
FILE(REMOVE_RECURSE "${PKG_DIR}/ball_contrib")


# Generate contrib for Windows
GENERATE_CONTRIB(TRUE)

# Generate zip
EXECUTE_PROCESS(COMMAND zip -qr "${PKG_DIR}/ball_contrib_win" "ball_contrib" -x "*.git*" WORKING_DIRECTORY "${PKG_DIR}")

# Cleanup temporary working directories
FILE(REMOVE_RECURSE "${PKG_DIR}/build")
FILE(REMOVE_RECURSE "${PKG_DIR}/ball_contrib")




