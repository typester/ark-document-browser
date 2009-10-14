% extends 'inc/base'

% block content => sub {

<div id="index">
<%= raw_string $stash->{doc}->toc_list %>
</div>

% if (my $desc = $stash->{doc}->section('DESCRIPTION')) {
<%= raw_string $desc %>
% }

% for my $section ($stash->{doc}->sections) {
<h2 id="<%= $section %>"><%= $section %></h2>
<%= raw_string $stash->{doc}->section( $section ) %>
% }

% } # endblock content



