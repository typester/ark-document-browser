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
