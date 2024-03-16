-- Role: cargodbuser
-- DROP ROLE IF EXISTS cargodbuser;

CREATE ROLE cargodbuser WITH
  LOGIN
  NOSUPERUSER
  INHERIT
  NOCREATEDB
  NOCREATEROLE
  NOREPLICATION
  ENCRYPTED PASSWORD 'SCRAM-SHA-256$4096:M7B9O+DtxAh8brKJ3bU4Cw==$n68HSC+jcezj2DY9mY5B9VTg0vRhaUVXZLakxiORv0c=:d5GsFDU+TKxQx6+f6BUwwXCqGBOGDuLnan9nMZYcflc=';

ALTER ROLE cargodbuser SET default_transaction_isolation TO 'read committed';
ALTER ROLE cargodbuser SET client_encoding TO 'utf8';

-- Database: cargo_delivery

-- DROP DATABASE IF EXISTS cargo_delivery;

CREATE DATABASE cargo_delivery
    WITH
    OWNER = cargodbuser
    ENCODING = 'UTF8'
    LC_COLLATE = 'Russian_Russia.1251'
    LC_CTYPE = 'Russian_Russia.1251'
    LOCALE_PROVIDER = 'libc'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

GRANT TEMPORARY, CONNECT ON DATABASE cargo_delivery TO PUBLIC;

GRANT ALL ON DATABASE cargo_delivery TO cargodbuser;

-- CATALOG: information_schema

-- DROP SCHEMA IF EXISTS information_schema;

CREATE SCHEMA IF NOT EXISTS information_schema
    AUTHORIZATION postgres;

GRANT CREATE ON SCHEMA information_schema TO postgres;

-- CATALOG: pg_catalog

-- DROP SCHEMA IF EXISTS pg_catalog;

CREATE SCHEMA IF NOT EXISTS pg_catalog
    AUTHORIZATION postgres;

COMMENT ON SCHEMA pg_catalog
    IS 'system catalog schema';

GRANT CREATE ON SCHEMA pg_catalog TO postgres;

-- Extension: plpgsql

-- DROP EXTENSION plpgsql;

CREATE EXTENSION IF NOT EXISTS plpgsql
    SCHEMA pg_catalog
    VERSION "1.0";

-- Language: plpgsql

-- DROP LANGUAGE IF EXISTS plpgsql

CREATE OR REPLACE TRUSTED PROCEDURAL LANGUAGE plpgsql
    HANDLER plpgsql_call_handler
    INLINE plpgsql_inline_handler
    VALIDATOR plpgsql_validator;

ALTER LANGUAGE plpgsql
    OWNER TO postgres;

COMMENT ON LANGUAGE plpgsql
    IS 'PL/pgSQL procedural language';

-- SCHEMA: public

-- DROP SCHEMA IF EXISTS public ;

CREATE SCHEMA IF NOT EXISTS public
    AUTHORIZATION pg_database_owner;

COMMENT ON SCHEMA public
    IS 'standard public schema';

GRANT USAGE ON SCHEMA public TO PUBLIC;

GRANT ALL ON SCHEMA public TO pg_database_owner;

-- FUNCTION: public.orderview(bigint, character varying, character varying)

-- DROP FUNCTION IF EXISTS public.orderview(bigint, character varying, character varying);

CREATE OR REPLACE FUNCTION public.orderview(
	i bigint DEFAULT NULL::bigint,
	p character varying DEFAULT NULL::character varying,
	l character varying DEFAULT NULL::character varying)
    RETURNS TABLE(id bigint, "Имя" character varying, "Фамилия" character varying, "Отчество" character varying, "Телефон" character varying, "Создан" timestamp without time zone) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
BEGIN
   RETURN QUERY
   SELECT o.id_order, c.firstnamecustomer, c.lastnamecustomer, c.patronymiccustomer, c.phonenumbercustomer, o.datecreateorder
   FROM  ordercargo o
	INNER JOIN customer c ON c.id_customer = o.customer_id_customer
   WHERE CASE
	WHEN $1 is NOT NULL AND $2 is NOT NULL AND $3 is NOT NULL
	THEN o.id_order = $1 AND c.phonenumbercustomer = $2 AND c.lastnamecustomer = $3
	WHEN $1 is NOT NULL AND $2 is NOT NULL
	THEN o.id_order = $1 AND c.phonenumbercustomer = $2
	WHEN $1 is NOT NULL
	THEN o.id_order = $1
	WHEN $2 is NOT NULL
	THEN c.phonenumbercustomer = $2
	WHEN $3 is NOT NULL
	THEN c.lastnamecustomer = $3
	WHEN $1 is NOT NULL AND $3 is NOT NULL
	THEN o.id_order = $1 AND c.lastnamecustomer = $3
	WHEN $2 is NOT NULL AND $3 is NOT NULL
	THEN c.phonenumbercustomer = $2 AND c.lastnamecustomer = $3
	WHEN $1 is NULL AND $2 is NULL AND $3 is NULL
	THEN 1=1
	END;
