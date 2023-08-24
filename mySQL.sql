--  1. Average price of items with physical inventory and those without.

SELECT 
    has_physical_inventory,
    AVG(price) AS average_price
FROM item
INNER JOIN item_price ON item.default_price_id = item_price.item_price_id
GROUP BY has_physical_inventory;

-- 2. Show which storeroom has the most inventory.

SELECT
    item_stock.stockroom_id,
    stockroom_name,
    SUM(item_stock.quantity) AS total_quantity
FROM item_stock
INNER JOIN stockroom ON item_stock.stockroom_id = stockroom.stockroom_id
GROUP BY item_stock.stockroom_id, stockroom_name
ORDER BY total_quantity DESC
LIMIT 1;

-- 3. Time in minutes since item prices were last modified.
-- Difference between time of last item created vs. modified in item_prices table

SELECT 
    MAX(date_changed) AS last_date_changed,
    MAX(date_created) AS last_date_created,
    TIMESTAMPDIFF(MINUTE, MAX(date_created), MAX(date_changed)) AS minutes_since_last_change
FROM item_price;

-- 4. List items that are running out of stock.

SELECT 
    item.item_id, 
    item.item_name, 
    quantity
FROM item_stock
INNER JOIN item ON item_stock.item_id = item.item_id
WHERE quantity > 0 AND quantity < 10
ORDER BY quantity DESC;

-- 5. List items whose quantity is Zero (0) and how long (In minutes) they have been in this state.
--  From last date changed to current date timestamp

SELECT 
    item.item_id,
    item.item_name,
    item_stock.quantity,
    date_created,
    date_changed,
    TIMESTAMPDIFF(MINUTE, date_created, date_changed) AS minutes_in_zero
FROM item_stock
INNER JOIN item ON item_stock.item_id = item.item_id
WHERE item_stock.quantity = 0
ORDER BY minutes_in_zero;

-- 6. Quantities of items with paracetamol

SELECT 
    item_name, 
    quantity
FROM item_stock
INNER JOIN item ON item_stock.item_id = item.item_id
WHERE item_name LIKE '%mol' OR item_name LIKE 'para%';