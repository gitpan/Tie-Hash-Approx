use ExtUtils::MakeMaker;

# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'         => 'Tie::Hash::Approx',
    'VERSION_FROM' => 'Approx.pm',
    'PREREQ_PM'    => { 'Test::More' => 0,
		    			'String::Approx' => 1,},
    'LIBS'         => [''],
    'DEFINE'       => '',
    'INC'          => '',
);


