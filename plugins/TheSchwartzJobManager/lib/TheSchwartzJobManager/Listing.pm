package TheSchwartzJobManager::Listing;

use strict;
use MT::Util qw( epoch2ts format_ts );

our $plugin = MT->component( 'TheSchwartzJobManager' );

sub _terms_funcid {
    my ( $prop, $args, $db_terms, $db_args ) = @_;
    my $funcname = $args->{ value }
      or return;
    my $funcmap = mt->model( 'ts_funcmap' )->load({ funcname => $funcname })
      or return;
    $db_terms->{ funcid } = $funcmap->funcid;
    return;
}

1;
