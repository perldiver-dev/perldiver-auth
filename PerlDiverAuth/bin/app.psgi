#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";


# use this block if you don't need middleware, and only have a single target Dancer app to run here
use PerlDiverAuth;

PerlDiverAuth->to_app;

=begin comment
# use this block if you want to include middleware such as Plack::Middleware::Deflater

use PerlDiverAuth;
use Plack::Builder;

builder {
    enable 'Deflater';
    PerlDiverAuth->to_app;
}

=end comment

=cut

=begin comment
# use this block if you want to mount several applications on different path

use PerlDiverAuth;
use PerlDiverAuth_admin;

use Plack::Builder;

builder {
    mount '/'      => PerlDiverAuth->to_app;
    mount '/admin'      => PerlDiverAuth_admin->to_app;
}

=end comment

=cut

