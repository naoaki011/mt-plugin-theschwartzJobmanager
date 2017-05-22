package PublishQueueManager::Plugin;

use strict;
use MT::Util qw( epoch2ts iso2ts );
use warnings;

sub _delete {
    my $app = shift;
    $app->validate_magic
      or return;

    my @jobs = $app->param('id');
    for my $job_id (@jobs) {
        my $job = MT->model('ts_job')->load({jobid => $job_id})
          or next;
        my $funcmap = MT->model('ts_funcmap')->load({funcid => $job->funcid})
          or next;
        next unless ($funcmap->funcname eq 'MT::Worker::Publish');
        $job->remove();
    }
    $app->redirect(
        $app->uri(
            mode => 'list',
            args   => {
                _type => 'ts_job',
                blog_id => 0,
                deleted => 1,
            }
        )
    );
}

sub _publish {
    my $app = shift;
    $app->validate_magic
      or return;

    require MT::WeblogPublisher;
    my @jobs = $app->param('id');
    my $pub = MT::WeblogPublisher->new;
    for my $job_id (@jobs) {
        my $job = MT->model('ts_job')->load({jobid => $job_id})
          or next;
        my $funcmap = MT->model('ts_funcmap')->load({funcid => $job->funcid})
          or next;
        next unless ($funcmap->funcname eq 'MT::Worker::Publish');
        if ( my $key = $job->uniqkey ) {
            if ( my $finfo = MT->model('fileinfo')->load( $key ) ) {
                if ( $pub->rebuild_from_fileinfo( $finfo ) ) {
                    $job->remove
                      or die $job->errstr;
                }
            }
        }
    }
    $app->redirect(
        $app->uri(
            mode => 'list',
            args   => {
                _type => 'ts_job',
                blog_id => 0,
                published => 1,
            }
        )
    );
}

sub _priority {
    my $app = shift;
    $app->validate_magic
      or return;

    my $pri = $app->param('itemset_action_input');
    if (($pri !~ /^[0-9]+$/)||($pri > 10)) {
        return $app->error("You must enter a number between 1 and 10.");
    }
    my @jobs = $app->param('id');
    for my $job_id (@jobs) {
        my $job = MT->model('ts_job')->load({jobid => $job_id})
          or next;
        my $funcmap = MT->model('ts_funcmap')->load({funcid => $job->funcid})
          or next;
        next unless ($funcmap->funcname eq 'MT::Worker::Publish');
        $job->priority($pri);
        $job->save();
    }
    $app->redirect(
        $app->uri(
            mode => 'list',
            args   => {
                _type => 'ts_job',
                blog_id => 0,
                priority => $pri,
            }
        )
    );
}

1;
