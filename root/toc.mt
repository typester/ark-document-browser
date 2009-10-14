% extends 'inc/base'

% block content => sub {
<ul>
% for my $module (sort keys %{ $stash->{modules} }) {
<li>
  <a href="<%= $c->uri_for('/view') . '?' . $module %>"><%= $module %></a>
  - <%= $c->model('Pod')->get_entry($module)->title %>
</li>
% }
</ul>
% } # endblock content

