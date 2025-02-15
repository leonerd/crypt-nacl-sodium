
use strict;
use warnings;
use Test::More;


use Crypt::NaCl::Sodium qw(:utils);

my $bin = 'ABC';
my $hex = bin2hex($bin);
is($hex, "414243", "bin2hex(ABC)");
my $bin2 = hex2bin($hex);
is($bin2, $bin, "hex2bin(hex)");

my @hex = (
    '414243',
    '41 42 43',
    '41:4243',
);

for my $hex ( @hex ) {
    my $bin3 = hex2bin( $hex, ignore => ': ' );
    is($bin3, $bin, "hex2bin($hex, ignore => ': ')");
}
is(hex2bin( '414243', max_len => 2 ), 'AB',
    "hex2bin(414243, max_len => 2) == AB");
is(hex2bin( '41 42 43', max_len => 2 ), 'A',
    "hex2bin(41 42 43, max_len => 2) == A");
is(hex2bin( '41:42:43', ignore => ':', max_len => 2 ), 'AB',
    "hex2bin(41:42:43, ignore => ':', max_len => 2) == AB");
is(hex2bin( '41:42:43', max_len => 2 ), 'A',
    "hex2bin(41:42:43, max_len => 2) == A");

my ($a, $b) = ( "abc", "abC");

ok( ! memcmp($a, $b), "'abc' and 'abC' differ");

eval {
    my $res = memcmp("ab", "abc");
};
like($@, qr/^Variables of unequal length/, "variables of unequal length cannot be compared without length specified");

ok( memcmp("ab", "abc", 2), "first two chars are equal");

eval {
    my $res = memcmp("ab", "abc", 3);
};
like($@, qr/^First argument is shorter/, "length=3 > ab");

eval {
    my $res = memcmp("abcd", "abc", 4);
};
like($@, qr/^Second argument is shorter/, "length=4 > abc");

memzero($a, $b);
is(length($a), 3, "memzero(a) preserves length");
like($a, qr/^\0{3}$/, "...and replaces with null bytes");
is(length($b), 3, "memzero(a) preserves length");
like($b, qr/^\0{3}$/, "...and replaces with null bytes");

for my $i ( 0 .. 10 ) {
    my $max = $i ** 10;
    for ( 1 .. 10 ) {
        my $n;
        if ( $max && $max % 3 == 0 ) {
            $n = random_number( $max );
            ok($n < $max, "$n < $max generated");
        } else {
            $n = random_number();
            ok($n, "$n without upper bound generated");
        }
    }
}

my $rbytes = random_bytes(10);
ok($rbytes, "got random bytes");
is(length($rbytes), 10, "...and 10 as requested");

eval {
    my $t = random_bytes(0);
};
like($@, qr/^Invalid length/, "at least 1 random byte needs to be requested");

done_testing();

