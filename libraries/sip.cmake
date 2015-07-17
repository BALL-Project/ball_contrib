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

# TODO: ensure that flex, bison, and python mercurial bindings are installed
MSG_CONFIGURE_PACKAGE_BEGIN("${PACKAGE_NAME}")

SET(Python_ADDITIONAL_VERSIONS 2.7 2.6)
FIND_PACKAGE(PythonInterp QUIET)

IF(NOT PYTHONINTERP_FOUND)
	MESSAGE(SEND_ERROR "sip requires a python interpreter. "
		"Try specifying PYTHON_EXECUTABLE on the cmake command line.")
ENDIF()

FIND_PACKAGE(PythonLibs QUIET)

IF(NOT PYTHONINTERP_FOUND)
	MESSAGE(SEND_ERROR "sip requires the python libraries and headers. "
		"Try specifying PYTHON_LIBRARY and PYTHON_INCLUDE_DIR on the cmake command line.")
ENDIF()

# Ensure that the python version is compatible with what we want to build
EXECUTE_PROCESS(COMMAND ${PYTHON_EXECUTABLE} -c "import struct; print struct.calcsize(\"P\") * 8"
	RESULT_VARIABLE RUN_PYTHON_SUCCESS
	OUTPUT_VARIABLE PYTHON_BITSIZE)

IF(NOT RUN_PYTHON_SUCCESS EQUAL 0)
	MESSAGE(SEND_ERROR "Could not execute python! (Error: ${RUN_PYTHON_SUCCESS})")
ENDIF()

STRING(STRIP ${PYTHON_BITSIZE} PYTHON_BITSIZE)
IF(NOT PYTHON_BITSIZE EQUAL BITS)
	MESSAGE(SEND_ERROR "The python interpreter was built for a different bitsize (${PYTHON_BITSIZE}) "
		"from that of the contrib libraries (${BITS})! Try pointing PYTHON_EXECUTABLE to a suitable version of python "
		"at the cmake command line!")
ENDIF()

IF(MSVC)
	IF(N_MAKE_THREADS GREATER 1)
		FILE(WRITE "${CONTRIB_BINARY_SRC}/${PACKAGE_NAME}/build.bat" "set CL=/MP\nnmake")
	ELSE()
		FILE(WRITE "${CONTRIB_BINARY_SRC}/${PACKAGE_NAME}/build.bat" "nmake")
	ENDIF()

	SET(SIP_BUILD_COMMAND "${CONTRIB_BINARY_SRC}/${PACKAGE_NAME}/build.bat")
	SET(SIP_INSTALL_COMMAND nmake install)
ELSE()
	SET(SIP_BUILD_COMMAND make -j "${N_MAKE_THREADS}")
	SET(SIP_INSTALL_COMMAND make install)
ENDIF()

ExternalProject_Add(${PACKAGE_NAME}

	GIT_REPOSITORY "${GITHUB_BASE_URL}/${PACKAGE_NAME}.git"
	GIT_TAG "ball-contrib"
	GIT_DEPTH 1

	PREFIX ${PROJECT_BINARY_DIR}

	BUILD_IN_SOURCE ${CUSTOM_BUILD_IN_SOURCE}

	LOG_DOWNLOAD ${CUSTOM_LOG_DOWNLOAD}
	LOG_UPDATE ${CUSTOM_LOG_UPDATE}
	LOG_CONFIGURE ${CUSTOM_LOG_CONFIGURE}
	LOG_BUILD ${CUSTOM_LOG_BUILD}
	LOG_INSTALL ${CUSTOM_LOG_INSTALL}

	#CONFIGURE_COMMAND python build.py prepare
	CONFIGURE_COMMAND ${PYTHON_EXECUTABLE} configure.py -b "${CONTRIB_INSTALL_BIN}" -d "${CONTRIB_INSTALL_LIB}" -e "${CONTRIB_INSTALL_INC}"
	BUILD_COMMAND ${SIP_BUILD_COMMAND}
	INSTALL_COMMAND ${SIP_INSTALL_COMMAND}
)

MSG_CONFIGURE_PACKAGE_END("${PACKAGE_NAME}")
