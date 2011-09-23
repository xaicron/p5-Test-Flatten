use inc::Module::Install;
name 'Test-Flatten';
all_from 'lib/Test/Flatten.pm';

test_requires 'Test::More', 0.96;
test_requires 'Test::Requires', 0.06;

tests join q{ }, map { sprintf 't%s.t', '/*' x $_ } 1..3;
author_tests 'xt';

repository 'https://github.com/xaicron/p5-Test-Flatten';
bugtracker 'https://github.com/xaicron/p5-Test-Flatten/issues';

WriteAll;
