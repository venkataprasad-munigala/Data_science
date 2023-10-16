/* 
-----------------------------------
Axon Car Retailers Capstone Project
-----------------------------------


1. Total Sales
*/
select sum(quantityOrdered * priceEach) as Total_Sales from orderdetails;

/*
2. Total Products
*/
select distinct count(productCode) from products;

/*
3. Total Orders
*/
select distinct count(orderNumber) from orderdetails;

/*
4. Total Cost
*/
select SUM(o.quantityOrdered * p.buyPrice) Total_Cost from orderdetails o
inner join products p
on o.productCode = p.productCode;

/*
5. Total Profit
*/
select SUM(o.quantityOrdered * (o.priceEach - p.buyPrice)) Total_Profit from orderdetails o
inner join products p
on o.productCode = p.productCode;

/*
6. Total Profit PCT
*/
with total_cost_cte as(
select SUM(o.quantityOrdered * p.buyPrice) Total_Cost from orderdetails o
inner join products p
on o.productCode = p.productCode),

total_profit_cte as(
select SUM(o.quantityOrdered * (o.priceEach - p.buyPrice)) Total_Profit from orderdetails o
inner join products p
on o.productCode = p.productCode)

select (Total_Profit / Total_Cost) * 100 as Total_Profit_PCT from total_cost_cte
inner join total_profit_cte;

/*
7. Total Employees
*/
select count(employeeNumber) as Employees from employees;

/*
8. Yearly Orders
*/
select Year(o.orderDate) Year, count(od.orderNumber) Orders from orderdetails od
join orders o on od.orderNumber = o.orderNumber
group by Year(o.orderDate);

/*
9. Total Customers
*/
select count(customerName) from customers;

/*
10. Yearly Sales
*/
select Year(o.orderDate) Year, SUM(od.quantityOrdered * od.priceEach) Sales from orderdetails od
join orders o on od.orderNumber = o.orderNumber
group by Year(o.orderDate);

/*
11. Top 5 Customers
*/
select c.customerName, SUM(od.quantityOrdered * od.priceEach) Sales from orderdetails od
inner join orders o on od.orderNumber = o.orderNumber
inner join customers c on o.customerNumber = c.customerNumber
group by c.customerNumber
order by Sales desc
limit 5;

/*
12. Bottom 5 Customers
*/
select c.customerName, SUM(od.quantityOrdered * od.priceEach) Sales from orderdetails od
inner join orders o on od.orderNumber = o.orderNumber
inner join customers c on o.customerNumber = c.customerNumber
group by c.customerNumber
order by Sales asc
limit 5;

/*
13. Top 5 Products
*/
select p.productName, SUM(od.quantityOrdered * od.priceEach) Sales from products p
inner join orderdetails Od
on p.productCode = od.productCode
group by od.productCode
order by Sales desc
limit 5;

/*
14. Bottom 5 Products
*/
select p.productName, SUM(od.quantityOrdered * od.priceEach) Sales from products p
inner join orderdetails Od
on p.productCode = od.productCode
group by od.productCode
order by Sales asc
limit 5;

/*
15. Most customers country wise
*/
select country, count(distinct customerNumber) Customer_Count from customers
group by country
order by Customer_Count desc;

/*
16. sales representative of a customer
*/
select e.employeeNumber, concat(e.firstName, e.lastName) as Employee, c.customerName from customers c
inner join employees e 
on c.salesRepEmployeeNumber = e.employeeNumber
order by e.employeeNumber asc;

/*
17. Top 5 Customers with high credit limit
*/
select customerName, creditLimit from customers
order by creditLimit desc
limit 5;

/*
17. Bottom 5 Customers with low credit limit
*/
select customerName, creditLimit from customers
where creditLimit > 0
order by creditLimit asc
limit 5;

/*
18. Customers with no credit limit
*/
select customerName, creditLimit from customers
where creditLimit = 0
order by customerName asc;

/*
19. Customer with most orders
*/
select c.customerNumber, c.customerName, count(o.orderNumber) as OrdersCount from customers c
inner join orders o on c.customerNumber = o.customerNumber
group by o.customerNumber
order by OrdersCount desc;

/*
20. Orders per productline
*/
select p.productline, count(od.productCode) Orders from products p
inner join orderdetails od on p.productcode = od.productcode
inner join orders o on o.ordernumber = od.ordernumber
group by p.productline
order by Orders desc;

