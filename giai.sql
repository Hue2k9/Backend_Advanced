
--ex1
select LastName +' '+ FirstName as FullName 
from Employees

--ex2
select upper((LastName +' '+ FirstName)) as FullName
from Employees

--ex3
select * from Employees where Country ='USA'

--ex4
select * from Customers where Country='UK'

--ex5
select * from Customers where Country='Mexico'

--ex6
select * from Customers where Country='Sweden'

--ex7
select productid, ProductName,UnitPrice,UnitsInStock
from products 
where UnitsInStock between 5 and 10

--ex8
select productid, ProductName, UnitPrice, ReorderLevel, UnitsOnOrder
from products
where UnitsOnOrder between 60 and 100

--ex9
select orders.EmployeeID,LastName, FirstName, Title,YEAR(OrderDate) 'year',count(orders.EmployeeID) as totalOrders
from Employees inner join Orders
on Employees.EmployeeID = Orders.EmployeeID
where YEAR(OrderDate)=1996
group by orders.EmployeeID, LastName, FirstName, Title,YEAR(OrderDate)

--ex10
select orders.EmployeeID,LastName, FirstName, City,Country,count(orders.EmployeeID) as totalOrders
from Employees inner join Orders
on Employees.EmployeeID = Orders.EmployeeID
where YEAR(OrderDate)=1998
group by orders.EmployeeID,LastName, FirstName, Title,City,Country

--ex11
select orders.EmployeeID,LastName, FirstName, HireDate,count(orders.EmployeeID) as totalOrders
from Employees inner join Orders
on Employees.EmployeeID = Orders.EmployeeID
where   CONVERT(VARCHAR,OrderDate, 20) between '1998-01-01 00:00:00' and '1998-07-31 00:00:00'
group by orders.EmployeeID, LastName, FirstName, Title,HireDate

--ex12
select orders.EmployeeID,LastName, FirstName, HireDate,HomePhone,count(orders.EmployeeID) as totalOrders
from Employees inner join Orders
on Employees.EmployeeID = Orders.EmployeeID
where   CONVERT(VARCHAR,OrderDate, 20) between '1997-01-01 00:00:00' and '1997-06-30 23:59:59'
group by orders.EmployeeID, LastName, FirstName, Title, HireDate,HomePhone

--ex13
create function ex13(@Freight float)
returns float
as
begin
   declare @tax float;
   set @tax=0.05;
   if (exists(select * from Orders where Freight>100 and Freight=@Freight)) set @tax=0.1
   return @tax
end

select OrderId, Day(OrderDate) 'OrderDay', MONTH(OrderDate) 'OrderMonth',
YEAR(OrderDate) 'OrderYear', Freight, dbo.ex13(Freight) 'tax' , (Freight+Freight*dbo.ex13(Freight)) 'Frieght with tax' from Orders
where CONVERT(VARCHAR,OrderDate, 20) between '1996-08-01 00:00:00' and '1996-08-05 23:59:59' 

--ex14
create function ex14(@Gender char(10))
returns char(10)
as 
begin
   declare @sex char(10);
   set @sex = 'Male';
   if (exists (select * from Employees where TitleOfCourtesy in ('Ms.','Mrs.') and TitleOfCourtesy=@Gender)) 
      set @sex='Female';
   return @sex
end

select LastName+' '+FirstName as 'Full name',TitleOfCourtesy, dbo.ex14(TitleOfCourtesy) 'Sex'
from Employees
order by dbo.ex15(TitleOfCourtesy) desc

--ex15
create function ex15(@Gender char(10))
returns char(10)
as 
begin
   declare @sex char(10);
   set @sex = 'M';
   if (exists (select * from Employees where TitleOfCourtesy in ('Ms.','Mrs.') and TitleOfCourtesy=@Gender)) 
      set @sex='F';
   return @sex
end

select LastName+' '+FirstName as 'Full name',TitleOfCourtesy, dbo.ex15(TitleOfCourtesy) 'Sex'
from Employees
order by dbo.ex15(TitleOfCourtesy) desc

--ex16
create function ex16(@Gender char(10))
returns char(10)
as 
begin
   declare @sex char(10);
   set @sex = 'Male';
   if (exists (select * from Employees where TitleOfCourtesy in ('Ms.','Mrs.') and TitleOfCourtesy=@Gender)) 
      set @sex='Female';
   if (exists (select * from Employees where TitleOfCourtesy in ('Dr.') and TitleOfCourtesy=@Gender)) 
      set @sex='Unknown';
   return @sex
end

select LastName+' '+FirstName as 'Full name',TitleOfCourtesy, dbo.ex16(TitleOfCourtesy) 'Sex'
from Employees
order by dbo.ex16(TitleOfCourtesy) 

