use Bio::P3::NCBILookup::NCBILookupImpl;

use Bio::P3::NCBILookup::Service;
use Plack::Middleware::CrossOrigin;
use Plack::Builder;



my @dispatch;

{
    my $obj = Bio::P3::NCBILookup::NCBILookupImpl->new;
    push(@dispatch, 'NCBIAnnotation' => $obj);
}


my $server = Bio::P3::NCBILookup::Service->new(instance_dispatch => { @dispatch },
				allow_get => 0,
			       );

my $rpc_handler = sub { $server->handle_input(@_) };

$handler = builder {
    mount "/ping" => sub { $server->ping(@_); };
    mount "/auth_ping" => sub { $server->auth_ping(@_); };
    mount "/" => $rpc_handler;
};

$handler = Plack::Middleware::CrossOrigin->wrap( $handler, origins => "*", headers => "*");
