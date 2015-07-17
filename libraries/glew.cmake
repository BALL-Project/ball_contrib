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

IF(MSVC) # Windows
	SET(BUILDDIR "${PROJECT_BINARY_DIR}/src/glew/build/vc12")
	IF(MSVC10)
		SET(BUILDDIR "${PROJECT_BINARY_DIR}/src/glew/build/vc10")
	ENDIF()

	SET(GLEW_BUILD_COMMAND ${MSBUILD} "/m:${N_MAKE_THREADS}" "${BUILDDIR}/glew.sln")
  SET(GLEW_INSTALL_COMMAND "${CMAKE_COMMAND}" -Dconfig=${CMAKE_CFG_INTDIR} -P ${BUILDDIR}/glew_install.cmake)

	SET(DOLLAR "$") # Don't ask... please, please, don't ask...
	CONFIGURE_FILE(${PROJECT_SOURCE_DIR}/libraries/glew_install.cmake.in ${BUILDDIR}/glew_install.cmake)
ELSE() # Linux / Darwin
	SET(GLEW_BUILD_COMMAND make "-j${N_MAKE_THREADS}")
	SET(GLEW_INSTALL_COMMAND make "-j${N_MAKE_THREADS}")
ENDIF()


ExternalProject_Add(${PACKAGE_NAME}

	PREFIX ${PROJECT_BINARY_DIR}

	GIT_REPOSITORY "${GITHUB_BASE_URL}/${PACKAGE_NAME}.git"
	GIT_TAG "ball-contrib"
	GIT_DEPTH 1

	BUILD_IN_SOURCE ${CUSTOM_BUILD_IN_SOURCE}

	LOG_DOWNLOAD ${CUSTOM_LOG_DOWNLOAD}
	LOG_UPDATE ${CUSTOM_LOG_UPDATE}
	LOG_CONFIGURE ${CUSTOM_LOG_CONFIGURE}
	LOG_BUILD ${CUSTOM_LOG_BUILD}
	LOG_INSTALL ${CUSTOM_LOG_INSTALL}

	CONFIGURE_COMMAND ""
	BUILD_COMMAND ${GLEW_BUILD_COMMAND}
	INSTALL_COMMAND ${GLEW_INSTALL_COMMAND}
)

MSG_CONFIGURE_PACKAGE_END("${PACKAGE_NAME}")
