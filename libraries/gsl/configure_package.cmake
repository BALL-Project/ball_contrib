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

MSG_CONFIGURE_PACKAGE_BEGIN("${PACKAGE_NAME}")

# Download archive
SET(PACKAGE_ARCHIVE "gsl-1.9.tar.gz")
SET(ARCHIVE_MD5 "81dca4362ae8d2aa1547b7d010881e43")
FETCH_PACKAGE_ARCHIVE(${PACKAGE_ARCHIVE} ${ARCHIVE_MD5})


IF(OS_WINDOWS)

	# Windows

ELSE()

	# Linux / Darwin

	ExternalProject_Add(${PACKAGE_NAME}

		URL "${CONTRIB_ARCHIVES_PATH}/${PACKAGE_ARCHIVE}"
		PREFIX ${PROJECT_BINARY_DIR}

		BUILD_IN_SOURCE 1

		LOG_DOWNLOAD 1
		LOG_UPDATE 1
		LOG_CONFIGURE 1
		LOG_BUILD 1
		LOG_INSTALL 1

		CONFIGURE_COMMAND "${CONTRIB_BINARY_SRC}/${PACKAGE_NAME}/configure" --prefix=${CONTRIB_INSTALL_BASE}
		BUILD_COMMAND make
		INSTALL_COMMAND make install
	)


ENDIF()

MSG_CONFIGURE_PACKAGE_END("${PACKAGE_NAME}")
