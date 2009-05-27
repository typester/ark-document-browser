package ArkDoc::Controller::Root;
use Ark 'Controller';

has '+namespace' => default => '';

# default page handler
sub render_page :Path :Args {
    my ($self, $c, @page) = @_;

    $c->model('Pod')->perldoc_url_prefix( $c->uri_for('/view') . '?' );

    my $ns  = $c->app->config->{pod_namespace};
    my $doc = $c->stash->{doc} = $c->model('Pod')->get_entry($ns, @page)
        or $c->detach('not_found');

    $c->stash->{site_title} = $c->config->{site_title};
    $c->stash->{page_title} = $doc->title if @page;

    $c->view('MT')->template('page');
}

sub view :Local :Args(0) {
    my ($self, $c) = @_;
    my $doc = $c->req->uri->query or $c->detach('not_found');

    my $ns  = $c->app->config->{pod_namespace};
    if ($doc =~ s!^$ns(::)?!!) {
        $c->redirect_and_detach( $c->uri_for('', split('::', $doc)) );
    }
    else {
        $c->redirect_and_detach( 'http://search.cpan.org/perldoc?' . $doc );
    }
}

sub toc :Local :Args(0) {
    my ($self, $c) = @_;

    $c->stash->{page_title} = 'ページ一覧';

    my $ns  = $c->app->config->{pod_namespace};
    $c->stash->{modules} = $c->model('Pod')->get_entries($ns);
}

sub not_found :Private {
    my ($self, $c) = @_;
    $c->res->status(404);
    $c->view('MT')->template('errors/404');
}

sub end :Private {
    my ($self, $c) = @_;

    $c->res->header( 'Cache-Control' => 'private' );

    unless ($c->res->body or $c->res->status =~ /^3\d\d/) {
        $c->forward( $c->view('MT') );
    }
}

1;
