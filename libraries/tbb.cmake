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

IF(MSVC)
	SET(BUILDDIR "${CONTRIB_BINARY_SRC}/${PACKAGE_NAME}/build/vs2012")

	SET(TBB_BUILD_COMMAND ${MSBUILD} "/m:${THREADS}" "${BUILDDIR}/makefile.sln")
ELSE()
	SET(BUILDDIR "${CONTRIB_BINARY_SRC}/${PACKAGE_NAME}")

	SET(TBB_BUILD_COMMAND make "-j${THREADS}")
ENDIF()

CONFIGURE_FILE("${CONTRIB_LIBRARY_PATH}/tbb_install.cmake.in" "${CONTRIB_BINARY_SRC}/tbb_install.cmake" @ONLY)

ExternalProject_Add(${PACKAGE_NAME}

	URL "${CONTRIB_ARCHIVES_URL}/${${PACKAGE_NAME}_archive}"
	PREFIX ${PROJECT_BINARY_DIR}
	BUILD_IN_SOURCE ${CUSTOM_BUILD_IN_SOURCE}

	LOG_DOWNLOAD ${CUSTOM_LOG_DOWNLOAD}
	LOG_UPDATE ${CUSTOM_LOG_UPDATE}
	LOG_CONFIGURE ${CUSTOM_LOG_CONFIGURE}
	LOG_BUILD ${CUSTOM_LOG_BUILD}
	LOG_INSTALL ${CUSTOM_LOG_INSTALL}

	CONFIGURE_COMMAND ""
	BUILD_COMMAND ${TBB_BUILD_COMMAND}
	INSTALL_COMMAND "${CMAKE_COMMAND}" -Dconfig=${CONTRIB_BUILD_TYPE} -P "${CONTRIB_BINARY_SRC}/tbb_install.cmake"
)

# On Mac OS X we have to use absolute paths as install names for dylibs
IF(APPLE)
	FIX_DYLIB_INSTALL_NAMES(libtbb)
ENDIF()

MSG_CONFIGURE_PACKAGE_END("${PACKAGE_NAME}")
