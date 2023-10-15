-- What is the warehouse with the highest current capacity?
-- The below query's result ranks the warehouses based on how full their storage are.
SELECT products.warehouseCode, SUM(quantityInStock) AS quantityInStock, warehouses.warehousePctCap
	FROM products
    INNER JOIN warehouses
    ON products.warehouseCode = warehouses.warehouseCode
	GROUP BY warehouseCode
    ORDER BY warehousePctCap DESC;

-- What is the real profit of the products in each warehouse?
-- The below query's result shows the actual profit from past orders,
-- ranking the warehouse based on the profit that their stored products generated.
SELECT SUM(quantityOrdered*(priceEach-products.buyPrice)) AS profit, products.warehouseCode
	FROM orderdetails
    LEFT JOIN products
    ON orderdetails.productCode = products.productCode
	GROUP BY products.warehouseCode
    ORDER BY profit;

-- What are the product lines stored in the warehouse?
SELECT COUNT(productLine) AS numOfProducts, productLine, warehouseCode
	FROM products
    GROUP BY warehouseCode, productLine
    ORDER BY warehouseCode;

-- What are the products' rates of quantity ordered vs. quantity in stock
-- The higher the rate, the more the products are moving.
SELECT SUM(quantityOrdered / products.quantityInstock) AS totalOrderRate, products.warehouseCode
	FROM orderdetails
    LEFT JOIN products
    ON orderdetails.productCode = products.productCode
    GROUP BY products.warehouseCode
    ORDER BY totalOrderRate;
    
-- What are the products that have not yielded the expected profit?
-- The result shows the number of products with real profit less than suggested profit.
-- The warehouses will be ranked based on how many undervalued products it stores.
SELECT COUNT(DISTINCT products.productCode) AS undervaluedProducts, products.warehouseCode
	FROM orderdetails
    LEFT JOIN products
    ON orderdetails.productCode = products.productCode
    WHERE orderdetails.priceEach - products.buyPrice < products.MSRP - products.buyPrice
    GROUP BY products.warehouseCode
    ORDER BY undervaluedProducts DESC;

-- What are the product that have not been moving at all?
SELECT products.productCode, products.quantityInStock, products.warehouseCode, products.productLine
	FROM products
    LEFT OUTER JOIN orderdetails
    ON products.productCode = orderdetails.productCode
    WHERE orderdetails.productCode IS NULL;
