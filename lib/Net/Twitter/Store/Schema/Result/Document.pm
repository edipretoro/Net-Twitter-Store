package Net::Twitter::Store::Schema::Result::Document;

use base 'DBIx::Class';

__PACKAGE__->load_components(qw/ Core /);
__PACKAGE__->table('documents');

__PACKAGE__->add_columns(
    'id' => {
        'data_type'         => 'bigint',
        'is_auto_increment' => 1,
        'default_value'     => undef,
        'is_foreign_key'    => 0,
        'name'              => 'id',
        'is_nullable'       => 0,
        'size'              => '20'
    },
    'name' => {
        'data_type'         => 'varchar',
        'is_auto_increment' => 0,
        'default_value'     => undef,
        'is_foreign_key'    => 0,
        'name'              => 'name',
        'is_nullable'       => 0,
        'size'              => '255'
    },
    'type' => {
        'data_type'         => 'varchar',
        'is_auto_increment' => 0,
        'default_value'     => undef,
        'is_foreign_key'    => 0,
        'name'              => 'type',
        'is_nullable'       => 1,
        'size'              => '255'
    },
);

__PACKAGE__->set_primary_key('id');
__PACKAGE__->add_unique_constraint( 'name', ['name'] );
__PACKAGE__->has_many(
    properties => 'Net::Twitter::Store::Schema::Result::Property',
    'document_id'
);

1;    # End of Net::Twitter::Store::Schema
