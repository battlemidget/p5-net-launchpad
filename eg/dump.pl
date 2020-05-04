#!/usr/bin/env perl
#
# for quick tests only, should not be depended upon for
# proper examples of current api.

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";
use Net::Launchpad::Client;
use Mojo::IOLoop;

# use List::AllUtils qw(first);
use Data::Dumper::Concise;

die "Missing envs"
  unless $ENV{LP_CONSUMER_KEY}
  && $ENV{LP_ACCESS_TOKEN}
  && $ENV{LP_ACCESS_TOKEN_SECRET};

my $public_bug = $ENV{LP_BUG} || '1388929';

my $lp = Net::Launchpad::Client->new(
    consumer_key        => $ENV{LP_CONSUMER_KEY},
    access_token        => $ENV{LP_ACCESS_TOKEN},
    access_token_secret => $ENV{LP_ACCESS_TOKEN_SECRET},
);

my $bug_p    = $lp->resource("Bug")->by_id($public_bug);
my $person_p = $lp->resource("Person")->by_name("~adam-stokes");

Mojo::Promise->all( $bug_p, $person_p )->then(
    sub {
        my ( $bug, $person ) = @_;
        print Dumper( $bug->[0]->title );
        print Dumper( $bug->[0]->description );
        $bug->[0]->tasks->then(
            sub {
                my $entries = shift;
                print Dumper($entries);
            }
        );
        print Dumper( $bug->[0]->messages );
        print Dumper( $bug->[0]->attachments );
        $bug->[0]->activity->then(
            sub {
                my $entries = shift;
                print Dumper($entries);
            }
            );
        print Dumper( $person->[0]->person );
        print Dumper( $person->[0]->name );
        print Dumper( $person->[0]->timezone );
        $person->[0]->assigned_bugs->then(
            sub {
                my $entries = shift;
                print Dumper($entries);
            }
        );
    }
)->wait;

# my $person_by_name = $lp->resource("Person")->find("adam-stokes");
# print Dumper(scalar @$person_by_name == 1);
# foreach my $p (@{$person_by_name}) {
#     print Dumper($p->name);
# }

# my $branch = $model->branch('~adam-stokes', '+junk', 'cloud-installer');
#print Dumper($branch->dependent_branches);

# my $project = $model->project('cloud-installer');
# print Dumper($project->{result});

#p $bug_item;
# p $bug->tasks;
# p $bug->date_created;
# p $bug->watches;
# my $bugtask =
#   first { $_->{bug_target_name} =~ /ubuntu-advantage|(Ubuntu)/ } @{$bug->tasks};
# # p $bugtask;
# my $person = $c->model('Person')->by_name('~adam-stokes');
# p $person;
# p $person->ppas;

# Mojo::IOLoop->start unless Mojo::IOLoop->is_running;