--ex17
create function ex17(@Gender char(10))
returns char(10)
as 
begin
   declare @sex int;
   set @sex = 1;
   if (exists (select * from Employees where TitleOfCourtesy in ('Ms.','Mrs.') and TitleOfCourtesy=@Gender)) 
      set @sex=0;
   if (exists (select * from Employees where TitleOfCourtesy in ('Dr.') and TitleOfCourtesy=@Gender)) 
      set @sex=2;
   return @sex
end

select LastName+' '+FirstName as 'Full name',TitleOfCourtesy, dbo.ex17(TitleOfCourtesy) 'Sex'
from Employees

--ex18
create function ex18(@Gender char(10))
returns char(10)
as 
begin
   declare @sex char(10);
   set @sex = 'M';
   if (exists (select * from Employees where TitleOfCourtesy in ('Ms.','Mrs.') and TitleOfCourtesy=@Gender)) 
      set @sex='F';
   if (exists (select * from Employees where TitleOfCourtesy in ('Dr.') and TitleOfCourtesy=@Gender)) 
      set @sex='N/A';
   return @sex
end

select LastName+' '+FirstName as 'Full name',TitleOfCourtesy, dbo.ex18(TitleOfCourtesy) 'Sex'
from Employees
order by dbo.ex18(TitleOfCourtesy) 

--ex 21
select Categories.CategoryID, Categories.CategoryName, Products.ProductID, ProductName,
Day(OrderDate) 'Day', Month(OrderDate) 'Month',YEAR(OrderDate) 'Year',(Quantity*[Order Details].UnitPrice) 'Revenue'
from Products
inner join Categories on Categories.CategoryID=Products.CategoryID
inner join [Order Details] on Products.ProductID=[Order Details].ProductID
inner join Orders on Orders.OrderID=[Order Details].OrderID
where CONVERT(VARCHAR,OrderDate, 20) between '1996-07-01 00:00:00' and '1996-07-05 23:59:59' 

--ex 22
select Employees.EmployeeID, LastName,FirstName, Orders.OrderID,OrderDate,RequiredDate,ShippedDate
from Orders
inner join Employees on Employees.EmployeeID=Orders.EmployeeID
where ShippedDate-RequiredDate>7
order by EmployeeID

--ex23
select CompanyName as 'CompanyName', Phone as 'Phone'  from Customers
where CompanyName like 'W%'
Union
select (LastName + ' '+FirstName) as 'CompanyName', HomePhone 'Phone' from Employees
order by CompanyName desc

--ex24
select orders.CustomerID, CompanyName, ContactName, ContactTitle
from Customers
inner join Orders on Orders.CustomerID=Customers.CustomerID
where OrderID=10643

--ex25
select Products.ProductID,ProductName, sum(Quantity) as [Total Ordered] from products
inner join [Order Details] on [Order Details].ProductID=Products.ProductID
group by Products.ProductID,ProductName
having  sum(Quantity)>1200

--ex26
select Products.ProductID,ProductName, SupplierID,CategoryID,sum(Quantity) as [Total Ordered] from products
inner join [Order Details] on [Order Details].ProductID=Products.ProductID
group by Products.ProductID,ProductName,SupplierID,CategoryID
having  sum(Quantity)>1400
order by ProductName

--ex27
select products.CategoryID, CategoryName,count(products.CategoryID) 'Total products'
from Products
inner join Categories on Categories.CategoryID=Products.CategoryID
group by CategoryName,products.CategoryID
having count(products.CategoryID)=(select TOP 1  count(products.CategoryID) as 'Total products'
from Products
inner join Categories on Categories.CategoryID=Products.CategoryID
group by CategoryName,products.CategoryID
order by count(products.CategoryID) desc)

--ex28
select products.CategoryID, CategoryName,count(products.CategoryID) 'Total products'
from Products
inner join Categories on Categories.CategoryID=Products.CategoryID
group by CategoryName,products.CategoryID
having count(products.CategoryID)=(select TOP 1  count(products.CategoryID) as 'Total products'
from Products
inner join Categories on Categories.CategoryID=Products.CategoryID
group by CategoryName,products.CategoryID
order by count(products.CategoryID) )

--ex29
declare @customers int;
declare @employees int;
declare @total int;
set @customers=(select Count(*)  from Customers)
set @employees=(select Count(*) from Employees)
set @total=@customers+@employees
select @total 'Total record'

--ex 30
select orders.EmployeeID, LastName,FirstName,Title, count(orders.EmployeeID) 'total orders'
from Employees
inner join Orders on Orders.EmployeeID=Employees.EmployeeID
group by  orders.EmployeeID, LastName,FirstName,Title
having count(orders.EmployeeID)=(select top 1 count(orders.EmployeeID) 
from Employees
inner join Orders on Orders.EmployeeID=Employees.EmployeeID
group by  orders.EmployeeID
order by count(orders.EmployeeID) 
)

