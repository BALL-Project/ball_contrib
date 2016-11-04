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


SET(SIP_CONFIGURE_OPTIONS "")
IF("${CMAKE_BUILD_TYPE}" STREQUAL "Debug")
	LIST(APPEND SIP_CONFIGURE_OPTIONS "-u")
ENDIF()

IF(MSVC)
	SET(SIP_BUILD_COMMAND nmake)
	SET(SIP_INSTALL_COMMAND "")
ELSE()
	SET(SIP_BUILD_COMMAND ${MAKE_COMMAND})
	SET(SIP_INSTALL_COMMAND ${MAKE_INSTALL_COMMAND})

	LIST(APPEND SIP_CONFIGURE_OPTIONS -b "${CONTRIB_INSTALL_BIN}" -d "${CONTRIB_INSTALL_LIB}" -e "${CONTRIB_INSTALL_INC}")
ENDIF()


ExternalProject_Add(${PACKAGE}

	GIT_REPOSITORY ${CONTRIB_GITHUB_BASE}/${pkg_${PACKAGE}}
	GIT_TAG ${CONTRIB_GIT_BRANCH}
	PREFIX ${PROJECT_BINARY_DIR}
	BUILD_IN_SOURCE ${CUSTOM_BUILD_IN_SOURCE}

	LOG_DOWNLOAD ${CUSTOM_LOG_DOWNLOAD}
	LOG_UPDATE ${CUSTOM_LOG_UPDATE}
	LOG_CONFIGURE ${CUSTOM_LOG_CONFIGURE}
	LOG_BUILD ${CUSTOM_LOG_BUILD}
	LOG_INSTALL ${CUSTOM_LOG_INSTALL}

	CONFIGURE_COMMAND ${PYTHON_EXECUTABLE} configure.py ${SIP_CONFIGURE_OPTIONS}
	BUILD_COMMAND ${SIP_BUILD_COMMAND}
	INSTALL_COMMAND "${SIP_INSTALL_COMMAND}"
)

# Add custom install step for Windows
IF(MSVC)
	ExternalProject_Add_Step(${PACKAGE} custom_install

		LOG 1
		DEPENDEES build

		WORKING_DIRECTORY "${CONTRIB_BINARY_SRC}"

		COMMAND ${CMAKE_COMMAND} -E copy ${PACKAGE}/sipgen/sip.exe ${CONTRIB_INSTALL_BIN}
		COMMAND ${CMAKE_COMMAND} -E copy ${PACKAGE}/siplib/sip.h ${CONTRIB_INSTALL_INC}
		COMMAND ${CMAKE_COMMAND} -E copy ${PACKAGE}/siplib/sip.pyd ${CONTRIB_INSTALL_LIB}
		COMMAND ${CMAKE_COMMAND} -E copy ${PACKAGE}/siplib/sip.lib ${CONTRIB_INSTALL_LIB}

		DEPENDERS install
	)
ENDIF()
