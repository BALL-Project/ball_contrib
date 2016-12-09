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


# Determine the correct b2 switches according to build type and platform
IF("${CMAKE_BUILD_TYPE}" STREQUAL "RelWithDebInfo")
	SET(BOOST_BUILD_TYPE "release debug-symbols=on")
ELSE()
	STRING(TOLOWER "${CMAKE_BUILD_TYPE}" BOOST_BUILD_TYPE)
ENDIF()

# Libraries to be build
SET(BOOST_LIBRARIES --with-chrono
		    --with-date_time
		    --with-iostreams
		    --with-regex
		    --with-serialization
		    --with-system
		    --with-thread
		    --with-math
		    --with-filesystem
		    --with-graph
		    --with-program_options

)

# Boost b2 options
SET(BOOST_B2_OPTIONS --prefix=${CONTRIB_INSTALL_PREFIX}
		     -j ${THREADS}
		     -sBZIP2_SOURCE=${CONTRIB_BINARY_SRC}/${PACKAGE}/bzip2
		     -sZLIB_SOURCE=${CONTRIB_BINARY_SRC}/${PACKAGE}/zlib
		     address-model=${CONTRIB_ADDRESSMODEL}
		     variant=${BOOST_BUILD_TYPE}
		     --layout=tagged
		     link=shared
		     threading=multi
		     --ignore-site-config
)

# Set system dependent variables
IF(MSVC)
	LIST(APPEND BOOST_B2_OPTIONS --toolset=msvc-${CONTRIB_MSVC_VERSION})
	SET(BOOST_BOOTSTRAP_CMD bootstrap.bat)
	SET(BOOST_B2_CMD b2.exe)
ELSE()
	SET(BOOST_BOOTSTRAP_CMD ./bootstrap.sh)
	SET(BOOST_B2_CMD ./b2)
ENDIF()


ExternalProject_Add(${PACKAGE}

	PREFIX ${PROJECT_BINARY_DIR}
	DOWNLOAD_COMMAND ""
	BUILD_IN_SOURCE ${CUSTOM_BUILD_IN_SOURCE}

	LOG_DOWNLOAD ${CUSTOM_LOG_DOWNLOAD}
	LOG_UPDATE ${CUSTOM_LOG_UPDATE}
	LOG_CONFIGURE ${CUSTOM_LOG_CONFIGURE}
	LOG_BUILD ${CUSTOM_LOG_BUILD}
	LOG_INSTALL ${CUSTOM_LOG_INSTALL}

	CONFIGURE_COMMAND ${BOOST_BOOTSTRAP_CMD}

	BUILD_COMMAND ${BOOST_B2_CMD} install
		      ${BOOST_B2_OPTIONS}
		      ${BOOST_LIBRARIES}

	INSTALL_COMMAND ""
)

# On Mac OS X we have to use absolute paths as install names for dylibs
IF(APPLE)
	FIX_DYLIB_INSTALL_NAMES(libboost)
ENDIF()








