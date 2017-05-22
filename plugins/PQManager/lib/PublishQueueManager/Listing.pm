package PublishQueueManager::Listing;

use strict;
use MT::Util qw( epoch2ts format_ts );

our $plugin = MT->component( 'PublishQueueManager' );

sub _list_actions_tsjob {
    my $app = MT->instance;
    return if ( $app->param( 'dialog_view' ) );
    return {
        'priority' => {
            label      => 'Change Priority',
            code       => $PublishQueueManager::PublishQueueManager::Plugin::_priority,
            input      => 1,
            input_label => "Enter a priority from 1 to 10 to assign to the selected job(s) (1 = lowest, 10 = highest):",
        },
        'delete' => {
            label      => 'Delete',
            code       => $PublishQueueManager::PublishQueueManager::Plugin::_delete,
            button     => 1,
        },
        #'publish' => {
        #    label      => 'Publish',
        #    code       => $PublishQueueManager::PublishQueueManager::Plugin::_publish,
        #    button     => 1,
        #},
    };
}

sub _list_properties_tsjob {
    my $app = MT->instance;
    return {
        'jobid' => {
            auto       => 1,
            label      => 'ID',
            order      => 100,
            display    => 'default',
        },
        'uniqkey' => {
            auto       => 1,
            label      => 'Uniqkey',
            order      => 150,
            display    => 'option',
        },
        'priority' => {
            auto       => 1,
            label      => 'Priority',
            order      => 200,
            display    => 'default',
        },
        'insert_time' => {
            auto       => 1,
            label      => 'Inserted',
            order      => 300,
            display    => 'force',
            filter_editable => 0,
            html       => &_prpp_insert_time,
        },
        #'publish_path' => {
        #    label      => 'Publish Path',
        #    base       =>  __virtual.string,
        #    display    => 'default',
        #    order      => 400,
        #    filter_editable => 0,
        #    html       => {
        #        my ($prop, $obj, $app) = @_;
        #        my $fi = mt->model( 'fileinfo' )->load({ id => $obj->uniqkey })
        #            or return qq{ <em>Load Failure</em> };
        #        my $url = $fi->url || 'No PublishPath';
        #        my $out = qq {
        #           <span>$url</span>
        #        };
        #        return $out;
        #    },
        #},
        #'blog' => {
        #    label      => 'Blog',
        #    base       =>  __virtual.string,
        #    display    => 'option',
        #    order      => 450,
        #    filter_editable => 0,
        #    html       => {
        #        my ($prop, $obj, $app) = @_;
        #        my $fi = mt->model( 'fileinfo' )->load({ id => $obj->uniqkey })
        #            or return qq{ <span>-</span> };
        #        my $blog = mt->model( 'blog' )->load({ id => $fi->blog_id })
        #            or return qq{ <span>-</span> };
        #        my $blog_name = $blog->name;
        #        my $blog_id = $blog->id;
        #        my $admin_script = MT->config( 'AdminScript' );
        #        my $out = qq {
        #            <span><a href="./$admin_script?blog_id=$blog_id">$blog_name</a></span>
        #        };
        #        return $out;
        #    },
        #    condition   => {
        #        my ($prop, $obj, $app) = @_;
        #        return 1;
        #    },
        #},
        #'archive_type' => {
        #    label      => 'Archive Type',
        #    base       => __virtual.string,
        #    display    => 'option',
        #    order      => 500,
        #    filter_editable => 0,
        #    html       => {
        #        my ($prop, $obj, $app) = @_;
        #        my $fi = mt->model( 'fileinfo' )->load({ id => $obj->uniqkey })
        #            or return qq{ <span>-</span> };
        #        my $archive_type = $fi->archive_type || 'No ArchiveType';
        #        my $out = qq {
        #            <span>$archive_type</span>
        #        };
        #        return $out;
        #    },
        #},
        #'entry' => {
        #    label      =>  'Entry',
        #    base       =>  __virtual.string,
        #    display    =>  'default',
        #    order      =>  550,
        #    filter_editable =>  0,
        #    html       => {
        #        my ($prop, $obj, $app) = @_;
        #        my $fi = mt->model( 'fileinfo' )->load({ id => $obj->uniqkey })
        #            or return qq{ <span>-</span> };
        #        my $entry_id = $fi->entry_id || '';
        #        my $out = '';
        #        if ($entry_id) {
        #            my $blog_id = $fi->blog_id || 0;
        #            my $entry_type = ($fi->archive_type eq 'Individual') ? 'entry' : 'page';
        #            my $entry = mt->model( 'entry' )->load( $entry_id )
        #                or return '<em>Load Entry Failure</em>';
        #            my $entry_title = $entry->title || 'no title';
        #            my $admin_script = MT->config( 'AdminScript' );
        #            $out = qq {
        #                <span><a href="./$admin_script?__mode=view&_type=$entry_type&blog_id=$blog_id&id=$entry_id">$entry_title</a></span>
        #            };
        #        }
        #        $entry_id ? return $out : ($fi->archive_type eq 'Individual')||($fi->archive_type eq 'Page')
        #            ? return '<span>No EntryID</span>' : return '<span>-</span>';
        #    },
        #},
        #'template' => {
        #    label      => 'Template',
        #    base       => __virtual.string,
        #    display    => 'default',
        #    order      =>  600,
        #    filter_editable => 0,
        #    html       => {
        #        my ($prop, $obj, $app) = @_;
        #        my $fi = mt->model( 'fileinfo' )->load({ id => $obj->uniqkey })
        #            or return qq{ <span>-</span> };
        #        my $tmpl = mt->model( 'template' )->load({ id => $fi->template_id });
        #        if ($tmpl) {
        #            my $template_name = $tmpl->name || 'no name';
        #            my $blog_id = $fi->blog_id || 0;
        #            my $template_id = $fi->template_id;
        #            my $admin_script = MT->config( 'AdminScript' );
        #            my $out = qq {
        #               <span><a href="./$admin_script?__mode=view&_type=template&id=$template_id&blog_id=$blog_id">$template_name</a></span>
        #            };
        #            return $out;
        #        } else {
        #            return qq{ '<em>No Template</em>' };
        #        }
        #    },
        #},
        'funcid' => {
            auto       => 1,
            label      => 'Funcid',
            order      => 700,
            display    => 'default',
            filter_editable => 0,
        },
        #coalesce:
        #  auto: 1
        #  label: Coalesce
        #  order: 650
        #  display: option
        #  filter_editable: 0
        #grabbed_until:
        #  auto: 1
        #  label: Grabbed Until
        #  order: 750
        #  display: option
        #  filter_editable: 0
        #run_after:
        #  auto: 1
        #  label: Run After
        #  order: 800
        #  display: option
        #  filter_editable: 0
        #err:
        #  label: Error
        #  base: __virtual.string
        #  display: option
        #  order: 900
        #  filter_editable: 0
        #  html: >
        #    sub {
        #      my ($prop, $obj, $app) = @_;
        #      require MT::TheSchwartz::Error;
        #      my $err = MT::TheSchwartz::Error->load({ jobid => $obj->jobid });
        #      my $err_msg = $err ? $err->message : undef;
        #      my $out = $err_msg ? qq {
        #       <span>$err_msg</span>
        #      } : '';
        #      return $out;
        #    }
        
    };
}

sub _prpp_insert_time {
    my ($prop, $obj, $app) = @_;
    #my $inser_ts = epoch2ts($app->blog, $obj->insert_time);
    #my $insert_date =
    #    format_ts( MT::App::CMS::LISTING_DATE_FORMAT(), $inser_ts, $app->blog, $app->user ? $app->user->preferred_language : undef );
    #my $insert_time =
    #    format_ts( '%I:%M:%S%p', $inser_ts, $app->blog, $app->user ? $app->user->preferred_language : undef );
    #my $out = qq {
    #    <span>$insert_date<br />$insert_time</span>
    #};
    #return $out;
    return 1;
}

1;
