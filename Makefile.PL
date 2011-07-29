use inc::Module::Install;
name 'Test-Flatten';
all_from 'lib/Test/Flatten.pm';

test_requires 'Test::More', 0.96;
test_requires 'Test::SharedFork', 0.16;

tests join q{ }, map { sprintf 't%s.t', '/*' x $_ } 1..3;
author_tests 'xt';

auto_set_repository();

WriteAll;
