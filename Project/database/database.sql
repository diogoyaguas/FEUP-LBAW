-----------------------------------------
-- Drop old schmema
-----------------------------------------
DROP TABLE IF EXISTS product_categories CASCADE;
DROP TABLE IF EXISTS product_brand CASCADE;
DROP TABLE IF EXISTS product_size CASCADE;
DROP TABLE IF EXISTS product_color CASCADE;
DROP TABLE IF EXISTS administrator CASCADE;
DROP TABLE IF EXISTS store_manager CASCADE;
DROP TABLE IF EXISTS standard CASCADE;
DROP TABLE IF EXISTS deleted CASCADE;
DROP TABLE IF EXISTS premium CASCADE;
DROP TABLE IF EXISTS "analyze" CASCADE;
DROP TABLE IF EXISTS reportear CASCADE;
DROP TABLE IF EXISTS report CASCADE;
DROP TABLE IF EXISTS favorites CASCADE;
DROP TABLE IF EXISTS brand CASCADE;
DROP TABLE IF EXISTS size CASCADE;
DROP TABLE IF EXISTS color CASCADE;
DROP TABLE IF EXISTS address CASCADE;
DROP TABLE IF EXISTS city CASCADE;
DROP TABLE IF EXISTS country CASCADE;
DROP TABLE IF EXISTS line_item_cart CASCADE;
DROP TABLE IF EXISTS line_item_order CASCADE;
DROP TABLE IF EXISTS line_item CASCADE;
DROP TABLE IF EXISTS "order" CASCADE;
DROP TABLE IF EXISTS review CASCADE;
DROP TABLE IF EXISTS categories CASCADE;
DROP TABLE IF EXISTS product CASCADE;
DROP TABLE IF EXISTS "user" CASCADE;
DROP TABLE IF EXISTS cart CASCADE;
DROP TRIGGER IF EXISTS product_score ON review;
DROP TRIGGER IF EXISTS set_users ON "user";
DROP TRIGGER IF EXISTS update_total_line ON line_item;
DROP TRIGGER IF EXISTS update_stock ON line_item_order;
DROP TRIGGER IF EXISTS deleteProd ON product;




-----------------------------------------
-- Tables
-----------------------------------------

CREATE TABLE cart
(
  id SERIAL PRIMARY KEY,
  date DATE DEFAULT current_date

);

CREATE TABLE "user"
(
  id SERIAL PRIMARY KEY,
  name text NOT NULL,
  username text NOT NULL CONSTRAINT username_uk UNIQUE,
  email text NOT NULL CONSTRAINT email_user_uk UNIQUE,
  password text NOT NULL,
  id_cart INTEGER NOT NULL REFERENCES "cart" (id) ON UPDATE CASCADE,
  is_admin BOOLEAN NOT NULL,
  is_manager BOOLEAN NOT NULL,
  is_premium BOOLEAN NOT NULL,
  deleted BOOLEAN NOT NULL

);

CREATE TABLE product
(
  id SERIAL PRIMARY KEY,
  name text NOT NULL CONSTRAINT name_uk UNIQUE,
  price FLOAT NOT NULL CONSTRAINT price_ck CHECK (price > 0),
  description text,
  deleted BOOLEAN DEFAULT TRUE,
  stock INTEGER NOT NULL CONSTRAINT stock_ck CHECK (stock >= 0),
  score INTEGER NOT NULL CONSTRAINT score_ck DEFAULT 0 CHECK ((score >= 0) OR (score <=5))

);

CREATE TABLE categories
(
  id SERIAL PRIMARY KEY,
  name text NOT NULL CONSTRAINT categories_name_uk UNIQUE,
  season text NOT NULL

);

CREATE TABLE review
(
  id SERIAL PRIMARY KEY,
  id_user INTEGER NOT NULL REFERENCES "user" (id) ON UPDATE CASCADE,
  id_product INTEGER NOT NULL REFERENCES "product" (id) ON UPDATE CASCADE,
  title text NOT NULL,
  description text,
  score INTEGER NOT NULL CONSTRAINT score_ck CHECK ((score >= 0) OR (score <=5))

);

CREATE TABLE "order"
(
  id SERIAL PRIMARY KEY,
  id_user INTEGER NOT NULL REFERENCES "user" (id) ON UPDATE CASCADE,
  date DATE DEFAULT current_date,
  total FLOAT NOT NULL CONSTRAINT total_ck CHECK (total >= 0),
  state text NOT NULL CONSTRAINT state_ck CHECK (state IN ('Processing', 'Delivered', 'Shipped'))
);

CREATE TABLE line_item
(
  id SERIAL PRIMARY KEY,
  id_product INTEGER NOT NULL REFERENCES "product" (id) ON UPDATE CASCADE,
  quantity INTEGER NOT NULL CONSTRAINT quantity_ck CHECK (quantity > 0),
  price FLOAT NOT NULL CONSTRAINT price_ck CHECK (price > 0)
);

