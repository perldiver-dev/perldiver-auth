use utf8;
package PerlDiverAuth::Schema::Result::Authorisation;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

PerlDiverAuth::Schema::Result::Authorisation

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

=head1 TABLE: C<authorisation>

=cut

__PACKAGE__->table("authorisation");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 repo_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 auth_key

  data_type: 'char'
  is_nullable: 0
  size: 64

=head2 expires

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "repo_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "auth_key",
  { data_type => "char", is_nullable => 0, size => 64 },
  "expires",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    is_nullable => 0,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 repo

Type: belongs_to

Related object: L<PerlDiverAuth::Schema::Result::Repo>

=cut

__PACKAGE__->belongs_to(
  "repo",
  "PerlDiverAuth::Schema::Result::Repo",
  { id => "repo_id" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);


# Created by DBIx::Class::Schema::Loader v0.07051 @ 2023-09-17 14:39:32
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:hh8g7dTxHIwJgwvViP5CZQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
