# Post-install CMake script to change install names of dylibs to absolute paths

# First, select all candidate dylibs in the current working directory.
# The working directory is set by the calling macro (FIX_DYLIB_INSTALL_NAMES) to the install/lib folder.
FILE(GLOB_RECURSE dylibs "${LIBNAME}*.dylib")


FOREACH(dylib ${dylibs})

	# Only process the library itself and not symlinks to it
	IF(NOT IS_SYMLINK ${dylib})
		# Call install_name_tool to set the install name appropriately
		EXECUTE_PROCESS(COMMAND install_name_tool -id ${dylib} ${dylib})
	ENDIF()

ENDFOREACH()
