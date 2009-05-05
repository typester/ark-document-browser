<%=r $self->render('inc/header') %>

<ul>
% for my $module (sort keys %{ $stash->{modules} }) {
<li>
  <a href="<%= $c->uri_for('/doc') . '?' . $module %>"><%= $module %></a>
  - <%= $c->model('Pod')->get_entry($module)->title %>
</li>
% }
</ul>

<%=r $self->render('inc/footer') %>