--ex 31
select orders.EmployeeID, LastName,FirstName,Title, count(orders.EmployeeID) 'total orders'
from Employees
inner join Orders on Orders.EmployeeID=Employees.EmployeeID
group by  orders.EmployeeID, LastName,FirstName,Title
having count(orders.EmployeeID)=(select top 1 count(orders.EmployeeID) 
from Employees
inner join Orders on Orders.EmployeeID=Employees.EmployeeID
group by  orders.EmployeeID
order by count(orders.EmployeeID) desc
)

--ex32
select ProductID, ProductName, SupplierID, CategoryID, UnitsInStock
from Products
where UnitsInStock=(select max(UnitsInStock) from Products)

--ex 33
select ProductID, ProductName, SupplierID, CategoryID, UnitsInStock
from Products
where UnitsInStock=(select min(UnitsInStock) from Products)

--ex 34
select ProductID, ProductName, SupplierID, CategoryID, UnitsOnOrder
from Products
where UnitsOnOrder=(select max(UnitsOnOrder) from Products)

--ex 35
select ProductID, ProductName, SupplierID, CategoryID, ReorderLevel
from Products
where ReorderLevel=(select max(ReorderLevel) from Products)

--ex 36
select Employees.EmployeeID, LastName,FirstName, count(Employees.EmployeeID) 'Delay Orders'
from Orders
inner join Employees on Employees.EmployeeID=Orders.EmployeeID
where ShippedDate-RequiredDate>0
group by Employees.EmployeeID, LastName,FirstName
having count(Employees.EmployeeID)=(select top 1  count(Employees.EmployeeID) 'Delay Orders'
from Orders
inner join Employees on Employees.EmployeeID=Orders.EmployeeID
where ShippedDate-RequiredDate>0
group by Employees.EmployeeID
order by count(Employees.EmployeeID) desc)


--ex 37
select Employees.EmployeeID, LastName,FirstName, count(Employees.EmployeeID) 'Delay Orders'
from Orders
inner join Employees on Employees.EmployeeID=Orders.EmployeeID
where ShippedDate-RequiredDate>0
group by Employees.EmployeeID, LastName,FirstName
having count(Employees.EmployeeID)=(select top 1  count(Employees.EmployeeID) 'Delay Orders'
from Orders
inner join Employees on Employees.EmployeeID=Orders.EmployeeID
where ShippedDate-RequiredDate>0
group by Employees.EmployeeID
order by count(Employees.EmployeeID))


--ex 38
declare @top2 int;
set @top2=(select top 1 sum(Quantity) 'Total Ordered'from Products
inner join [Order Details] on [Order Details].ProductID=Products.ProductID
group by Products.ProductID
having 
sum(Quantity)<(select  top 1 sum(Quantity) 'Total Ordered'from Products
inner join [Order Details] on [Order Details].ProductID=Products.ProductID
group by Products.ProductID order by sum(quantity) desc)
order by sum(quantity) desc)

declare @top3 int;
set @top3=(select top 1 sum(Quantity) 'Total Ordered'from Products
inner join [Order Details] on [Order Details].ProductID=Products.ProductID
group by Products.ProductID
having sum(Quantity)<@top2 order by  sum(quantity) desc)

select  top 3  products.ProductID,ProductName, sum(Quantity) 'Total Ordered'from Products
inner join [Order Details] on [Order Details].ProductID=Products.ProductID
group by Products.ProductID,ProductName
having sum(Quantity)>=@top3
order by sum(quantity) asc

--ex 39
declare @top2 int;
set @top2=(select top 1 sum(Quantity) 'Total Ordered'from Products
inner join [Order Details] on [Order Details].ProductID=Products.ProductID
group by Products.ProductID
having 
sum(Quantity)<(select  top 1 sum(Quantity) 'Total Ordered'from Products
inner join [Order Details] on [Order Details].ProductID=Products.ProductID
group by Products.ProductID order by sum(quantity) desc)
order by sum(quantity) desc)

declare @top3 int;
set @top3=(select top 1 sum(Quantity) 'Total Ordered'from Products
inner join [Order Details] on [Order Details].ProductID=Products.ProductID
group by Products.ProductID
having sum(Quantity)<@top2 order by  sum(quantity) desc)

declare @top4 int;
set @top4=(select top 1 sum(Quantity) 'Total Ordered'from Products
inner join [Order Details] on [Order Details].ProductID=Products.ProductID
group by Products.ProductID
having sum(Quantity)<@top3 order by  sum(quantity) desc)

declare @top5 int;
set @top5=(select top 1 sum(Quantity) 'Total Ordered'from Products
inner join [Order Details] on [Order Details].ProductID=Products.ProductID
group by Products.ProductID
having sum(Quantity)<@top4 order by  sum(quantity) desc)

select  top 5  products.ProductID,ProductName, sum(Quantity) 'Total Ordered'from Products
inner join [Order Details] on [Order Details].ProductID=Products.ProductID
group by Products.ProductID,ProductName
having sum(Quantity)>=@top5
order by sum(quantity) asc



















