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
SET(PACKAGE_ARCHIVE "openbabel-2.3.2-devel.tar.gz")
SET(ARCHIVE_MD5 "0c8b74066fb978311a03ef99780fee34")
FETCH_PACKAGE_ARCHIVE(${PACKAGE_ARCHIVE} ${ARCHIVE_MD5})


# Add project
ExternalProject_Add(${PACKAGE_NAME}

	DEPENDS eigen3

	URL "${CONTRIB_ARCHIVES_PATH}/${PACKAGE_ARCHIVE}"
	PREFIX ${PROJECT_BINARY_DIR}

	BUILD_IN_SOURCE 1

	LOG_DOWNLOAD 1
	LOG_UPDATE 1
	LOG_CONFIGURE 1
	LOG_BUILD 1
	LOG_INSTALL 1

	CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CONTRIB_INSTALL_BASE}
		   -DCMAKE_PREFIX_PATH=${CONTRIB_INSTALL_BASE}
		   -DBUILD_GUI=OFF
		   -DWITH_INCHI=OFF
		   -DMINIMAL_BUILD=ON
		   -DENABLE_TESTS=OFF
		   -DOB_USE_PREBUILT_BINARIES=OFF # Relevant only on windows systems
		   -Wno-dev
)

ExternalProject_Add_Step(${PACKAGE_NAME} patch_1
	WORKING_DIRECTORY "${CONTRIB_BINARY_SRC}/${PACKAGE_NAME}"
	COMMAND ${PROGRAM_PATCH} -p0 --binary -b -N -i "${CONTRIB_LIBRARY_PATH}/${PACKAGE_NAME}/patches/CMakeLists.txt.diff"
	DEPENDEES download
	DEPENDERS configure
)

MSG_CONFIGURE_PACKAGE_END("${PACKAGE_NAME}")
