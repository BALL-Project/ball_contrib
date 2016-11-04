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


# Create a list of all packages available in this contrib and a list of packages selected for installation
MACRO(EVALUATE_PACKAGES)

	# First, generate list of available packages
	GET_CMAKE_PROPERTY(VAR_LIST VARIABLES)

	FOREACH(TMP_VAR ${VAR_LIST})
		STRING(REGEX MATCH "^pkg_+" MATCH_RESULT ${TMP_VAR})
		IF(NOT ${MATCH_RESULT})
			STRING(SUBSTRING ${TMP_VAR} 4 -1 PACKAGE)
			LIST(APPEND PACKAGES_AVAILABLE ${PACKAGE})
		ENDIF()
	ENDFOREACH()

	# Second, generate list of packages to be installed
	IF("${PACKAGES}" STREQUAL "all")
		SET(PACKAGES_SELECTED ${PACKAGES_AVAILABLE})
	ELSE()
		SET(PACKAGES_SELECTED ${PACKAGES_SELECTED} ${PACKAGES})
	ENDIF()

ENDMACRO()


# Configure and download (git clone) packages
MACRO(CONFIGURE_PACKAGES)

	FOREACH(PACKAGE ${PACKAGES_SELECTED})

		# Check if selected package is indeed an available one
		LIST(FIND PACKAGES_AVAILABLE ${PACKAGE} PACKAGE_FOUND)

		IF(${PACKAGE_FOUND} EQUAL -1)
			MESSAGE(SEND_ERROR "The selected package '${PACKAGE}' is not part of BALL_contrib.")
		ELSE()
			# Configure package
			MESSAGE(STATUS "Configuring project: ${PACKAGE}")
			INCLUDE("${CONTRIB_LIBRARY_PATH}/${PACKAGE}.cmake")

			# Check if package has already been cloned, if not, clone it
			IF(NOT ${PACKAGE}_downloaded)
				MESSAGE(STATUS "Downloading package (git clone): ${PACKAGE}")
				EXECUTE_PROCESS(COMMAND ${GIT_EXECUTABLE} clone --branch "${CONTRIB_GIT_BRANCH}" "${CONTRIB_GITHUB_BASE}/${pkg_${PACKAGE}}" "${CONTRIB_BINARY_SRC}/${PACKAGE}"
						TIMEOUT ${DOWNLOAD_TIMEOUT}
						RESULT_VARIABLE DOWNLOAD_EXIT_CODE
						OUTPUT_FILE "${CONTRIB_BINARY_SRC}/${PACKAGE}_download_out.log"
						ERROR_FILE "${CONTRIB_BINARY_SRC}/${PACKAGE}_download_err.log"
						)

				# Check if download was successful
				IF(${DOWNLOAD_EXIT_CODE} EQUAL 0)
					# If yes, mark package as donwloaded in CMake internal cache
					SET("${PACKAGE}_downloaded" TRUE CACHE INTERNAL "Variable indicates that package ${PACKAGE} has already been cloned")
				ELSE()
					# If not, exit CMake run with fatal error
					MESSAGE(FATAL_ERROR "Downloading of package failed: ${PACKAGE}")
				ENDIF()
			ENDIF()
		ENDIF()

	ENDFOREACH()

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















