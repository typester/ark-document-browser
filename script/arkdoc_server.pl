#!/usr/bin/env perl

use strict;
use warnings;
use FindBin::libs;

use ArkDoc;
use HTTP::Engine;
use HTTP::Engine::Middleware;

my $pod_namespace = $ARGV[0] || 'Ark::Manual';

my $app = ArkDoc->new;
$app->config( pod_namespace => $pod_namespace );
$app->setup;

my $mw = HTTP::Engine::Middleware->new;
$mw->install( 'HTTP::Engine::Middleware::Static' => {
    regexp  => qr{^/(robots.txt|favicon.ico|(?:css|js|images?)/.+)$},
    docroot => $app->path_to('root'),
});

HTTP::Engine->new(
    interface => {
        module => 'ServerSimple',
        args   => {
            host => '0.0.0.0',
            port => 4423,
        },
        request_handler => $mw->handler( $app->handler ),
    },
)->run;
