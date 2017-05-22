package PublishQueueManager::Task;
use strict;
use warning;

sub _normalize_publish_queue {
    my $app = MT->instance();
    #return 1 if $app->request( 'already_unpublished' ); # if both callbacks and tasks are performed, only callback will be performed.
    #my @blogs = MT::Blog->load( { class => '*' } );
    #my @titles;
    #for my $blog ( @blogs ) {
    #    push ( @titles, EntryUnpublish::Util::change_status( $app, $blog ) );
    #}
    #$app->request( 'already_unpublished', 1 );
    return 1;
}

1;