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


# Configure and download (git clone) packages
MACRO(CONFIGURE_PACKAGES)

	FOREACH(PACKAGE ${PACKAGES_SELECTED})

		# Check if selected package is indeed an available one
		LIST(FIND PACKAGES_AVAILABLE ${PACKAGE} PACKAGE_FOUND)

		IF(${PACKAGE_FOUND} EQUAL -1)
			MESSAGE(SEND_ERROR "The selected package '${PACKAGE}' is not part of BALL_contrib.")
		ELSE()
			# Configure package
			MESSAGE(STATUS "Configuring project: ${PACKAGE}")
			INCLUDE("${CONTRIB_LIBRARY_PATH}/${PACKAGE}.cmake")

			# Check if package has already been cloned, if not, clone it
			IF(NOT pkg_${PACKAGE}_downloaded)
				MESSAGE(STATUS "Downloading package (git clone): ${PACKAGE}")
				EXECUTE_PROCESS(COMMAND ${GIT_EXECUTABLE} clone --branch "${CONTRIB_GIT_BRANCH}" "${CONTRIB_GITHUB_BASE}/${pkg_${PACKAGE}}" "${CONTRIB_BINARY_SRC}/${PACKAGE}"
						TIMEOUT 300
						RESULT_VARIABLE DOWNLOAD_EXIT_CODE
						OUTPUT_FILE "${CONTRIB_BINARY_SRC}/${PACKAGE}_download_out.log"
						ERROR_FILE "${CONTRIB_BINARY_SRC}/${PACKAGE}_download_err.log"
						)

				# Check if download was successful
				IF(${DOWNLOAD_EXIT_CODE} EQUAL 0)
					# If yes, mark package as donwloaded in CMake internal cache
					SET(pkg_${PACKAGE}_downloaded TRUE CACHE INTERNAL "Variable indicates that package ${PACKAGE} has already been cloned")
				ELSE()
					# If not, exit CMake run with fatal error
					MESSAGE(FATAL_ERROR "Downloading of package failed: ${PACKAGE}")
				ENDIF()
			ENDIF()
		ENDIF()

	ENDFOREACH()

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

