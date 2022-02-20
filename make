#!/usr/bin/env perl
use Mojolicious::Lite -signatures;
use Redis::Fast;
get '/sequence' => sub {
  my $c = shift;
  $c->render(template => 'make');
};

 

any '/image/bg/:name' => sub {
  my $c = shift;
  my $bytes = 0;
  $c->render(data=> $bytes, format=>'png');

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
