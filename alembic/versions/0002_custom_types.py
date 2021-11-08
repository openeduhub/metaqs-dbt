"""custom_types

Revision ID: 0002
Revises: 0001
Create Date: 1970-01-01 00:00:00.000000

"""
from alembic import op

# revision identifiers, used by Alembic.
revision = "0002"
down_revision = "0001"
branch_labels = None
depends_on = None


def upgrade():
    conn = op.get_bind()
    conn.execute(
        """
        create type resource_type as enum (
            'collection',
            'material'
            );
        
        create type resource_field as enum (
            'title',
            'description',
            'keywords',
            'edu_context',
            'taxon_id',
            'learning_resource_type',
            'license',
            'ads_qualifier',
            'object_type',
            'intended_enduser_role',
            'url',
            'replication_source',
            'replication_source_id'
            );
        
        create type validation_error as enum (
            'too_few',
            'too_short',
            'lacks_clarity'
            );
        """
    )


def downgrade():
    conn = op.get_bind()
    conn.execute(
        """
        drop type if exists validation_error cascade;
        drop type if exists resource_field cascade;
        drop type if exists resource_type cascade;
        """
    )
