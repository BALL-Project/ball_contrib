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

SET(CONTRIB_VERSION_MAJOR "1" CACHE INTERNAL "Contrib version MAJOR")
SET(CONTRIB_VERSION_MINOR "5" CACHE INTERNAL "Contrib version MINOR")
SET(CONTRIB_VERSION_PATCH "1" CACHE INTERNAL "Contrib version PATCH")
SET(CONTRIB_VERSION "${CONTRIB_VERSION_MAJOR}.${CONTRIB_VERSION_MINOR}.${CONTRIB_VERSION_PATCH}" CACHE INTERNAL "Contrib version string")


###############################################################################
# CMake and global settings

CMAKE_MINIMUM_REQUIRED(VERSION 3.0.0 FATAL_ERROR)

# Path to contrib-specific CMake modules
LIST(APPEND CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake")
LIST(APPEND CMAKE_MODULE_PATH "${PROJECT_BINARY_DIR}/cmake")

# CMake variables that can be changed by the user
SET(CONTRIB_INSTALL_PREFIX "${PROJECT_BINARY_DIR}/install" CACHE PATH "Prefix to install BALL_contrib. Default: <BALL_contrib_build_dir>/install")
SET(THREADS "1" CACHE STRING "Number of threads used by make steps. Default: 1")

# ExternalProjects package
INCLUDE(ExternalProject)

# Setup BALL_contrib
INCLUDE(ContribSetup)

# Load contrib-specific macros and messages
INCLUDE(ContribMacros)
return (0)

###############################################################################
# Packages contained in this contrib

SET(pkg_boost        "BALL_contrib_boost_1.60.0" CACHE INTERNAL "Boost repo name")
SET(pkg_eigen3       "BALL_contrib_eigen_3.2.5" CACHE INTERNAL "Eigen3 repo name")
SET(pkg_fftw         "BALL_contrib_fftw_3.3.4" CACHE INTERNAL "FFTW repo name")
SET(pkg_glew         "BALL_contrib_glew_1.13.0" CACHE INTERNAL "GLEW repo name")
SET(pkg_openbabel    "BALL_contrib_openbabel_2.4.1" CACHE INTERNAL "OpenBabel repo name")
SET(pkg_sip          "BALL_contrib_sip_4.16.9" CACHE INTERNAL "SIP repo name")
SET(pkg_tbb          "BALL_contrib_tbb43_20150611" CACHE INTERNAL "TBB repo name")
SET(pkg_qt5          "BALL_contrib_qt_5.6.1-1" CACHE INTERNAL "Qt5 repo name")

IF(MSVC)
	SET(pkg_bison        "BALL_contrib_bison_2.4.1" CACHE INTERNAL "Bison repo name")
	SET(pkg_flex         "BALL_contrib_flex_2.5.4" CACHE INTERNAL "Flex repo name")
	SET(pkg_oncrpc       "BALL_contrib_oncrpc_1.14" CACHE INTERNAL "Oncrpc repo name")

	# Bison and Flex are mandatory on Windows
	SET(PACKAGES_SELECTED bison flex)
ENDIF()

# The following macro evaluates the list of available packages and
# the packages selected for installation by the user via -DPACKAGES
#
# The following varables will then be available
# - PACKAGES_AVAILABLE
# - PACKAGES_SELECTED
EVALUATE_PACKAGES()


###############################################################################
# Check selected packages and configure them

FOREACH(PACKAGE ${PACKAGES_SELECTED})

	# Check if selected package is indeed an available one
	LIST(FIND PACKAGES_AVAILABLE ${PACKAGE} PACKAGE_FOUND)

	IF(${PACKAGE_FOUND} EQUAL -1)
		MESSAGE(SEND_ERROR "The selected package '${PACKAGE}' is not part of BALL_contrib.")
	ELSE()
		MSG_CONFIGURE_PACKAGE_BEGIN(${PACKAGE})
		INCLUDE("${CONTRIB_LIBRARY_PATH}/${PACKAGE}.cmake")
		MSG_CONFIGURE_PACKAGE_END(${PACKAGE})
	ENDIF()

ENDFOREACH()


