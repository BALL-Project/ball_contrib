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


###############################################################################
###    Determine appropriate system settings                                ###
###############################################################################

SET(OS_LINUX FALSE)
SET(OS_DARWIN FALSE)
SET(OS_WINDOWS FALSE)

IF(${CMAKE_SYSTEM_NAME} MATCHES "Linux")
	SET(OS_LINUX TRUE)
ELSEIF(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
	SET(OS_DARWIN TRUE)
ELSEIF(${CMAKE_SYSTEM_NAME} MATCHES "Windows")
	SET(OS_WINDOWS TRUE)
ELSE()
	MESSAGE(FATAL_ERROR "The underlying system (${CMAKE_SYSTEM_NAME}) is not supported.")
ENDIF()
