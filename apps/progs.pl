#!/usr/local/bin/perl
# Generate progs.h file from list of "programs" passed on the command line.

print <<'EOF';
/*
 * Automatically generated by progs.pl for openssl.c
 * Copyright (c) 2008 The OpenSSL Project.  All rights reserved.
 * See the openssl.c for copyright details.
 */

typedef enum FUNC_TYPE {
    FT_none, FT_general, FT_md, FT_cipher, FT_pkey,
    FT_md_alg, FT_cipher_alg
} FUNC_TYPE;

typedef struct function_st {
    FUNC_TYPE type;
    const char *name;
    int (*func)(int argc,char *argv[]);
    const OPTIONS *help;
} FUNCTION;

DEFINE_LHASH_OF(FUNCTION);

EOF

grep(s/\.o//, @ARGV);
grep(s/^asn1pars$/asn1parse/, @ARGV);
grep(s/^crl2p7$/crl2pkcs7/, @ARGV);
push @ARGV, 'list';
push @ARGV, 'help';
push @ARGV, 'exit';

foreach (@ARGV) {
	printf "extern int %s_main(int argc, char *argv[]);\n", $_;
}

print "\n";

foreach (@ARGV) {
	printf "extern OPTIONS %s_options[];\n", $_;
}
print "\n#ifdef INCLUDE_FUNCTION_TABLE\n";
print "static FUNCTION functions[] = {\n";
foreach (@ARGV) {
	$str="    { FT_general, \"$_\", ${_}_main, ${_}_options },\n";
	if (/^s_/ || /^ciphers$/) {
		print "#if !defined(OPENSSL_NO_SOCK)\n${str}#endif\n";
	} elsif (/^engine$/) {
		print "#ifndef OPENSSL_NO_ENGINE\n${str}#endif\n";
	} elsif (/^rsa$/ || /^genrsa$/ || /^rsautl$/) {
		print "#ifndef OPENSSL_NO_RSA\n${str}#endif\n";
	} elsif (/^dsa$/ || /^gendsa$/ || /^dsaparam$/) {
		print "#ifndef OPENSSL_NO_DSA\n${str}#endif\n";
	} elsif (/^ec$/ || /^ecparam$/) {
		print "#ifndef OPENSSL_NO_EC\n${str}#endif\n";
	} elsif (/^dh$/ || /^gendh$/ || /^dhparam$/) {
		print "#ifndef OPENSSL_NO_DH\n${str}#endif\n";
	} elsif (/^pkcs12$/) {
		print "#if !defined(OPENSSL_NO_DES)\n${str}#endif\n";
	} elsif (/^cms$/) {
		print "#ifndef OPENSSL_NO_CMS\n${str}#endif\n";
	} elsif (/^ocsp$/) {
		print "#ifndef OPENSSL_NO_OCSP\n${str}#endif\n";
	} elsif (/^srp$/) {
		print "#ifndef OPENSSL_NO_SRP\n${str}#endif\n";
	} else {
		print $str;
	}
}

foreach (
	"md2", "md4", "md5",
	"md_ghost94",
	"sha1", "sha224", "sha256", "sha384", "sha512",
	"mdc2", "rmd160"
) {
        printf "#ifndef OPENSSL_NO_".uc($_)."\n" if ! /sha/;
        printf "    { FT_md, \"".$_."\", dgst_main},\n";
        printf "#endif\n" if ! /sha/;
}

foreach (
	"aes-128-cbc", "aes-128-ecb",
	"aes-192-cbc", "aes-192-ecb",
	"aes-256-cbc", "aes-256-ecb",
	"camellia-128-cbc", "camellia-128-ecb",
	"camellia-192-cbc", "camellia-192-ecb",
	"camellia-256-cbc", "camellia-256-ecb",
	"base64", "zlib",
	"des", "des3", "desx", "idea", "seed", "rc4", "rc4-40",
	"rc2", "bf", "cast", "rc5",
	"des-ecb", "des-ede",    "des-ede3",
	"des-cbc", "des-ede-cbc","des-ede3-cbc",
	"des-cfb", "des-ede-cfb","des-ede3-cfb",
	"des-ofb", "des-ede-ofb","des-ede3-ofb",
	"idea-cbc","idea-ecb",    "idea-cfb", "idea-ofb",
	"seed-cbc","seed-ecb",    "seed-cfb", "seed-ofb",
	"rc2-cbc", "rc2-ecb", "rc2-cfb","rc2-ofb", "rc2-64-cbc", "rc2-40-cbc",
	"bf-cbc",  "bf-ecb",     "bf-cfb",   "bf-ofb",
	"cast5-cbc","cast5-ecb", "cast5-cfb","cast5-ofb",
	"cast-cbc", "rc5-cbc",   "rc5-ecb",  "rc5-cfb",  "rc5-ofb"
) {
	$str="    { FT_cipher, \"$_\", enc_main, enc_options },\n";
	if (/des/) {
		printf "#ifndef OPENSSL_NO_DES\n${str}#endif\n";
	} elsif (/aes/) {
		printf "#ifndef OPENSSL_NO_AES\n${str}#endif\n";
	} elsif (/camellia/) {
		printf "#ifndef OPENSSL_NO_CAMELLIA\n${str}#endif\n";
	} elsif (/idea/) {
		printf "#ifndef OPENSSL_NO_IDEA\n${str}#endif\n";
	} elsif (/seed/) {
		printf "#ifndef OPENSSL_NO_SEED\n${str}#endif\n";
	} elsif (/rc4/) {
		printf "#ifndef OPENSSL_NO_RC4\n${str}#endif\n";
	} elsif (/rc2/) {
		printf "#ifndef OPENSSL_NO_RC2\n${str}#endif\n";
	} elsif (/bf/) {
		printf "#ifndef OPENSSL_NO_BF\n${str}#endif\n";
	} elsif (/cast/) {
		printf "#ifndef OPENSSL_NO_CAST\n${str}#endif\n";
	} elsif (/rc5/) {
		printf "#ifndef OPENSSL_NO_RC5\n${str}#endif\n";
	} elsif (/zlib/) {
		printf "#ifdef ZLIB\n${str}#endif\n";
	} else {
		print $str;
	}
}

print "    { 0, NULL, NULL}\n};\n";
printf "#endif\n";
