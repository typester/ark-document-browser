<%=r $self->render('inc/header') %>


<div id="index">
<%=r $stash->{doc}->toc_list %>
</div>

% if (my $desc = $stash->{doc}->section('DESCRIPTION')) {
<%=r $desc %>
% }

% for my $section ($stash->{doc}->sections) {
<h2 id="<%= $section %>"><%= $section %></h2>
<%=r $stash->{doc}->section( $section ) %>
% }

<%=r $self->render('inc/footer') %>
