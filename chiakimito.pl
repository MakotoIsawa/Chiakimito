#!/usr/bin/env perl
package Zenra::Model;
use WebService::YahooJapan::WebMA;
use utf8;

$WebService::YahooJapan::WebMA::APIBase =
  'http://jlp.yahooapis.jp/MAService/V1/parse';

sub new {
    bless { yahoo_ma =>
          WebService::YahooJapan::WebMA->new( appid => 'dj0zaiZpPTVtQmpsN0NWYTZwVCZkPVlXazlVSEJPUW1Oek4ya21jR285TUEtLSZzPWNvbnN1bWVyc2VjcmV0Jng9NzQ-', ), },
      shift;
}

sub zenrize {
    my ( $self, $sentence ) = @_;
    return unless $sentence;
    my $api       = $self->{yahoo_ma};
    my $result    = $api->parse( sentence => $sentence ) or return;
    my $ma_result = $result->{ma_result};

    my $result_text = '';
    for my $word ( @{ $ma_result->{word_list} } ) {
        if ( $word->{pos} eq '動詞' ) {
            $result_text .= "みとうさんと$word->{surface}";
        }
        else {
            $result_text .= $word->{surface};
        }
    }
    return $result_text;
}

package main;
use Mojolicious::Lite;
use Encode;

app->helper(
    model => sub {
        Zenra::Model->new;
    }
);

get '/' => sub {
    my $self = shift;
    $self->render('index');
};

post '/result' => sub {
    my $self        = shift;
    my $text        = $self->req->param('text');
  # my $result_text = $self->app->model->zenrize( decode_utf8($text) )
    my $result_text = $self->app->model->zenrize( $text )
      or return $self->redirect_to('/');
    $self->stash->{result} = $result_text;
    $self->render('result');
};

app->start;

__DATA__

@@ index.html.ep
% layout 'default';
<form action="/result" method="post">
<textarea rows="3" cols="60" name="text"></textarea>
<br />
<input type="submit" value="やさしく押してね♪" />
</form>

@@ result.html.ep
% layout 'default';
<p>
<b><%= $result %></b>
</p>
<a href="/">戻る</a>

@@ layouts/default.html.ep
<!DOCTYPE html>
<html>
<head><title><%= title %></title></head>
<body style="width:500px;margin:0 auto;"><h1>ねえ〜、何する？</h1><%= content %></body>
</html>