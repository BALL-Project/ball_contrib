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

# Validate user package selection against provided packages in CONTRIB_PACKAGES
# Additionally, populate top-level BUILD_PACKAGES list that holds the packages that will be  build.
MACRO(VALIDATE_SELECTION)

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

ENDMACRO()


# Check MD5 sum of ARCHIVE and set IS_VALID=TRUE if it matches ARCHIVE_MD5
MACRO(CHECK_PACKAGE_ARCHIVE ARCHIVE_SRC ARCHIVE_MD5 IS_VALID)

	# Check if archive has already been downloaded
	IF(EXISTS "${ARCHIVE_SRC}")

		# Check if archive MD5 sum is correct
		FILE(MD5 "${ARCHIVE_SRC}" ARCHIVE_MD5_CALC)
		STRING(COMPARE EQUAL "${ARCHIVE_MD5_CALC}" "${ARCHIVE_MD5}" IS_VALID)

	ENDIF()

ENDMACRO()


# Fetch ARCHIVE either from a local directory or download
# Using a local directoy can manually be specified by setting the optional variable ARCHIVES_PATH
# This mechanism can be used to build older contrib packages
MACRO(FETCH_PACKAGE_ARCHIVES)

	FOREACH(p ${BUILD_PACKAGES})

		# Package archive and md5 checksum
		SET(ARCHIVE "${${p}_archive}")
		SET(ARCHIVE_MD5 "${${p}_archive_md5}")

		# Check if ARCHIVE_PATH variable has been specified manually
		IF(ARCHIVES_PATH)

			SET(IS_VALID FALSE)
			SET(ARCHIVE_SRC "${ARCHIVES_PATH}/${ARCHIVE}")

			CHECK_PACKAGE_ARCHIVE("${ARCHIVE_SRC}" "${ARCHIVE_MD5}" IS_VALID)

			IF(IS_VALID)
				FILE(COPY "${ARCHIVE_SRC}" DESTINATION "${CONTRIB_ARCHIVES_PATH}")
			ELSE()
				MSG_INVALID_ARCHIVE_PATH("${ARCHIVE}")
			ENDIF()

		ELSE()

			# Not yet locally available so download archive
			DOWNLOAD_ARCHIVE("${ARCHIVE}" "${ARCHIVE_MD5}")

		ENDIF()

	ENDFOREACH()

ENDMACRO()


# Download archive
MACRO(DOWNLOAD_ARCHIVE ARCHIVE ARCHIVE_MD5)

	SET(SCP_USER "buildusr")
	SET(SCP_HOST "buildarchive.informatik.uni-tuebingen.de")
	SET(SCP_PATH "/nfs/wsi/abi/buildarchive/ball/contrib/archives")

	MESSAGE(STATUS "Downloading: ${ARCHIVE}")

	SET(IS_VALID FALSE)
	SET(ARCHIVE_DEST "${CONTRIB_ARCHIVES_PATH}/${ARCHIVE}")

	CHECK_PACKAGE_ARCHIVE("${ARCHIVE_DEST}" "${ARCHIVE_MD5}" IS_VALID)

	IF(NOT IS_VALID)

		IF(SCP)
			EXECUTE_PROCESS(COMMAND scp -r "${SCP_USER}@${SCP_HOST}:${SCP_PATH}/${ARCHIVE}" .
				WORKING_DIRECTORY "${CONTRIB_ARCHIVES_PATH}")
		ELSE()
			FILE(DOWNLOAD "${CONTRIB_ARCHIVES_URL}/${ARCHIVE}" "${ARCHIVE_DEST}")
		ENDIF()

	ENDIF()

	CHECK_PACKAGE_ARCHIVE("${ARCHIVE_DEST}" "${ARCHIVE_MD5}" IS_VALID)

	IF(NOT IS_VALID)
		MSG_DOWNLOAD_FAILED("${ARCHIVE}")
	ENDIF()

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


MACRO(MSG_DOWNLOAD_FAILED ARCHIVE)
	MESSAGE(STATUS "")
	MESSAGE(STATUS "=============================================================================================")
	MESSAGE(STATUS " FATAL ERROR: Download of contrib archive failed: ${ARCHIVE}")
	MESSAGE(STATUS "")
	MESSAGE(STATUS " - Please verify that your internet connection works and try again.")
	MESSAGE(STATUS " - If this error occurrs again please contact the developers.")
	MESSAGE(STATUS "=============================================================================================")
	MESSAGE(STATUS "")
	MESSAGE(FATAL_ERROR "")
ENDMACRO()


MACRO(MSG_INVALID_ARCHIVE_PATH ARCHIVE)
	MESSAGE(STATUS "")
	MESSAGE(STATUS "=============================================================================================")
	MESSAGE(STATUS " FATAL ERROR: Contrib archive ${ARCHIVE} not found or invalid." )
	MESSAGE(STATUS "")
	MESSAGE(STATUS " - Please verify that ARCHIVES_PATH (${ARCHIVES_PATH}) is set correctly")
	MESSAGE(STATUS "")
	MESSAGE(STATUS " PLEASE NOTE: only use ARCHIVES_PATH if you plan to build an older contrib version" )
	MESSAGE(STATUS "")
	MESSAGE(STATUS "=============================================================================================")
	MESSAGE(STATUS "")
	MESSAGE(FATAL_ERROR "")
ENDMACRO()




