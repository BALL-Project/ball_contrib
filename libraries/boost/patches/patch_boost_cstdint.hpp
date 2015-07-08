--- cstdint.hpp	2015-07-08 14:47:57.523120026 +0000
+++ /cstdint_fixed.hpp	2015-07-08 14:49:56.939116630 +0000
@@ -41,7 +41,10 @@
 // so we disable use of stdint.h when GLIBC does not define __GLIBC_HAVE_LONG_LONG.
 // See https://svn.boost.org/trac/boost/ticket/3548 and http://sources.redhat.com/bugzilla/show_bug.cgi?id=10990
 //
-#if defined(BOOST_HAS_STDINT_H) && (!defined(__GLIBC__) || defined(__GLIBC_HAVE_LONG_LONG))
+#if defined(BOOST_HAS_STDINT_H)                                 \ 
+ 	&& (!defined(__GLIBC__)                                 \ 
+ 	|| defined(__GLIBC_HAVE_LONG_LONG)                      \ 
+ 	|| (defined(__GLIBC__) && ((__GLIBC__ > 2) || ((__GLIBC__ == 2) && (__GLIBC_MINOR__ >= 17)))))
 
 // The following #include is an implementation artifact; not part of interface.
 # ifdef __hpux
