import sqlalchemy as sa

from relengapi.lib import db

class ArchiverTask(db.declarative_base('relengapi')):
    __tablename__ = 'archiver_tasks'
    id = sa.Column(sa.Integer, primary_key=True)
    task_id = sa.Column(sa.String(100), nullable=False, unique=True)
    created_at = sa.Column(db.UTCDateTime(timezone=True), nullable=False)
    state = sa.Column(sa.String(50))
    # for debugging
    src_url = sa.Column(sa.String(200))
