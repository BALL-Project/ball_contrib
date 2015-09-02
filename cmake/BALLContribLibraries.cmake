# Available contrib packages
SET(CONTRIB_PACKAGES "boost" "eigen3" "tbb" "openbabel" "fftw" "sip")

# For Visual Studio, we need to build oncrpc for persistence in BALL to work correctly.
IF(MSVC)
	LIST(APPEND CONTRIB_PACKAGES "oncrpc")
ENDIF()

SET(boost "boost_1_55_0")
SET(boost_archive "boost_1_55_0.tar.gz")
SET(boost_archive_md5 "93780777cfbf999a600f62883bd54b17")

SET(bzip2 "bzip2-1.0.6")
SET(bzip2_archive "bzip2-1.0.6.tar.gz")
SET(bzip2_archive_md5 "00b516f4704d4a7cb50a1d97e6e8e15b")

SET(zlib "zlib-1.2.8")
SET(zlib_archive "zlib-1.2.8.tar.gz")
SET(zlib_archive_md5 "44d667c142d7cda120332623eab69f40")

SET(boost "eigen-eigen-bdd17ee3b1b3")
SET(eigen3_archive "eigen-eigen-bdd17ee3b1b3.tar.bz2")
SET(eigen3_archive_md5 "21a928f6e0f1c7f24b6f63ff823593f5")

SET(boost "tbb43_20150611oss_src")
SET(tbb_archive "tbb43_20150611oss_src.tgz")
SET(tbb_archive_md5 "bb144ec868c53244ea6be11921d86f03")

SET(boost "openbabel-master")
SET(openbabel_archive "openbabel-master.zip")
SET(openbabel_archive_md5 "4330fd8a31c95c01a2925e27123182f7")

SET(boost "fftw-3.3.4")
SET(fftw_archive "fftw-3.3.4.tar.gz")
SET(fftw_archive_md5 "2edab8c06b24feeb3b82bbb3ebf3e7b3")

SET(boost "sip-4.16.9")
SET(sip_archive "sip-4.16.9.tar.gz")
SET(sip_archive_md5 "7a1dfff4e6fade0e4adee2c4e3d3aa9a")

SET(oncrpc "oncrpc")
SET(oncrpc_archive "oncrpc.zip")
SET(oncrpc_archive_md5 "403c2db7fa54bccaedf0ba9f00392af4")
