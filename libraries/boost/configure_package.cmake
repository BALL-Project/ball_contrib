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
SET(PACKAGE_ARCHIVE "boost_1_57_0.tar.gz")
SET(ARCHIVE_MD5 "25f9a8ac28beeb5ab84aa98510305299")
FETCH_PACKAGE_ARCHIVE(${PACKAGE_ARCHIVE} ${ARCHIVE_MD5})

# Download Bzip2 archive
SET(BZIP2_NAME "bzip2-1.0.6")
SET(BZIP2_ARCHIVE "${BZIP2_NAME}.tar.gz")
SET(BZIP2_MD5 "00b516f4704d4a7cb50a1d97e6e8e15b")
FETCH_PACKAGE_ARCHIVE(${BZIP2_ARCHIVE} ${BZIP2_MD5})

# Download Zlib archive
SET(ZLIB_NAME "zlib-1.2.8")
SET(ZLIB_ARCHIVE "${ZLIB_NAME}.tar.gz")
SET(ZLIB_MD5 "44d667c142d7cda120332623eab69f40")
FETCH_PACKAGE_ARCHIVE(${ZLIB_ARCHIVE} ${ZLIB_MD5})


IF(MSVC)

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

		CONFIGURE_COMMAND "${CONTRIB_BINARY_SRC}/${PACKAGE_NAME}/bootstrap.sh"
		--with-libraries=chrono,date_time,iostreams,regex,serialization,system,thread

		BUILD_COMMAND "${CONTRIB_BINARY_SRC}/${PACKAGE_NAME}/b2"
		install
		--prefix=${CONTRIB_INSTALL_BASE}
		--layout=tagged
		threading=multi
		variant=release
		-sBZIP2_SOURCE=${CONTRIB_BINARY_SRC}/${BZIP2_NAME}
		-sZLIB_SOURCE=${CONTRIB_BINARY_SRC}/${ZLIB_NAME}

		INSTALL_COMMAND ""
	)

	# Extract bzip2 and zlib sources
	ExternalProject_Add_Step(${PACKAGE_NAME} bzip2_zlib
		WORKING_DIRECTORY "${CONTRIB_BINARY_SRC}"
		COMMAND tar -xzf "${CONTRIB_ARCHIVES_PATH}/${BZIP2_ARCHIVE}"
		COMMAND tar -xzf "${CONTRIB_ARCHIVES_PATH}/${ZLIB_ARCHIVE}"
		DEPENDEES configure
	)


ENDIF()

MSG_CONFIGURE_PACKAGE_END("${PACKAGE_NAME}")

