-- Create Enums
CREATE TYPE user_type AS ENUM ('STUDENT', 'TEACHER');
CREATE TYPE assessment_type AS ENUM ('DIGITAL', 'WRITTEN');
CREATE TYPE question_type AS ENUM ('MCQ', 'TYPE', 'IMAGE');
CREATE TYPE submission_type AS ENUM ('OFFLINE', 'ONLINE');

-- Create Tables
CREATE TABLE year (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    label TEXT UNIQUE NOT NULL
);

CREATE TABLE course (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT UNIQUE NOT NULL
);

CREATE TABLE "user" (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email TEXT UNIQUE NOT NULL,
    password TEXT NOT NULL,
    name TEXT,
    type user_type NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE profile (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL UNIQUE REFERENCES "user"(id) ON DELETE CASCADE,
    roll_no TEXT UNIQUE NOT NULL,
    dob TIMESTAMP NOT NULL,
    year_id UUID NOT NULL REFERENCES year(id),
    course_id UUID NOT NULL REFERENCES course(id)
);

CREATE TABLE subject (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT UNIQUE NOT NULL,
    year_id UUID NOT NULL REFERENCES year(id) ON DELETE CASCADE,
    course_id UUID NOT NULL REFERENCES course(id) ON DELETE CASCADE
);

CREATE TABLE assessment (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    type assessment_type NOT NULL,
    author_id UUID NOT NULL REFERENCES "user"(id) ON DELETE CASCADE,
    subject_id UUID NOT NULL REFERENCES subject(id) ON DELETE CASCADE,
    instructions TEXT,
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP NOT NULL
);

CREATE TABLE question (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    type question_type NOT NULL,
    assessment_id UUID NOT NULL REFERENCES assessment(id) ON DELETE CASCADE,
    text TEXT NOT NULL,
    UNIQUE (assessment_id, text)
);

CREATE TABLE choice (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    question_id UUID NOT NULL REFERENCES question(id) ON DELETE CASCADE,
    text TEXT NOT NULL,
    UNIQUE (question_id, text)
);

CREATE TABLE submission (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    type submission_type NOT NULL,
    student_id UUID NOT NULL REFERENCES "user"(id) ON DELETE CASCADE,
    assessment_id UUID NOT NULL REFERENCES assessment(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    UNIQUE (student_id, assessment_id)
);

CREATE TABLE answer (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    question_id UUID NOT NULL REFERENCES question(id) ON DELETE CASCADE,
    submission_id UUID NOT NULL REFERENCES submission(id) ON DELETE CASCADE,
    text TEXT,
    choice_id UUID REFERENCES choice(id),
    UNIQUE (question_id, submission_id)
);

CREATE TABLE image (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    data TEXT NOT NULL,
    answer_id UUID REFERENCES answer(id) ON DELETE CASCADE
);
