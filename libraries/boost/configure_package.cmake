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

# We add both as an external project without build step, since they are being built
# by boost itself

# bzip2 is not hosted officially on github, so we offer a fork
ExternalProject_Add("bzip2"

	GIT_REPOSITORY "https://github.com/ball-project/ball_contrib_bzip2"

	PREFIX ${PROJECT_BINARY_DIR}

	LOG_DOWNLOAD ${CUSTOM_LOG_DOWNLOAD}
	LOG_UPDATE ${CUSTOM_LOG_UPDATE}
	LOG_CONFIGURE ${CUSTOM_LOG_CONFIGURE}
	LOG_BUILD ${CUSTOM_LOG_BUILD}
	LOG_INSTALL ${CUSTOM_LOG_INSTALL}

	CONFIGURE_COMMAND ""
	BUILD_COMMAND ""
	INSTALL_COMMAND ""
)
SET(BZIP2_NAME "bzip2")

ExternalProject_Add("zlib"

	GIT_REPOSITORY "https://github.com/madler/zlib.git"

	PREFIX ${PROJECT_BINARY_DIR}

	LOG_DOWNLOAD ${CUSTOM_LOG_DOWNLOAD}
	LOG_UPDATE ${CUSTOM_LOG_UPDATE}
	LOG_CONFIGURE ${CUSTOM_LOG_CONFIGURE}
	LOG_BUILD ${CUSTOM_LOG_BUILD}
	LOG_INSTALL ${CUSTOM_LOG_INSTALL}

	CONFIGURE_COMMAND ""
	BUILD_COMMAND ""
	INSTALL_COMMAND ""
)
SET(ZLIB_NAME "zlib")

# Set system dependent variables
SET(BOOTSTRAP_COMMAND "./bootstrap.sh")

IF(OS_WINDOWS)
	SET(BOOTSTRAP_COMMAND "bootstrap.bat")
ENDIF()


# Add project
ExternalProject_Add(${PACKAGE_NAME}

	DEPENDS "bzip2" "zlib"

	GIT_REPOSITORY "git@github.com:boostorg/boost.git"

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
	threading=multi
	variant=release
	-sBZIP2_SOURCE=${CONTRIB_BINARY_SRC}/${BZIP2_NAME} -sZLIB_SOURCE=${CONTRIB_BINARY_SRC}/${ZLIB_NAME}

	INSTALL_COMMAND ""
)

ExternalProject_Add_Step(${PACKAGE_NAME} patch_1
		WORKING_DIRECTORY "${CONTRIB_BINARY_SRC}/${PACKAGE_NAME}/boost/"
        COMMAND ${PROGRAM_PATCH} -p0 --binary -b -N -i "${CONTRIB_LIBRARY_PATH}/${PACKAGE_NAME}/patches/patch_boost_cstdint.hpp"
        DEPENDEES download
        DEPENDERS configure
)

MSG_CONFIGURE_PACKAGE_END("${PACKAGE_NAME}")
