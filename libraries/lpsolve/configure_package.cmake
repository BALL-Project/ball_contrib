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
SET(PACKAGE_ARCHIVE "lp_solve_5.5.2.0_source.tar.gz")
SET(ARCHIVE_MD5 "167c0fb4ab178e0b7ab50bf0a635a836")
FETCH_PACKAGE_ARCHIVE(${PACKAGE_ARCHIVE} ${ARCHIVE_MD5})


IF(OS_WINDOWS)

	# Windows

ELSE()

	# Linux / Darwin

	ExternalProject_Add(${PACKAGE_NAME}

		URL "${CONTRIB_ARCHIVES_PATH}/${PACKAGE_ARCHIVE}"
		PREFIX ${PROJECT_BINARY_DIR}

		BUILD_IN_SOURCE ${CUSTOM_BUILD_IN_SOURCE}

		LOG_DOWNLOAD ${CUSTOM_LOG_DOWNLOAD}
		LOG_UPDATE ${CUSTOM_LOG_UPDATE}
		LOG_CONFIGURE ${CUSTOM_LOG_CONFIGURE}
		LOG_BUILD ${CUSTOM_LOG_BUILD}
		LOG_INSTALL ${CUSTOM_LOG_INSTALL}

		CONFIGURE_COMMAND ""
		BUILD_COMMAND ""
		INSTALL_COMMAND ""
	)

	# Build step
	ExternalProject_Add_Step(${PACKAGE_NAME} custom_build
		WORKING_DIRECTORY "${CONTRIB_BINARY_SRC}/${PACKAGE_NAME}/lpsolve55/"
		COMMAND sh "ccc.osx"
		LOG 1
		DEPENDEES install
	)

	# Install library
	ExternalProject_Add_Step(${PACKAGE_NAME} custom_install_lib
		COMMAND find "${CONTRIB_BINARY_SRC}/${PACKAGE_NAME}/lpsolve55/bin" -iname "liblpsolve55*" | xargs -I {} install {} "${CONTRIB_INSTALL_LIB}"
		DEPENDEES custom_build
	)

	# Install headers
	ExternalProject_Add_Step(${PACKAGE_NAME} custom_install_headers
		COMMAND cd "${CONTRIB_BINARY_SRC}/${PACKAGE_NAME}/" && install -d "${CONTRIB_INSTALL_INC}/lpsolve"
		COMMAND find "${CONTRIB_BINARY_SRC}/${PACKAGE_NAME}/" -iname "*.h" | xargs -I {} install {} "${CONTRIB_INSTALL_INC}/lpsolve"
		DEPENDEES custom_install_lib
	)

ENDIF()

MSG_CONFIGURE_PACKAGE_END("${PACKAGE_NAME}")
