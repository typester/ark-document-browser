package ArkDoc::API::Data::Entry;
use Mouse;

use ArkDoc::API::ObjectContainer;

use Path::Class qw/file/;
use HTML::TreeBuilder;
use Pod::Simple::XHTML;
use List::Util qw/min/;

has name => (
    is      => 'rw',
    isa     => 'Str',
    lazy    => 1,
    default => sub {
        my $self = shift;
        (my $name = $self->section('NAME')) =~ s/\s*-.*$//s;
        $name =~ s/<.*?>//gs;
        $name;
    },
);

has title => (
    is      => 'rw',
    isa     => 'Str',
    lazy    => 1,
    default => sub {
        my $self = shift;
        my ($title) = $self->section('NAME') =~ / - (.*)/ or return '';
        $title =~ s/<.*?>//g;
        $title;
    },
);

has body => (
    is      => 'rw',
    isa     => 'Str',
    lazy    => 1,
    default => sub {
        my $self = shift;
        my $body = q[];
        for my $content ($self->tree->find('body')->content_list) {
            $body .= $content->as_XML . "\n";
        }
        $body;
    },
);

has tree => (
    is      => 'rw',
    isa     => 'HTML::TreeBuilder',
    lazy    => 1,
    default => sub {
        HTML::TreeBuilder->new;
    },
);

has pod_finder => (
    is      => 'rw',
    isa     => 'Pod::Simple::Search',
    lazy    => 1,
    default => sub {
        ArkDoc::API::ObjectContainer->get('Pod::Simple::Search');
    },
);

has pod_parser => (
    is      => 'rw',
    isa     => 'Pod::Simple::XHTML',
    lazy    => 1,
    default => sub {
        my $parser = Pod::Simple::XHTML->new;
        $parser->html_header('');
        $parser->html_footer('');
        $parser;
    },
);

has perldoc_url_prefix => (
    is  => 'rw',
    isa => 'Str',
);

sub new_from_name {
    my ($self, $name, @args) = @_;
    return unless $name;
    $self = $self->new( name => $name, @args ) unless ref $self;

    my $file = $self->pod_finder->find($name) or return;
    $self->new_from_file($file);
}

sub new_from_file {
    my ($self, $file, @args) = @_;
    return unless $file && -f $file;
    $self = $self->new(@args) unless ref $self;

    $self->pod_parser->perldoc_url_prefix( $self->perldoc_url_prefix )
        if $self->perldoc_url_prefix;

    $self->pod_parser->output_string(\my $html);
    $self->pod_parser->parse_file($file) or die $!;

    $self->build_tree($html);

    $self;
}

sub sections {
    my $self = shift;
    grep { $_ !~ /(^NAME$|^DESCRIPTION$|^AUTHOR$|COPYRIGHT|LISENCE)/ } $self->all_sections;
}

sub all_sections {
    my $self = shift;
    map { $_->content_list } $self->tree->find('h2');
}

sub section {
    my ($self, $section_name) = @_;

    my $section = $self->tree->look_down(
        _tag => 'h2',
        sub { $_[0]->content->[0] eq $section_name },
    );

    my $content = q[];
    while ($section and $section = $section->right and $section->tag ne 'h2') {
        $content .= $section->as_XML . "\n";
    }

    $content;
}

sub build_tree {
    my ($self, $html) = @_;

    my $tree = $self->tree;
    $tree->parse_content($html);

    # remove white spaces in codeblocks
    my @codes = $tree->look_down( _tag => 'code', sub { $_[0]->parent->tag eq 'pre' } );
    $self->strip_tree($_) for @codes;

    # remove first num strings in <ol> tag
    my @list = $tree->look_down( _tag => 'li', sub { $_[0]->parent->tag eq 'ol' } );
    for my $li (@list) {
        my $first_child = shift @{ $li->content_array_ref } or next;
        $first_child =~ s/^\d+\.\s+// unless ref $first_child;
        $li->unshift_content($first_child);
    }

    # shift header level
    my @header = $tree->look_down( _tag => qr/^h[1-5]$/ );
    for my $header (@header) {
        my ($n) = $header->tag =~ /(\d)/;
        $header->tag( 'h' . ++$n );
    }
}

sub strip_tree {
    my ($self, $code) = @_;
    my $stripped = strip($code->content_list);
    $stripped .= "\n" unless $stripped =~ /\n$/;

    $code->delete_content;
    $code->push_content($stripped);
}

# copy from String::TT::strip
sub strip($){
    my $lines = shift;

    my $trailing_newline = ($lines =~ /\n$/s);# perl silently throws away data
    my @lines = split "\n", $lines;
    shift @lines if $lines[0] eq ''; # strip empty leading line

    # determine indentation level
    my @spaces = map { /^(\040+)/ and length $1 or 0 } grep { !/^\s*$/ } @lines;
    
    my $indentation_level = min(@spaces);
    
    # strip off $indentation_level spaces
    my $stripped = join "\n", map { 
        my $copy = $_;
        substr($copy,0,$indentation_level) = "";
        $copy;
    } @lines;
    
    $stripped .= "\n" if $trailing_newline;
    return $stripped;
}

sub DESTROY {
    my $self = shift;
    $self->tree->delete if defined $self->{tree};
}

1;
