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


OPTION(SKIP_QTWEBENGINE "Skip building QtWebEngine." OFF)

FIND_PACKAGE(Perl QUIET)
IF(NOT PERL_EXECUTABLE)
	IF(NOT OS_WINDOWS)
                MESSAGE(SEND_ERROR "Compiling Qt requires Perl! Cannot continue!")
	ELSE()
                MESSAGE(SEND_ERROR "Compiling Qt requires Perl! Please install ActivePerl from http://www.activestate.com/downloads")
	ENDIF()
ENDIF()

# TODO: openssl

# Common configure options
SET(QT_CONFIGURE_OPTIONS -prefix ${CONTRIB_INSTALL_PREFIX}
			 -opensource
			 -confirm-license
			 -shared
			 -nomake examples
			 -no-nis
			 -no-harfbuzz
			 -skip qt3d
			 -skip qtcanvas3d
			 -skip qtconnectivity
			 -skip qtdoc
			 -skip qtgraphicaleffects
			 -skip qtimageformats
			 -skip qtquickcontrols2
			 -skip qtsensors
			 -skip qtserialbus
			 -skip qtserialport
			 -skip qtwayland
			 -skip qtwebview
)

# Set the appropriate build type
IF("${CMAKE_BUILD_TYPE}" STREQUAL "RelWithDebInfo")
	LIST(APPEND QT_CONFIGURE_OPTIONS -release -force-debug-info)
ELSE()
	STRING(TOLOWER "${CMAKE_BUILD_TYPE}" QT_BUILD_TYPE)
	LIST(APPEND QT_CONFIGURE_OPTIONS -${QT_BUILD_TYPE})
ENDIF()

# Check if QtWebEngine should be excluded
IF(SKIP_QTWEBENGINE)
	LIST(APPEND QT_CONFIGURE_OPTIONS -skip qtwebengine)
ENDIF()

# Platform-specific settings
IF(MSVC)
	SET(QT_CONFIGURE_COMMAND configure.bat)
	SET(QT_BUILD_COMMAND nmake)
	SET(QT_INSTALL_COMMAND nmake install)

	LIST(APPEND QT_CONFIGURE_OPTIONS -opengl dynamic)
	LIST(APPEND QT_CONFIGURE_OPTIONS -platform win32-msvc${CONTRIB_MSVC_VERSION_YEAR})

	# Configure for multiple process build
	IF("${THREADS}" GREATER "1")
		LIST(APPEND QT_CONFIGURE_OPTIONS -mp)
	ENDIF()
ELSE()
	SET(QT_CONFIGURE_COMMAND ./configure)
	SET(QT_BUILD_COMMAND ${MAKE_COMMAND})
	SET(QT_INSTALL_COMMAND ${MAKE_INSTALL_COMMAND})

	# In case of Linux OS use xcb-libraries bundled with Qt
	IF(CMAKE_SYSTEM_NAME STREQUAL Linux)
		LIST(APPEND QT_CONFIGURE_OPTIONS -qt-xcb)
	ENDIF()
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

	CONFIGURE_COMMAND ${QT_CONFIGURE_COMMAND}
			  ${QT_CONFIGURE_OPTIONS}

	BUILD_COMMAND ${QT_BUILD_COMMAND}
	INSTALL_COMMAND ${QT_INSTALL_COMMAND}
)
