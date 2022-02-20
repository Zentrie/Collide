#!/usr/bin/env perl
use Mojolicious::Lite -signatures;
use Redis::Fast;
get '/' => sub ($c) {
  $c->render(template => 'make');
};

app->start;
__DATA__

@@ index.html.ep
% layout 'default';
% title 'Welcome';
<h1>Welcome to the Mojolicious real-time web framework!</h1>

@@ layouts/default.html.ep
<!DOCTYPE html>
<html>
  <head><title><%= title %></title></head>
  <body><%= content %></body>
</html>
