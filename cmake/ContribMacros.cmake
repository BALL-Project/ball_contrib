# -----------------------------------------------------------------------------
# CONTRIB FRAMEWORK
#
# Based on CMake ExternalProjects, this repository offers functionality
# to configure, build, and install software dependencies that can be used
# by other projects.
#
# It has been developed in course of the open source
# research software BALL (Biochemical ALgorithms Library).
#
#
# Copyright 2016, the BALL team (http://www.ball-project.org)
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL ANY OF THE AUTHORS OR THE CONTRIBUTING
# INSTITUTIONS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
# OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
# OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# -----------------------------------------------------------------------------


# Generate CMake list that contains all available packages without pkg_ prefix
# Created CMake variable holding available packages: PACKAGES_AVAILABLE
MACRO(PACKAGE_LIST_GENERATE)

	GET_CMAKE_PROPERTY(VAR_LIST VARIABLES)

	FOREACH(TMP_VAR ${VAR_LIST})
		STRING(REGEX MATCH "^pkg_+" MATCH_RESULT ${TMP_VAR})
		IF(NOT ${MATCH_RESULT})
			STRING(SUBSTRING ${TMP_VAR} 4 -1 PACKAGE)
			LIST(APPEND PACKAGES_AVAILABLE ${PACKAGE})
		ENDIF()
	ENDFOREACH()

ENDMACRO()


# Set a cross dependency for a contrib package selected for installation
MACRO(SET_CROSS_DEPENDENCIES)

	LIST(FIND PACKAGES_SELECTED ${ARGV0} PACKAGE_FOUND)

	IF(NOT ${PACKAGE_FOUND} EQUAL -1)
		SET(ARGN_LIST "${ARGN}")
		LIST(REMOVE_ITEM PACKAGES_SELECTED ${ARGN_LIST})
		LIST(REVERSE ARGN_LIST)
		LIST(APPEND PACKAGES_SELECTED ${ARGN_LIST})
	ENDIF()

ENDMACRO()


# Configure packages and download sources
MACRO(CONFIGURE_PACKAGES)

	FOREACH(PACKAGE ${PACKAGES_SELECTED})

		# Check if selected package is indeed an available one
		LIST(FIND PACKAGES_AVAILABLE ${PACKAGE} PACKAGE_FOUND)

		IF(${PACKAGE_FOUND} EQUAL -1)
			MESSAGE(SEND_ERROR "The selected package '${PACKAGE}' is not part of BALL_contrib.")
		ELSE()
			# Configure package
			MESSAGE(STATUS "Configuring external project: ${PACKAGE}")
			INCLUDE("${CONTRIB_LIBRARY_PATH}/${PACKAGE}.cmake")

			# Check if package source has already been downloaded
			IF(NOT ${PACKAGE}_downloaded)

				IF(${DOWNLOAD_TYPE} STREQUAL "archive")
					DOWNLOAD_SOURCE_ARCHIVE("${PACKAGE}")
				ELSE()
					DOWNLOAD_SOURCE_GIT("${PACKAGE}")
				ENDIF()

				# Mark package as donwloaded in CMake internal cache
				SET("${PACKAGE}_downloaded" TRUE CACHE INTERNAL "Variable indicates that package ${PACKAGE} has already been cloned")

			ENDIF()
		ENDIF()

	ENDFOREACH()

ENDMACRO()


