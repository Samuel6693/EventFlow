-- USERS
INSERT INTO users (name, email) VALUES
  ('Anna Svensson', 'anna.svensson@example.com'),
  ('Bilal Hassan',  'bilal.hassan@example.com'),
  ('Carla Nguyen',  'carla.nguyen@example.com'),
  ('David Ali',     'david.ali@example.com');

-- EVENTS (Event 4 ska ha 0 biljetter)
INSERT INTO event (title, starts_at, price, max_tickets) VALUES
  ('Lokala Derbyt',      now() + interval '10 days', 150.00, 50),
  ('Kulturkväll Live',   now() + interval '20 days', 250.00, 120),
  ('Teater: Vinterljus', now() + interval '30 days', 180.00, 80),
  ('Öppet Hus',          now() + interval '40 days', 100.00, 60);

-- ORDERS (id blir 1..4 efter TRUNCATE RESTART IDENTITY)
INSERT INTO event_order (user_id, event_id) VALUES (1, 1);
INSERT INTO event_order (user_id, event_id) VALUES (2, 2);
INSERT INTO event_order (user_id, event_id) VALUES (3, 3);
INSERT INTO event_order (user_id, event_id) VALUES (4, 1);

-- TICKETS (order_id refererar event_order.id)
INSERT INTO tickets (order_id) VALUES (1), (1);
INSERT INTO tickets (order_id) VALUES (2), (2), (2);
INSERT INTO tickets (order_id) VALUES (3);
INSERT INTO tickets (order_id) VALUES (4), (4), (4), (4);
