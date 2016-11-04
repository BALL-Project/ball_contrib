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


IF(MSVC)
	SET(GLEW_BUILD_COMMAND "")
	SET(GLEW_INSTALL_COMMAND "")

	SET(GLEW_ARCH_DIR "x64")
	IF(${CONTRIB_ADDRESSMODEL} EQUAL 32)
		SET(GLEW_ARCH_DIR "Win32")
	ENDIF()
ELSE()
	SET(GLEW_BUILD_COMMAND env GLEW_DEST=${CONTRIB_INSTALL_PREFIX} ${MAKE_COMMAND} STRIP=strip)
	SET(GLEW_INSTALL_COMMAND env GLEW_DEST=${CONTRIB_INSTALL_PREFIX} ${MAKE_INSTALL_COMMAND})
ENDIF()


ExternalProject_Add(${PACKAGE}

	PREFIX ${PROJECT_BINARY_DIR}
	DOWNLOAD_COMMAND ""
	BUILD_IN_SOURCE ${CUSTOM_BUILD_IN_SOURCE}

	LOG_DOWNLOAD ${CUSTOM_LOG_DOWNLOAD}
	LOG_UPDATE ${CUSTOM_LOG_UPDATE}
	LOG_CONFIGURE ${CUSTOM_LOG_CONFIGURE}
	LOG_BUILD ${CUSTOM_LOG_BUILD}
	LOG_INSTALL ${CUSTOM_LOG_INSTALL}

	CONFIGURE_COMMAND ""
	BUILD_COMMAND "${GLEW_BUILD_COMMAND}"
	INSTALL_COMMAND "${GLEW_INSTALL_COMMAND}"
)

IF(MSVC)
	# Add custom install step for Windows
	ExternalProject_Add_Step(${PACKAGE} custom_install

		LOG 1
		DEPENDEES build

		WORKING_DIRECTORY "${CONTRIB_BINARY_SRC}"
		COMMAND ${CMAKE_COMMAND} -E copy_directory ${PACKAGE}/include/GL ${CONTRIB_INSTALL_INC}/GL
		COMMAND ${CMAKE_COMMAND} -E copy ${PACKAGE}/bin/Release/${GLEW_ARCH_DIR}/glew32.dll ${CONTRIB_INSTALL_LIB}
		COMMAND ${CMAKE_COMMAND} -E copy ${PACKAGE}/lib/Release/${GLEW_ARCH_DIR}/glew32.lib ${CONTRIB_INSTALL_LIB}
		COMMAND ${CMAKE_COMMAND} -E copy ${PACKAGE}/lib/Release/${GLEW_ARCH_DIR}/glew32s.lib ${CONTRIB_INSTALL_LIB}

		DEPENDERS install
	)
ENDIF()
