# Post-install CMake script to change install names of dylibs to absolute paths

# First, select all candidate dylibs in the current working directory.
# The working directory is set by the calling macro (FIX_DYLIB_INSTALL_NAMES) to the install/lib folder.
FILE(GLOB_RECURSE dylibs "${LIBNAME}*.dylib")


FOREACH(dylib ${dylibs})
	GET_FILENAME_COMPONENT(base_name ${dylib} NAME)

	# Only process the library itself and not symlinks to it
	IF(NOT IS_SYMLINK ${dylib})

		EXECUTE_PROCESS(COMMAND otool -L ${dylib} OUTPUT_VARIABLE temp)
		SEPARATE_ARGUMENTS(deps UNIX_COMMAND ${temp})
		LIST(REMOVE_AT deps 0)

		FOREACH(dep ${deps})
			IF(${dep} MATCHES ".?dylib" AND NOT IS_ABSOLUTE ${dep})
				GET_FILENAME_COMPONENT(name ${dep} NAME)
				GET_FILENAME_COMPONENT(abs_name ${dep} ABSOLUTE)

				IF(${name} STREQUAL ${base_name})
					# Set asolute path of dylib as its install name
					EXECUTE_PROCESS(COMMAND install_name_tool -id "${abs_name}" ${dylib})
				ELSE()
					# Set absolute paths of dependent shared libraries
					EXECUTE_PROCESS(COMMAND install_name_tool -change "${name}" "${abs_name}" ${dylib})
				ENDIF()
			ENDIF()
		ENDFOREACH()
	ENDIF()

ENDFOREACH()

