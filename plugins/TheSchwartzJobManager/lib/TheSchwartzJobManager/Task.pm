package TheSchwartzJobManager::Task;
use strict;
use warning;

sub _normalize_publish_queue {
    my $app = MT->instance();
    my $pqjob_funcid = 2;
    my @jobs = mt->model('ts_job')->load({ funcid => $pqjob_funcid });
    for my $job ( @jobs ) {
        my $ellegal_job = 0;
        my $fi = mt->model( 'fileinfo' )->load({ id => $job->uniqkey })
          or $ellegal_job = 1;
        my $entry_id = $fi->entry_id
          or $ellegal_job = 1;
        my $entry = mt->model( 'entry' )->load({ id => $fi->entry_id })
          or $ellegal_job = 1;
        $ellegal_job = 1 if ($entry->status != 2);
        my $tmpl = mt->model( 'template' )->load({ id => $fi->template_id })
          or $ellegal_job = 1;


        $job->remove if $ellegal_job;
    }
    return 1;
}

1;