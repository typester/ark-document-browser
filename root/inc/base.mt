<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ja">
<head>
<link rel="stylesheet" type="text/css" href="<%= $c->uri_for('/css/default.css') %>" />
<title><%= $s->{page_title} ? "$s->{page_title} - " : ''  %><%= $s->{site_title} %></title>
</head>
<body>
<div id="container">

<h1><%= $s->{page_title} || $s->{site_title} %></h1>

<% block content => '' %>

<div id="menu">
<ul>
  <li><a href="<%= $c->uri_for('/') %>">ホーム</a></li>
  <li><a href="<%= $c->uri_for('/toc') %>">ページ一覧</a></li>
</ul>
</div>

<div id="footer">
  <p>Copyright &#169; 2009 <a href="http://www.kayac.com/">KAYAC Inc.</a> All rights reserved.</p>

  <p>Powered by <a href="http://github.com/typester/ark-document-browser">ark-document-browser</a> <%= $ArkDoc::VERSION %></p>
</div>

</div>
</body>
</html>