# Download package archive (tarball/zipball)
MACRO(DOWNLOAD_SOURCE_ARCHIVE PACKAGE)

	# Download archive
	FILE(DOWNLOAD "${CONTRIB_GITHUB_BASE}/${pkg_${PACKAGE}}/${GIT_ARCHIVE_FORMAT}/${CONTRIB_GIT_BRANCH}" "${CONTRIB_BINARY_SRC}/${PACKAGE}.${GIT_ARCHIVE_FORMAT}"
		LOG "${CONTRIB_BINARY_SRC}/${PACKAGE}_download_out.log"
		TIMEOUT ${DOWNLOAD_TIMEOUT}
		STATUS DOWNLOAD_STATUS
		)

	LIST(GET DOWNLOAD_STATUS 0 DOWNLOAD_EXIT_CODE)

	# Check if download was successful
	IF(${DOWNLOAD_EXIT_CODE} EQUAL 0)

		# Extract archive
		EXECUTE_PROCESS(COMMAND ${CMAKE_COMMAND} -E tar xf "${CONTRIB_BINARY_SRC}/${PACKAGE}.${GIT_ARCHIVE_FORMAT}" WORKING_DIRECTORY ${CONTRIB_BINARY_SRC}
			OUTPUT_FILE "${CONTRIB_BINARY_SRC}/${PACKAGE}_extract_out.log"
			ERROR_FILE "${CONTRIB_BINARY_SRC}/${PACKAGE}_extract_err.log")

		# Move content of extracted archive into package source folder
		FILE(GLOB ARCHIVE_FILE_NAME "${CONTRIB_BINARY_SRC}/*${pkg_${PACKAGE}}*")
		EXECUTE_PROCESS(COMMAND ${CMAKE_COMMAND} -E remove_directory ${PACKAGE} WORKING_DIRECTORY ${CONTRIB_BINARY_SRC})
		EXECUTE_PROCESS(COMMAND ${CMAKE_COMMAND} -E rename ${ARCHIVE_FILE_NAME} ${PACKAGE} WORKING_DIRECTORY ${CONTRIB_BINARY_SRC})

	ELSE()
		MESSAGE(FATAL_ERROR "Download of package failed (archive): ${PACKAGE}")
	ENDIF()

ENDMACRO()


# Download package source using git clone
MACRO(DOWNLOAD_SOURCE_GIT PACKAGE)

	EXECUTE_PROCESS(COMMAND ${GIT_EXECUTABLE} clone --depth 1 --branch "${CONTRIB_GIT_BRANCH}" "${CONTRIB_GITHUB_BASE}/${pkg_${PACKAGE}}" "${CONTRIB_BINARY_SRC}/${PACKAGE}"
			TIMEOUT ${DOWNLOAD_TIMEOUT}
			RESULT_VARIABLE DOWNLOAD_EXIT_CODE
			OUTPUT_FILE "${CONTRIB_BINARY_SRC}/${PACKAGE}_download_out.log"
			ERROR_FILE "${CONTRIB_BINARY_SRC}/${PACKAGE}_download_err.log"
			)

	# Check if download was successful
	IF(NOT ${DOWNLOAD_EXIT_CODE} EQUAL 0)
		MESSAGE(FATAL_ERROR "Download of package failed (git clone): ${PACKAGE}")
	ENDIF()

ENDMACRO()


# Macro to write absolute paths as install names for dylibs using install_name_tool
MACRO(FIX_DYLIB_INSTALL_NAMES DYLIB_PREFIX)

	# As this procedure has to wait until the libraries are built and installed,
	# fixing the names is added as an ExternalProject step depending on the install step.
	ExternalProject_Add_Step(${PACKAGE} fixnames

		LOG 1
		DEPENDEES install

		WORKING_DIRECTORY "${CONTRIB_INSTALL_LIB}"
		COMMAND ${CMAKE_COMMAND} -DLIBNAME=${DYLIB_PREFIX} -P "${PROJECT_SOURCE_DIR}/cmake/FixDylibInstallNames.cmake"
	)

ENDMACRO()


# Macro to print licensing information after successful configuration run
MACRO(LICENSE_AGREEMENT_MSG)
	MESSAGE("")
	MESSAGE("   +---------------------------------------------------------------------")
	MESSAGE("   +")
	MESSAGE("   + You successfully configured the Contrib!")
	MESSAGE("   +")
	MESSAGE("   +---------------------------------------------------------------------")
	MESSAGE("   +")
	MESSAGE("   + !!! IMPORTANT LICENSING INFORMATION !!!")
	MESSAGE("   +")
	MESSAGE("   + By running the build process of this project you accept")
	MESSAGE("   + all copyright and license agreements of software packages")
	MESSAGE("   + that are contained in this contrib project.")
	MESSAGE("   +")
	MESSAGE("   + Licensing information can be found in the source")
	MESSAGE("   + directories of the corresponding projects:")
	MESSAGE("   +")

	FOREACH(PACKAGE ${PACKAGES_SELECTED})
		MESSAGE( "   + - ${PACKAGE}:")
		MESSAGE( "   +   ${CONTRIB_BINARY_SRC}/${PACKAGE}")
	ENDFOREACH()

	MESSAGE("   +")
	MESSAGE("   +---------------------------------------------------------------------")
	MESSAGE("")
ENDMACRO()















