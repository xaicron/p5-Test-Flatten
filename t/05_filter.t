use strict;
use warnings;
use Test::More;
use Test::Flatten;

plan tests => 2;

$ENV{SUBTEST_FILTER} = 'bar';

subtest 'foo' => sub {
    pass 'loooooooop' while 1;
};

subtest 'bar' => sub {
    pass 'bar is matched';
};

$ENV{SUBTEST_FILTER} = 'nest';

subtest 'nest' => sub {
    subtest 'pass' => sub {
        pass 'nest passed';
    };
};

subtest 'not passed' => sub {
    subtest 'nest' => sub {
        fail 'oops!';
    };
};
