package TheSchwartzJobManager::Listing;

use strict;
use MT::Util qw( epoch2ts format_ts );

our $plugin = MT->component( 'TheSchwartzJobManager' );

sub _list_actions_tsjob {
    my $app = MT->instance;
    return if ( $app->param( 'dialog_view' ) );
    return {
        'priority' => {
            label      => 'Change Priority',
            code       => $TheSchwartzJobManager::TheSchwartzJobManager::Plugin::_priority,
            input      => 1,
            input_label => "Enter a priority from 1 to 10 to assign to the selected job(s) (1 = lowest, 10 = highest):",
        },
        'delete' => {
            label      => 'Delete',
            code       => $TheSchwartzJobManager::TheSchwartzJobManager::Plugin::_delete,
            button     => 1,
        },
        #'publish' => {
        #    label      => 'Publish',
        #    code       => $TheSchwartzJobManager::TheSchwartzJobManager::Plugin::_publish,
        #    button     => 1,
        #},
    };
}

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
