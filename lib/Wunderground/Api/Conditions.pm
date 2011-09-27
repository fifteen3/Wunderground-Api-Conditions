package Wunderground::Api::Conditions;

use Moose;
use LWP::UserAgent;
use JSON::PP;

=head1 NAME

Wunderground::Api::Conditions - The great new Wunderground::Api::Conditions!

=head1 VERSION

Version 0.01

=cut

has 'version' => ( is => 'ro', default => '0.01' );
has 'key' => ( is => 'ro', lazy_build => 1, required => 1, isa => 'Str' );
has 'location' => ( is => 'rw', isa => 'Str' );
has 'ua' => ( is => 'ro', default => sub {  LWP::UserAgent->new(); } );
has 'json_handler' => ( is => 'ro', default => sub {  JSON::PP->new(); } );
has 'http_endpoint' => ( is => 'ro', default => 'http://api.wunderground.com/api/' );

=head1 SYNOPSIS

    use Wunderground::Api::Conditions;
    my $conifg = {
                   key => 'Your API Key',
                   location => 'San Francisco, CA',
                   ua => LWP::UserAgent->new,
                   json_handler => JSON::XS->new
                 };
    my $weather_report = Wunderground::Api::Conditions->new($config);
    my $current_conditions = $weather_report->current_conditions();
    $current_conditions->{"temp_f"};

=head1 SUBROUTINES/METHODS

=head2 current_conditions
    Get the conditions for a given time period. If no time period is specificed, the current conditions will be returned.
    If a location has not been configured for the object, no results will be returned and an exception will be thrown indicating
    that a location has not been set.
=cut

sub current_conditions {
        my ($self) = @_;

        die( "A Location or API key has not been set for the current request." ) unless ($self->key && $self->location);

        my $res = $self->ua->get( $self->http_endpoint . $self->key . "/conditions/q/" . $self->location . ".json" );
        if (!$res->is_success) {
            return;
        }

        return $self->json_handler->decode( $res->decoded_content )->{'current_observation'};
}

=head1 AUTHOR

Carlo Costantini, C<< <carlo at carlocostantini.ca> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-wunderground-api-conditions at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Wunderground-Api-Conditions>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Wunderground::Api::Conditions


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Wunderground-Api-Conditions>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Wunderground-Api-Conditions>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Wunderground-Api-Conditions>

=item * Search CPAN

L<http://search.cpan.org/dist/Wunderground-Api-Conditions/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2011 Carlo Costantini.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of Wunderground::Api::Conditions
