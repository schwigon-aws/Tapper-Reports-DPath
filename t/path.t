#! perl

use Test::More tests => 14;

BEGIN {
        use Class::C3;
        use MRO::Compat;
}
use Artemis::Reports::DPath 'reports_dpath_search', 'rds';
use Artemis::Schema::TestTools;
use Test::Fixture::DBIC::Schema;
use Data::Dumper;

# -------------------- path division --------------------

my $dpath = new Artemis::Reports::DPath;
my $condition;
my $path;
my @res;

($condition, $path) = Artemis::Reports::DPath::_extract_condition_and_part('{ suite_name => "TestSuite-LmBench" } :: /tap/section/math/*/bogomips[0]');
is($condition, '{ suite_name => "TestSuite-LmBench" }', "condition easy");
is($path,      '/tap/section/math/*/bogomips[0]',       "path easy");

($condition, $path) = Artemis::Reports::DPath::_extract_condition_and_part('{ suite_name => "TestSuite::LmBench" } :: /tap/section/math/*/bogomips[0]');
is($condition, '{ suite_name => "TestSuite::LmBench" }', "condition colons");
is($path,      '/tap/section/math/*/bogomips[0]',        "path colons");

($condition, $path) = Artemis::Reports::DPath::_extract_condition_and_part('{ suite_name => "{TestSuite::LmBench}" } :: /tap/section/math/*/bogomips[0]');
is($condition, '{ suite_name => "{TestSuite::LmBench}" }', "condition balanced braces");
is($path,      '/tap/section/math/*/bogomips[0]',          "path balanced braces");

($condition, $path) = Artemis::Reports::DPath::_extract_condition_and_part('{ suite_name => "TestSuite::LmBench}" } :: /tap/section/math/*/bogomips[0]');
is($condition, '{ suite_name => "TestSuite::LmBench}" }', "condition unbalanced braces");
is($path,      '/tap/section/math/*/bogomips[0]',         "path unbalanced braces");

($condition, $path) = Artemis::Reports::DPath::_extract_condition_and_part('{ } :: /tap/section/math/*/bogomips[0]');
is($condition, '{ }',                                     "condition empty braces");
is($path,      '/tap/section/math/*/bogomips[0]',         "path unbalanced braces");

($condition, $path) = Artemis::Reports::DPath::_extract_condition_and_part(':: /tap/section/math/*/bogomips[0]');
is($condition, undef,                                     "condition just colons");
is($path,      '/tap/section/math/*/bogomips[0]',         "path unbalanced braces");

($condition, $path) = Artemis::Reports::DPath::_extract_condition_and_part('/tap/section/math/*/bogomips[0]');
is($condition, undef,                                     "condition no braces no colons");
is($path,      '/tap/section/math/*/bogomips[0]',         "path unbalanced braces");
