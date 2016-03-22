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


# Check Python installation
SET(Python_ADDITIONAL_VERSIONS 2.7 2.6)

INCLUDE(FindPythonLibs)
IF(NOT PYTHONLIBS_FOUND)
	MESSAGE(FATAL_ERROR "No python libraries found. Required to build SIP.")
ENDIF()

INCLUDE(FindPythonInterp)
IF(NOT PYTHONINTERP_FOUND)
	MESSAGE(FATAL_ERROR "No python interpreter found. Required to build SIP and CTD2Galaxy.")
ENDIF()

EXECUTE_PROCESS(COMMAND ${PYTHON_EXECUTABLE} -c "import struct; print struct.calcsize(\"P\") * 8"
		RESULT_VARIABLE RUN_PYTHON_SUCCESS
		OUTPUT_VARIABLE PYTHON_BITSIZE)

IF(NOT RUN_PYTHON_SUCCESS EQUAL 0)
	MESSAGE(FATAL_ERROR "Could not execute python. Required to build SIP and CTD2Galaxy. Error: ${RUN_PYTHON_SUCCESS}")
ENDIF()

STRING(STRIP ${PYTHON_BITSIZE} PYTHON_BITSIZE)
IF(NOT PYTHON_BITSIZE EQUAL CONTRIB_ADDRESSMODEL)
	MESSAGE(FATAL_ERROR "Python was built for a different address model. Please install appropriate version.")
ENDIF()
