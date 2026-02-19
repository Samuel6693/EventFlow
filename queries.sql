--Orderdetaljer:
SELECT
  eo.id          AS order_id,
  e.id           AS event_id,
  e.title        AS event_title,
  eo.order_date,
  u.id           AS user_id,
  u.name         AS user_name,
  u.email        AS user_email
FROM event_order eo
JOIN event e  ON e.id = eo.event_id
JOIN users u  ON u.id = eo.user_id
WHERE e.id = 1 
ORDER BY eo.order_date DESC, eo.id DESC;

--Deltagarstatistik: 
SELECT
  e.id        AS event_id,
  e.title     AS event_title,
  COUNT(t.id) AS participants
FROM event e
LEFT JOIN event_order eo ON eo.event_id = e.id
LEFT JOIN tickets t      ON t.order_id = eo.id
GROUP BY e.id, e.title
ORDER BY participants DESC;

--Bokningskontroll:
SELECT
  e.id            AS event_id,
  e.title         AS event_title,
  e.max_tickets,
  COUNT(t.id)     AS sold_tickets,
  CASE
    WHEN COUNT(t.id) >= e.max_tickets THEN 'Eventet är fullbokat'
    ELSE 'Platser finns'
  END AS booking_status
FROM event e
LEFT JOIN event_order eo ON eo.event_id = e.id
LEFT JOIN tickets t      ON t.order_id = eo.id
WHERE e.id = 1
GROUP BY e.id, e.title, e.max_tickets;

--Ekonomisk rapport:
SELECT
  e.id                AS event_id,
  e.title             AS event_title,
  e.price,
  COUNT(t.id)         AS sold_tickets,
  (COUNT(t.id) * e.price) AS total_revenue
FROM event e
LEFT JOIN event_order eo ON eo.event_id = e.id
LEFT JOIN tickets t      ON t.order_id = eo.id
WHERE e.id = 1
GROUP BY e.id, e.title, e.price;


