package Net::Twitter::Store::Schema::Result::Property;

use base 'DBIx::Class';

__PACKAGE__->load_components(qw/ Core /);
__PACKAGE__->table('properties');

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
    'property' => {
        'data_type'         => 'varchar',
        'is_auto_increment' => 0,
        'default_value'     => undef,
        'is_foreign_key'    => 0,
        'name'              => 'property',
        'is_nullable'       => 0,
        'size'              => '255'
    },
    'value' => {
        'data_type'         => 'text',
        'is_auto_increment' => 0,
        'default_value'     => undef,
        'is_foreign_key'    => 0,
        'name'              => 'value',
        'is_nullable'       => 0,
    },
    'document_id' => {
        'data_type'         => 'bigint',
        'is_auto_increment' => 0,
        'default_value'     => undef,
        'is_foreign_key'    => 0,
        'name'              => 'document_id',
        'is_nullable'       => 0,
        'size'              => '20'
    },
);

__PACKAGE__->set_primary_key('id');
# __PACKAGE__->belongs_to(
#     'document' => 'Net::Twitter::Store::Schema::Result::Document',
#     'id'
# );

1;    # End of Net::Twitter::Store::Schema
