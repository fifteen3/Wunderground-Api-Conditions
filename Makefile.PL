use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Wunderground::Api::Conditions',
    AUTHOR              => q{Carlo Costantini <carlo@carlocostantini.ca>},
    VERSION_FROM        => 'lib/Wunderground/Api/Conditions.pm',
    ABSTRACT_FROM       => 'lib/Wunderground/Api/Conditions.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Wunderground-Api-Conditions-*' },
);
