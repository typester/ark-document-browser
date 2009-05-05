<%=r $self->render('inc/header') %>

<ul id="index">
% for my $section ($stash->{doc}->sections) {
<li><a href="#<%= $section %>"><%= $section %></a></li>
% }
</ul>

% if (my $desc = $stash->{doc}->section('DESCRIPTION')) {
<%=r $desc %>
% }

% for my $section ($stash->{doc}->sections) {
<h2 id="<%= $section %>"><%= $section %></h2>
<%=r $stash->{doc}->section( $section ) %>
% }

<%=r $self->render('inc/footer') %>
