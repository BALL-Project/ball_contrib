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
# Macros

# Create a list of all packages available in this contrib and a list of packages selected for installation
MACRO(EVALUATE_PACKAGES)

	# First, generate list of available packages
	GET_CMAKE_PROPERTY(VAR_LIST VARIABLES)

	FOREACH(TMP_VAR ${VAR_LIST})
		STRING(REGEX MATCH "^pkg_+" MATCH_RESULT ${TMP_VAR})
		IF(NOT ${MATCH_RESULT})
			STRING(SUBSTRING ${TMP_VAR} 4 -1 PACKAGE)
			LIST(APPEND PACKAGES_AVAILABLE ${PACKAGE})
		ENDIF()
	ENDFOREACH()

	# Second, generate list of packages to be installed
	IF("${PACKAGES}" STREQUAL "all" OR "${PACKAGES}" STREQUAL "")
		SET(PACKAGES_SELECTED ${PACKAGES_AVAILABLE})
	ELSE()
		SET(PACKAGES_SELECTED ${PACKAGES_SELECTED} ${PACKAGES})
	ENDIF()

ENDMACRO()


# Macro to write absolute paths as install names for dylibs using install_name_tool
MACRO(FIX_DYLIB_INSTALL_NAMES DYLIB_PREFIX)

        # As this procedure has to wait until the libraries are built and installed,
        # fixing the names is added as an ExternalProject step depending on the install step.
	ExternalProject_Add_Step(${PACKAGE} fixnames

		LOG 1
		DEPENDEES install

		WORKING_DIRECTORY "${CONTRIB_INSTALL_LIB}"
		COMMAND ${CMAKE_COMMAND} -DLIBNAME=${DYLIB_PREFIX} -P "${PROJECT_SOURCE_DIR}/cmake/FixDylibInstallNames.cmake"
	)

ENDMACRO()


###############################################################################
# Messages

MACRO(MSG_CONFIGURE_PACKAGE_BEGIN package_name)
	MESSAGE(STATUS "Configuring project: ${package_name}")
ENDMACRO()


MACRO(MSG_CONFIGURE_PACKAGE_END package_name)
	MESSAGE(STATUS "Configuring ${package_name} - done")
ENDMACRO()
