package ArkDoc::View::MT;
use Ark 'View::MT';

has '+options' => default => sub {
    return {
        tag_start  => '<%',
        tag_end    => '%>',
        line_start => '%',
    };
};

1;
