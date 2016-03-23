MACRO(GENERATE_CONTRIB CONTRIB_WIN)

	# Clone ball_contrib repository
	EXECUTE_PROCESS(COMMAND git clone --depth 1 https://github.com/BALL-Project/ball_contrib.git WORKING_DIRECTORY "${PKG_DIR}")
	# Execute cmake to download packages
	EXECUTE_PROCESS(COMMAND cmake ../.. -DMSVC=${CONTRIB_WIN} WORKING_DIRECTORY "${BUILD_DIR}")

	# Move contrib packages to ball_contrib source directory
	FILE(RENAME "${BUILD_DIR}/archives" "${PKG_DIR}/ball_contrib/archives")

	# Modify CMakeLists.txt in order to use the downloaded archives and to prevent Internet access
	FILE(READ "${PKG_DIR}/ball_contrib/CMakeLists.txt" FILE_CONTENT)
	STRING(REGEX REPLACE "ARCHIVES_PATH \"\"" "ARCHIVES_PATH \"\${CMAKE_SOURCE_DIR}/archives\"" MODIFIED_FILE_CONTENT "${FILE_CONTENT}")
	STRING(REGEX REPLACE "SET_CONTRIB_ARCHIVES_URL" "#SET_CONTRIB_ARCHIVES_URL" MODIFIED_FILE_CONTENT "${FILE_CONTENT}")
	FILE(WRITE "${PKG_DIR}/ball_contrib/CMakeLists.txt" "${MODIFIED_FILE_CONTENT}")

ENDMACRO()

# Create temporary working directories
SET(PKG_DIR "${CMAKE_BINARY_DIR}/packaging")
FILE(MAKE_DIRECTORY "${PKG_DIR}")
SET(BUILD_DIR "${PKG_DIR}/build")
FILE(MAKE_DIRECTORY "${BUILD_DIR}")

# Generate contrib for Linux / OSX
GENERATE_CONTRIB(FALSE)
EXECUTE_PROCESS(COMMAND gnutar cjf "${PKG_DIR}/ball_contrib.tar.bz2" "ball_contrib/" WORKING_DIRECTORY "${PKG_DIR}")
EXECUTE_PROCESS(COMMAND gnutar czf "${PKG_DIR}/ball_contrib.tar.gz"  "ball_contrib/" WORKING_DIRECTORY "${PKG_DIR}")
FILE(REMOVE_RECURSE "${PKG_DIR}/build/*")
FILE(REMOVE_RECURSE "${PKG_DIR}/ball_contrib")

# Generate contrib for Windows
GENERATE_CONTRIB(TRUE)
EXECUTE_PROCESS(COMMAND zip -qr "${PKG_DIR}/ball_contrib_win" "ball_contrib" -x "*.git*" WORKING_DIRECTORY "${PKG_DIR}")
FILE(REMOVE_RECURSE "${PKG_DIR}/build")
FILE(REMOVE_RECURSE "${PKG_DIR}/ball_contrib")
