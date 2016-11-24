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


PROJECT("BALL_contrib")

SET(CONTRIB_VERSION_MAJOR "1" CACHE INTERNAL "Contrib version MAJOR")
SET(CONTRIB_VERSION_MINOR "5" CACHE INTERNAL "Contrib version MINOR")
SET(CONTRIB_VERSION_PATCH "1" CACHE INTERNAL "Contrib version PATCH")
SET(CONTRIB_VERSION "${CONTRIB_VERSION_MAJOR}.${CONTRIB_VERSION_MINOR}.${CONTRIB_VERSION_PATCH}" CACHE INTERNAL "Contrib version string")


###############################################################################
# CMake and global settings

CMAKE_MINIMUM_REQUIRED(VERSION 3.0.0 FATAL_ERROR)

# Path to contrib-specific CMake modules
LIST(APPEND CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake")
LIST(APPEND CMAKE_MODULE_PATH "${PROJECT_BINARY_DIR}/cmake")

# CMake variables that can be changed by the user
SET(CONTRIB_INSTALL_PREFIX "${PROJECT_BINARY_DIR}/install" CACHE PATH "Prefix to install BALL_contrib. Default: <BALL_contrib_build_dir>/install")
SET(THREADS "1" CACHE STRING "Number of threads used by make steps. Default: 1")
SET(PACKAGES "all" CACHE STRING "Contrib packages to be build. Default: all")
SET(DOWNLOAD_TYPE "archive" CACHE STRING "Download packages as zipped archives (archive) or clone git repositories (git). Default: archive")
SET(DOWNLOAD_TIMEOUT "2400" CACHE STRING "Timout (seconds) for single package downloads (git clone). Default: 420")

# ExternalProjects package
INCLUDE(ExternalProject)

# Setup BALL_contrib
INCLUDE(ContribSetup)

# Load contrib-specific macros and messages
INCLUDE(ContribMacros)


###############################################################################
# Packages contained in this contrib

SET(pkg_boost        "contrib_boost_1.60.0" CACHE INTERNAL "Boost repo name")
SET(pkg_eigen3       "contrib_eigen_3.2.5" CACHE INTERNAL "Eigen3 repo name")
SET(pkg_fftw         "contrib_fftw_3.3.4" CACHE INTERNAL "FFTW repo name")
SET(pkg_glew         "contrib_glew_1.13.0" CACHE INTERNAL "GLEW repo name")
SET(pkg_openbabel    "contrib_openbabel_2.4.1" CACHE INTERNAL "OpenBabel repo name")
SET(pkg_sip          "contrib_sip_4.16.9" CACHE INTERNAL "SIP repo name")
SET(pkg_tbb          "contrib_tbb43_20150611" CACHE INTERNAL "TBB repo name")
SET(pkg_qt5          "contrib_qt_5.6.1-1" CACHE INTERNAL "Qt5 repo name")

IF(MSVC)
	SET(pkg_bison        "contrib_bison_2.4.1" CACHE INTERNAL "Bison repo name")
	SET(pkg_flex         "contrib_flex_2.5.4" CACHE INTERNAL "Flex repo name")
	SET(pkg_oncrpc       "contrib_oncrpc_1.14" CACHE INTERNAL "Oncrpc repo name")

	# Bison and Flex are mandatory on Windows
	SET(PACKAGES_SELECTED bison flex)
ENDIF()


###############################################################################
# Generate list of available packages (PACKAGES_AVAILABLE)
# and evaluate packages selected by the user via -DPACKAGES (PACKAGES_SELECTED)

EVALUATE_PACKAGES()


###############################################################################
# Configure and download selected packages

CONFIGURE_PACKAGES()

LICENSE_AGREEMENT_MSG()

