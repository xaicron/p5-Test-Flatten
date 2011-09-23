use strict;
use warnings;
use Test::More;
use Test::Flatten;

pass 'ok';

subtest 'foo' => sub {
    pass 'ok';
};

subtest 'bar' => sub {
    pass 'ok';
    subtest 'baz' => sub {
        pass 'ok';
    };
};

pass 'ok';

done_testing;
