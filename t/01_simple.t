use strict;
use warnings;
use Test::More;
use Test::Flatten;

subtest 'foo' => sub {
    pass 'ok';
};

subtest 'bar' => sub {
    pass 'ok';
    subtest 'baz' => sub {
        pass 'ok';
    };
};

done_testing;
