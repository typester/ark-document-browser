package ArkDoc::API::Data;
use Mouse;

use ArkDoc::API::ObjectContainer;
use ArkDoc::API::Data::Entry;

has perldoc_url_prefix => (
    is      => 'rw',
    isa     => 'Str',
    default => '',
);

no Mouse;

sub get_entry {
    my ($self, @name) = @_;
    ArkDoc::API::Data::Entry->new_from_name(
        join('::', @name),
        perldoc_url_prefix => $self->perldoc_url_prefix,
    );
}

sub get_entries {
    my ($self, $namespace) = @_;

    my $finder  = ArkDoc::API::ObjectContainer->get('Pod::Simple::Search');
    my $modules = $finder->limit_glob($namespace . '*')->survey;

    # reset module
    $finder->limit_re('');
    $finder->dir_prefix('');

    return $modules;
}

1;