CREATE TABLE line_item_order
(
  id_line_item INTEGER NOT NULL REFERENCES "line_item" (id) ON UPDATE CASCADE,
  id_order INTEGER NOT NULL REFERENCES "order" (id) ON UPDATE CASCADE,
  PRIMARY KEY (id_line_item)

);

CREATE TABLE line_item_cart
(
  id_line_item INTEGER NOT NULL REFERENCES "line_item" (id) ON UPDATE CASCADE,
  id_cart INTEGER NOT NULL REFERENCES "cart" (id) ON UPDATE CASCADE,
  PRIMARY KEY (id_line_item)

);

CREATE TABLE country
(
  id SERIAL PRIMARY KEY,
  name text NOT NULL
);

CREATE TABLE city
(
  id SERIAL PRIMARY KEY,
  id_country INTEGER NOT NULL REFERENCES "country" (id) ON UPDATE CASCADE,
  name text NOT NULL
);

CREATE TABLE address
(
  id SERIAL PRIMARY KEY,
  id_user INTEGER NOT NULL REFERENCES "user" (id) ON UPDATE CASCADE,
  id_city INTEGER NOT NULL REFERENCES "city" (id) ON UPDATE CASCADE,
  street text NOT NULL,
  zipCode text NOT NULL
);

CREATE TABLE color
(
  id SERIAL PRIMARY KEY,
  name text NOT NULL
);

CREATE TABLE size
(
  id SERIAL PRIMARY KEY,
  name text NOT NULL
);

CREATE TABLE brand
(
  id SERIAL PRIMARY KEY,
  name text NOT NULL
);

CREATE TABLE favorites
(
  id_user INTEGER NOT NULL REFERENCES "user" (id) ON UPDATE CASCADE,
  id_product INTEGER NOT NULL REFERENCES "product" (id) ON UPDATE CASCADE,
  PRIMARY KEY (id_user, id_product)
);

CREATE TABLE report
(
  id_review INTEGER NOT NULL REFERENCES "review" (id) ON UPDATE CASCADE,
  id_user_reportee INTEGER NOT NULL REFERENCES "user" (id) ON UPDATE CASCADE,
  PRIMARY KEY (id_review, id_user_reportee)
);

CREATE TABLE reportear
(
  id_review INTEGER NOT NULL REFERENCES "review" (id) ON UPDATE CASCADE,
  id_user_reportear INTEGER NOT NULL REFERENCES "user" (id) ON UPDATE CASCADE,
  PRIMARY KEY (id_review, id_user_reportear)
);

CREATE TABLE "analyze"
(
  id_review INTEGER NOT NULL REFERENCES "review" (id) ON UPDATE CASCADE,
  id_user_analyze INTEGER NOT NULL REFERENCES "user" (id) ON UPDATE CASCADE,
  PRIMARY KEY (id_review, id_user_analyze)
);

CREATE TABLE premium
(
  id_user INTEGER NOT NULL REFERENCES "user" (id) ON UPDATE CASCADE,
  discounts FLOAT NOT NULL CONSTRAINT discounts_ck CHECK (discounts > 0),
  PRIMARY KEY (id_user)
);

CREATE TABLE deleted
(
  id_user INTEGER NOT NULL REFERENCES "user" (id) ON UPDATE CASCADE,
  date DATE DEFAULT current_date,
  PRIMARY KEY (id_user)
);

CREATE TABLE standard
(
  id_user INTEGER NOT NULL REFERENCES "user" (id) ON UPDATE CASCADE,
  PRIMARY KEY (id_user)
);

CREATE TABLE store_manager
(
  id_user INTEGER NOT NULL REFERENCES "user" (id) ON UPDATE CASCADE,
  PRIMARY KEY (id_user)
);

CREATE TABLE administrator
(
  id_user INTEGER NOT NULL REFERENCES "user" (id) ON UPDATE CASCADE,
  PRIMARY KEY (id_user)
);

CREATE TABLE product_color
(
  id_product INTEGER NOT NULL REFERENCES "product" (id) ON UPDATE CASCADE,
  id_color INTEGER NOT NULL REFERENCES "color" (id) ON UPDATE CASCADE,
  PRIMARY KEY (id_product, id_color)
);

CREATE TABLE product_size
(
  id_product INTEGER NOT NULL REFERENCES "product" (id) ON UPDATE CASCADE,
  id_size INTEGER NOT NULL REFERENCES "size" (id) ON UPDATE CASCADE,
  PRIMARY KEY (id_product, id_size)
);

