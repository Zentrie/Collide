#!/usr/bin/env perl
use strict;
use Mojolicious::Lite -signatures;
use Redis::Fast;
our $DB = Redis::Fast->new(reconnect =>10, every=>500000);
use Data::Dumper; 
$Data::Dumper::Sortkeys = 1; 
use JSON::XS;

use Functions;
any '/sequence/:sid/' => sub {
  my $c = shift;

  $c->render(template => 'make');
};

any '/rframe' => sub {
  my $c = shift;
  my $sid = $c->param('sid');
  my $idx = $c->param('idx');
  my $F = $DB->lindex("S:".$sid);
  my $H = $DB->hgetall($F);

  my $j = encode_json $H;

  $c->render(text=>$j);

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
