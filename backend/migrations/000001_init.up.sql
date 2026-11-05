CREATE TABLE labs (
  id               TEXT PRIMARY KEY,
  name             TEXT        NOT NULL,
  professor        TEXT        NOT NULL DEFAULT '',
  summary          TEXT        NOT NULL DEFAULT '',
  location         TEXT        NOT NULL DEFAULT '',
  core_time        TEXT        NOT NULL DEFAULT '',
  seminar_schedule TEXT        NOT NULL DEFAULT '',
  equipment        TEXT[]      NOT NULL DEFAULT '{}',
  contact          TEXT        NOT NULL DEFAULT '',
  updated_at       TIMESTAMPTZ NOT NULL DEFAULT now()
);
