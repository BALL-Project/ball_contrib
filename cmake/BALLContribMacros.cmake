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
###    Macros                                                               ###
###############################################################################





###############################################################################
###    Messages                                                             ###
###############################################################################

MACRO(MSG_HELP)
	MESSAGE(STATUS "")
	MESSAGE(STATUS "===========================================================================")
	MESSAGE(STATUS "BALL contrib (dependency) packages installation system:")
	MESSAGE(STATUS "")
	MESSAGE(STATUS "* This program will allow you to compile and install all BALL dependencies.")
	MESSAGE(STATUS "* By default, all contrib packages are build. ")
	MESSAGE(STATUS "* Use the CMake variable -DWITH_PACKAGES to select only a subset for building.")
	MESSAGE(STATUS "  For multiple choices please use a semicolon-separated and double quoted argument.")
	MESSAGE(STATUS "* A list of available contrib packages is listed using -DWITH_PACKAGES=list")
	MESSAGE(STATUS "")
	MESSAGE(STATUS "===========================================================================")
	MESSAGE(STATUS "")
ENDMACRO()


MACRO(MSG_LIST contrib_packages)
	MESSAGE(STATUS "")
	MESSAGE(STATUS "===========================================================================")
	MESSAGE(STATUS "Available BALL contrib packages:")
	MESSAGE(STATUS "")

	MESSAGE(STATUS " * all  (build all packages)")
	MESSAGE(STATUS " * core (build only packages nedded to build BALL core library)")

	FOREACH(p ${contrib_packages})
		MESSAGE(STATUS " * ${p}")
	ENDFOREACH()

	MESSAGE(STATUS "")
	MESSAGE(STATUS "===========================================================================")
	MESSAGE(STATUS "")
ENDMACRO()


MACRO(MSG_CONFIGURE_PACKAGE_BEGIN package_name)
	MESSAGE(STATUS "Configuring project: ${package_name}")
ENDMACRO()


MACRO(MSG_CONFIGURE_PACKAGE_END package_name)
	MESSAGE(STATUS "Configuring ${package_name} - done")
ENDMACRO()


MACRO(MSG_DOWNLOAD_FAILED archive)
	MESSAGE(STATUS "")
	MESSAGE(STATUS "=============================================================================================")
	MESSAGE(STATUS " FATAL ERROR: Download of contrib archive failed: ${archive}")
	MESSAGE(STATUS "")
	MESSAGE(STATUS " - Please verify that your internet connection works and try again.")
	MESSAGE(STATUS " - If this error occurrs again please contact the developers.")
	MESSAGE(STATUS "=============================================================================================")
	MESSAGE(STATUS "")
	MESSAGE(FATAL_ERROR "")
ENDMACRO()


MACRO(MSG_INVALID_ARCHIVE_PATH archive)
	MESSAGE(STATUS "")
	MESSAGE(STATUS "=============================================================================================")
	MESSAGE(STATUS " FATAL ERROR: Contrib archive ${archive} not found or invalid." )
	MESSAGE(STATUS "")
	MESSAGE(STATUS " - Please verify that ARCHIVES_PATH (${ARCHIVES_PATH}) is set correctly")
	MESSAGE(STATUS "")
	MESSAGE(STATUS " PLEASE NOTE: only use ARCHIVES_PATH if you plan to build an older contrib version" )
	MESSAGE(STATUS "")
	MESSAGE(STATUS "=============================================================================================")
	MESSAGE(STATUS "")
	MESSAGE(FATAL_ERROR "")
ENDMACRO()




