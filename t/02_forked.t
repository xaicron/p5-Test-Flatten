use strict;
use warnings;
use Test::More;
use Test::SharedFork;
use Test::Flatten;

subtest 'foo' => sub {
    pass 'parent one';
    pass 'parent two';
    my $pid = fork;
    unless ($pid) {
        pass 'child one';
        pass 'child two';
        pass 'child three';
        exit;
    }
    wait;
    pass 'parent three';
};

done_testing;
