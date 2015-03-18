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


###############################################################################
###    CMake settings                                                       ###
###############################################################################

CMAKE_MINIMUM_REQUIRED(VERSION 2.8.3 FATAL_ERROR)

# ExternalProjects package
INCLUDE(ExternalProject)

# Path to install modules
LIST(APPEND CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake")



###############################################################################
###    Load macros and determine global system configuration                ###
###############################################################################

INCLUDE(BALLContribConfigure)

INCLUDE(BALLContribMacros)



###############################################################################
###    Set variables and create necessary directories                       ###
###############################################################################

# URL to download the tarballs
SET(CONTRIB_PACKAGES_URL_1 "http://abi.inf.uni-tuebingen.de/Software/ball/contrib")

# Fallback URL to download the tarballs, providing some redundancy
SET(CONTRIB_PACKAGES_URL_2 "http://sourceforge.net/projects/ballproject/files/contrib/")

# Folder to store the downloaded tarballs
SET(CONTRIB_PACKAGE_PATH "${PROJECT_BINARY_DIR}/packages")
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


###############################################################################
###    Include all contrib packages here                                    ###
###    The package name must match its corresponding folder name            ###
###############################################################################

SET(PACKAGE_NAME "boost")
INCLUDE("${CONTRIB_LIBRARY_PATH}/${PACKAGE_NAME}/configure_ext_project.cmake")

SET(PACKAGE_NAME "eigen3")
INCLUDE("${CONTRIB_LIBRARY_PATH}/${PACKAGE_NAME}/configure_ext_project.cmake")

SET(PACKAGE_NAME "lpsolve")
INCLUDE("${CONTRIB_LIBRARY_PATH}/${PACKAGE_NAME}/configure_ext_project.cmake")

SET(PACKAGE_NAME "gsl")
INCLUDE("${CONTRIB_LIBRARY_PATH}/${PACKAGE_NAME}/configure_ext_project.cmake")

SET(PACKAGE_NAME "fftw")
INCLUDE("${CONTRIB_LIBRARY_PATH}/${PACKAGE_NAME}/configure_ext_project.cmake")

SET(PACKAGE_NAME "glew")
INCLUDE("${CONTRIB_LIBRARY_PATH}/${PACKAGE_NAME}/configure_ext_project.cmake")






