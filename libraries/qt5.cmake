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


# Common configure options
SET(QT_CONFIGURE_OPTIONS -prefix ${CONTRIB_INSTALL_PREFIX}
                         -v
			 -opensource
			 -confirm-license
			 -shared
			 -nomake examples
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

# Package branch to clone/download from the BALL-Contrib repository
SET(GIT_BRANCH "master")

SET(PACKAGE_DEPENDENCIES "")


# Platform-specific settings
IF(MSVC)
	SET(PACKAGE_DEPENDENCIES "openssl")
	SET(QT_CONFIGURE_COMMAND configure.bat)
	SET(QT_BUILD_COMMAND nmake)
	SET(QT_INSTALL_COMMAND nmake install)

	LIST(APPEND QT_CONFIGURE_OPTIONS -opengl dynamic)
	LIST(APPEND QT_CONFIGURE_OPTIONS -platform win32-msvc${CONTRIB_MSVC_VERSION_YEAR})

	# SSL support in Windows from BALL-contrib OpenSSL build
	LIST(APPEND QT_CONFIGURE_OPTIONS -openssl-runtime -I${CONTRIB_INSTALL_INC})

	# Configure for multiple process build
	IF("${THREADS}" GREATER "1")
		LIST(APPEND QT_CONFIGURE_OPTIONS -mp)
	ENDIF()
ELSEIF(APPLE)
	SET(QT_CONFIGURE_COMMAND ./configure)
	SET(QT_BUILD_COMMAND ${MAKE_COMMAND})
	SET(QT_INSTALL_COMMAND ${MAKE_INSTALL_COMMAND})

	# SSL support on macOS using Secure Transport API
	LIST(APPEND QT_CONFIGURE_OPTIONS -securetransport)
ELSE()
	SET(QT_CONFIGURE_COMMAND ./configure)
	SET(QT_BUILD_COMMAND ${MAKE_COMMAND})
	SET(QT_INSTALL_COMMAND ${MAKE_INSTALL_COMMAND})

	# SSL support on Linux using OpenSSL
	LIST(APPEND QT_CONFIGURE_OPTIONS -openssl-linked)

	# On Linux we use Qt's XCB
	LIST(APPEND QT_CONFIGURE_OPTIONS -qt-xcb)
ENDIF()


ExternalProject_Add(${PACKAGE}

	DEPENDS ${PACKAGE_DEPENDENCIES}
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

# Easy access to qt5 config settings
# Not required to build the contrib
STRING(REPLACE ";" " " CONFIG_STRING "${QT_CONFIGURE_OPTIONS}")
FILE(WRITE ${CONTRIB_BINARY_SRC}/qt5_config.txt "${QT_CONFIGURE_COMMAND} " "${CONFIG_STRING}")


#IF(APPLE)
#
#	# This step is not very nice and can most likely be removed when moving to Qt 5.7
#	# QtTest library links to XCTest framework via rpath but no LC_RPATH is set in the dylib.
#	# Thus, XCTest cannot be found. As a solution, we change the installed name of XCTest framework.
#
#	EXECUTE_PROCESS(COMMAND xcrun --show-sdk-path OUTPUT_VARIABLE XCRUN_SDK_PATH)
#	STRING(STRIP ${XCRUN_SDK_PATH} XCRUN_SDK_PATH)
#
#	# Add custom Install step
#	ExternalProject_Add_Step(${PACKAGE} qttest_add_lc_rpath
#
#		LOG 1
#		DEPENDEES build
#
#		WORKING_DIRECTORY "${CONTRIB_BINARY_SRC}"
#		COMMAND install_name_tool -change "@rpath/XCTest.framework/Versions/A/XCTest" "${XCRUN_SDK_PATH}/../../Library/Frameworks/XCTest.framework/Versions/A/XCTest" "${PACKAGE}/qtbase/lib/QtTest.framework/QtTest"
#
#		DEPENDERS install
#	)
#
#ENDIF()











