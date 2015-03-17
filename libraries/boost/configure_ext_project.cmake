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

# Download package
SET(PACKAGE_TARBALL "boost_1_54_0.tar.gz")
SET(PACKAGE_MD5 "efbfbff5a85a9330951f243d0a46e4b9")
DOWNLOAD_PACKAGE_TARBALL(${PACKAGE_TARBALL} ${PACKAGE_MD5})


IF(MSVC)

	# Windows

ELSE()

	# Linux / Darwin

	ExternalProject_Add(${PACKAGE_NAME}

		DEPENDS bzip2 zlib

		URL "${CONTRIB_PACKAGE_PATH}/${PACKAGE_TARBALL}"
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
		-sBZIP2_INCLUDE=${CONTRIB_INSTALL_INCLUDE} -sBZIP2_LIBPATH=${CONTRIB_INSTALL_LIB}
		-sZLIB_INCLUDE=${CONTRIB_INSTALL_INCLUDE} -sZLIB_LIBPATH=${CONTRIB_INSTALL_LIB}

		INSTALL_COMMAND ""
	)



ENDIF()

MSG_CONFIGURE_PACKAGE_END("${PACKAGE_NAME}")

