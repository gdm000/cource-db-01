create database test;

create schema if not exists shop;


create role manager login password 'manager';
create role seller login password 'seller';

CREATE TABLE shop.supplier
(
    id bigserial NOT NULL,
    title varchar(255) NOT NULL,
    description varchar(1024),
    PRIMARY KEY (id)
);

ALTER TABLE IF EXISTS shop.supplier
    OWNER to postgres;

CREATE TABLE shop.manufacturer
(
    id bigserial NOT NULL,
    title varchar(255) NOT NULL,
    description varchar(1024),
    PRIMARY KEY (id)
);

ALTER TABLE IF EXISTS shop.manufacturer
    OWNER to postgres;

CREATE TABLE shop.customer
(
    id bigserial NOT NULL,
    name varchar(255) NOT NULL,
    phone varchar(18) NOT NULL,
    email varchar(255) NOT NULL,
    PRIMARY KEY (id)
);

ALTER TABLE IF EXISTS shop.customer
    OWNER to postgres;

CREATE TABLE shop.purchase
(
    id bigserial NOT NULL,
    customer_id bigint NOT NULL,
    paid boolean NOT NULL DEFAULT false,
    details varchar(1024),
    PRIMARY KEY (id),
    CONSTRAINT customer_fk FOREIGN KEY (customer_id)
        REFERENCES shop.customer (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
);

ALTER TABLE IF EXISTS shop.purchase
    OWNER to postgres;
    
CREATE TABLE shop.product_category
(
    id bigserial NOT NULL,
    title varchar(255) NOT NULL,
    description varchar(1024),
    PRIMARY KEY (id)
);

ALTER TABLE IF EXISTS shop.product_category
    OWNER to postgres;

CREATE TABLE shop.product
(
    id bigserial NOT NULL,
    title varchar(255) NOT NULL,
    product_category_id bigint NOT NULL,
    manufacturer_id bigint NOT NULL,
    description varchar(1024),
    PRIMARY KEY (id),
    CONSTRAINT product_category_fk FOREIGN KEY (product_category_id)
        REFERENCES shop.product_category (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
);

ALTER TABLE IF EXISTS shop.product
    OWNER to postgres;

CREATE TABLE shop.price
(
    id bigserial NOT NULL,
    product_id bigint NOT NULL,
    supplier_id bigint NOT NULL,
    val decimal NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT product_fk FOREIGN KEY (product_id)
        REFERENCES shop.product (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT supplier_fk FOREIGN KEY (supplier_id)
        REFERENCES shop.supplier (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
);

ALTER TABLE IF EXISTS shop.price
    OWNER to postgres;

CREATE TABLE shop.purchase_item
(
    id bigserial NOT NULL,
    purchase_id bigint NOT NULL,
    price_id bigint NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT purchase_fk FOREIGN KEY (purchase_id)
        REFERENCES shop.purchase (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT price_fk FOREIGN KEY (price_id)
        REFERENCES shop.price (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
);

ALTER TABLE IF EXISTS shop.purchase_item
    OWNER to postgres;

GRANT SELECT, INSERT, UPDATE, DELETE ON
shop.purchase_item,
shop.purchase,
shop.product_category,
shop.product,
shop.price,
shop.customer,
shop.manufacturer,
shop.supplier
TO manager;

GRANT SELECT, INSERT, UPDATE, DELETE ON
shop.purchase_item,
shop.purchase
TO seller;

GRANT SELECT ON
shop.product_category,
shop.product,
shop.price,
shop.customer,
shop.manufacturer,
shop.supplier
TO seller;

commit;




