 OPENSSL INSTALLATION
 --------------------

 This document describes installation on all supported operating
 systems (the Unix/Linux family (which includes Mac OS/X), OpenVMS,
 and Windows).

 To install OpenSSL, you will need:

  * A make implementation
  * Perl 5 with core modules (please read NOTES.PERL)
  * The perl module Text::Template (please read NOTES.PERL)
  * an ANSI C compiler
  * a development environment in the form of development libraries and C
    header files
  * a supported operating system

 For additional platform specific requirements, solutions to specific
 issues and other details, please read one of these:

  * NOTES.UNIX (any supported Unix like system)
  * NOTES.VMS (OpenVMS)
  * NOTES.WIN (any supported Windows)
  * NOTES.DJGPP (DOS platform with DJGPP)
  * NOTES.ANDROID (obviously Android [NDK])
  * NOTES.VALGRIND (testing with Valgrind)

 Notational conventions in this document
 ---------------------------------------

 Throughout this document, we use the following conventions in command
 examples:

 $ command                      Any line starting with a dollar sign
                                ($) is a command line.

 { word1 | word2 | word3 }      This denotes a mandatory choice, to be
                                replaced with one of the given words.
                                A simple example would be this:

                                $ echo { FOO | BAR | COOKIE }

                                which is to be understood as one of
                                these:

                                $ echo FOO
                                - or -
                                $ echo BAR
                                - or -
                                $ echo COOKIE

 [ word1 | word2 | word3 ]      Similar to { word1 | word2 | word3 }
                                except it's optional to give any of
                                those.  In addition to the examples
                                above, this would also be valid:

                                $ echo

 {{ target }}                   This denotes a mandatory word or
                                sequence of words of some sort.  A
                                simple example would be this:

                                $ type {{ filename }}

                                which is to be understood to use the
                                command 'type' on some file name
                                determined by the user.

 [[ options ]]                  Similar to {{ target }}, but is
                                optional.

 Note that the notation assumes spaces around {, }, [, ], {{, }} and
 [[, ]].  This is to differentiate from OpenVMS directory
 specifications, which also use [ and ], but without spaces.

 Quick Start
 -----------

 If you want to just get on with it, do:

  on Unix (again, this includes Mac OS/X):

    $ ./config
    $ make
    $ make test
    $ make install

  on OpenVMS:

    $ @config
    $ mms
    $ mms test
    $ mms install

  on Windows (only pick one of the targets for configuration):

    $ perl Configure { VC-WIN32 | VC-WIN64A | VC-WIN64I | VC-CE }
    $ nmake
    $ nmake test
    $ nmake install

 Note that in order to perform the install step above you need to have
 appropriate permissions to write to the installation directory.

 If any of these steps fails, see section Installation in Detail below.

 This will build and install OpenSSL in the default location, which is:

  Unix:    normal installation directories under /usr/local
  OpenVMS: SYS$COMMON:[OPENSSL-'version'...], where 'version' is the
           OpenSSL version number with underscores instead of periods.
  Windows: C:\Program Files\OpenSSL or C:\Program Files (x86)\OpenSSL

 The installation directory should be appropriately protected to ensure
 unprivileged users cannot make changes to OpenSSL binaries or files, or install
 engines. If you already have a pre-installed version of OpenSSL as part of
 your Operating System it is recommended that you do not overwrite the system
 version and instead install to somewhere else.

 If you want to install it anywhere else, run config like this:

  On Unix:

    $ ./config --prefix=/opt/openssl --openssldir=/usr/local/ssl

  On OpenVMS:

    $ @config --prefix=PROGRAM:[INSTALLS] --openssldir=SYS$MANAGER:[OPENSSL]

 (Note: if you do add options to the configuration command, please make sure
 you've read more than just this Quick Start, such as relevant NOTES.* files,
 the options outline below, as configuration options may change the outcome
 in otherwise unexpected ways)


 Configuration Options
 ---------------------

 There are several options to ./config (or ./Configure) to customize
 the build (note that for Windows, the defaults for --prefix and
 --openssldir depend in what configuration is used and what Windows
 implementation OpenSSL is built on.  More notes on this in NOTES.WIN):

  --api=x.y[.z]
                   Build the OpenSSL libraries to support the API for
                   the specified version.  If "no-deprecated" is also
                   given, don't build with support for deprecated APIs
                   in or below the specified version number. For example
                   "--api=1.1.0" with "no-deprecated" will remove
                   support for all APIS that were deprecated in
                   OpenSSL version 1.1.0 or below.
                   This is a rather specialized option for developers.
                   If you just intend to remove all deprecated APIs
                   entirely (up to the current version), only specify
                   "-no-deprecated" (see below).
                   If "--api" isn't given, it defaults to the current
                   OpenSSL minor version.

  --cross-compile-prefix=PREFIX
                   The PREFIX to include in front of commands for your
                   toolchain. It's likely to have to end with dash, e.g.
                   a-b-c- would invoke GNU compiler as a-b-c-gcc, etc.
                   Unfortunately cross-compiling is too case-specific to
                   put together one-size-fits-all instructions. You might
                   have to pass more flags or set up environment variables
                   to actually make it work. Android and iOS cases are
                   discussed in corresponding Configurations/15-*.conf
                   files. But there are cases when this option alone is
                   sufficient. For example to build the mingw64 target on
                   Linux "--cross-compile-prefix=x86_64-w64-mingw32-"
                   works. Naturally provided that mingw packages are
                   installed. Today Debian and Ubuntu users have option to
                   install a number of prepackaged cross-compilers along
                   with corresponding run-time and development packages for
                   "alien" hardware. To give another example
                   "--cross-compile-prefix=mipsel-linux-gnu-" suffices
                   in such case. Needless to mention that you have to
                   invoke ./Configure, not ./config, and pass your target
                   name explicitly. Also, note that --openssldir refers
                   to target's file system, not one you are building on.

  --debug
                   Build OpenSSL with debugging symbols and zero optimization
                   level.

  --libdir=DIR
                   The name of the directory under the top of the installation
                   directory tree (see the --prefix option) where libraries will
                   be installed. By default this is "lib". Note that on Windows
                   only ".lib" files will be stored in this location. dll files
                   will always be installed to the "bin" directory.

  --openssldir=DIR
                   Directory for OpenSSL configuration files, and also the
                   default certificate and key store.  Defaults are:

                   Unix:           /usr/local/ssl
                   Windows:        C:\Program Files\Common Files\SSL
                                or C:\Program Files (x86)\Common Files\SSL
                   OpenVMS:        SYS$COMMON:[OPENSSL-COMMON]

  --prefix=DIR
                   The top of the installation directory tree.  Defaults are:

                   Unix:           /usr/local
                   Windows:        C:\Program Files\OpenSSL
                                or C:\Program Files (x86)\OpenSSL
                   OpenVMS:        SYS$COMMON:[OPENSSL-'version']

  --release
                   Build OpenSSL without debugging symbols. This is the default.

  --strict-warnings
                   This is a developer flag that switches on various compiler
                   options recommended for OpenSSL development. It only works
                   when using gcc or clang as the compiler. If you are
                   developing a patch for OpenSSL then it is recommended that
                   you use this option where possible.

  --with-zlib-include=DIR
                   The directory for the location of the zlib include file. This
                   option is only necessary if enable-zlib (see below) is used
                   and the include file is not already on the system include
                   path.

  --with-zlib-lib=LIB
                   On Unix: this is the directory containing the zlib library.
                   If not provided the system library path will be used.
                   On Windows: this is the filename of the zlib library (with or
                   without a path). This flag must be provided if the
                   zlib-dynamic option is not also used. If zlib-dynamic is used
                   then this flag is optional and a default value ("ZLIB1") is
                   used if not provided.
                   On VMS: this is the filename of the zlib library (with or
                   without a path). This flag is optional and if not provided
                   then "GNV$LIBZSHR", "GNV$LIBZSHR32" or "GNV$LIBZSHR64" is
                   used by default depending on the pointer size chosen.


  --with-rand-seed=seed1[,seed2,...]
                   A comma separated list of seeding methods which will be tried
                   by OpenSSL in order to obtain random input (a.k.a "entropy")
                   for seeding its cryptographically secure random number
                   generator (CSPRNG). The current seeding methods are:

                   os:         Use a trusted operating system entropy source.
                               This is the default method if such an entropy
                               source exists.
                   getrandom:  Use the L<getrandom(2)> or equivalent system
                               call.
                   devrandom:  Use the first device from the DEVRANDOM list
                               which can be opened to read random bytes. The
                               DEVRANDOM preprocessor constant expands to
                               "/dev/urandom","/dev/random","/dev/srandom" on
                               most unix-ish operating systems.
                   egd:        Check for an entropy generating daemon.
                   rdcpu:      Use the RDSEED or RDRAND command if provided by
                               the CPU.
                   librandom:  Use librandom (not implemented yet).
                   none:       Disable automatic seeding. This is the default
                               on some operating systems where no suitable
                               entropy source exists, or no support for it is
                               implemented yet.

                   For more information, see the section 'Note on random number
                   generation' at the end of this document.

  no-afalgeng
                   Don't build the AFALG engine. This option will be forced if
                   on a platform that does not support AFALG.

  enable-ktls
                   Build with Kernel TLS support. This option will enable the
                   use of the Kernel TLS data-path, which can improve
                   performance and allow for the use of sendfile and splice
                   system calls on TLS sockets. The Kernel may use TLS
                   accelerators if any are available on the system.
                   This option will be forced off on systems that do not support
                   the Kernel TLS data-path.

  enable-asan
                   Build with the Address sanitiser. This is a developer option
                   only. It may not work on all platforms and should never be
                   used in production environments. It will only work when used
                   with gcc or clang and should be used in conjunction with the
                   no-shared option.

  no-asm
                   Do not use assembler code. This should be viewed as
                   debugging/trouble-shooting option rather than production.
                   On some platforms a small amount of assembler code may
                   still be used even with this option.

  no-async
                   Do not build support for async operations.

  no-autoalginit
                   Don't automatically load all supported ciphers and digests.
                   Typically OpenSSL will make available all of its supported
                   ciphers and digests. For a statically linked application this
                   may be undesirable if small executable size is an objective.
                   This only affects libcrypto. Ciphers and digests will have to
                   be loaded manually using EVP_add_cipher() and
                   EVP_add_digest() if this option is used. This option will
                   force a non-shared build.

  no-autoerrinit
                   Don't automatically load all libcrypto/libssl error strings.
                   Typically OpenSSL will automatically load human readable
                   error strings. For a statically linked application this may
                   be undesirable if small executable size is an objective.

  no-autoload-config
                   Don't automatically load the default openssl.cnf file.
                   Typically OpenSSL will automatically load a system config
                   file which configures default ssl options.

  enable-buildtest-c++
                   While testing, generate C++ buildtest files that
                   simply check that the public OpenSSL header files
                   are usable standalone with C++.

                   Enabling this option demands extra care.  For any
                   compiler flag given directly as configuration
                   option, you must ensure that it's valid for both
                   the C and the C++ compiler.  If not, the C++ build
                   test will most likely break.  As an alternative,
                   you can use the language specific variables, CFLAGS
                   and CXXFLAGS.

  no-capieng
                   Don't build the CAPI engine. This option will be forced if
                   on a platform that does not support CAPI.

  no-cmp
                   Don't build support for CMP features

  no-cms
                   Don't build support for CMS features

  no-comp
                   Don't build support for SSL/TLS compression. If this option
                   is left enabled (the default), then compression will only
                   work if the zlib or zlib-dynamic options are also chosen.

  enable-crypto-mdebug
                   This now only enables the failed-malloc feature.

  enable-crypto-mdebug-backtrace
                   This is a no-op; the project uses the compiler's
                   address/leak sanitizer instead.

  no-ct
                   Don't build support for Certificate Transparency.

  no-deprecated
                   Don't build with support for deprecated APIs up
                   until and including the version given with
                   "--api" (or the current version of "--api" wasn't
                   given).

  no-dgram
                   Don't build support for datagram based BIOs. Selecting this
                   option will also force the disabling of DTLS.

  no-dso
                   Don't build support for loading Dynamic Shared Objects.

  enable-devcryptoeng
                   Build the /dev/crypto engine.  It is automatically selected
                   on BSD implementations, in which case it can be disabled with
                   no-devcryptoeng.

  no-dynamic-engine
                   Don't build the dynamically loaded engines. This only has an
                   effect in a "shared" build

  no-ec
                   Don't build support for Elliptic Curves.

  no-ec2m
                   Don't build support for binary Elliptic Curves

  enable-ec_nistp_64_gcc_128
                   Enable support for optimised implementations of some commonly
                   used NIST elliptic curves.
                   This is only supported on platforms:
                   - with little-endian storage of non-byte types
                   - that tolerate misaligned memory references
                   - where the compiler:
                     - supports the non-standard type __uint128_t
                     - defines the built-in macro __SIZEOF_INT128__

  enable-egd
                   Build support for gathering entropy from EGD (Entropy
                   Gathering Daemon).

  no-engine
                   Don't build support for loading engines.

  no-err
                   Don't compile in any error strings.

  enable-external-tests
                   Enable building of integration with external test suites.
                   This is a developer option and may not work on all platforms.
                   The only supported external test suite at the current time is
                   the BoringSSL test suite. See the file test/README.external
                   for further details.

  no-filenames
                   Don't compile in filename and line number information (e.g.
                   for errors and memory allocation).

  no-fips
                   Don't compile the FIPS module

  enable-fuzz-libfuzzer, enable-fuzz-afl
                   Build with support for fuzzing using either libfuzzer or AFL.
                   These are developer options only. They may not work on all
                   platforms and should never be used in production environments.
                   See the file fuzz/README.md for further details.

  no-gost
                   Don't build support for GOST based ciphersuites. Note that
                   if this feature is enabled then GOST ciphersuites are only
                   available if the GOST algorithms are also available through
                   loading an externally supplied engine.

  no-legacy
                   Don't build the legacy provider. Disabling this also disables
                   the legacy algorithms: MD2 (already disabled by default).

  no-makedepend
                   Don't generate dependencies.

  no-module
                   Don't build any dynamically loadable engines.  This also
                   implies 'no-dynamic-engine'.

  no-multiblock
                   Don't build support for writing multiple records in one
                   go in libssl (Note: this is a different capability to the
                   pipelining functionality).

  no-nextprotoneg
                   Don't build support for the NPN TLS extension.

  no-ocsp
                   Don't build support for OCSP.

  no-padlockeng
  no-hw-padlock
                   Don't build the padlock engine.
                   ('no-hw-padlock' is deprecated and should not be used)

  no-pic
                   Don't build with support for Position Independent Code.

  no-pinshared     By default OpenSSL will attempt to stay in memory until the
                   process exits. This is so that libcrypto and libssl can be
                   properly cleaned up automatically via an "atexit()" handler.
                   The handler is registered by libcrypto and cleans up both
                   libraries. On some platforms the atexit() handler will run on
                   unload of libcrypto (if it has been dynamically loaded)
                   rather than at process exit. This option can be used to stop
                   OpenSSL from attempting to stay in memory until the process
                   exits. This could lead to crashes if either libcrypto or
                   libssl have already been unloaded at the point
                   that the atexit handler is invoked, e.g. on a platform which
                   calls atexit() on unload of the library, and libssl is
                   unloaded before libcrypto then a crash is likely to happen.
                   Applications can suppress running of the atexit() handler at
                   run time by using the OPENSSL_INIT_NO_ATEXIT option to
                   OPENSSL_init_crypto(). See the man page for it for further
                   details.

  no-posix-io
                   Don't use POSIX IO capabilities.

  no-psk
                   Don't build support for Pre-Shared Key based ciphersuites.

  no-rdrand
                   Don't use hardware RDRAND capabilities.

  no-rfc3779
                   Don't build support for RFC3779 ("X.509 Extensions for IP
                   Addresses and AS Identifiers")

  sctp
                   Build support for SCTP

  no-shared
                   Do not create shared libraries, only static ones.  See "Note
                   on shared libraries" below.

  no-sock
                   Don't build support for socket BIOs

  no-srp
                   Don't build support for SRP or SRP based ciphersuites.

  no-srtp
                   Don't build SRTP support

  no-sse2
                   Exclude SSE2 code paths from 32-bit x86 assembly modules.
                   Normally SSE2 extension is detected at run-time, but the
                   decision whether or not the machine code will be executed
                   is taken solely on CPU capability vector. This means that
                   if you happen to run OS kernel which does not support SSE2
                   extension on Intel P4 processor, then your application
                   might be exposed to "illegal instruction" exception.
                   There might be a way to enable support in kernel, e.g.
                   FreeBSD kernel can  be compiled with CPU_ENABLE_SSE, and
                   there is a way to disengage SSE2 code paths upon application
                   start-up, but if you aim for wider "audience" running
                   such kernel, consider no-sse2. Both the 386 and
                   no-asm options imply no-sse2.

  enable-ssl-trace
                   Build with the SSL Trace capabilities (adds the "-trace"
                   option to s_client and s_server).

  no-static-engine
                   Don't build the statically linked engines. This only
                   has an impact when not built "shared".

  no-stdio
                   Don't use anything from the C header file "stdio.h" that
                   makes use of the "FILE" type. Only libcrypto and libssl can
                   be built in this way. Using this option will suppress
                   building the command line applications. Additionally since
                   the OpenSSL tests also use the command line applications the
                   tests will also be skipped.

  no-tests
                   Don't build test programs or run any test.

  no-threads
                   Don't try to build with support for multi-threaded
                   applications.

  threads
                   Build with support for multi-threaded applications. Most
                   platforms will enable this by default. However if on a
                   platform where this is not the case then this will usually
                   require additional system-dependent options! See "Note on
                   multi-threading" below.

  enable-trace
                   Build with support for the integrated tracing api. See manual pages
                   OSSL_trace_set_channel(3) and OSSL_trace_enabled(3) for details.

  no-ts
                   Don't build Time Stamping Authority support.

  enable-ubsan
                   Build with the Undefined Behaviour sanitiser. This is a
                   developer option only. It may not work on all platforms and
                   should never be used in production environments. It will only
                   work when used with gcc or clang and should be used in
                   conjunction with the "-DPEDANTIC" option (or the
                   --strict-warnings option).

  no-ui
                   Don't build with the "UI" capability (i.e. the set of
                   features enabling text based prompts).

  enable-unit-test
                   Enable additional unit test APIs. This should not typically
                   be used in production deployments.

  no-uplink
                   Don't build support for UPLINK interface.

  enable-weak-ssl-ciphers
                   Build support for SSL/TLS ciphers that are considered "weak"
                   (e.g. RC4 based ciphersuites).

  zlib
                   Build with support for zlib compression/decompression.

  zlib-dynamic
                   Like "zlib", but has OpenSSL load the zlib library
                   dynamically when needed.  This is only supported on systems
                   where loading of shared libraries is supported.

  386
                   In 32-bit x86 builds, when generating assembly modules,
                   use the 80386 instruction set only (the default x86 code
                   is more efficient, but requires at least a 486). Note:
                   This doesn't affect code generated by compiler, you're
                   likely to complement configuration command line with
                   suitable compiler-specific option.

  no-<prot>
                   Don't build support for negotiating the specified SSL/TLS
                   protocol (one of ssl, ssl3, tls, tls1, tls1_1, tls1_2,
                   tls1_3, dtls, dtls1 or dtls1_2). If "no-tls" is selected then
                   all of tls1, tls1_1, tls1_2 and tls1_3 are disabled.
                   Similarly "no-dtls" will disable dtls1 and dtls1_2. The
                   "no-ssl" option is synonymous with "no-ssl3". Note this only
                   affects version negotiation. OpenSSL will still provide the
                   methods for applications to explicitly select the individual
                   protocol versions.

  no-<prot>-method
                   As for no-<prot> but in addition do not build the methods for
                   applications to explicitly select individual protocol
                   versions. Note that there is no "no-tls1_3-method" option
                   because there is no application method for TLSv1.3. Using
                   individual protocol methods directly is deprecated.
                   Applications should use TLS_method() instead.

  enable-<alg>
                   Build with support for the specified algorithm, where <alg>
                   is one of: md2 or rc5.

  no-<alg>
                   Build without support for the specified algorithm, where
                   <alg> is one of: aria, bf, blake2, camellia, cast, chacha,
                   cmac, des, dh, dsa, ecdh, ecdsa, idea, md4, mdc2, ocb,
                   poly1305, rc2, rc4, rmd160, scrypt, seed, siphash, siv, sm2,
                   sm3, sm4 or whirlpool.  The "ripemd" algorithm is deprecated
                   and if used is synonymous with rmd160.

  -Dxxx, -Ixxx, -Wp, -lxxx, -Lxxx, -Wl, -rpath, -R, -framework, -static
                   These system specific options will be recognised and
                   passed through to the compiler to allow you to define
                   preprocessor symbols, specify additional libraries, library
                   directories or other compiler options. It might be worth
                   noting that some compilers generate code specifically for
                   processor the compiler currently executes on. This is not
                   necessarily what you might have in mind, since it might be
                   unsuitable for execution on other, typically older,
                   processor. Consult your compiler documentation.

                   Take note of the VAR=value documentation below and how
                   these flags interact with those variables.

  -xxx, +xxx, /xxx
                   Additional options that are not otherwise recognised are
                   passed through as they are to the compiler as well.
                   Unix-style options beginning with a '-' or '+' and
                   Windows-style options beginning with a '/' are recognized.
                   Again, consult your compiler documentation.

                   If the option contains arguments separated by spaces,
                   then the URL-style notation %20 can be used for the space
                   character in order to avoid having to quote the option.
                   For example, -opt%20arg gets expanded to -opt arg.
                   In fact, any ASCII character can be encoded as %xx using its
                   hexadecimal encoding.

                   Take note of the VAR=value documentation below and how
                   these flags interact with those variables.

  VAR=value
                   Assignment of environment variable for Configure.  These
                   work just like normal environment variable assignments,
                   but are supported on all platforms and are confined to
                   the configuration scripts only.  These assignments override
                   the corresponding value in the inherited environment, if
                   there is one.

                   The following variables are used as "make variables" and
                   can be used as an alternative to giving preprocessor,
                   compiler and linker options directly as configuration.
                   The following variables are supported:

                   AR              The static library archiver.
                   ARFLAGS         Flags for the static library archiver.
                   AS              The assembler compiler.
                   ASFLAGS         Flags for the assembler compiler.
                   CC              The C compiler.
                   CFLAGS          Flags for the C compiler.
                   CXX             The C++ compiler.
                   CXXFLAGS        Flags for the C++ compiler.
                   CPP             The C/C++ preprocessor.
                   CPPFLAGS        Flags for the C/C++ preprocessor.
                   CPPDEFINES      List of CPP macro definitions, separated
                                   by a platform specific character (':' or
                                   space for Unix, ';' for Windows, ',' for
                                   VMS).  This can be used instead of using
                                   -D (or what corresponds to that on your
                                   compiler) in CPPFLAGS.
                   CPPINCLUDES     List of CPP inclusion directories, separated
                                   the same way as for CPPDEFINES.  This can
                                   be used instead of -I (or what corresponds
                                   to that on your compiler) in CPPFLAGS.
                   HASHBANGPERL    Perl invocation to be inserted after '#!'
                                   in public perl scripts (only relevant on
                                   Unix).
                   LD              The program linker (not used on Unix, $(CC)
                                   is used there).
                   LDFLAGS         Flags for the shared library, DSO and
                                   program linker.
                   LDLIBS          Extra libraries to use when linking.
                                   Takes the form of a space separated list
                                   of library specifications on Unix and
                                   Windows, and as a comma separated list of
                                   libraries on VMS.
                   RANLIB          The library archive indexer.
                   RC              The Windows resource compiler.
                   RCFLAGS         Flags for the Windows resource compiler.
                   RM              The command to remove files and directories.

                   These cannot be mixed with compiling / linking flags given
                   on the command line.  In other words, something like this
                   isn't permitted.

                       ./config -DFOO CPPFLAGS=-DBAR -DCOOKIE

                   Backward compatibility note:

                   To be compatible with older configuration scripts, the
                   environment variables are ignored if compiling / linking
                   flags are given on the command line, except for these:

                   AR, CC, CXX, CROSS_COMPILE, HASHBANGPERL, PERL, RANLIB, RC
                   and WINDRES

                   For example, the following command will not see -DBAR:

                        CPPFLAGS=-DBAR ./config -DCOOKIE

                   However, the following will see both set variables:

                        CC=gcc CROSS_COMPILE=x86_64-w64-mingw32- \
                        ./config -DCOOKIE

                   If CC is set, it is advisable to also set CXX to ensure
                   both C and C++ compilers are in the same "family".  This
                   becomes relevant with 'enable-external-tests' and
                   'enable-buildtest-c++'.

  reconf
  reconfigure
                   Reconfigure from earlier data.  This fetches the previous
                   command line options and environment from data saved in
                   "configdata.pm", and runs the configuration process again,
                   using these options and environment.
                   Note: NO other option is permitted together with "reconf".
                   This means that you also MUST use "./Configure" (or
                   what corresponds to that on non-Unix platforms) directly
                   to invoke this option.
                   Note: The original configuration saves away values for ALL
                   environment variables that were used, and if they weren't
                   defined, they are still saved away with information that
                   they weren't originally defined.  This information takes
                   precedence over environment variables that are defined
                   when reconfiguring.

 Displaying configuration data
 -----------------------------

 The configuration script itself will say very little, and finishes by
 creating "configdata.pm".  This perl module can be loaded by other scripts
 to find all the configuration data, and it can also be used as a script to
 display all sorts of configuration data in a human readable form.

 For more information, please do:

       $ ./configdata.pm --help                         # Unix

       or

       $ perl configdata.pm --help                      # Windows and VMS

 Installation in Detail
 ----------------------

 1a. Configure OpenSSL for your operation system automatically:

     NOTE: This is not available on Windows.

       $ ./config [[ options ]]                         # Unix

       or

       $ @config [[ options ]]                          ! OpenVMS

     For the remainder of this text, the Unix form will be used in all
     examples, please use the appropriate form for your platform.

     This guesses at your operating system (and compiler, if necessary) and
     configures OpenSSL based on this guess. Run ./config -t to see
     if it guessed correctly. If you want to use a different compiler, you
     are cross-compiling for another platform, or the ./config guess was
     wrong for other reasons, go to step 1b. Otherwise go to step 2.

     On some systems, you can include debugging information as follows:

       $ ./config -d [[ options ]]

 1b. Configure OpenSSL for your operating system manually

     OpenSSL knows about a range of different operating system, hardware and
     compiler combinations. To see the ones it knows about, run

       $ ./Configure                                    # Unix

       or

       $ perl Configure                                 # All other platforms

     For the remainder of this text, the Unix form will be used in all
     examples, please use the appropriate form for your platform.

     Pick a suitable name from the list that matches your system. For most
     operating systems there is a choice between using "cc" or "gcc".  When
     you have identified your system (and if necessary compiler) use this name
     as the argument to Configure. For example, a "linux-elf" user would
     run:

       $ ./Configure linux-elf [[ options ]]

     If your system isn't listed, you will have to create a configuration
     file named Configurations/{{ something }}.conf and add the correct
     configuration for your system. See the available configs as examples
     and read Configurations/README and Configurations/README.design for
     more information.

     The generic configurations "cc" or "gcc" should usually work on 32 bit
     Unix-like systems.

     Configure creates a build file ("Makefile" on Unix, "makefile" on Windows
     and "descrip.mms" on OpenVMS) from a suitable template in Configurations,
     and defines various macros in include/openssl/configuration.h (generated
     from include/openssl/configuration.h.in).

 1c. Configure OpenSSL for building outside of the source tree.

     OpenSSL can be configured to build in a build directory separate from
     the directory with the source code.  It's done by placing yourself in
     some other directory and invoking the configuration commands from
     there.

     Unix example:

       $ mkdir /var/tmp/openssl-build
       $ cd /var/tmp/openssl-build
       $ /PATH/TO/OPENSSL/SOURCE/config [[ options ]]

       or

       $ /PATH/TO/OPENSSL/SOURCE/Configure {{ target }} [[ options ]]

     OpenVMS example:

       $ set default sys$login:
       $ create/dir [.tmp.openssl-build]
       $ set default [.tmp.openssl-build]
       $ @[PATH.TO.OPENSSL.SOURCE]config [[ options ]]

       or

       $ @[PATH.TO.OPENSSL.SOURCE]Configure {{ target }} [[ options ]]

     Windows example:

       $ C:
       $ mkdir \temp-openssl
       $ cd \temp-openssl
       $ perl d:\PATH\TO\OPENSSL\SOURCE\Configure {{ target }} [[ options ]]

     Paths can be relative just as well as absolute.  Configure will
     do its best to translate them to relative paths whenever possible.

  2. Build OpenSSL by running:

       $ make                                           # Unix
       $ mms                                            ! (or mmk) OpenVMS
       $ nmake                                          # Windows

     This will build the OpenSSL libraries (libcrypto.a and libssl.a on
     Unix, corresponding on other platforms) and the OpenSSL binary
     ("openssl"). The libraries will be built in the top-level directory,
     and the binary will be in the "apps" subdirectory.

     Troubleshooting:

     If the build fails, look at the output.  There may be reasons
     for the failure that aren't problems in OpenSSL itself (like
     missing standard headers).

     If the build succeeded previously, but fails after a source or
     configuration change, it might be helpful to clean the build tree
     before attempting another build. Use this command:

       $ make clean                                     # Unix
       $ mms clean                                      ! (or mmk) OpenVMS
       $ nmake clean                                    # Windows

     Assembler error messages can sometimes be sidestepped by using the
     "no-asm" configuration option.

     Compiling parts of OpenSSL with gcc and others with the system
     compiler will result in unresolved symbols on some systems.

     If you are still having problems you can get help by sending an email
     to the openssl-users email list (see
     https://www.openssl.org/community/mailinglists.html for details). If
     it is a bug with OpenSSL itself, please open an issue on GitHub, at
     https://github.com/openssl/openssl/issues. Please review the existing
     ones first; maybe the bug was already reported or has already been
     fixed.

  3. After a successful build, the libraries should be tested. Run:

       $ make test                                      # Unix
       $ mms test                                       ! OpenVMS
       $ nmake test                                     # Windows

     NOTE: you MUST run the tests from an unprivileged account (or
     disable your privileges temporarily if your platform allows it).

     If some tests fail, look at the output.  There may be reasons for
     the failure that isn't a problem in OpenSSL itself (like a
     malfunction with Perl).  You may want increased verbosity, that
     can be accomplished like this:

     Verbosity on failure only (make macro VERBOSE_FAILURE or VF):

       $ make VF=1 test                                 # Unix
       $ mms /macro=(VF=1) test                         ! OpenVMS
       $ nmake VF=1 test                                # Windows

     Full verbosity (make macro VERBOSE or V):

       $ make V=1 test                                  # Unix
       $ mms /macro=(V=1) test                          ! OpenVMS
       $ nmake V=1 test                                 # Windows

     If you want to run just one or a few specific tests, you can use
     the make variable TESTS to specify them, like this:

       $ make TESTS='test_rsa test_dsa' test            # Unix
       $ mms/macro="TESTS=test_rsa test_dsa" test       ! OpenVMS
       $ nmake TESTS='test_rsa test_dsa' test           # Windows

     And of course, you can combine (Unix example shown):

       $ make VF=1 TESTS='test_rsa test_dsa' test

     You can find the list of available tests like this:

       $ make list-tests                                # Unix
       $ mms list-tests                                 ! OpenVMS
       $ nmake list-tests                               # Windows

     Have a look at the manual for the perl module Test::Harness to
     see what other HARNESS_* variables there are.

     If you find a problem with OpenSSL itself, try removing any
     compiler optimization flags from the CFLAGS line in Makefile and
     run "make clean; make" or corresponding.

     To report a bug please open an issue on GitHub, at
     https://github.com/openssl/openssl/issues.

     For more details on how the make variables TESTS can be used,
     see section TESTS in Detail below.

  4. If everything tests ok, install OpenSSL with

       $ make install                                   # Unix
       $ mms install                                    ! OpenVMS
       $ nmake install                                  # Windows

     Note that in order to perform the install step above you need to have
     appropriate permissions to write to the installation directory.

     The above commands will install all the software components in this
     directory tree under PREFIX (the directory given with --prefix or its
     default):

       Unix:

         bin/           Contains the openssl binary and a few other
                        utility scripts.
         include/openssl
                        Contains the header files needed if you want
                        to build your own programs that use libcrypto
                        or libssl.
         lib            Contains the OpenSSL library files.
         lib/engines    Contains the OpenSSL dynamically loadable engines.

         share/man/man1 Contains the OpenSSL command line man-pages.
         share/man/man3 Contains the OpenSSL library calls man-pages.
         share/man/man5 Contains the OpenSSL configuration format man-pages.
         share/man/man7 Contains the OpenSSL other misc man-pages.

         share/doc/openssl/html/man1
         share/doc/openssl/html/man3
         share/doc/openssl/html/man5
         share/doc/openssl/html/man7
                        Contains the HTML rendition of the man-pages.

       OpenVMS ('arch' is replaced with the architecture name, "Alpha"
       or "ia64", 'sover' is replaced with the shared library version
       (0101 for 1.1), and 'pz' is replaced with the pointer size
       OpenSSL was built with):

         [.EXE.'arch']  Contains the openssl binary.
         [.EXE]         Contains a few utility scripts.
         [.include.openssl]
                        Contains the header files needed if you want
                        to build your own programs that use libcrypto
                        or libssl.
         [.LIB.'arch']  Contains the OpenSSL library files.
         [.ENGINES'sover''pz'.'arch']
                        Contains the OpenSSL dynamically loadable engines.
         [.SYS$STARTUP] Contains startup, login and shutdown scripts.
                        These define appropriate logical names and
                        command symbols.
         [.SYSTEST]     Contains the installation verification procedure.
         [.HTML]        Contains the HTML rendition of the manual pages.


     Additionally, install will add the following directories under
     OPENSSLDIR (the directory given with --openssldir or its default)
     for you convenience:

         certs          Initially empty, this is the default location
                        for certificate files.
         private        Initially empty, this is the default location
                        for private key files.
         misc           Various scripts.

     The installation directory should be appropriately protected to ensure
     unprivileged users cannot make changes to OpenSSL binaries or files, or
     install engines. If you already have a pre-installed version of OpenSSL as
     part of your Operating System it is recommended that you do not overwrite
     the system version and instead install to somewhere else.

     Package builders who want to configure the library for standard
     locations, but have the package installed somewhere else so that
     it can easily be packaged, can use

       $ make DESTDIR=/tmp/package-root install         # Unix
       $ mms/macro="DESTDIR=TMP:[PACKAGE-ROOT]" install ! OpenVMS

     The specified destination directory will be prepended to all
     installation target paths.

  Compatibility issues with previous OpenSSL versions:

  *  COMPILING existing applications

     Starting with version 1.1.0, OpenSSL hides a number of structures
     that were previously open.  This includes all internal libssl
     structures and a number of EVP types.  Accessor functions have
     been added to allow controlled access to the structures' data.

     This means that some software needs to be rewritten to adapt to
     the new ways of doing things.  This often amounts to allocating
     an instance of a structure explicitly where you could previously
     allocate them on the stack as automatic variables, and using the
     provided accessor functions where you would previously access a
     structure's field directly.

     Some APIs have changed as well.  However, older APIs have been
     preserved when possible.

 Environment Variables
 ---------------------

 A number of environment variables can be used to provide additional control
 over the build process. Typically these should be defined prior to running
 config or Configure. Not all environment variables are relevant to all
 platforms.

 AR
                The name of the ar executable to use.

 BUILDFILE
                Use a different build file name than the platform default
                ("Makefile" on Unix-like platforms, "makefile" on native Windows,
                "descrip.mms" on OpenVMS).  This requires that there is a
                corresponding build file template.  See Configurations/README
                for further information.

 CC
                The compiler to use. Configure will attempt to pick a default
                compiler for your platform but this choice can be overridden
                using this variable. Set it to the compiler executable you wish
                to use, e.g. "gcc" or "clang".

 CROSS_COMPILE
                This environment variable has the same meaning as for the
                "--cross-compile-prefix" Configure flag described above. If both
                are set then the Configure flag takes precedence.

 NM
                The name of the nm executable to use.

 OPENSSL_LOCAL_CONFIG_DIR
                OpenSSL comes with a database of information about how it
                should be built on different platforms as well as build file
                templates for those platforms. The database is comprised of
                ".conf" files in the Configurations directory.  The build
                file templates reside there as well as ".tmpl" files. See the
                file Configurations/README for further information about the
                format of ".conf" files as well as information on the ".tmpl"
                files.
                In addition to the standard ".conf" and ".tmpl" files, it is
                possible to create your own ".conf" and ".tmpl" files and store
                them locally, outside the OpenSSL source tree. This environment
                variable can be set to the directory where these files are held
                and will be considered by Configure before it looks in the
                standard directories.

 PERL
                The name of the Perl executable to use when building OpenSSL.
                This variable is used in config script only. Configure on the
                other hand imposes the interpreter by which it itself was
                executed on the whole build procedure.

 HASHBANGPERL
                The command string for the Perl executable to insert in the
                #! line of perl scripts that will be publicly installed.
                Default: /usr/bin/env perl
                Note: the value of this variable is added to the same scripts
                on all platforms, but it's only relevant on Unix-like platforms.

 RC
                The name of the rc executable to use. The default will be as
                defined for the target platform in the ".conf" file. If not
                defined then "windres" will be used. The WINDRES environment
                variable is synonymous to this. If both are defined then RC
                takes precedence.

 RANLIB
                The name of the ranlib executable to use.

 WINDRES
                See RC.

 Makefile targets
 ----------------

 The Configure script generates a Makefile in a format relevant to the specific
 platform. The Makefiles provide a number of targets that can be used. Not all
 targets may be available on all platforms. Only the most common targets are
 described here. Examine the Makefiles themselves for the full list.

 all
                The target to build all the software components and
                documentation.

 build_sw
                Build all the software components.
                THIS IS THE DEFAULT TARGET.

 build_docs
                Build all documentation components.

 clean
                Remove all build artefacts and return the directory to a "clean"
                state.

 depend
                Rebuild the dependencies in the Makefiles. This is a legacy
                option that no longer needs to be used since OpenSSL 1.1.0.

 install
                Install all OpenSSL components.

 install_sw
                Only install the OpenSSL software components.

 install_docs
                Only install the OpenSSL documentation components.

 install_man_docs
                Only install the OpenSSL man pages (Unix only).

 install_html_docs
                Only install the OpenSSL html documentation.

 list-tests
                Prints a list of all the self test names.

 test
                Build and run the OpenSSL self tests.

 uninstall
                Uninstall all OpenSSL components.

 reconfigure
 reconf
                Re-run the configuration process, as exactly as the last time
                as possible.

 update
                This is a developer option. If you are developing a patch for
                OpenSSL you may need to use this if you want to update
                automatically generated files; add new error codes or add new
                (or change the visibility of) public API functions. (Unix only).

 TESTS in Detail
 ---------------

 The make variable TESTS supports a versatile set of space separated tokens
 with which you can specify a set of tests to be performed.  With a "current
 set of tests" in mind, initially being empty, here are the possible tokens:

 alltests       The current set of tests becomes the whole set of available
                tests (as listed when you do 'make list-tests' or similar).
 xxx            Adds the test 'xxx' to the current set of tests.
 -xxx           Removes 'xxx' from the current set of tests.  If this is the
                first token in the list, the current set of tests is first
                assigned the whole set of available tests, effectively making
                this token equivalent to TESTS="alltests -xxx".
 nn             Adds the test group 'nn' (which is a number) to the current
                set of tests.
 -nn            Removes the test group 'nn' from the current set of tests.
                If this is the first token in the list, the current set of
                tests is first assigned the whole set of available tests,
                effectively making this token equivalent to
                TESTS="alltests -xxx".

 Also, all tokens except for "alltests" may have wildcards, such as *.
 (on Unix and Windows, BSD style wildcards are supported, while on VMS,
 it's VMS style wildcards)

 Example: All tests except for the fuzz tests:

 $ make TESTS=-test_fuzz test

 or (if you want to be explicit)

 $ make TESTS='alltests -test_fuzz' test

 Example: All tests that have a name starting with "test_ssl" but not those
 starting with "test_ssl_":

 $ make TESTS='test_ssl* -test_ssl_*' test

 Example: Only test group 10:

 $ make TESTS='10'

 Example: All tests except the slow group (group 99):

 $ make TESTS='-99'

 Example: All tests in test groups 80 to 99 except for tests in group 90:

 $ make TESTS='[89]? -90'

To stochastically verify that the algorithm that produces uniformly distributed
random numbers is operating correctly (with a false positive rate of 0.01%):

 $ ./util/shlib_wrap.sh test/bntest -stochastic

 Note on multi-threading
 -----------------------

 For some systems, the OpenSSL Configure script knows what compiler options
 are needed to generate a library that is suitable for multi-threaded
 applications.  On these systems, support for multi-threading is enabled
 by default; use the "no-threads" option to disable (this should never be
 necessary).

 On other systems, to enable support for multi-threading, you will have
 to specify at least two options: "threads", and a system-dependent option.
 (The latter is "-D_REENTRANT" on various systems.)  The default in this
 case, obviously, is not to include support for multi-threading (but
 you can still use "no-threads" to suppress an annoying warning message
 from the Configure script.)

 OpenSSL provides built-in support for two threading models: pthreads (found on
 most UNIX/Linux systems), and Windows threads. No other threading models are
 supported. If your platform does not provide pthreads or Windows threads then
 you should Configure with the "no-threads" option.

 Notes on shared libraries
 -------------------------

 For most systems the OpenSSL Configure script knows what is needed to
 build shared libraries for libcrypto and libssl. On these systems
 the shared libraries will be created by default. This can be suppressed and
 only static libraries created by using the "no-shared" option. On systems
 where OpenSSL does not know how to build shared libraries the "no-shared"
 option will be forced and only static libraries will be created.

 Shared libraries are named a little differently on different platforms.
 One way or another, they all have the major OpenSSL version number as
 part of the file name, i.e. for OpenSSL 1.1.x, 1.1 is somehow part of
 the name.

 On most POSIX platforms, shared libraries are named libcrypto.so.1.1
 and libssl.so.1.1.

 on Cygwin, shared libraries are named cygcrypto-1.1.dll and cygssl-1.1.dll
 with import libraries libcrypto.dll.a and libssl.dll.a.

 On Windows build with MSVC or using MingW, shared libraries are named
 libcrypto-1_1.dll and libssl-1_1.dll for 32-bit Windows, libcrypto-1_1-x64.dll
 and libssl-1_1-x64.dll for 64-bit x86_64 Windows, and libcrypto-1_1-ia64.dll
 and libssl-1_1-ia64.dll for IA64 Windows.  With MSVC, the import libraries
 are named libcrypto.lib and libssl.lib, while with MingW, they are named
 libcrypto.dll.a and libssl.dll.a.

 On VMS, shareable images (VMS speak for shared libraries) are named
 ossl$libcrypto0101_shr.exe and ossl$libssl0101_shr.exe.  However, when
 OpenSSL is specifically built for 32-bit pointers, the shareable images
 are named ossl$libcrypto0101_shr32.exe and ossl$libssl0101_shr32.exe
 instead, and when built for 64-bit pointers, they are named
 ossl$libcrypto0101_shr64.exe and ossl$libssl0101_shr64.exe.

 Note on random number generation
 --------------------------------

 Availability of cryptographically secure random numbers is required for
 secret key generation. OpenSSL provides several options to seed the
 internal CSPRNG. If not properly seeded, the internal CSPRNG will refuse
 to deliver random bytes and a "PRNG not seeded error" will occur.

 The seeding method can be configured using the --with-rand-seed option,
 which can be used to specify a comma separated list of seed methods.
 However in most cases OpenSSL will choose a suitable default method,
 so it is not necessary to explicitly provide this option. Note also
 that not all methods are available on all platforms.

 I) On operating systems which provide a suitable randomness source (in
 form  of a system call or system device), OpenSSL will use the optimal
 available  method to seed the CSPRNG from the operating system's
 randomness sources. This corresponds to the option --with-rand-seed=os.

 II) On systems without such a suitable randomness source, automatic seeding
 and reseeding is disabled (--with-rand-seed=none) and it may be necessary
 to install additional support software to obtain a random seed and reseed
 the CSPRNG manually.  Please check out the manual pages for RAND_add(),
 RAND_bytes(), RAND_egd(), and the FAQ for more information.