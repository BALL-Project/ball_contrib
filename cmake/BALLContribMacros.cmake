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


MACRO(CHECK_PACKAGE_TARBALL tarball md5sum package_valid)

	# Check if tarball has already been downloaded
	IF(EXISTS "${CONTRIB_PACKAGE_PATH}/${tarball}")

		FILE(MD5 "${CONTRIB_PACKAGE_PATH}/${tarball}" PACKAGE_MD5)

		# Check if tarball MD5 sum is correct
		IF("${PACKAGE_MD5}" STREQUAL "${md5sum}")
			SET(${package_valid} TRUE)
		ENDIF()

	ENDIF()

ENDMACRO()


MACRO(DOWNLOAD_PACKAGE_TARBALL tarball md5sum)

	MESSAGE(STATUS "Downloading: ${tarball}")

	SET(PACKAGE_VALID FALSE)

	CHECK_PACKAGE_TARBALL("${tarball}" "${md5sum}" PACKAGE_VALID)

	# Try download from mirror 1
	IF(NOT PACKAGE_VALID)

		FILE(DOWNLOAD
			"${CONTRIB_PACKAGES_URL_1}/${tarball}"
			"${CONTRIB_PACKAGE_PATH}/${tarball}"
		)

	ENDIF()

	CHECK_PACKAGE_TARBALL("${tarball}" "${md5sum}" PACKAGE_VALID)

	# Try download from mirror 1
	IF(NOT PACKAGE_VALID)

		FILE(DOWNLOAD
			"${CONTRIB_PACKAGES_URL_2}/${tarball}"
			"${CONTRIB_PACKAGE_PATH}/${tarball}"
		)

	ENDIF()

	CHECK_PACKAGE_TARBALL("${tarball}" "${md5sum}" PACKAGE_VALID)

	IF(NOT PACKAGE_VALID)
		MSG_DOWNLOAD_FAILED("${tarball}")
	ENDIF()

ENDMACRO()


MACRO(MSG_CONFIGURE_PACKAGE_BEGIN package_name)
	MESSAGE(STATUS "Configuring project: ${package_name}")
ENDMACRO()


MACRO(MSG_CONFIGURE_PACKAGE_END package_name)
	MESSAGE(STATUS "Configuring ${package_name} - done")
ENDMACRO()

MACRO(MSG_DOWNLOAD_FAILED tarball)
	MESSAGE(STATUS "")
	MESSAGE(STATUS "===========================================================================")
	MESSAGE(STATUS " FATAL ERROR: Download of contrib package failed: ${tarball}")
	MESSAGE(STATUS "")
	MESSAGE(STATUS " - Please verify that your internet connection works and try again.")
	MESSAGE(STATUS " - If this error occurrs again please contact the developers.")
	MESSAGE(STATUS "===========================================================================")
	MESSAGE(STATUS "")
	MESSAGE(FATAL_ERROR "")
ENDMACRO()





