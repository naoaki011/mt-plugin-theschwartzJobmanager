# Publish Queue Manager Plugin for Movable Type
# Author: Byrne Reese, byrne at majordojo dot com
# Copyright (C) 2008 Six Apart, Ltd.
package PQManager::Plugin;

use strict;
use MT::Util qw( relative_date epoch2ts iso2ts );
use warnings;
use Carp;

sub hdlr_widget {
    my $app = shift;
    my ($tmpl, $param) = @_;

    my @data;
    my $task_workers = MT->component('core')->registry('task_workers');
    for my $name (keys %$task_workers) {
        my $worker = $task_workers->{$name};
        my $funcmap = MT->model('ts_funcmap')->load({
            funcname => $worker->{class}
        }, {
            unique   => 1
        })
            or next;
        my $count = MT->model('ts_job')->count({
            funcid   => $funcmap->funcid
        });

        push @data, {
            name  => $name,
            label => $worker->{label},
            count => $count,
        };
    }
    $param->{data} = \@data;

    1;
}

sub mode_delete {
    my $app = shift;
    $app->validate_magic
      or return;

    require MT::TheSchwartz::Job;
    my @jobs = $app->param('id');
    for my $job_id (@jobs) {
        my $job = MT::TheSchwartz::Job->load({jobid => $job_id})
          or next;
        $job->remove();
    }
    $app->redirect(
            $app->uri(
                'mode' => 'list',
                args   => {
                    _type => 'ts_job',
                    blog_id => 0,
                    deleted => 1,
                }
            )
        );
}

sub mode_priority {
    my $app = shift;
    $app->validate_magic or return;

    my $pri = $app->param('itemset_action_input');
    if (($pri !~ /^[0-9]+$/)||($pri > 10)) {
        return $app->error("You must enter a number between 1 and 10.");
    }

    require MT::TheSchwartz::Job;
    my @jobs = $app->param('id');
    for my $job_id (@jobs) {
        my $job = MT::TheSchwartz::Job->load({jobid => $job_id}) or next;
        $job->priority($pri);
    $job->save();
    }
    $app->redirect(
            $app->uri(
                'mode' => 'list',
                args   => {
                    _type => 'ts_job',
                    blog_id => 0,
                    priority => $pri,
                }
            )
        );
}

1;
