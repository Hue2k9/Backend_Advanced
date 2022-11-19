
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