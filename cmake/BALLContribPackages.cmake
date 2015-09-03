# Available contrib packages
SET(CONTRIB_PACKAGES "boost" "eigen3" "tbb" "openbabel" "fftw" "sip")

SET(boost "boost_1_55_0_ball_contrib")
SET(boost_archive "boost_1_55_0_ball_contrib.tar.gz")
SET(boost_archive_md5 "99e98dfe34bb4c0597a40c7672b06f83")

SET(bzip2 "bzip2-1.0.6")
SET(bzip2_archive "bzip2-1.0.6.tar.gz")
SET(bzip2_archive_md5 "00b516f4704d4a7cb50a1d97e6e8e15b")

SET(zlib "zlib-1.2.8")
SET(zlib_archive "zlib-1.2.8.tar.gz")
SET(zlib_archive_md5 "44d667c142d7cda120332623eab69f40")

SET(eigen3 "eigen-eigen-bdd17ee3b1b3")
SET(eigen3_archive "eigen-eigen-bdd17ee3b1b3.tar.bz2")
SET(eigen3_archive_md5 "21a928f6e0f1c7f24b6f63ff823593f5")

SET(tbb "tbb43_20150611oss_ball_contrib")
SET(tbb_archive "tbb43_20150611oss_ball_contrib.tar.gz")
SET(tbb_archive_md5 "bb144ec868c53244ea6be11921d86f03")

SET(openbabel "openbabel-master_ball_contrib")
SET(openbabel_archive "openbabel-master_ball_contrib.tar.gz")
SET(openbabel_archive_md5 "4330fd8a31c95c01a2925e27123182f7")

SET(fftw "fftw-3.3.4_ball_contrib")
SET(fftw_archive "fftw-3.3.4_ball_contrib.tar.gz")
SET(fftw_archive_md5 "2edab8c06b24feeb3b82bbb3ebf3e7b3")

SET(sip "sip-4.16.9")
SET(sip_archive "sip-4.16.9.tar.gz")
SET(sip_archive_md5 "7a1dfff4e6fade0e4adee2c4e3d3aa9a")


# From here: win-only dependencies

IF(MSVC)
	LIST(APPEND CONTRIB_PACKAGES "oncrpc")
	SET(oncrpc "oncrpc")
	SET(oncrpc_archive "oncrpc.zip")
	SET(oncrpc_archive_md5 "403c2db7fa54bccaedf0ba9f00392af4")

	LIST(APPEND CONTRIB_PACKAGES "flex")
	SET(flex "flex-2.5.4a-1-bin")
	SET(flex_archive "flex-2.5.4a-1-bin.zip")
	SET(flex_archive_md5 "0e6dfc5bb7b80924e9f20c653199890e")

	LIST(APPEND CONTRIB_PACKAGES "bison")
	SET(bison "bison-2.4.1-bin")
	SET(bison_archive "bison-2.4.1-bin.zip")
	SET(bison_archive_md5 "9d3ccf30fc00ba5e18176c33f45aee0e")

	SET(bison_deps "bison-2.4.1-dep")
	SET(bison_deps_archive "bison-2.4.1-dep.zip")
	SET(bison_deps_archive_md5 "9d3ccf30fc00ba5e18176c33f45aee0e")
ENDIF()

