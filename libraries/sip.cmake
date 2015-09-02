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

SET(Python_ADDITIONAL_VERSIONS 2.7 2.6)

INCLUDE(FindPythonLibs)
IF(NOT PYTHONLIBS_FOUND)
	MESSAGE(FATAL_ERROR "No python libraries found. Required to build SIP.")
ENDIF()

INCLUDE(FindPythonInterp)
IF(NOT PYTHONINTERP_FOUND)
	MESSAGE(FATAL_ERROR "No python interpreter found. Required to build SIP.")
ENDIF()

# Ensure that the python version is compatible with what we want to build
EXECUTE_PROCESS(COMMAND ${PYTHON_EXECUTABLE} -c "import struct; print struct.calcsize(\"P\") * 8"
	RESULT_VARIABLE RUN_PYTHON_SUCCESS
	OUTPUT_VARIABLE PYTHON_BITSIZE)

IF(NOT RUN_PYTHON_SUCCESS EQUAL 0)
	MESSAGE(FATAL_ERROR "Could not execute python. Required to build SIP. Error: ${RUN_PYTHON_SUCCESS}")
ENDIF()

STRING(STRIP ${PYTHON_BITSIZE} PYTHON_BITSIZE)
IF(NOT PYTHON_BITSIZE EQUAL CONTRIB_ADDRESSMODEL)
	MESSAGE(FATAL_ERROR "Python was built for a different address model. Please install appropriate version.")
ENDIF()

IF(MSVC)
	SET(BUILD_TOOL "nmake")
ELSE()
	SET(BUILD_TOOL "make")
ENDIF()

ExternalProject_Add(${PACKAGE_NAME}

	URL "${CONTRIB_ARCHIVES_URL}/${${PACKAGE_NAME}_archive}"
	PREFIX ${PROJECT_BINARY_DIR}
	BUILD_IN_SOURCE ${CUSTOM_BUILD_IN_SOURCE}

	LOG_DOWNLOAD ${CUSTOM_LOG_DOWNLOAD}
	LOG_UPDATE ${CUSTOM_LOG_UPDATE}
	LOG_CONFIGURE ${CUSTOM_LOG_CONFIGURE}
	LOG_BUILD ${CUSTOM_LOG_BUILD}
	LOG_INSTALL ${CUSTOM_LOG_INSTALL}

	CONFIGURE_COMMAND python configure.py -b "${CONTRIB_INSTALL_BIN}" -d "${CONTRIB_INSTALL_LIB}" -e "${CONTRIB_INSTALL_INC}"
	BUILD_COMMAND ${BUILD_TOOL}
	INSTALL_COMMAND ${BUILD_TOOL} install
)

MSG_CONFIGURE_PACKAGE_END("${PACKAGE_NAME}")
