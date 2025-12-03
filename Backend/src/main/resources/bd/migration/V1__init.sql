CREATE TABLE users (
                       id serial primary key,
                       full_name varchar(255),
                       email varchar(255) unique not null,
                       password_hash varchar(255) not null,
                       role varchar(50),
                       active boolean default true,
                       created_at timestamptz default now()
);

CREATE TABLE courses (
                         id serial primary key,
                         title varchar(255),
                         description text
);

CREATE TABLE lessons (
                         id serial primary key,
                         title varchar(255),
                         course_id int references courses(id),
                         order_index int
);

CREATE TABLE sessions (
                          id varchar(64) primary key,
                          student_id int references users(id),
                          lesson_id int references lessons(id),
                          started_at timestamptz default now(),
                          ended_at timestamptz,
                          status varchar(50)
);

CREATE TABLE emotion_events (
                                id serial primary key,
                                session_id varchar(64) not null,
                                timestamp timestamptz,
                                frustration_score numeric,
                                face_detected boolean,
                                meta_json text
);
CREATE INDEX idx_session_time ON emotion_events(session_id, timestamp);