CREATE TABLE product_brand
(
  id_product INTEGER NOT NULL REFERENCES "product" (id) ON UPDATE CASCADE,
  id_brand INTEGER NOT NULL REFERENCES "brand" (id) ON UPDATE CASCADE,
  PRIMARY KEY (id_product, id_brand)
);

CREATE TABLE product_categories
(
  id_product INTEGER NOT NULL REFERENCES "product" (id) ON UPDATE CASCADE,
  id_categories INTEGER NOT NULL REFERENCES "categories" (id) ON UPDATE CASCADE,
  PRIMARY KEY (id_product, id_categories)
);
 
-----------------------------------------
-- INDEXES
-----------------------------------------

CREATE INDEX username_user ON "user" USING hash (username);

CREATE INDEX address_id_user ON address USING hash (id_user);

CREATE INDEX favorites_id_user ON favorites USING hash (id_user);

CREATE INDEX order_id_user ON "order" USING hash (id_user);

CREATE INDEX review_id_product ON review USING hash (id_product);

CREATE INDEX product_price ON "order" USING btree (total);

CREATE INDEX product_category_id ON product_categories USING hash (id_product);

CREATE INDEX product_search ON product USING GIST (to_tsvector('english', name));

-----------------------------------------
-- TRIGGERS and UDFs
-----------------------------------------

CREATE OR REPLACE FUNCTION update_product_score() RETURNS TRIGGER AS
$BODY$
BEGIN
	UPDATE product
	SET score = (SELECT avg(review.score) FROM review WHERE id_product = New.id_product)
	WHERE id = New.id_product;

  RETURN NULL;
END
$BODY$
LANGUAGE plpgsql;

CREATE TRIGGER product_score AFTER INSERT OR UPDATE
ON review
FOR EACH ROW  
EXECUTE PROCEDURE update_product_score();

-- insert users

CREATE OR REPLACE FUNCTION insert_standard_users() RETURNS TRIGGER AS 
$BODY$
BEGIN 
    CASE
    WHEN NEW.is_admin THEN
     INSERT INTO administrator(id_user) VALUES(NEW.id);
    WHEN NEW.is_premium THEN 
     INSERT INTO premium(id_user, discounts) VALUES(NEW.id, 20);
    WHEN NEW.is_manager THEN
     INSERT INTO store_manager(id_user) VALUES(NEW.id);
    ELSE INSERT INTO standard(id_user) VALUES(NEW.id);
    END CASE;

RETURN NULL;

END
$BODY$
LANGUAGE plpgsql;

CREATE TRIGGER set_users AFTER INSERT ON "user" 
FOR EACH ROW  
EXECUTE PROCEDURE insert_standard_users();



-- update de price in a line 
CREATE OR REPLACE  FUNCTION update_total() RETURNS TRIGGER AS
$BODY$
BEGIN
    UPDATE line_item
    SET price  = (SELECT price FROM product WHERE id = id_product) * quantity
    where id = new.id;

RETURN NULL;
END
$BODY$
LANGUAGE plpgsql;

CREATE TRIGGER update_total_line AFTER INSERT ON line_item 
FOR EACH ROW
EXECUTE PROCEDURE update_total();


-- update quantity of stock

CREATE OR REPLACE FUNCTION setStock() RETURNS TRIGGER AS
$BODY$
BEGIN 
IF NOT EXISTS (SELECT * FROM product, line_item WHERE product.id = line_item.id_product AND new.id_line_item = line_item.id AND stock >= line_item.quantity) THEN 
    RAISE EXCEPTION 'YOU CAN NOT BUY That number of ITEMS';
ELSE
    UPDATE product SET stock = stock - line_item.quantity FROM line_item WHERE product.id = line_item.id_product and  new.id_line_item = line_item.id;
END IF;

RETURN NULL;
END
$BODY$
LANGUAGE plpgsql;



CREATE TRIGGER update_stock BEFORE INSERT ON line_item_order 
FOR EACH ROW 
EXECUTE PROCEDURE setStock();

-- delete all products

CREATE OR REPLACE FUNCTION removeProducts() RETURNS TRIGGER AS
$BODY$
BEGIN
IF new.deleted = TRUE THEN 
    DELETE FROM favorites WHERE favorites.id_product = NEW.id;
    DELETE FROM product_categories where product_categories.id_product = NEW.id;

    IF EXISTS (SELECT id_line_item, id, id_product from line_item_cart, line_item where id = id_line_item and id_product = new.id) THEN 
        DELETE FROM line_item_cart USING line_item where line_item.id = line_item_cart.id_line_item and new.id = line_item.id_product; 
        DELETE from line_item where new.id = line_item.id_product;
    END IF;

END IF;

RETURN NULL;
END

$BODY$
LANGUAGE plpgsql;


CREATE TRIGGER deleteProd AFTER UPDATE ON product 
FOR EACH ROW
EXECUTE PROCEDURE removeProducts();





