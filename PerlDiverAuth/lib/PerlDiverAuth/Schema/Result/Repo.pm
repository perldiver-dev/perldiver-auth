use utf8;
package PerlDiverAuth::Schema::Result::Repo;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

PerlDiverAuth::Schema::Result::Repo

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<repo>

=cut

__PACKAGE__->table("repo");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 user_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 owner

  data_type: 'varchar'
  is_nullable: 0
  size: 100

=head2 name

  data_type: 'varchar'
  is_nullable: 0
  size: 100

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "user_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "owner",
  { data_type => "varchar", is_nullable => 0, size => 100 },
  "name",
  { data_type => "varchar", is_nullable => 0, size => 100 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 authorisations

Type: has_many

Related object: L<PerlDiverAuth::Schema::Result::Authorisation>

=cut

__PACKAGE__->has_many(
  "authorisations",
  "PerlDiverAuth::Schema::Result::Authorisation",
  { "foreign.repo_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 user

Type: belongs_to

Related object: L<PerlDiverAuth::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "user",
  "PerlDiverAuth::Schema::Result::User",
  { id => "user_id" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);


# Created by DBIx::Class::Schema::Loader v0.07051 @ 2023-09-17 14:39:32
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:r9C7Jc98ZhxOBfxg/XQZAQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration

use Digest::SHA 'sha256_hex';

sub make_token {
  my $self = shift;
  my ($salt) = @_;

  my $token = sha256_hex($salt . time . $self->owner . '/' . $self->name);

  return $token;
}

__PACKAGE__->meta->make_immutable;
1;
