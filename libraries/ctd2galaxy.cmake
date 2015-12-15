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

LIST(APPEND DOWNLOAD_ARCHIVES "ctdopts")

# For CTD2Galaxy we need CTDopts, Python and the lxml python module
# First, we make sure that Python is installed and that the lxml module is available
# We will then clone CTD2Galaxy and CTDopts

FIND_PACKAGE(PythonInterp)
IF (PYTHONINTERP_FOUND)

	# check that lxml has been installed
	EXECUTE_PROCESS(COMMAND ${PYTHON_EXECUTABLE} -c 
		"from lxml.etree import Element; Element('dummy');"
		OUTPUT_VARIABLE stdout 
		ERROR_VARIABLE stderr 
		RESULT_VARIABLE exit_code 
		OUTPUT_STRIP_TRAILING_WHITESPACE 
		ERROR_STRIP_TRAILING_WHITESPACE)

	IF(NOT exit_code EQUAL 0)
	
		MESSAGE(WARNING "CTD2Galaxy requires the lxml python module. BALLaxy will not be built. "
						"Reported error: ${stderr}")
		
	ELSE()
	
		MESSAGE(STATUS "lxml python module found")
		# install CTDopts/CTD2Galaxy (since it's just a python script, there's no need to configure or build)
		ExternalProject_Add(ctdopts

			#URL "${CONTRIB_ARCHIVES_URL}/${ctdopts_archive}"
			URL "file:///Users/delagarza/Projects/${ctdopts_archive}"
			PREFIX ${PROJECT_BINARY_DIR}
			BUILD_IN_SOURCE ${CUSTOM_BUILD_IN_SOURCE}

			LOG_DOWNLOAD ${CUSTOM_LOG_DOWNLOAD}
			LOG_UPDATE ${CUSTOM_LOG_UPDATE}
			LOG_CONFIGURE ${CUSTOM_LOG_CONFIGURE}
			LOG_BUILD ${CUSTOM_LOG_BUILD}
			LOG_INSTALL ${CUSTOM_LOG_INSTALL}

			CONFIGURE_COMMAND ""
			BUILD_COMMAND ""
			INSTALL_COMMAND ${PYTHON_EXECUTABLE} setup.py install
		)
	
		ExternalProject_Add(${PACKAGE_NAME}
	
			#URL "${CONTRIB_ARCHIVES_URL}/${${PACKAGE_NAME}_archive}"
			URL "file:///Users/delagarza/Projects/${${PACKAGE_NAME}_archive}"
			PREFIX ${PROJECT_BINARY_DIR}
			BUILD_IN_SOURCE ${CUSTOM_BUILD_IN_SOURCE}

			LOG_DOWNLOAD ${CUSTOM_LOG_DOWNLOAD}
			LOG_UPDATE ${CUSTOM_LOG_UPDATE}
			LOG_CONFIGURE ${CUSTOM_LOG_CONFIGURE}
			LOG_BUILD ${CUSTOM_LOG_BUILD}
			LOG_INSTALL ${CUSTOM_LOG_INSTALL}

			CONFIGURE_COMMAND ""
			BUILD_COMMAND ""
			INSTALL_COMMAND ${PYTHON_EXECUTABLE} setup.py install
		)	
	ENDIF()	
	
ELSE()
	MESSAGE(WARNING "Python interpreter was not found. BALLaxy will not be built.")
ENDIF()


MSG_CONFIGURE_PACKAGE_END("${PACKAGE_NAME}")






