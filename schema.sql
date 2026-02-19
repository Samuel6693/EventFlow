-- USERS
CREATE TABLE users (
  id          SERIAL PRIMARY KEY,
  name        VARCHAR(155) NOT NULL,
  email       VARCHAR(255) NOT NULL UNIQUE,
  created_at  TIMESTAMP NOT NULL DEFAULT now()
);

-- EVENT
CREATE TABLE event (
  id            SERIAL PRIMARY KEY,
  title         VARCHAR(255) NOT NULL,
  starts_at     TIMESTAMP NOT NULL,
  price         NUMERIC(10,2) NOT NULL CHECK (price > 0),
  max_tickets   INTEGER NOT NULL CHECK (max_tickets > 0),
  created_at    TIMESTAMP NOT NULL DEFAULT now()
);

-- EVENT ORDER
CREATE TABLE event_order (
  id          SERIAL PRIMARY KEY,
  user_id     INTEGER NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
  event_id    INTEGER NOT NULL REFERENCES event(id) ON DELETE RESTRICT,
  order_date  TIMESTAMP NOT NULL DEFAULT now()
);

-- TICKETS
CREATE TABLE tickets (
  id          SERIAL PRIMARY KEY,
  order_id    INTEGER NOT NULL REFERENCES event_order(id) ON DELETE CASCADE,
  created_at  TIMESTAMP NOT NULL DEFAULT now()
);

--Styrelsevy
CREATE OR REPLACE VIEW styrelsevy_events AS
SELECT
  e.id          AS event_id,
  e.title       AS event_title,
  e.starts_at   AS event_date,
  e.max_tickets,
  COALESCE(COUNT(t.id), 0) AS sold_tickets,
  COALESCE(COUNT(t.id) * e.price, 0) AS total_revenue
FROM event e
LEFT JOIN event_order eo ON eo.event_id = e.id
LEFT JOIN tickets t      ON t.order_id = eo.id
GROUP BY e.id, e.title, e.starts_at, e.max_tickets, e.price;