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
	IF(MSVC_VERSION EQUAL "1800")
		SET(BUILDDIR "${CONTRIB_BINARY_SRC}/${PACKAGE}/vs2013")
	ELSEIF(MSVC_VERSION EQUAL "1900")
		SET(BUILDDIR "${CONTRIB_BINARY_SRC}/${PACKAGE}/vs2015")
	ENDIF()

	SET(FFTW3_CONFIGURE_COMMAND "cmd" "/c echo nothing to do")
	SET(FFTW3_BUILD_COMMAND ${MSBUILD} "${BUILDDIR}/fftw-3.3-libs.sln")
	SET(FFTW3_INSTALL_COMMAND "${CMAKE_COMMAND}" -Dconfig=${CONTRIB_BUILD_TYPE} -P "${CONTRIB_BINARY_SRC}/fftw_install.cmake")

	CONFIGURE_FILE("${CONTRIB_LIBRARY_PATH}/fftw_install.cmake.in" "${CONTRIB_BINARY_SRC}/fftw_install.cmake" @ONLY)
ELSE()
	SET(FFTW3_CONFIGURE_COMMAND ./configure --prefix=${CONTRIB_INSTALL_PREFIX} --enable-shared --with-pic)
	SET(FFTW3_BUILD_COMMAND ${MAKE_COMMAND})
	SET(FFTW3_INSTALL_COMMAND ${MAKE_INSTALL_COMMAND})
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

	CONFIGURE_COMMAND ${FFTW3_CONFIGURE_COMMAND}
	BUILD_COMMAND ${FFTW3_BUILD_COMMAND}
	INSTALL_COMMAND ${FFTW3_INSTALL_COMMAND}
)

# On Mac OS X we have to use absolute paths as install names for dylibs
IF(APPLE)
	FIX_DYLIB_INSTALL_NAMES(libfftw)
ENDIF()
