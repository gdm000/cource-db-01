insert into shop.product_category(title, description) values
('toys', 'toys descr'),
('books', 'books descr'),
('dishes', 'dishes descr');

insert into shop.manufacturer(title, description) values
('man1', 'man1 descr'),
('man2', 'man2 descr'),
('man3', 'man3 descr');

insert into shop.supplier(title, description) values
('supp1', 'supp1 descr'),
('supp2', 'supp2 descr'),
('supp3', 'supp3 descr');

insert into shop.product (title, description, manufacturer_id, product_category_id)
values
('product1','product1 descr toys', 1, 1),
('product2', 'product2 descr toys', 1, 1),
('product3','product3 descr toys', 1, 1),
('product4','product4 descr books', 1, 2),
('product5','product5 descr dishes', 1, 3),
('product6','product6 descr books', 2, 2),
('product7','product7 descr books', 2, 2),
('product8','product8 descr toys', 3, 1),
('product9','product9 descr dishes', 3, 3),
('product10','product10 descr dishes', 3, 3);

insert into shop.price (product_id, supplier_id, val)
values
(1, 1, 1000.50),
(2, 1, 2500.00),
(3, 1, 5000.00),
(4, 2, 2300.50),
(5, 2, 4700.00),
(6, 2, 750.00),
(7, 2, 330.00),
(8, 2, 1000.00),
(9, 2, 530.00),
(10, 2, 530.00),
(4, 3, 2500.00),
(5, 3, 5000.00),
(6, 3, 1000.00),
(7, 3, 200.00),
(9, 3, 500.00),
(10, 3, 600.00)

insert into shop.customer (name, email, phone)
values
('Jhon', 'jhon@mail.ru', '79998887711'),
('Mary', 'mary@mail.ru', '79998887722'),
('David', 'david@mail.ru', '79998887733'),
('Tess', 'tess@mail.ru', '79998887744'),
('Lisy', 'lisy@mail.ru', '79998887755'),
('Ann', 'ann@mail.ru', '79998887766'),
('Bob', 'bob@mail.ru', '79998887777');

insert into shop.purchase (customer_id, paid, details)
values
(1, true, ''),
(1, true, ''),
(1, true, ''),
(1, false, ''),
(2, true, ''),
(2, true, ''),
(2, true, ''),
(3, false, ''),
(3, true, ''),
(4, false, ''),
(4, false, ''),
(5, true, ''),
(6, false, '');

/*1-10
11 - (4, 3, 2500.00),
12 - (5, 3, 5000.00),
13 - (6, 3, 1000.00),
14 - (7, 3, 200.00),
15 - (9, 3, 500.00),
16 - (10, 3, 600.00)*/

insert into shop.purchase_item (purchase_id, price_id)
values
(1,6),
(1,2),
(1,1),
(1,11),
(2,11),
(2,8),
(2,9),
(3,4),
(3,12),
(4,11),
(4,13),
(4,14),
(4,15),
(4,16),
(5,1),
(5,2),
(6,3),
(7,12),
(8,13),
(9,14),
(10,15),
(11,16),
(12,16),
(13,16);

-- Get products which have 'toys' in description
select prd.title as product, prd.description , mnf.title as manufacturer from shop.product as prd
join shop.manufacturer as mnf on prd.manufacturer_id = mnf.id where prd.description like '%toys%';

--All customers are propagated according to matching purchases count for each customer, also will see customers WITHOUT purchases
select c.email, p.id as purchase, p.paid from shop.customer as c left join shop.purchase as p on c."id" = p.customer_id;

--All customers are propagated according to matching purchases count for each customer, will NOT see customers WITHOUT purchases
select c.email, p.id as purchase, p.paid from shop.customer as c inner join shop.purchase as p on c."id" = p.customer_id;

insert into shop.purchase_item (purchase_id, price_id)
select p.id, (select max(pr.id) from shop.price as pr where pr.product_id = (select max(shop.product."id") from shop.product))
from shop.purchase as p where p.paid = false returning id, price_id;

update shop.product as pr set description = pr.description || ' ' || mf.title from shop.manufacturer mf where pr.manufacturer_id = mf."id";

delete from shop.purchase_item pi using shop.purchase pu where pi.purchase_id = pu.id and pu.paid = false returning pi.id;