END
$BODY$;

ALTER FUNCTION public.orderview(bigint, character varying, character varying)
    OWNER TO postgres;

-- PROCEDURE: public.megainsert(character varying, character varying, character varying, character varying, character varying, character varying)

-- DROP PROCEDURE IF EXISTS public.megainsert(character varying, character varying, character varying, character varying, character varying, character varying);

CREATE OR REPLACE PROCEDURE public.megainsert(
	IN firstname character varying,
	IN lastname character varying,
	IN patronymic character varying,
	IN phone character varying,
	IN address1 character varying,
	IN address2 character varying)
LANGUAGE 'plpgsql'
AS $BODY$
DECLARE 
    departure bigint; 
    deliver bigint;
	cust integer;
BEGIN
INSERT INTO customer VALUES (DEFAULT, $1, $2, $3, $4);
cust := lastval();
INSERT INTO address VALUES (DEFAULT, $5, 'Standart');
departure := lastval();
INSERT INTO address VALUES (DEFAULT, $6, 'Standart');
deliver := lastval();
INSERT INTO ordercargo VALUES(DEFAULT, cust, departure, deliver, 1, 'М719ТР198', 'Processing', 'Card', 'Pallets', 0, false, LOCALTIMESTAMP(1));
END;
$BODY$;
ALTER PROCEDURE public.megainsert(character varying, character varying, character varying, character varying, character varying, character varying)
    OWNER TO postgres;

-- SEQUENCE: public.id_address

-- DROP SEQUENCE IF EXISTS public.id_address;

CREATE SEQUENCE IF NOT EXISTS public.id_address
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1
    OWNED BY address.id_address;

ALTER SEQUENCE public.id_address
    OWNER TO cargodbuser;

-- SEQUENCE: public.id_customer

-- DROP SEQUENCE IF EXISTS public.id_customer;

CREATE SEQUENCE IF NOT EXISTS public.id_customer
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 2147483647
    CACHE 1
    OWNED BY customer.id_customer;

ALTER SEQUENCE public.id_customer
    OWNER TO cargodbuser;

-- SEQUENCE: public.id_driver

-- DROP SEQUENCE IF EXISTS public.id_driver;

CREATE SEQUENCE IF NOT EXISTS public.id_driver
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 32767
    CACHE 1
    OWNED BY driver.id_driver;

ALTER SEQUENCE public.id_driver
    OWNER TO cargodbuser;

-- SEQUENCE: public.id_order

-- DROP SEQUENCE IF EXISTS public.id_order;

CREATE SEQUENCE IF NOT EXISTS public.id_order
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1
    OWNED BY ordercargo.id_order;

ALTER SEQUENCE public.id_order
    OWNER TO cargodbuser;

-- Table: public.vehiclestatus

-- DROP TABLE IF EXISTS public.vehiclestatus;

