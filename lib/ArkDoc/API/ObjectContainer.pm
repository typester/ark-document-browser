package ArkDoc::API::ObjectContainer;
use Mouse;

extends 'Object::Container';

__PACKAGE__->register(
    'Pod::Simple::Search' => sub {
        __PACKAGE__->ensure_class_loaded('Pod::Simple::Search');
        Pod::Simple::Search->new;
    },
);

1;
