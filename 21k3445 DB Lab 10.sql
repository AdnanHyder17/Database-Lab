-- 21k3445 Adnan Haider
-- Class Task

SET TRANSACTION NAME 'products_order_transaction';

INSERT INTO customer (customer_id, customer_name, balance) VALUES (3, 'Charlie', 1500);  

INSERT INTO products (product_id, product_name, price) VALUES (103, 'Tablet', 500);  

INSERT INTO inventory (product_id, quantity_in_stock) VALUES (103, 30);

-- savepoint 
SAVEPOINT inventory_added;

-- Deduct from inventory and create an order
UPDATE inventory SET quantity_in_stock = quantity_in_stock - 5
WHERE product_id = 103;  

SAVEPOINT order_added;

-- Check if there is sufficient balance for the customer or stock is available or not
DECLARE
    v_balance NUMBER(10, 2);
    v_quantity_in_stock NUMBER;
BEGIN
    -- Check the customer balance for Charlie
    SELECT balance INTO v_balance
    FROM customer
    WHERE customer_id = 3;

    -- Check inventory for Tablets
    SELECT quantity_in_stock INTO v_quantity_in_stock
    FROM inventory
    WHERE product_id = 103;

    -- If inventory is sufficient and customer has enough balance, proceed
    IF v_quantity_in_stock >= 0 AND v_balance >= (500 * 5) THEN
        -- Deduct balance from customer
        UPDATE customer
        SET balance = balance - (500 * 5)
        WHERE customer_id = 3;

        -- Insert order
        INSERT INTO orders (order_id, customer_id, product_id, quantity_ordered, status)
        VALUES (orders_seq.NEXTVAL, 3, 103, 5, 'Completed');  -- Assuming orders_seq is a sequence for order_id

        -- Commit the transaction if everything is successful
        COMMIT;
    ELSE
        -- If inventory is insufficient, rollback to inventory_added savepoint
        ROLLBACK TO SAVEPOINT inventory_added;
        DBMS_OUTPUT.PUT_LINE('Insufficient inventory or balance. Order canceled.');
    END IF;
END;
/


-- Task 1:

CREATE TABLE prod_inv (
    product_id NUMBER PRIMARY KEY,
    product_name VARCHAR2(50),
    stock NUMBER,
    price NUMBER(10, 2)
);

CREATE TABLE returns (
    return_id NUMBER PRIMARY KEY,
    product_id NUMBER,
    return_date DATE,
    reason VARCHAR2(255),
    quantity NUMBER,
    FOREIGN KEY (product_id) REFERENCES prod_inv(product_id)
);

INSERT INTO prod_inv (product_id, product_name, stock, price)
VALUES (101, 'Laptop', 50, 1000.00);

INSERT INTO prod_inv (product_id, product_name, stock, price)
VALUES (102, 'Smartphone', 100, 500.00);

INSERT INTO prod_inv (product_id, product_name, stock, price)
VALUES (103, 'Tablet', 30, 300.00);



SET TRANSACTION NAME 'product_return_transaction';

INSERT INTO returns (return_id, product_id, return_date, reason, quantity)
VALUES (1, 101, SYSDATE, 'Defective', 3);

SAVEPOINT stock_update;

-- 2. Calculate the adjusted returned quantity (after the 5% restocking fee)
DECLARE
    v_returned_quantity NUMBER;
    v_restocked_quantity NUMBER;
BEGIN
    -- Retrieve the returned quantity from the returns table
    SELECT quantity INTO v_returned_quantity
    FROM returns
    WHERE return_id = (SELECT MAX(return_id) FROM returns);

    -- Apply 5% restocking fee
    v_restocked_quantity := v_returned_quantity * 0.95;

    -- Update stock in product_inventory
    UPDATE prod_inv
    SET stock = stock + v_restocked_quantity
    WHERE product_id = 101;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN

        ROLLBACK TO SAVEPOINT stock_update;
        
        DBMS_OUTPUT.PUT_LINE('Error occurred, rolled back to savepoint stock_update.');
END;



-- Calculate total returned products, deducting a 5% restocking fee
SELECT ri.product_name,
       ri.product_id,
       SUM(COALESCE(r.quantity, 0)) * (1 - 0.05) AS adjusted_returned_quantity
FROM prod_inv ri
LEFT JOIN returns r ON ri.product_id = r.product_id
GROUP BY ri.product_name, ri.product_id;


