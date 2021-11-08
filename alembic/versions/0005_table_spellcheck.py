"""table_spellcheck

Revision ID: 0005
Revises: 0004
Create Date: 1970-01-01 00:00:00.000000

"""
import sqlalchemy as sa
from alembic import op
from sqlalchemy.dialects import postgresql

# revision identifiers, used by Alembic.
revision = "0005"
down_revision = "0004"
branch_labels = None
depends_on = None


def upgrade():
    op.create_table(
        "spellcheck",
        sa.Column("resource_id", postgresql.UUID(), nullable=False),
        sa.Column("resource_field", postgresql.TEXT(), nullable=False),
        sa.Column("resource_type", postgresql.TEXT(), nullable=False),
        sa.Column("error", postgresql.JSONB(astext_type=sa.Text()), nullable=False),
        sa.Column("text_content", postgresql.TEXT(), nullable=False),
        sa.Column("derived_at", postgresql.TIMESTAMP(), nullable=False),
        sa.PrimaryKeyConstraint("resource_id", "resource_field"),
        schema="store",
    )


def downgrade():
    op.execute(
        f"""
        -- drop table if exists store.spellcheck cascade;
        """
    )
