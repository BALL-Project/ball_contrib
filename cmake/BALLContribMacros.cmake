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
###    Macros                                                               ###
###############################################################################

# Macro to write absolute paths as install names for dylibs using install_name_tool
MACRO(FIX_DYLIB_INSTALL_NAMES DYLIB_PREFIX)

        # As this procedure has to wait until the libraries are built and installed,
        # fixing the names is added as an ExternalProject step depending on the install step.
	ExternalProject_Add_Step(${PACKAGE_NAME} fixnames

		LOG 1
		DEPENDEES install

		WORKING_DIRECTORY "${CONTRIB_INSTALL_LIB}"
		COMMAND ${CMAKE_COMMAND} -DLIBNAME=${DYLIB_PREFIX} -P "${PROJECT_SOURCE_DIR}/cmake/FixDylibInstallNames.cmake"
	)

ENDMACRO()

# Check which URL to use for archive download
MACRO(SET_CONTRIB_ARCHIVES_URL)

	# Check first URL
	FILE(DOWNLOAD "${ARCHIVES_URL}/README" "${PROJECT_BINARY_DIR}/README" TIMEOUT 10 STATUS URL_STATUS)
	LIST(GET URL_STATUS 0 STATUS)

	IF(STATUS STREQUAL "0")
		SET(CONTRIB_ARCHIVES_URL "${ARCHIVES_URL}")
	ELSE()
		# Check second URL
		FILE(DOWNLOAD "${ARCHIVES_URL_FALLBACK}/README" "${PROJECT_BINARY_DIR}/README" TIMEOUT 10 STATUS URL_STATUS)
		LIST(GET URL_STATUS 0 STATUS)

		IF(STATUS STREQUAL "0")
			SET(CONTRIB_ARCHIVES_URL "${ARCHIVES_URL_FALLBACK}")
		ELSE()
			MESSAGE(FATAL_ERROR "Servers for archive download are not accessible. Please try again later.
					     If the problem remains please contact the BALL developers!")
		ENDIF()
	ENDIF()

	FILE(DOWNLOAD "${CONTRIB_ARCHIVES_URL}/BALLContribPackages.cmake" "${CONTRIB_CMAKE_MODULES}/BALLContribPackages.cmake")
	MESSAGE(STATUS "Download resource: ${CONTRIB_ARCHIVES_URL}" )

ENDMACRO()


# Validate user package selection against provided packages in CONTRIB_PACKAGES
# Additionally, populate top-level BUILD_PACKAGES list that holds the packages that will be  build.
MACRO(EVALUATE_SELECTION)

	SET(VALID_PACKAGES "")
	SET(INVALID_PACKAGES "")

	# Iterate list of selected packages and check
	# if every item indeed exists as a provided contrib package
	FOREACH(p ${PACKAGES})

		LIST(FIND CONTRIB_PACKAGES ${p} VALID_ITEM)
		IF(VALID_ITEM EQUAL -1)
			LIST(APPEND INVALID_PACKAGES ${p})
		ELSE()
			LIST(APPEND VALID_PACKAGES ${p})
		ENDIF()

	ENDFOREACH()

	# Check if invalid packages were detected.
	# If true, print error message and exit with error.
	LIST(LENGTH INVALID_PACKAGES N_INVALID_PACKAGES)
	IF(NOT N_INVALID_PACKAGES EQUAL 0)
		MSG_LIST()
		MESSAGE(STATUS "")
		MESSAGE(FATAL_ERROR " ERROR: invalid contrib package(s) selected: ${INVALID_PACKAGES}")
	ENDIF()

	# Generate list of packages to be build from the list of selected valid packages
	FOREACH(p ${VALID_PACKAGES})

		# Check if dependency for package p exists.
		# If true, first add dependency to BUILD_PACKAGES list
		IF(DEP_${p})
			LIST(APPEND BUILD_PACKAGES "${DEP_${p}}")
		ENDIF()

		# Now add package itself
		LIST(APPEND BUILD_PACKAGES ${p})

	ENDFOREACH()

	# Add mandatory windows packages if appropriate
	IF(MSVC)
		LIST(APPEND BUILD_PACKAGES "${WIN_CONTRIB_PACKAGES}")
	ENDIF()

ENDMACRO()


# Fetch ARCHIVE either from a local directory or download
# Using a local directoy can manually be specified by setting the optional variable ARCHIVES_PATH
# This mechanism can be used to build older contrib packages
MACRO(FETCH_PACKAGE_ARCHIVES)

	FOREACH(p ${DOWNLOAD_ARCHIVES})

		# Package archive and md5 checksum
		SET(ARCHIVE "${${p}_archive}")
		SET(ARCHIVE_MD5 "${${p}_archive_md5}")

		# Check if ARCHIVE_PATH variable has been specified manually
		IF(ARCHIVES_PATH)

			SET(IS_VALID FALSE)
			SET(ARCHIVE_SRC "${ARCHIVES_PATH}/${ARCHIVE}")

			FILE(MD5 "${ARCHIVE_SRC}" ARCHIVE_MD5_CALC)

			IF("${ARCHIVE_MD5_CALC}" EQUAL "${ARCHIVE_MD5}")
				FILE(COPY "${ARCHIVE_SRC}" DESTINATION "${CONTRIB_ARCHIVES_PATH}")
			ELSE()
				MESSAGE(WARNING "MD5 mismatch for archive: ${ARCHIVE}")
			ENDIF()

		ELSE()

			MESSAGE(STATUS "Downloading: ${ARCHIVE}")
			FILE(DOWNLOAD "${CONTRIB_ARCHIVES_URL}/${ARCHIVE}" "${CONTRIB_ARCHIVES_PATH}/${ARCHIVE}" EXPECTED_MD5 "${ARCHIVE_MD5}")

		ENDIF()

	ENDFOREACH()

ENDMACRO()


###############################################################################
###    Messages                                                             ###
###############################################################################

MACRO(MSG_HELP)
	MESSAGE(STATUS "")
	MESSAGE(STATUS "===========================================================================")
	MESSAGE(STATUS "BALL contrib packages installation:")
	MESSAGE(STATUS "")
	MESSAGE(STATUS "* This program will allow you to compile and install almost all BALL dependencies.")
	MESSAGE(STATUS "* By default, all contrib packages are build. ")
	MESSAGE(STATUS "* Use the CMake variable -DPACKAGES to select only a subset for building.")
	MESSAGE(STATUS "  For multiple choices please use a semicolon-separated and double quoted argument.")

	MSG_LIST()

	MESSAGE(STATUS "")
	MESSAGE(STATUS "===========================================================================")
	MESSAGE(STATUS "")
ENDMACRO()


MACRO(MSG_LIST)

	MESSAGE(STATUS "")
	MESSAGE(STATUS "Available BALL contrib packages:")
	MESSAGE(STATUS "")

	FOREACH(p ${CONTRIB_PACKAGES})
		MESSAGE(STATUS " * ${p}")
	ENDFOREACH()

ENDMACRO()


MACRO(MSG_CONFIGURE_PACKAGE_BEGIN package_name)
	MESSAGE(STATUS "Configuring project: ${package_name}")
ENDMACRO()


MACRO(MSG_CONFIGURE_PACKAGE_END package_name)
	MESSAGE(STATUS "Configuring ${package_name} - done")
ENDMACRO()
