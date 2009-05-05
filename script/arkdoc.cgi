#!/usr/bin/env perl

use strict;
use warnings;
use FindBin::libs;

use ArkDoc;
use HTTP::Engine;

my $app = ArkDoc->new;
$app->config( pod_namespace => 'Ark::Manual' );

$app->setup_minimal;

HTTP::Engine->new(
    interface => {
        module          => 'CGI',
        request_handler => $app->handler,
    },
)->run;
