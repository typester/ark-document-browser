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
