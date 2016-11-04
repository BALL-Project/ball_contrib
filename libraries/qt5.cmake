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


OPTION(SKIP_QTWEBENGINE "Skip building QtWebEngine." OFF)

FIND_PACKAGE(Perl QUIET)
IF(NOT PERL_EXECUTABLE)
	IF(NOT OS_WINDOWS)
                MESSAGE(SEND_ERROR "Compiling Qt requires Perl! Cannot continue!")
	ELSE()
                MESSAGE(SEND_ERROR "Compiling Qt requires Perl! Please install ActivePerl from http://www.activestate.com/downloads")
	ENDIF()
ENDIF()

# TODO: openssl

# Common configure options
SET(QT_CONFIGURE_OPTIONS -prefix ${CONTRIB_INSTALL_PREFIX}
			 -opensource
			 -confirm-license
			 -shared
			 -nomake examples
			 -no-nis
			 -no-harfbuzz
			 -skip qt3d
			 -skip qtcanvas3d
			 -skip qtconnectivity
			 -skip qtdoc
			 -skip qtgraphicaleffects
			 -skip qtimageformats
			 -skip qtquickcontrols2
			 -skip qtsensors
			 -skip qtserialbus
			 -skip qtserialport
			 -skip qtwayland
			 -skip qtwebview
)

# Set the appropriate build type
IF("${CMAKE_BUILD_TYPE}" STREQUAL "RelWithDebInfo")
	LIST(APPEND QT_CONFIGURE_OPTIONS -release -force-debug-info)
ELSE()
	STRING(TOLOWER "${CMAKE_BUILD_TYPE}" QT_BUILD_TYPE)
	LIST(APPEND QT_CONFIGURE_OPTIONS -${QT_BUILD_TYPE})
ENDIF()

# Check if QtWebEngine should be excluded
IF(SKIP_QTWEBENGINE)
	LIST(APPEND QT_CONFIGURE_OPTIONS -skip qtwebengine)
ENDIF()

# Platform-specific settings
IF(MSVC)
	SET(QT_CONFIGURE_COMMAND configure.bat)
	SET(QT_BUILD_COMMAND nmake)
	SET(QT_INSTALL_COMMAND nmake install)

	LIST(APPEND QT_CONFIGURE_OPTIONS -opengl dynamic)

	IF(MSVC_VERSION EQUAL "1800")
		LIST(APPEND QT_CONFIGURE_OPTIONS -platform win32-msvc2013)
	ELSEIF(MSVC_VERSION EQUAL "1900")
		LIST(APPEND QT_CONFIGURE_OPTIONS -platform win32-msvc2015)
	ENDIF()

	# Configure for multiple process build
	IF("${THREADS}" GREATER "1")
		LIST(APPEND QT_CONFIGURE_OPTIONS -mp)
	ENDIF()
ELSE()
	SET(QT_CONFIGURE_COMMAND ./configure)
	SET(QT_BUILD_COMMAND ${MAKE_COMMAND})
	SET(QT_INSTALL_COMMAND ${MAKE_INSTALL_COMMAND})

	# In case of Linux OS use xcb-libraries bundled with Qt
	IF(CMAKE_SYSTEM_NAME STREQUAL Linux)
		LIST(APPEND QT_CONFIGURE_OPTIONS -qt-xcb)
	ENDIF()
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

	CONFIGURE_COMMAND ${QT_CONFIGURE_COMMAND}
			  ${QT_CONFIGURE_OPTIONS}

	BUILD_COMMAND ${QT_BUILD_COMMAND}
	INSTALL_COMMAND ${QT_INSTALL_COMMAND}
)
