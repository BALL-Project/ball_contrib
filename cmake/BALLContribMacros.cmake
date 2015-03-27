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

#
# Check MD5 sum of ARCHIVE and set IS_VALID=TRUE if it matches ARCHIVE_MD5
#
MACRO(CHECK_PACKAGE_ARCHIVE archive archive_md5 is_valid)

	# Check if archive has already been downloaded
	IF(EXISTS "${archive}")

		FILE(MD5 "${archive}" ARCHIVE_MD5_CALC)

		# Check if archive MD5 sum is correct
		IF("${ARCHIVE_MD5_CALC}" STREQUAL "${archive_md5}")
			SET(${is_valid} TRUE)
		ENDIF()

	ENDIF()

ENDMACRO()


#
# Fetch ARCHIVE either from a local directory or download
# Using a local directoy can manually be specified by setting the optional variable ARCHIVES_PATH
# This mechanism can be used to build older contrib packages
#
MACRO(FETCH_PACKAGE_ARCHIVE archive archive_md5)

	# Check if ARCHIVE_PATH variable has been specified manually
	IF(ARCHIVES_PATH)

		SET(IS_VALID FALSE)
		SET(ARCHIVE_SRC "${ARCHIVES_PATH}/${archive}")

		CHECK_PACKAGE_ARCHIVE("${ARCHIVE_SRC}" "${archive_md5}" IS_VALID)

		IF(IS_VALID)
			FILE(COPY "${ARCHIVE_SRC}" DESTINATION "${CONTRIB_ARCHIVES_PATH}")
		ELSE()
			MSG_INVALID_ARCHIVE_PATH("${archive}")
		ENDIF()

	ELSE()

		DOWNLOAD_PACKAGE_ARCHIVE("${archive}" "${archive_md5}")

	ENDIF()

ENDMACRO()


#
# Download archive
#
MACRO(DOWNLOAD_PACKAGE_ARCHIVE archive archive_md5)

	MESSAGE(STATUS "Downloading: ${archive}")

	SET(IS_VALID FALSE)
	SET(ARCHIVE_DEST "${CONTRIB_ARCHIVES_PATH}/${archive}")

	CHECK_PACKAGE_ARCHIVE("${ARCHIVE_DEST}" "${archive_md5}" IS_VALID)

	# Try download from mirror 1
	IF(NOT IS_VALID)

		FILE(DOWNLOAD
			"${CONTRIB_ARCHIVES_URL_1}/${archive}"
			"${ARCHIVE_DEST}"
		)

	ENDIF()

	CHECK_PACKAGE_ARCHIVE("${ARCHIVE_DEST}" "${archive_md5}" IS_VALID)

	# Try download from mirror 1
	IF(NOT IS_VALID)

		FILE(DOWNLOAD
			"${CONTRIB_ARCHIVES_URL_2}/${archive}"
			"${ARCHIVE_DEST}"
		)

	ENDIF()

	CHECK_PACKAGE_ARCHIVE("${ARCHIVE_DEST}" "${archive_md5}" IS_VALID)

	IF(NOT IS_VALID)
		MSG_DOWNLOAD_FAILED("${archive}")
	ENDIF()

ENDMACRO()



###############################################################################
###    Messages                                                             ###
###############################################################################

MACRO(MSG_HELP)
	MESSAGE(STATUS "")
	MESSAGE(STATUS "===========================================================================")
	MESSAGE(STATUS "BALL contrib (dependency) packages installation system:")
	MESSAGE(STATUS "")
	MESSAGE(STATUS "* This program will allow you to compile and install all BALL dependencies.")
	MESSAGE(STATUS "* By default, all contrib packages are build. ")
	MESSAGE(STATUS "* Use the CMake variable -DWITH_PACKAGES to select only a subset for building.")
	MESSAGE(STATUS "  For multiple choices please use a semicolon-separated and double quoted argument.")
	MESSAGE(STATUS "* A list of available contrib packages is listed using -WITH_PACKAGES=list")
	MESSAGE(STATUS "")
	MESSAGE(STATUS "===========================================================================")
	MESSAGE(STATUS "")
ENDMACRO()


MACRO(MSG_LIST contrib_packages)
	MESSAGE(STATUS "")
	MESSAGE(STATUS "===========================================================================")
	MESSAGE(STATUS "Available BALL contrib packages:")
	MESSAGE(STATUS "")

	MESSAGE(STATUS " * all  (build all packages)")
	MESSAGE(STATUS " * core (build only packages nedded to build BALL core library)")

	FOREACH(p ${contrib_packages})
		MESSAGE(STATUS " * ${p}")
	ENDFOREACH()

	MESSAGE(STATUS "")
	MESSAGE(STATUS "===========================================================================")
	MESSAGE(STATUS "")
ENDMACRO()


MACRO(MSG_CONFIGURE_PACKAGE_BEGIN package_name)
	MESSAGE(STATUS "Configuring project: ${package_name}")
ENDMACRO()


MACRO(MSG_CONFIGURE_PACKAGE_END package_name)
	MESSAGE(STATUS "Configuring ${package_name} - done")
ENDMACRO()


MACRO(MSG_DOWNLOAD_FAILED archive)
	MESSAGE(STATUS "")
	MESSAGE(STATUS "=============================================================================================")
	MESSAGE(STATUS " FATAL ERROR: Download of contrib archive failed: ${archive}")
	MESSAGE(STATUS "")
	MESSAGE(STATUS " - Please verify that your internet connection works and try again.")
	MESSAGE(STATUS " - If this error occurrs again please contact the developers.")
	MESSAGE(STATUS "=============================================================================================")
	MESSAGE(STATUS "")
	MESSAGE(FATAL_ERROR "")
ENDMACRO()


MACRO(MSG_INVALID_ARCHIVE_PATH archive)
	MESSAGE(STATUS "")
	MESSAGE(STATUS "=============================================================================================")
	MESSAGE(STATUS " FATAL ERROR: Contrib archive ${archive} not found or invalid." )
	MESSAGE(STATUS "")
	MESSAGE(STATUS " - Please verify that ARCHIVES_PATH (${ARCHIVES_PATH}) is set correctly")
	MESSAGE(STATUS "")
	MESSAGE(STATUS " PLEASE NOTE: only use ARCHIVES_PATH if you plan to build an older contrib version" )
	MESSAGE(STATUS "")
	MESSAGE(STATUS "=============================================================================================")
	MESSAGE(STATUS "")
	MESSAGE(FATAL_ERROR "")
ENDMACRO()




