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

# We need bzip2 and zlib sources for boost::iostreams

# We add both as an external project without build step,
# since they are being built by boost itself

SET(BZIP2_NAME "bzip2")
ExternalProject_Add("${BZIP2_NAME}"

	GIT_REPOSITORY "${GITHUB_PTH_URL}/${BZIP2_NAME}.git"

	PREFIX ${PROJECT_BINARY_DIR}

	LOG_DOWNLOAD ${CUSTOM_LOG_DOWNLOAD}
	LOG_UPDATE ${CUSTOM_LOG_UPDATE}

	CONFIGURE_COMMAND ""
	BUILD_COMMAND ""
	INSTALL_COMMAND ""
)

SET(ZLIB_NAME "zlib")
ExternalProject_Add("${ZLIB_NAME}"

	GIT_REPOSITORY "${GITHUB_PTH_URL}/${ZLIB_NAME}.git"

	PREFIX ${PROJECT_BINARY_DIR}

	LOG_DOWNLOAD ${CUSTOM_LOG_DOWNLOAD}
	LOG_UPDATE ${CUSTOM_LOG_UPDATE}

	CONFIGURE_COMMAND ""
	BUILD_COMMAND ""
	INSTALL_COMMAND ""
)

# Set system dependent variables
SET(BOOTSTRAP_COMMAND "./bootstrap.sh")
IF(OS_WINDOWS)
	SET(BOOTSTRAP_COMMAND "bootstrap.bat")
ENDIF()

# Determine the correct b2 switches according to build type and platform
SET(BOOST_BUILD_TYPE "release")

IF(CMAKE_BUILD_TYPE STREQUAL "Debug")
	SET(BOOST_BUILD_TYPE "debug")
ENDIF()

IF(CMAKE_BUILD_TYPE STREQUAL "RelWithDebInfo")
	SET(BOOST_BUILD_TYPE "release debug-symbols=on")
ENDIF()

# Add project
ExternalProject_Add(${PACKAGE_NAME}

	DEPENDS "bzip2" "zlib"

	GIT_REPOSITORY "${GITHUB_PTH_URL}/${PACKAGE_NAME}.git"
	GIT_TAG "ball_contrib-1.4.3"

	PREFIX ${PROJECT_BINARY_DIR}

	BUILD_IN_SOURCE ${CUSTOM_BUILD_IN_SOURCE}

	LOG_DOWNLOAD ${CUSTOM_LOG_DOWNLOAD}
	LOG_UPDATE ${CUSTOM_LOG_UPDATE}
	LOG_CONFIGURE ${CUSTOM_LOG_CONFIGURE}
	LOG_BUILD ${CUSTOM_LOG_BUILD}
	LOG_INSTALL ${CUSTOM_LOG_INSTALL}

	CONFIGURE_COMMAND ${BOOTSTRAP_COMMAND}

	BUILD_COMMAND ./b2 install
	-j "${N_MAKE_THREADS}"
	--prefix=${CONTRIB_INSTALL_BASE}
	--with-chrono
	--with-date_time
	--with-iostreams
	--with-regex
	--with-serialization
	--with-system
	--with-thread
	--layout=tagged
	-sBZIP2_SOURCE=${CONTRIB_BINARY_SRC}/${BZIP2_NAME}
	-sZLIB_SOURCE=${CONTRIB_BINARY_SRC}/${ZLIB_NAME}
	link=shared
	threading=multi
	variant=${BOOST_BUILD_TYPE}
	address-model=${BITS}

	INSTALL_COMMAND ""
)

MSG_CONFIGURE_PACKAGE_END("${PACKAGE_NAME}")
