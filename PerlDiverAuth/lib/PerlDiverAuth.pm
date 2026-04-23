package PerlDiverAuth;
use Dancer2;

use PerlDiverAuth::Schema;

use DateTime;
use Sys::Hostname;

our $VERSION = '0.1';

get '/' => sub {
    return encode_json({
        status => 'ok',
        code => 200,
        version => $VERSION,
        server => hostname,
    });
};

get '/check/:owner/:repo' => sub {
    my $token = query_parameters->get('token');

    unless ($token) {
        return encode_json({
            status => 'error',
            code => 400,
            message => 'No token provided',
        });
    }

    my $repo_owner = route_parameters->get('owner');
    my $repo_name  = route_parameters->get('repo');

    my $sch = PerlDiverAuth::Schema->get_schema;

    my $auth = $sch->resultset('Authorisation')->find({
        auth_key => $token,
    });

    unless ($auth) {
        return encode_json({
            status => 'error',
            code => 400,
            message => 'Invalid token',
        });
    }

    if ($auth->expires < DateTime->now) {
        $auth->delete;
        return encode_json({
            status => 'error',
            code => 400,
            message => 'Expired token',
        });
    }

    my $repo = $auth->repo;
    unless ($repo) {
        $auth->delete;
        return encode_json({
            status => 'error',
            code => 400,
            message => 'Auth for non-existent repo',
        });
    }

    unless ($repo->owner eq $repo_owner and $repo->name eq $repo_name) {
        $auth->delete;
        return encode_json({
            status => 'error',
            code => 400,
            message => 'Repo does not match auth token',
        });
    }

    return encode_json({
        status => 'ok',
        code => 200,
        message => 'Auth OK',
        authorised => 1,
    });
};

get '/auth/:owner/:repo' => sub {

    my $key = query_parameters->get('key');

    unless ($key) {
        return encode_json({
            status => 'error',
            code => 400,
            message => 'No key provided',
        });
    }

    my $sch = PerlDiverAuth::Schema->get_schema;

    my $user = $sch->resultset('User')->find({
        apikey => $key,
    });

    unless ($user) {
        return encode_json({
            status => 'error',
            code => 404,
            message => 'User not found',
        });
    }

    my $repo_owner = route_parameters->get('owner');
    my $repo_name  = route_parameters->get('repo');

    unless ($repo_owner && $repo_name) {
        return encode_json({
            status => 'error',
            code => 400,
            message => 'Invalid repo details',
        });
    }

    my $repo = $user->repoes->find({
        owner => $repo_owner,
        name => $repo_name,
    });

    unless ($repo) {
        return encode_json({
            status => 'error',
            code => 404,
            message => 'Repo not found',
        });
    }

    my $auth_token;
    if (my $auth = $repo->authorisations->first) {
        if ($auth->expires > DateTime->now) {
            $auth_token = $auth->auth_key;
            $auth->update({
                expires => DateTime->now->add(hours => 2),
            });
        } else {
            $auth->delete;
        }
    }

    if (!$auth_token) {
        $auth_token = $repo->make_token('salt');

        $repo->add_to_authorisations({
            auth_key => $auth_token,
            expires => DateTime->now->add(hours => 2),
        });
    }

    return encode_json({
        status => 'ok',
        code => 200,
        user => $user->name,
        token => $auth_token,
    });
};

true;
