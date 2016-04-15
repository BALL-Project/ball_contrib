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

SET(SIP_CONFIGURE_OPTIONS "")
IF(CONTRIB_BUILD_TYPE STREQUAL "Debug")
	LIST(APPEND SIP_CONFIGURE_OPTIONS "-u")
ENDIF()

IF(MSVC)
	SET(SIP_BUILD_COMMAND nmake)
	SET(SIP_INSTALL_COMMAND "${CMAKE_COMMAND}" -P "${CONTRIB_BINARY_SRC}/sip_install.cmake")

	CONFIGURE_FILE("${CONTRIB_LIBRARY_PATH}/sip_install.cmake.in" "${CONTRIB_BINARY_SRC}/sip_install.cmake" @ONLY)
ELSE()
	SET(SIP_BUILD_COMMAND make)
	SET(SIP_INSTALL_COMMAND make install)

	LIST(APPEND SIP_CONFIGURE_OPTIONS -b "${CONTRIB_INSTALL_BIN}" -d "${CONTRIB_INSTALL_LIB}" -e "${CONTRIB_INSTALL_INC}")
ENDIF()

# Add project
ExternalProject_Add(${PACKAGE_NAME}

	URL "${CONTRIB_ARCHIVES_PATH}/${${PACKAGE_NAME}_archive}"
	PREFIX ${PROJECT_BINARY_DIR}
	BUILD_IN_SOURCE ${CUSTOM_BUILD_IN_SOURCE}

	LOG_DOWNLOAD ${CUSTOM_LOG_DOWNLOAD}
	LOG_UPDATE ${CUSTOM_LOG_UPDATE}
	LOG_CONFIGURE ${CUSTOM_LOG_CONFIGURE}
	LOG_BUILD ${CUSTOM_LOG_BUILD}
	LOG_INSTALL ${CUSTOM_LOG_INSTALL}

	CONFIGURE_COMMAND ${PYTHON_EXECUTABLE} configure.py
	BUILD_COMMAND ${SIP_BUILD_COMMAND}
	INSTALL_COMMAND ${SIP_INSTALL_COMMAND}
)

MSG_CONFIGURE_PACKAGE_END("${PACKAGE_NAME}")
