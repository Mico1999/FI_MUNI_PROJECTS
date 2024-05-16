--
-- Category table definition
--
CREATE TABLE IF NOT EXISTS Category
(
    id                          BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name      VARCHAR(150)      NOT NULL,
    defaultDurationValue        INT,
    defaultDurationOption       INT,
    defaultColor VARCHAR(50)    NOT NULL
    );

--
-- Event table definition
--
CREATE TABLE IF NOT EXISTS Event
(
    id                  BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    date                DATE NOT NULL,
    durationValue       INT,
    durationOption      INT,
    name                VARCHAR(150) NOT NULL,
    description         VARCHAR(300),
    categoryId          BIGINT REFERENCES Category (id),
    status              INT
    );