--  1. Average price of items with physical inventory and those without.

SELECT 
    item.has_physical_inventory,
    AVG(item_price.price) AS average_price
FROM item
INNER JOIN item_price ON item.default_price_id = item_price.item_price_id
GROUP BY item.has_physical_inventory;

-- 2. Show which storeroom has the most inventory.

SELECT
    item_stock.stockroom_id,
    stockroom_name,
    SUM(item_stock.quantity) AS total_quantity
FROM item_stock
INNER JOIN stockroom ON item_stock.stockroom_id = stockroom.stockroom_id
GROUP BY item_stock.stockroom_id, stockroom_name;

-- 3. Time in minutes since item prices were last modified.
-- Time of last item modified in item_prices table

SELECT 
    MAX(date_changed) AS last_date_changed,
    TIMESTAMPDIFF(MINUTE, MAX(date_changed), NOW()) AS minutes_since_last_change
FROM item_price;

-- 4. List items that are running out of stock.

SELECT 
    item.item_id, 
    item.item_name, 
    item_stock.quantity
FROM item_stock
INNER JOIN item ON item_stock.item_id = item.item_id
WHERE item_stock.quantity > 0 AND item_stock.quantity < 10;

-- 5. List items whose quantity is Zero (0) and how long (In minutes) they have been in this state.
--  From last date changed to current date timestamp

SELECT 
    item.item_id,
    item.item_name,
    item_stock.quantity,
    date_created,
    date_changed,
    TIMESTAMPDIFF(MINUTE, date_changed, NOW()) AS minutes_in_zero
FROM item_stock
INNER JOIN item ON item_stock.item_id = item.item_id
WHERE item_stock.quantity = 0;