/*
21. Total products of each product line
*/
select productLine, count(*) as Count from products
group by productLine
order by Count desc;

/*
22. Customers who ordered  products of all productlines
*/
select c.customerNumber,c.customerName, count(distinct p.productLine) as Count from customers c
inner join orders o on c.customerNumber = o.customerNumber
inner join orderdetails od on o.ordernumber = od.orderNumber
inner join products p on p.productCode = od.productCode
inner join productlines pl on p.productLine = pl.productLine
group by c.customerNumber
having Count=7
order by c.customerName asc;

/*
23. OfficeCode, City, Country wise Sales and Profit.
*/
select ofc.officecode, ofc.city, ofc.country, SUM(od.quantityordered * od.priceeach) as Sales, 
SUM(od.quantityordered * (od.priceeach - p.buyprice)) as Profit
from orderdetails od
join products p on od.productcode = p.productcode
join orders o on od.ordernumber = o.ordernumber
join customers c on o.customernumber = c.customernumber
join employees e on c.salesrepemployeenumber = e.employeenumber
join offices ofc on e.officecode = ofc.officecode
group by ofc.officecode, ofc.city, ofc.country 
order by Profit desc;

/*
24. Average total sales
*/
select avg(sales)
from (
    select sum(quantityordered * priceeach) as sales
    from orderdetails
    group by ordernumber
) as average_sales;

/*
25. Avg sales yearly
*/
select yearr as Year, avg(sales)
from (
    select Year(o.orderDate) as yearr, sum(quantityordered * priceeach) as sales
    from orderdetails Od
    inner join orders o on od.orderNumber = o.orderNumber
    group by yearr, od.ordernumber
) as average_sales
group by yearr;

/*
26. Find the day which is having highest orders
*/
select dayname(orderdate) Day,Count(*) Orders
from orders
group by Day
order by Orders desc;

/*
27. Customers whose total sales exceed 10000
*/
select c.customernumber, c.customername, SUM(od.quantityordered * od.priceeach) as Sales
from customers c
join orders o on c.customernumber = o.customernumber
join orderdetails od on o.ordernumber = od.ordernumber
group by c.customernumber, c.customername
having Sales> 10000
order by Sales desc;

/*
28. Monthly Total and Avg sales
*/
select DATE_FORMAT(o.orderDate, '%Y') as Year,
DATE_FORMAT(o.orderDate, '%m') as Month,
SUM(od.quantityOrdered * od.priceEach) as Total_Sales,
AVG(od.quantityOrdered * od.priceEach) as Average_Sales
from orderdetails od
inner join orders o on od.orderNumber = o.orderNumber
group by Year, Month
order by  Year, Month;

/*
29. status wise value which are not shipped.
*/
select status, sum(quantityordered*priceeach) as Price
from orders o 
inner join orderdetails od on o.ordernumber = od.ordernumber
where shippeddate is null
group by status
order by status asc;

/*
30. Yearly details Customer, Product and price details of all orders
*/
select od.ordernumber, o.Customernumber, Customername, country,
year(orderdate) Year, count(productcode) Products, sum(quantityordered) Units,
sum(quantityordered*priceeach) Price
from orderdetails od 
inner join orders o on od.ordernumber = o.ordernumber
inner join customers c on c.customernumber = o.customernumber
group by o.Customernumber, Customername, country, od.ordernumber
order by Year asc, Price desc;

/*
31. Product wise stock availibility
*/
select p.productcode, productname, quantityinstock, SUM(quantityordered) QuantityOrdered
from products p 
inner join orderdetails od on p.productcode = od.productcode
group by p.productcode, productname, quantityinstock
order by QuantityOrdered desc;

/*
32. Country wise product with highest sale.
*/
with country_wise_prod_sales as(
select country, productLine, productName, round(sum(amount)) Amount
from customers c 
inner join payments p on c.customernumber = p.customernumber
inner join orders o on c.customernumber = o.customernumber
inner join orderdetails od on o.ordernumber = od.ordernumber
inner join products pr on od.productcode = pr.productcode
group by country, productLine, productName
order by country, Amount desc)

Select cps.Country, cps.productLine, productName, cps.Amount from
(select country, productLine, productName, Amount,
dense_rank() over(partition by Country order by Amount desc) Sales_Dense_Rank 
from country_wise_prod_sales) cps
where cps.Sales_Dense_Rank = 1;