CREATE TABLE IF NOT EXISTS public.vehiclestatus
(
    namevehiclestatus character varying(45) COLLATE pg_catalog."default" NOT NULL,
    descriptionvehiclestatus character varying(255) COLLATE pg_catalog."default",
    CONSTRAINT vehiclestatus_pkey PRIMARY KEY (namevehiclestatus)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.vehiclestatus
    OWNER to cargodbuser;

-- Table: public.tenttype

-- DROP TABLE IF EXISTS public.tenttype;

CREATE TABLE IF NOT EXISTS public.tenttype
(
    nametenttype character varying(45) COLLATE pg_catalog."default" NOT NULL,
    descriptiontenttype character varying(255) COLLATE pg_catalog."default",
    CONSTRAINT tenttype_pkey PRIMARY KEY (nametenttype)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.tenttype
    OWNER to cargodbuser;

-- Table: public.vehicle

-- DROP TABLE IF EXISTS public.vehicle;

CREATE TABLE IF NOT EXISTS public.vehicle
(
    vehiclenumber character(9) COLLATE pg_catalog."default" NOT NULL,
    vehiclename character varying(45) COLLATE pg_catalog."default" NOT NULL,
    vehiclestatus_namevehiclestatus character varying(45) COLLATE pg_catalog."default" NOT NULL,
    fueltype_namefuel character varying(45) COLLATE pg_catalog."default" NOT NULL,
    tenttype_nametenttype character varying(45) COLLATE pg_catalog."default" NOT NULL,
    fuelconsumptionper100km real NOT NULL,
    tentvalue real NOT NULL,
    loadcapacity real NOT NULL,
    multipliervehicle real NOT NULL DEFAULT 1,
    CONSTRAINT vehicle_pkey PRIMARY KEY (vehiclenumber),
    CONSTRAINT fk_vehicle_fueltype1 FOREIGN KEY (fueltype_namefuel)
        REFERENCES public.fueltype (namefuel) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_vehicle_tenttype FOREIGN KEY (tenttype_nametenttype)
        REFERENCES public.tenttype (nametenttype) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_vehicle_vehiclestatus FOREIGN KEY (vehiclestatus_namevehiclestatus)
        REFERENCES public.vehiclestatus (namevehiclestatus) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.vehicle
    OWNER to cargodbuser;

-- Table: public.paymentmethod

-- DROP TABLE IF EXISTS public.paymentmethod;

CREATE TABLE IF NOT EXISTS public.paymentmethod
(
    namepaymentmethod character varying(45) COLLATE pg_catalog."default" NOT NULL,
    flagactive boolean NOT NULL DEFAULT false,
    descriptionpaymentmethod character varying(255) COLLATE pg_catalog."default",
    CONSTRAINT paymentmethod_pkey PRIMARY KEY (namepaymentmethod)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.paymentmethod
    OWNER to cargodbuser;

-- Table: public.fueltype

-- DROP TABLE IF EXISTS public.fueltype;

CREATE TABLE IF NOT EXISTS public.fueltype
(
    namefuel character varying(45) COLLATE pg_catalog."default" NOT NULL,
    priceoneliter real NOT NULL,
    CONSTRAINT fueltype_pkey PRIMARY KEY (namefuel)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.fueltype
    OWNER to cargodbuser;

-- Table: public.driverstatus

-- DROP TABLE IF EXISTS public.driverstatus;

CREATE TABLE IF NOT EXISTS public.driverstatus
(
    namedriverstatus character varying(45) COLLATE pg_catalog."default" NOT NULL,
    descriptiondriverstatus character varying(255) COLLATE pg_catalog."default",
    CONSTRAINT driverstatus_pkey PRIMARY KEY (namedriverstatus)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.driverstatus
    OWNER to cargodbuser;


-- Table: public.driver

-- DROP TABLE IF EXISTS public.driver;

CREATE TABLE IF NOT EXISTS public.driver
(
    id_driver smallint NOT NULL DEFAULT nextval('id_driver'::regclass),
    firstnamedriver character varying(45) COLLATE pg_catalog."default" NOT NULL,
    lastnamdriver character varying(45) COLLATE pg_catalog."default" NOT NULL,
    patronymicdriver character varying(45) COLLATE pg_catalog."default",
    phonenumberdriver character varying(16) COLLATE pg_catalog."default" NOT NULL,
    driverstatus_namedriverstatus character varying(45) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT driver_pkey PRIMARY KEY (id_driver),
    CONSTRAINT fk_driver_driverstatus1 FOREIGN KEY (driverstatus_namedriverstatus)
        REFERENCES public.driverstatus (namedriverstatus) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.driver
    OWNER to cargodbuser;


-- Table: public.constmultiplier

-- DROP TABLE IF EXISTS public.constmultiplier;

CREATE TABLE IF NOT EXISTS public.constmultiplier
(
    nameconstmultiplier character varying(45) COLLATE pg_catalog."default" NOT NULL,
    valueconstmultiplier real NOT NULL DEFAULT 1,
    descriptionconstmultiplier character varying(255) COLLATE pg_catalog."default",
    CONSTRAINT constmultiplier_pkey PRIMARY KEY (nameconstmultiplier)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.constmultiplier
    OWNER to cargodbuser;


-- Table: public.cargotype

-- DROP TABLE IF EXISTS public.cargotype;

CREATE TABLE IF NOT EXISTS public.cargotype
(
    namecargotype character varying(45) COLLATE pg_catalog."default" NOT NULL,
    multipliercargotype real NOT NULL DEFAULT 1,
    descriptioncargotype character varying(255) COLLATE pg_catalog."default",
    CONSTRAINT cargotype_pkey PRIMARY KEY (namecargotype)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.cargotype
    OWNER to cargodbuser;

-- Table: public.addresstype

-- DROP TABLE IF EXISTS public.addresstype;

CREATE TABLE IF NOT EXISTS public.addresstype
(
    nameaddresstype character varying(45) COLLATE pg_catalog."default" NOT NULL,
    descriptionaddresstype character varying(255) COLLATE pg_catalog."default",
    multiplieraddresstype real NOT NULL DEFAULT 1,
    CONSTRAINT addresstype_pkey PRIMARY KEY (nameaddresstype)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.addresstype
    OWNER to cargodbuser;

-- Table: public.address

-- DROP TABLE IF EXISTS public.address;

CREATE TABLE IF NOT EXISTS public.address
(
    id_address bigint NOT NULL DEFAULT nextval('id_address'::regclass),
    fulladdress character varying(255) COLLATE pg_catalog."default" NOT NULL,
    addresstype_nameaddresstype character varying(45) COLLATE pg_catalog."default" NOT NULL,
    flooraddress smallint DEFAULT 1,
    descriptionaddress character varying(45) COLLATE pg_catalog."default",
    CONSTRAINT address_pkey PRIMARY KEY (id_address),
    CONSTRAINT fk_address_addresstype1 FOREIGN KEY (addresstype_nameaddresstype)
        REFERENCES public.addresstype (nameaddresstype) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.address
    OWNER to cargodbuser;

-- Table: public.ordercargo

-- DROP TABLE IF EXISTS public.ordercargo;

CREATE TABLE IF NOT EXISTS public.ordercargo
(
    id_order bigint NOT NULL DEFAULT nextval('id_order'::regclass),
    customer_id_customer integer NOT NULL,
    address_id_addressdeparture bigint NOT NULL,
    address_id_addressdelivery bigint NOT NULL,
    driver_id_driver smallint NOT NULL,
    vehicle_vehiclenumber character(9) COLLATE pg_catalog."default" NOT NULL,
    orderstatus_nameorderstatus character varying(45) COLLATE pg_catalog."default" NOT NULL,
    paymentmethod_namepaymentmethod character varying(45) COLLATE pg_catalog."default" NOT NULL,
    cargotype_namecargotype character varying(45) COLLATE pg_catalog."default" NOT NULL,
    cargoweightorder real NOT NULL DEFAULT 0,
    activeloaderflag boolean NOT NULL DEFAULT false,
    datecreateorder timestamp(1) without time zone NOT NULL,
    datecloseorder timestamp(1) without time zone,
    CONSTRAINT ordercargo_pkey PRIMARY KEY (id_order),
    CONSTRAINT fk_order_address1 FOREIGN KEY (address_id_addressdeparture)
        REFERENCES public.address (id_address) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_order_address2 FOREIGN KEY (address_id_addressdelivery)
        REFERENCES public.address (id_address) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_order_cargotype1 FOREIGN KEY (cargotype_namecargotype)
        REFERENCES public.cargotype (namecargotype) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_order_customer1 FOREIGN KEY (customer_id_customer)
        REFERENCES public.customer (id_customer) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_order_driver1 FOREIGN KEY (driver_id_driver)
        REFERENCES public.driver (id_driver) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_order_orderstatus1 FOREIGN KEY (orderstatus_nameorderstatus)
        REFERENCES public.orderstatus (nameorderstatus) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_order_paymentmethod1 FOREIGN KEY (paymentmethod_namepaymentmethod)
        REFERENCES public.paymentmethod (namepaymentmethod) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_order_vehicle1 FOREIGN KEY (vehicle_vehiclenumber)
        REFERENCES public.vehicle (vehiclenumber) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.ordercargo
    OWNER to cargodbuser;

-- Table: public.orderstatus

-- DROP TABLE IF EXISTS public.orderstatus;

CREATE TABLE IF NOT EXISTS public.orderstatus
(
    nameorderstatus character varying(45) COLLATE pg_catalog."default" NOT NULL,
    descriptionorderstatus character varying(255) COLLATE pg_catalog."default",
    CONSTRAINT orderstatus_pkey PRIMARY KEY (nameorderstatus)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.orderstatus
    OWNER to cargodbuser;

-- Table: public.customer

-- DROP TABLE IF EXISTS public.customer;

CREATE TABLE IF NOT EXISTS public.customer
(
    id_customer integer NOT NULL DEFAULT nextval('id_customer'::regclass),
    firstnamecustomer character varying(45) COLLATE pg_catalog."default" NOT NULL,
    lastnamecustomer character varying(45) COLLATE pg_catalog."default" NOT NULL,
    patronymiccustomer character varying(45) COLLATE pg_catalog."default",
    phonenumbercustomer character varying(16) COLLATE pg_catalog."default" NOT NULL,
    mailcustomer character varying(45) COLLATE pg_catalog."default",
    additionalnumbercustomer character varying(45) COLLATE pg_catalog."default",
    CONSTRAINT customer_pkey PRIMARY KEY (id_customer)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.customer
    OWNER to cargodbuser;




