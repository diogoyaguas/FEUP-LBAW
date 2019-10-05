-----------------------------------------
-- Drop old schmema
-----------------------------------------

DROP TABLE IF EXISTS password_resets CASCADE;

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

DROP TABLE IF EXISTS users CASCADE;

DROP TABLE IF EXISTS "user" CASCADE;

DROP TABLE IF EXISTS cart CASCADE;

DROP TRIGGER IF EXISTS product_score ON review;

DROP TRIGGER IF EXISTS set_users ON users;

DROP TRIGGER IF EXISTS update_total_line ON line_item;

DROP TRIGGER IF EXISTS update_stock ON line_item_order;

DROP TRIGGER IF EXISTS deleteProd ON product;

-----------------------------------------
-- Tables
-----------------------------------------

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name text NOT NULL,
  username text NOT NULL CONSTRAINT username_uk UNIQUE,
  email text NOT NULL CONSTRAINT email_user_uk UNIQUE,
  PASSWORD text NOT NULL,
  type_user text NOT NULL CONSTRAINT type_user_ck CHECK (type_user IN ('premium',
      'admin',
      'store_manager',
      'user')),
  deleted BOOLEAN DEFAULT FALSE,
  remember_token TEXT
);

CREATE TABLE cart (
  id SERIAL PRIMARY KEY,
  id_user INTEGER REFERENCES "users" (id) ON DELETE CASCADE CONSTRAINT user_id_cart_uk UNIQUE,
  date DATE DEFAULT CURRENT_DATE
);

CREATE TABLE product (
  id SERIAL PRIMARY KEY,
  name text NOT NULL CONSTRAINT name_uk UNIQUE,
  price FLOAT NOT NULL CONSTRAINT price_ck CHECK (price > 0),
  description text,
  deleted BOOLEAN DEFAULT FALSE,
  stock INTEGER NOT NULL CONSTRAINT stock_ck CHECK (stock >= 0),
  score INTEGER NOT NULL CONSTRAINT score_ck DEFAULT 0 CHECK ((score >= 0)
    OR (score <= 5))
);

CREATE TABLE categories (
  id SERIAL PRIMARY KEY,
  name text NOT NULL,
  sex CHAR(1) DEFAULT '?' CONSTRAINT sex_ck CHECK (sex IN ('?',
      'w',
      'm')),
  season text NOT NULL,
  dad text NOT NULL
);

CREATE TABLE review (
  id SERIAL PRIMARY KEY,
  id_user INTEGER NOT NULL REFERENCES users (id) ON DELETE CASCADE,
  id_product INTEGER NOT NULL REFERENCES "product" (id) ON UPDATE CASCADE,
  title text NOT NULL,
  description text,
  score INTEGER NOT NULL CONSTRAINT score_ck CHECK ((score >= 0)
    OR (score <= 5))
);

CREATE TABLE country (
  id SERIAL PRIMARY KEY,
  name text NOT NULL
);

CREATE TABLE city (
  id SERIAL PRIMARY KEY,
  id_country INTEGER NOT NULL REFERENCES "country" (id) ON UPDATE CASCADE,
  name text NOT NULL
);

CREATE TABLE address (
  id SERIAL PRIMARY KEY,
  door_number INTEGER NOT NULL,
  id_user INTEGER NOT NULL REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE,
  id_city INTEGER NOT NULL REFERENCES "city" (id) ON UPDATE CASCADE,
  street text NOT NULL,
  zipCode text NOT NULL,
  type_address text NOT NULL CONSTRAINT type_ck CHECK (type_address IN ('home',
      'other',
      'work'))
);

CREATE TABLE "order" (
  id SERIAL PRIMARY KEY,
  id_user INTEGER NOT NULL REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE,
  id_address_invoce INTEGER NOT NULL REFERENCES "address" (id) ON UPDATE CASCADE,
  id_address_shipping INTEGER REFERENCES "address" (id) ON UPDATE CASCADE,
  date DATE DEFAULT CURRENT_DATE,
  total FLOAT NOT NULL CONSTRAINT total_ck CHECK (total >= 0),
  state text NOT NULL CONSTRAINT state_ck CHECK (state IN ('Processing',
      'Delivered',
      'Shipped'))
);

CREATE TABLE line_item (
  id SERIAL PRIMARY KEY,
  id_product INTEGER NOT NULL REFERENCES "product" (id) ON UPDATE CASCADE,
  quantity INTEGER NOT NULL CONSTRAINT quantity_ck CHECK (quantity > 0),
  price FLOAT NOT NULL CONSTRAINT price_ck CHECK (price > 0)
);

CREATE TABLE line_item_order (
  id_line_item INTEGER NOT NULL REFERENCES "line_item" (id) ON UPDATE CASCADE ON DELETE CASCADE,
  id_order INTEGER NOT NULL REFERENCES "order" (id) ON UPDATE CASCADE ON DELETE CASCADE,
  PRIMARY KEY (id_line_item)
);

CREATE TABLE line_item_cart (
  id_line_item INTEGER NOT NULL REFERENCES "line_item" (id) ON UPDATE CASCADE ON DELETE CASCADE,
  id_cart INTEGER NOT NULL REFERENCES "cart" (id) ON UPDATE CASCADE ON DELETE CASCADE,
  PRIMARY KEY (id_line_item)
);

CREATE TABLE color (
  id SERIAL PRIMARY KEY,
  name text NOT NULL
);

CREATE TABLE size (
  id SERIAL PRIMARY KEY,
  name text NOT NULL
);

CREATE TABLE brand (
  id SERIAL PRIMARY KEY,
  name text NOT NULL
);

CREATE TABLE favorites (
  id_user INTEGER NOT NULL REFERENCES users (id) ON DELETE CASCADE,
  id_product INTEGER NOT NULL REFERENCES "product" (id) ON UPDATE CASCADE,
  PRIMARY KEY (id_user, id_product)
);

CREATE TABLE report (
  id_review INTEGER NOT NULL REFERENCES "review" (id) ON DELETE CASCADE,
  id_user_reportee INTEGER NOT NULL REFERENCES users (id) ON DELETE CASCADE,
  PRIMARY KEY (id_review, id_user_reportee)
);

CREATE TABLE reportear (
  id_review INTEGER NOT NULL REFERENCES "review" (id) ON DELETE CASCADE,
  id_user_reportear INTEGER NOT NULL REFERENCES users (id) ON DELETE CASCADE,
  PRIMARY KEY (id_review, id_user_reportear)
);

CREATE TABLE "analyze" (
  id_review INTEGER NOT NULL REFERENCES "review" (id) ON DELETE CASCADE,
  id_user_analyze INTEGER NOT NULL REFERENCES users (id) ON DELETE CASCADE,
  PRIMARY KEY (id_review, id_user_analyze)
);

CREATE TABLE premium (
  id_user INTEGER NOT NULL REFERENCES users (id) ON DELETE CASCADE,
  discounts FLOAT NOT NULL CONSTRAINT discounts_ck CHECK (discounts > 0),
  PRIMARY KEY (id_user)
);

CREATE TABLE deleted (
  id_user INTEGER NOT NULL REFERENCES users (id) ON DELETE CASCADE,
  date DATE DEFAULT CURRENT_DATE,
  PRIMARY KEY (id_user)
);

CREATE TABLE product_color (
  id_product INTEGER NOT NULL REFERENCES "product" (id) ON UPDATE CASCADE,
  id_color INTEGER NOT NULL REFERENCES "color" (id) ON UPDATE CASCADE,
  PRIMARY KEY (id_product, id_color)
);

CREATE TABLE product_size (
  id_product INTEGER NOT NULL REFERENCES "product" (id) ON UPDATE CASCADE,
  id_size INTEGER NOT NULL REFERENCES "size" (id) ON UPDATE CASCADE,
  PRIMARY KEY (id_product, id_size)
);

CREATE TABLE product_brand (
  id_product INTEGER NOT NULL REFERENCES "product" (id) ON UPDATE CASCADE,
  id_brand INTEGER NOT NULL REFERENCES "brand" (id) ON UPDATE CASCADE,
  PRIMARY KEY (id_product, id_brand)
);

CREATE TABLE product_categories (
  id_product INTEGER NOT NULL REFERENCES "product" (id) ON UPDATE CASCADE,
  id_categories INTEGER NOT NULL REFERENCES "categories" (id) ON UPDATE CASCADE,
  PRIMARY KEY (id_product, id_categories)
);

CREATE TABLE password_resets (
  email TEXT PRIMARY KEY,
  token TEXT,
  created_at TIMESTAMP WITH TIME zone
);

-----------------------------------------
-- INDEXES
-----------------------------------------

CREATE INDEX username_user ON users
USING HASH (username);

CREATE INDEX address_id_user ON address
USING HASH (id_user);

CREATE INDEX favorites_id_user ON favorites
USING HASH (id_user);

CREATE INDEX order_id_user ON "order"
USING HASH (id_user);

CREATE INDEX review_id_product ON review
USING HASH (id_product);

CREATE INDEX product_price ON "order"
USING btree (total);

CREATE INDEX product_category_id ON product_categories
USING HASH (id_product);

CREATE INDEX product_search ON product
USING GIST (to_tsvector('english', name));

-----------------------------------------
-- TRIGGERS and UDFs
-----------------------------------------

CREATE OR REPLACE FUNCTION update_product_score ()
  RETURNS TRIGGER
  AS $BODY$
BEGIN
  UPDATE
    product
  SET
    score = (
      SELECT
        avg(review.score)
      FROM
        review
      WHERE
        id_product = New.id_product)
    WHERE
      id = New.id_product;
  RETURN NULL;
END
$BODY$
LANGUAGE plpgsql;

CREATE TRIGGER product_score
  AFTER INSERT
  OR UPDATE ON review
  FOR EACH ROW
  EXECUTE PROCEDURE update_product_score ();

-- insert users

CREATE OR REPLACE FUNCTION insert_standard_users ()
  RETURNS TRIGGER
  AS $BODY$
BEGIN
  INSERT INTO cart (id_user)
    VALUES (NEW.id);
  RETURN NEW;
END
$BODY$
LANGUAGE plpgsql;

CREATE TRIGGER set_users
  AFTER INSERT ON users
  FOR EACH ROW
  EXECUTE PROCEDURE insert_standard_users ();

-- update de price in a line

CREATE OR REPLACE FUNCTION update_total ()
  RETURNS TRIGGER
  AS $BODY$
BEGIN
  UPDATE
    line_item
  SET
    price = (
      SELECT
        price
      FROM
        product
      WHERE
        id = id_product) * quantity
    WHERE
      id = new.id;
RETURN NULL;
END
$BODY$
LANGUAGE plpgsql;

CREATE TRIGGER update_total_line
  AFTER INSERT ON line_item
  FOR EACH ROW
  EXECUTE PROCEDURE update_total ();

-- update quantity of stock

CREATE OR REPLACE FUNCTION setStock ()
  RETURNS TRIGGER
  AS $BODY$
BEGIN
  IF NOT EXISTS (
      SELECT
        *
      FROM
        product,
        line_item
      WHERE
        product.id = line_item.id_product AND new.id_line_item = line_item.id AND stock >= line_item.quantity) THEN
      RAISE
    EXCEPTION 'YOU CAN NOT BUY That number of ITEMS';
  ELSE
    UPDATE
      product
    SET
      stock = stock - line_item.quantity
    FROM
      line_item
    WHERE
      product.id = line_item.id_product
      AND new.id_line_item = line_item.id;
  END IF;
RETURN NEW;
END
$BODY$
LANGUAGE plpgsql;

CREATE TRIGGER update_stock
  BEFORE INSERT ON line_item_order
  FOR EACH ROW
  EXECUTE PROCEDURE setStock ();

-- delete all products

CREATE OR REPLACE FUNCTION removeProducts ()
  RETURNS TRIGGER
  AS $BODY$
BEGIN
  IF new.deleted = TRUE THEN
    DELETE FROM favorites
    WHERE favorites.id_product = NEW.id;
    DELETE FROM product_categories
    WHERE product_categories.id_product = NEW.id;
    IF EXISTS (
      SELECT
        id_line_item,
        id,
        id_product
      FROM
        line_item_cart,
        line_item
      WHERE
        id = id_line_item
        AND id_product = new.id) THEN
      DELETE FROM line_item_cart USING line_item
      WHERE line_item.id = line_item_cart.id_line_item
        AND new.id = line_item.id_product;
    DELETE FROM line_item
    WHERE new.id = line_item.id_product;
  END IF;
END IF;
      RETURN NULL;
END
$BODY$
LANGUAGE plpgsql;

CREATE TRIGGER deleteProd
  AFTER UPDATE ON product
  FOR EACH ROW
  EXECUTE PROCEDURE removeProducts ();

-----------------------------------------
-- users
-----------------------------------------

INSERT INTO users (id, name, username, email, PASSWORD, type_user, deleted)
    VALUES (1, 'user', 'user', 'ghalhead0@mlb.com', '$2y$12$xqJe1BDygV3tiCKv3kCTyO92Oyd3jnL8RGcmze0xb2XnRL13KmEpu', 'user', FALSE);
INSERT INTO users (id, name, username, email, PASSWORD, type_user, deleted)
    VALUES (2, 'Kristal', 'ksarver1', 'kblackmoor1@google.com.br', '$2y$12$H/SY6zoFHDr3RWQS3Gqtde97POYTOCZT/JI6YpeknU.7UtKkF6Nd.', 'user', TRUE);
INSERT INTO users (id, name, username, email, PASSWORD, type_user, deleted)
    VALUES (3, 'Cathrine', 'cmcroberts2', 'cswannell2@geocities.jp', '$2y$12$I01WpYQxCiUL8f25QrfTTu7HYVWVFqJFCTt7QCxwWrDmy5dPltD1u', 'user', FALSE);
INSERT INTO users (id, name, username, email, PASSWORD, type_user, deleted)
    VALUES (4, 'Donnell', 'dklossek3', 'dmatusevich3@google.it', '$2y$12$Po/a1Yg2hT9MiX22ebyhauqxbXmtMEOHhD2K7vNrc21JPNYqYpW9a', 'user', FALSE);
INSERT INTO users (id, name, username, email, PASSWORD, type_user, deleted)
    VALUES (5, 'Caro', 'cshepherdson4', 'ctiler4@goo.ne.jp', '$2y$12$M52ft3z9K9vrlM1KFMqFRueKEpmgxHFU1VSx9YerSR1fsBGtsaDHG', 'user', FALSE);
INSERT INTO users (id, name, username, email, PASSWORD, type_user, deleted)
    VALUES (6, 'Art', 'ahearnah5', 'apettus5@microsoft.com', '$2y$12$sdrew.jzz8rQBbqjV34QG.eN8z9mbFebIdHv5j/Drf.LPK.1YL.We', 'user', FALSE);
INSERT INTO users (id, name, username, email, PASSWORD, type_user, deleted)
    VALUES (7, 'Wyn', 'wdonise6', 'wlovel6@nyu.edu', '$2y$12$NhzJx2.7B6lA/LtBzv5ULOsZmy/QN85.M0conkKJcenLx5kEdAcrq', 'store_manager', FALSE);
INSERT INTO users (id, name, username, email, PASSWORD, type_user, deleted)
    VALUES (8, 'Lynnette', 'ljoskowitz7', 'lgull7@wunderground.com', '$2y$12$2SuzgixcA7Ib34ujOMRuvuIQoGZC4C.2ZlPDNBA0J2O4w.VlVNxGG', 'user', FALSE);
INSERT INTO users (id, name, username, email, PASSWORD, type_user, deleted)
    VALUES (9, 'Tristan', 'tmaclennan8', 'tkeunemann8@google.es', '$2y$12$EZzMYHr0fiFtAWcsk9tMZOr/Xp4zMFVFiUrhCOsCNS4D3KVRpfnja', 'user', FALSE);
INSERT INTO users (id, name, username, email, PASSWORD, type_user, deleted)
    VALUES (10, 'Katha', 'kcalf9', 'kpenniell9@rediff.com', '$2y$12$BDtTx8nrdrVJCweewJWGzecqX0aGiex7/nxa.nmvILB9z3EVVt6Nq', 'user', FALSE);
INSERT INTO users (id, name, username, email, PASSWORD, type_user, deleted)
    VALUES (11, 'Shirleen', 'sdaffornea', 'saslina@archive.org', '$2y$10$T/KnD3y7nFckuajDlQit/OG6/TuQENO5y9pnUmEqf5CqlAXYhc5Lu', 'admin', FALSE);
----- jOWX2YyMgEeM

INSERT INTO users (id, name, username, email, PASSWORD, type_user, deleted)
    VALUES (12, 'Muhammad', 'mspelwoodb', 'mcassyb@fastcompany.com', '$2y$12$qfYhHf2vgRrEl1K5Kg2pdehsOmLADFJlTmx3H6EBBfFNqBNR8Ipyi', 'premium', FALSE);
INSERT INTO users (id, name, username, email, PASSWORD, type_user, deleted)
    VALUES (13, 'Jenelle', 'jpiddockec', 'jreichartzc@state.tx.us', 'cKEjYqKNrDmb', 'user', TRUE);
INSERT INTO users (id, name, username, email, PASSWORD, type_user, deleted)
    VALUES (14, 'Cymbre', 'cprinnettd', 'ctumbeltyd@bloglines.com', 'kHuNPMwnhm', 'user', FALSE);
INSERT INTO users (id, name, username, email, PASSWORD, type_user, deleted)
    VALUES (15, 'Kimberly', 'kzumbusche', 'kbraime@google.fr', 'JshbwLnTW', 'user', FALSE);
INSERT INTO users (id, name, username, email, PASSWORD, type_user, deleted)
    VALUES (16, 'Dani', 'kdsse', 'klmaoe@google.fr', 'olafofo', 'user', FALSE);
INSERT INTO users (id, name, username, email, PASSWORD, type_user, deleted)
    VALUES (17, 'Sibel', 'scayfordg', 'spettieg@quantcast.com', 'VpmhcpmngIh', 'user', FALSE);
INSERT INTO users (id, name, username, email, PASSWORD, type_user, deleted)
    VALUES (18, 'Fowler', 'fharnwellh', 'fhundalh@nyu.edu', 'LNIsoIF3BF', 'user', FALSE);
INSERT INTO users (id, name, username, email, PASSWORD, type_user, deleted)
    VALUES (19, 'Abdel', 'abigglestonei', 'agenickei@ifeng.com', 'GWO1UeuXN', 'user', FALSE);
INSERT INTO users (id, name, username, email, PASSWORD, type_user, deleted)
    VALUES (20, 'Hesther', 'hjollimanj', 'hescotj@irs.gov', 't3mIza4nb', 'user', TRUE);
INSERT INTO users (id, name, username, email, PASSWORD, type_user, deleted)
    VALUES (21, 'Emlen', 'eomannionk', 'espiveyk@arizona.edu', 'hanqclRayfU', 'user', FALSE);
INSERT INTO users (id, name, username, email, PASSWORD, type_user, deleted)
    VALUES (22, 'Garner', 'gwarlandl', 'gledsonl@google.com.br', 'HrN2BJouR0uW', 'user', FALSE);
INSERT INTO users (id, name, username, email, PASSWORD, type_user, deleted)
    VALUES (23, 'Torrey', 'tcumpstym', 'tleerm@dion.ne.jp', '8dQOLM9vt97K', 'user', FALSE);
INSERT INTO users (id, name, username, email, PASSWORD, type_user, deleted)
    VALUES (24, 'Patrica', 'pimesonn', 'pbatstonen@jalbum.net', 'PuwGUbe', 'user', FALSE);
INSERT INTO users (id, name, username, email, PASSWORD, type_user, deleted)
    VALUES (25, 'Sena', 'sadamkiewiczo', 'smixhelo@google.co.jp', 'WgKZzAf3', 'user', FALSE);
INSERT INTO users (id, name, username, email, PASSWORD, type_user, deleted)
    VALUES (26, 'Babara', 'bmewburnp', 'bbloggettp@clickbank.net', 'UNjzJkwB', 'user', FALSE);
INSERT INTO users (id, name, username, email, PASSWORD, type_user, deleted)
    VALUES (27, 'Blakeley', 'bbohlsenq', 'bjirusq@tiny.cc', 'm2HLvt', 'user', FALSE);
INSERT INTO users (id, name, username, email, PASSWORD, type_user, deleted)
    VALUES (28, 'Rich', 'rzamorar', 'rbillyardr@xing.com', '4JRLIKlVKRed', 'user', FALSE);
INSERT INTO users (id, name, username, email, PASSWORD, type_user, deleted)
    VALUES (29, 'Rodger', 'storemanager', 'rwakers@weather.com', '$2y$12$3mSjHn//.DfkqScUW/If7.0haSp2yU1dxH4FrcxU2G7m8vDRlsaVG', 'store_manager', FALSE);
------- storemanager

INSERT INTO users (id, name, username, email, PASSWORD, type_user, deleted)
    VALUES (30, 'Madlin', 'medmundsont', 'mbernott@nifty.com', 'lxWLX9dts', 'user', FALSE);
INSERT INTO users (id, name, username, email, PASSWORD, type_user, deleted)
    VALUES (31, 'Hagen', 'hkillichu', 'hmacandreisu@hp.com', '1s2SSyk8Px', 'user', FALSE);
INSERT INTO users (id, name, username, email, PASSWORD, type_user, deleted)
    VALUES (32, 'Emmey', 'eburberowv', 'eneatev@seesaa.net', 'rtszAQ89gAV', 'user', FALSE);
INSERT INTO users (id, name, username, email, PASSWORD, type_user, deleted)
    VALUES (33, 'Rey', 'rgribbinsw', 'rburgessw@youtube.com', 'SXZgky', 'store_manager', FALSE);
INSERT INTO users (id, name, username, email, PASSWORD, type_user, deleted)
    VALUES (34, 'Deny', 'dwykex', 'dhamblenx@rakuten.co.jp', 'QJ50uQOgEo2', 'user', FALSE);
INSERT INTO users (id, name, username, email, PASSWORD, type_user, deleted)
    VALUES (35, 'Alasdair', 'aspaffordy', 'acornelisseny@geocities.jp', 'Eyv58ODl6TKk', 'user', FALSE);
INSERT INTO users (id, name, username, email, PASSWORD, type_user, deleted)
    VALUES (36, 'Rivalee', 'rtimckez', 'rroblinz@weebly.com', 'pseXRzciw', 'user', FALSE);
INSERT INTO users (id, name, username, email, PASSWORD, type_user, deleted)
    VALUES (37, 'Karlie', 'kdenne10', 'khanbridge10@webmd.com', 'kJvt4Sy', 'user', FALSE);
INSERT INTO users (id, name, username, email, PASSWORD, type_user, deleted)
    VALUES (38, 'Katheryn', 'kdymidowicz11', 'kbinns11@mac.com', '4StbRVwWrKyQ', 'user', FALSE);
INSERT INTO users (id, name, username, email, PASSWORD, type_user, deleted)
    VALUES (39, 'Rip', 'rownsworth12', 'rchesman12@disqus.com', 'XBQkENBLa', 'user', TRUE);
INSERT INTO users (id, name, username, email, PASSWORD, type_user, deleted)
    VALUES (40, 'Burtie', 'bgoodbourn13', 'bpagen13@tamu.edu', '2lUp4blZhD', 'user', FALSE);
INSERT INTO users (id, name, username, email, PASSWORD, type_user, deleted)
    VALUES (41, 'Chevy', 'cgetley14', 'cklimt14@rediff.com', 'ORYt2jU0S', 'user', FALSE);
INSERT INTO users (id, name, username, email, PASSWORD, type_user, deleted)
    VALUES (42, 'Stanwood', 'sgentsch15', 'spiddletown15@army.mil', 'V8pXQTwer', 'user', FALSE);
INSERT INTO users (id, name, username, email, PASSWORD, type_user, deleted)
    VALUES (43, 'Sileas', 'sbushell16', 'skaveney16@biblegateway.com', 'YU9Yr66', 'user', FALSE);
INSERT INTO users (id, name, username, email, PASSWORD, type_user, deleted)
    VALUES (44, 'Doretta', 'dkippax17', 'dmaving17@angelfire.com', 'Wq5vYaZV', 'user', FALSE);
INSERT INTO users (id, name, username, email, PASSWORD, type_user, deleted)
    VALUES (45, 'Homere', 'hborthwick18', 'hlind18@ocn.ne.jp', 'InBdtHfxG', 'user', FALSE);
INSERT INTO users (id, name, username, email, PASSWORD, type_user, deleted)
    VALUES (46, 'Robin', 'rescreet19', 'rcadamy19@slashdot.org', 'i3sVh4', 'user', FALSE);
INSERT INTO users (id, name, username, email, PASSWORD, type_user, deleted)
    VALUES (47, 'Keith', 'kcrennell1a', 'ksmorthit1a@state.gov', 'HCfabMIoNg', 'user', FALSE);
INSERT INTO users (id, name, username, email, PASSWORD, type_user, deleted)
    VALUES (48, 'Gussie', 'gmoogan1b', 'ggenty1b@stumbleupon.com', 'X9nBQrJcJAMY', 'user', FALSE);
INSERT INTO users (id, name, username, email, PASSWORD, type_user, deleted)
    VALUES (49, 'Clarinda', 'coglesbee1c', 'cfeifer1c@gmpg.org', 'N8SgWrgvn7I', 'user', FALSE);
INSERT INTO users (id, name, username, email, PASSWORD, type_user, deleted)
    VALUES (50, 'Emelda', 'ewibberley1d', 'etolerton1d@blogs.com', 'LdYpbJ', 'user', FALSE);
-----------------------------------------
-- product
-----------------------------------------

INSERT INTO product (id, name, price, description, stock, score)
    VALUES (1, 'RVCA Pants', 60.0, 'Designed to maximize your mobility, these midweight pants are crafted with durable Sorona® Triexta yarns, feature articulated knees for freedom of movement, and reflective trim that''s visible when pants are cuffed.', 82, 3.0);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (2, '1996 Retro Seasonal Jacket', 119.90, 'Water-resistant, boxy down vest for capturing warmth around your torso.', 35, 4.0);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (3, 'Redux Leather Boots', 59.90, 'Blending an old-school silhouette with new-school technology, this insulated, waterproof boot delivers versatile performance on the local trails.', 60, 5.0);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (4, 'Premium 6 inch Boots', 230.00, 'In 1973, the small town of Newmarket in New Hampshire played host to the birth of an American legend. Created by Sidney Swartz with the “working man” in mind, our iconic Timberland® 6 Inch boot was one of the first waterproof leather boots of its kind. It became an instant classic and has since been embraced as a style icon by numerous scenes around the world.', 85, 4.0);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (5, 'Sheep Milkvetch', 79.90, 'Built to last, the thick rubber lug outsole keeps things steady with reliable gripping power.', 25, 3.0);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (6, 'Wachendorfia', 99.90, 'We use the finest quality nubuck and thoroughly seal every seam for guaranteed waterproof performance.', 87, 4.0);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (7, 'Humboldt''s Lily', 75.90, 'Be prepared for extreme backcountry weather with this lightweight, waterproof and windproof jacket that features a durable yet breathable ripstop exterior, Relaxed Fit and adjustable hood that leaves room for a helmet and extra layers.', 97, 4.0);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (8, 'Canadian Rim Lichen', 89.90, 'Revel in the deluge with this weatherproof rain jacket that features a breathable mesh lining and adjustable hood that stows inside the collar.', 17, 5.0);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (9, 'Soft Brome', 70.00, 'Travel and trek smarter with a sweater-knit jacket that provides heavyweight warmth with casual appeal.', 15, 4.0);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (10, 'Wheelscale Saltbush', 109.90, 'Light wind jacket with side-seam venting for ultimate comfort on the trail.', 22, 2.0);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (11, 'Orange Lichen', 75.00, 'This lightweight hoodie offers packable, wind protection with an adjustable hood for added versatility.', 60, 4.0);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (12, 'Slenderleaf False Foxglove', 42.90, 'Revel in the deluge with this weatherproof rain jacket that features a breathable mesh lining and adjustable hood that stows inside the collar.', 53, 1.0);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (13, 'Beet', 69.90, 'A hybrid jacket for men, this is like a hoodie but with extra quilting. The distinctive style plus extra warmth make it an easy choice for colder weather, and it even features a concealed pocket on the sleeve for your valuables.', 73, 4.0);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (14, 'Largeleaf Phlox', 85.00, 'Soft, low-maintenance pullover hoodie for down days and days at camp.', 14, 3.0);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (15, 'Fuchsia Begonia', 56.00, 'Bushwhack all you want in this midweight hoodie made of soft, easy-to-care-for fabric. When you blaze trails on cooler spring days, this pullover will have your back.', 22, 3.0);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (16, 'Mexican Avocado', 70.00, 'Wicking fleece for cold runs when you need warmth without the weight.', 16, 2.0);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (17, 'Spanish Arborvine', 45.00, 'Get set for full-day missions into the wild with this technical, stretch fleece that’s extremely durable and breathable. Full-zip front allows for easy wardrobe changes and zip pockets provide secure places for valuables like keys and IDs.', 45, 2.0);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (18, 'California Laurel', 89.90, 'Designed to maximize your mobility, these midweight pants are crafted with durable Sorona® Triexta yarns, feature articulated knees for freedom of movement, and reflective trim that''s visible when pants are cuffed.', 51, 1.0);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (19, 'Short''s Spreading Chervil', 52.00, 'Purpose built for tough hikes, these technical pants feature stretch-woven ripstop fabric in the seat and knees for maximum mobility and durability.', 89, 3.0);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (20, 'Douglas'' Buckwheat', 62.00, 'Lightweight, breathable pants for hiking in variable spring conditions.', 3, 1.0);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (21, 'Cola', 85.00, 'Stay comfortable on multiday hikes regardless of conditions with these versatile, durable pants that easily convert to 10-inch shorts and feature water-repellent nylon fabric to keep you dryer and a zip-close cargo pocket to stow trail permits.', 10, 3.0);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (22, 'Hawkweed Oxtongue', 39.90, 'Purpose built for tough hikes, these technical pants feature stretch-woven ripstop fabric in the seat and knees for maximum mobility and durability.', 38, 5.0);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (23, 'Kamchatka Globeflower', 21.00, 'Purpose built for tough hikes, these technical pants feature stretch-woven ripstop fabric in the seat and knees for maximum mobility and durability.', 88, 3.0);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (24, 'Mulberry', 350.00, 'Virtually a portable chateau, this durable, single-wall tent boasts room for six people, ceilings high enough to stand beneath, large windows for expansive views and exceptional airflow, and a color-coded easy-pitch design. Packs into a duffel-bag-style stuffsack for easy transport.', 74, 1.0);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (25, 'Fiveleaf Cinquefoil', 180.00, 'Virtually a portable chateau, this durable, single-wall tent boasts room for six people, ceilings high enough to stand beneath, large windows for expansive views and exceptional airflow, and a color-coded easy-pitch design. Packs into a duffel-bag-style stuffsack for easy transport.', 7, 2.0);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (26, 'Whorl-leaf Watermilfoil', 210.00, 'Virtually a portable chateau, this durable, single-wall tent boasts room for six people, ceilings high enough to stand beneath, large windows for expansive views and exceptional airflow, and a color-coded easy-pitch design. Packs into a duffel-bag-style stuffsack for easy transport.', 98, 2.0);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (27, 'Cup Lichen', 150.00, 'Virtually a portable chateau, this durable, single-wall tent boasts room for six people, ceilings high enough to stand beneath, large windows for expansive views and exceptional airflow, and a color-coded easy-pitch design. Packs into a duffel-bag-style stuffsack for easy transport.', 38, 4.0);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (28, 'Texas Ringstem', 130.00, 'Virtually a portable chateau, this durable, single-wall tent boasts room for six people, ceilings high enough to stand beneath, large windows for expansive views and exceptional airflow, and a color-coded easy-pitch design. Packs into a duffel-bag-style stuffsack for easy transport.', 24, 2.0);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (29, 'Smooth Northern-rockcress', 230.00, 'Virtually a portable chateau, this durable, single-wall tent boasts room for six people, ceilings high enough to stand beneath, large windows for expansive views and exceptional airflow, and a color-coded easy-pitch design. Packs into a duffel-bag-style stuffsack for easy transport.', 58, 4.0);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (30, 'Catalina Nightshade', 420.00, 'Virtually a portable chateau, this durable, single-wall tent boasts room for six people, ceilings high enough to stand beneath, large windows for expansive views and exceptional airflow, and a color-coded easy-pitch design. Packs into a duffel-bag-style stuffsack for easy transport.', 76, 2.0);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (31, 'Philonotis Moss', 90.00, 'Virtually a portable chateau, this durable, single-wall tent boasts room for six people, ceilings high enough to stand beneath, large windows for expansive views and exceptional airflow, and a color-coded easy-pitch design. Packs into a duffel-bag-style stuffsack for easy transport.', 78, 5.0);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (32, 'Tomentose Gopherweed', 85.00, 'Virtually a portable chateau, this durable, single-wall tent boasts room for six people, ceilings high enough to stand beneath, large windows for expansive views and exceptional airflow, and a color-coded easy-pitch design. Packs into a duffel-bag-style stuffsack for easy transport.', 62, 3.0);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (33, 'Standley''s Bloodleaf', 12.00, 'Designed for hikers who wish to carry and drink their drinks. A simple and lightweight flask with a one turn screw top. Tritan plastic transparent and solid (0.8L).', 22, 3.0);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (34, 'Dunn''s Lobelia', 63.00, 'Lightweight, fits-like-a-glove pack for trail aficionados who crush miles.', 77, 3.0);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (35, 'Wildrye', 80.00, 'Lightweight, fits-like-a-glove pack for trail aficionados who crush miles.', 59, 1.0);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (36, 'Coral Phyllopsora Lichen', 94.00, 'Lightweight, fits-like-a-glove pack for trail aficionados who crush miles.', 9, 4.0);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (37, 'South African Oatgrass', 105.00, 'Lightweight, fits-like-a-glove pack for trail aficionados who crush miles.', 87, 4.0);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (38, 'Barneby''s Phacelia', 99.90, 'Lightweight, fits-like-a-glove pack for trail aficionados who crush miles.', 21, 4.0);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (39, 'Paulownia', 45.00, 'Plow through all types of terrain safely, comfortably and quickly with these waterproof Gore-Tex® mid-height shoes. The gusseted tongue keeps out debris when you’re blazing new trails, and the OrthoLite® footbed ensures you’re comfortable from valley floor to the peak.', 84, 1.0);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (40, 'Los Alamos Beardtongue', 75.00, 'Lightweight, fits-like-a-glove pack for trail aficionados who crush miles.', 72, 2.0);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (41, 'Lecidea Lichen', 86.00, 'Lightweight, fits-like-a-glove pack for trail aficionados who crush miles.', 6, 2.0);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (42, 'Dwarf Chamaesaracha', 89.90, 'Lightweight, fits-like-a-glove pack for trail aficionados who crush miles.', 16, 1.0);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (43, 'Hoover''s Deserttrumpet', 50.00, 'Plow through all types of terrain safely, comfortably and quickly with these waterproof Gore-Tex® mid-height shoes. The gusseted tongue keeps out debris when you’re blazing new trails, and the OrthoLite® footbed ensures you’re comfortable from valley floor to the peak.', 5, 2.0);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (44, 'Elaeagnus Willow', 35.00, 'Keep the pace quick in this lightweight full-zip sweatshirt that features a cozy hood and split kangaroo pocket for mile 1 to mile 10 comfort.', 88, 2.0);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (45, 'Beaked Spikerush', 27.00, 'Keep the pace quick in this lightweight full-zip sweatshirt that features a cozy hood and split kangaroo pocket for mile 1 to mile 10 comfort.', 83, 3.0);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (46, 'Pohlia Moss', 40.00, 'Keep the pace quick in this lightweight full-zip sweatshirt that features a cozy hood and split kangaroo pocket for mile 1 to mile 10 comfort.', 81, 1.0);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (47, 'Duncan''s Foxtail Cactus', 70.00, 'Training hard doesn’t mean sacrificing style with these midweight pants designed articulated knees and a gusseted crotch for improved range of motion.', 46, 1.0);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (48, 'Winter Vetch', 93.00, 'Keep the pace quick in this lightweight full-zip sweatshirt that features a cozy hood and split kangaroo pocket for mile 1 to mile 10 comfort.', 92, 2.0);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (49, 'Neofuscelia Lichen', 38.90, 'Plow through all types of terrain safely, comfortably and quickly with these waterproof Gore-Tex® mid-height shoes. The gusseted tongue keeps out debris when you’re blazing new trails, and the OrthoLite® footbed ensures you’re comfortable from valley floor to the peak.', 78, 3.0);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (50, 'Field Eryngo', 17.00, 'A full brim makes this nylon ripstop hat ideal for extra coverage from the sun during a wide range of outdoor pursuits.', 70, 2.0);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (51, 'Flowering Ash', 610.00, 'A dependable workhorse for zero-degree expeditions, this lofty Summit Series® bag is insulated with water-repellent 800-fill ProDown and constructed with a wider, roomier cut and a center zip to make it easier to get in and out. Part of the Summit Series™ collection- the world’s finest alpine equipment.', 0, 4.0);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (52, 'Coville''s Rush', 10.00, 'A favorite of through-hikers and day-trippers alike, the PhD® Outdoor Light packs some serious trail power. Featuring a versatile, multi-sport design, this lightweight style includes Indestructawool™ technology for ultimate durability in high wear areas. And when it comes to comfort, we pulled out all the stops: the 4 Degree™ elite fit system provides a dialed fit and our signature Virtually Seamless™ toe offers extraordinary comfort in any trail shoe. The Mid Crew height sits at an ideal height for a low trail boot.', 57, 2.0);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (53, 'Mammoth Wildrye', 35.00, 'Some tools take everything in their stride. And our Walker medium pocket knife is a blade that knows no bounds. An everyday trailblazer, it steps up to the daily adventure game and delivers. Sling it in your pocket for a Sunday stroll, or hook it to your backpack for an intrepid hike. From carving timber, chopping logs for a roaring campfire, to opening a thirst-quenching bottle, this compact multitasker has all bases covered.', 63, 2.0);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (54, 'Bracted Passionflower', 79.00, 'Protect your gear from wet weather with this lightweight, packable rain cover that''s crafted with fully taped seams and an adjustable elastic closure for a secure fit around your pack.', 48, 2.0);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (55, 'Oval-leaf Clustervine', 66.21, 'Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.', 65, 1.9);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (56, 'False Brome', 87.35, 'Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.', 94, 4.4);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (57, 'Walpole''s Small Camas', 81.31, 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', 32, 2.5);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (58, 'Guilarte', 98.25, 'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', 11, 0.3);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (59, 'Sarea Lichen', 32.47, 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', 25, 3.5);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (60, 'Douglas'' Silver Lupine', 33.11, 'Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', 57, 4.4);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (61, 'Magalospora Lichen', 32.03, 'Sed ante. Vivamus tortor. Duis mattis egestas metus.', 49, 0.8);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (62, 'Clokey''s Cryptantha', 78.19, 'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', 83, 3.7);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (63, 'Cultivated Raspberry', 46.15, 'In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.', 65, 3.2);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (64, 'Pale Serviceberry', 27.27, 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.', 6, 3.1);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (65, 'Chamomile', 92.73, 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', 52, 2.3);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (66, 'Drymary Dwarf-flax', 62.54, 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.', 25, 3.6);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (67, 'Bugloss', 70.17, 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.', 82, 3.8);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (68, 'Globe Sedge', 82.45, 'In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.', 54, 3.1);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (69, 'Whiskerbush', 98.29, 'Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.', 67, 2.1);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (70, 'Buckthorn Bully', 73.99, 'In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.', 66, 4.2);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (71, 'Polished Maidenhair', 90.94, 'Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', 100, 3.7);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (72, 'Rough Coneflower', 95.82, 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', 40, 5.0);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (73, 'Smooth Arizona Cypress', 43.22, 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', 49, 4.1);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (74, 'River Redgum', 29.16, 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', 98, 1.2);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (75, 'Yellow Spikerush', 40.47, 'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', 28, 4.2);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (76, 'Netted Anoda', 62.76, 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.', 9, 1.4);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (77, 'Charleston Mountain Violet', 96.35, 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', 19, 5.0);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (78, 'Creeping Silverback', 73.44, 'In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.', 67, 2.1);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (79, 'Giant Ricegrass', 87.16, 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.', 66, 3.9);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (80, 'Pterygiopsis Lichen', 21.45, 'In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.', 95, 1.6);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (81, 'Marsh Hedgenettle', 54.32, 'Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.', 14, 3.3);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (82, 'Spiderling', 94.09, 'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.', 22, 3.8);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (83, 'Physcomitrium Moss', 46.27, 'Sed ante. Vivamus tortor. Duis mattis egestas metus.', 19, 3.0);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (84, 'Bayrumtree', 56.09, 'Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.', 30, 0.7);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (85, 'Yellow Pincushion', 56.45, 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.', 49, 2.9);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (86, 'White-flowered Black Mangrove', 61.1, 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', 74, 1.6);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (87, 'African Tamarisk', 81.89, 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', 63, 3.5);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (88, 'Coral Ipomopsis', 84.85, 'Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.', 9, 2.9);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (89, '''ohe Makai', 79.46, 'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.', 100, 5.0);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (90, 'Rosy Sandcrocus', 72.08, 'Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.', 66, 0.4);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (91, 'Mock Dandelion', 60.09, 'Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.', 14, 2.1);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (92, 'Maid Marian', 21.75, 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.', 67, 0.0);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (93, 'Alaska Alkaligrass', 40.24, 'Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.', 24, 2.7);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (94, 'Gooseberryleaf Globemallow', 86.33, 'Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.', 51, 3.6);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (95, 'Duck River Bladderpod', 75.98, 'In congue. Etiam justo. Etiam pretium iaculis justo.', 19, 2.8);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (96, 'Sierra Baby Blue Eyes', 63.75, 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.', 56, 4.3);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (97, 'Field Pussytoes', 34.85, 'Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', 17, 0.6);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (98, 'Whiteplume Wirelettuce', 84.21, 'Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.', 84, 2.1);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (99, 'Russian Milkvetch', 91.59, 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.', 93, 1.3);
INSERT INTO product (id, name, price, description, stock, score)
    VALUES (100, 'American Plum', 71.73, 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', 62, 4.9);
-----------------------------------------
-- categories
-----------------------------------------

INSERT INTO categories (id, name, sex, season, dad)
    VALUES (1, 'Tops', 'w', 'lacinia', 'Clothing');
INSERT INTO categories (id, name, sex, season, dad)
    VALUES (2, 'Tops', 'm', 'semper', 'Clothing');
INSERT INTO categories (id, name, sex, season, dad)
    VALUES (3, 'Bottoms', 'w', 'lobortis', 'Clothing');
INSERT INTO categories (id, name, sex, season, dad)
    VALUES (4, 'Shoes', 'w', 'vestibulum', 'Clothing');
INSERT INTO categories (id, name, sex, season, dad)
    VALUES (5, 'Accessories', 'w', 'justo', 'Clothing');
INSERT INTO categories (id, name, sex, season, dad)
    VALUES (6, 'Bottoms', 'm', 'nulla', 'Clothing');
INSERT INTO categories (id, name, sex, season, dad)
    VALUES (7, 'Shoes', 'm', 'volutpat', 'Clothing');
INSERT INTO categories (id, name, sex, season, dad)
    VALUES (8, 'Accessories', 'm', 'sed', 'Clothing');
INSERT INTO categories (id, name, sex, season, dad)
    VALUES (9, 'Bedroom', '?', 'ligula', 'House-Decor');
INSERT INTO categories (id, name, sex, season, dad)
    VALUES (10, 'Kitchen', '?', 'justo', 'House-Decor');
INSERT INTO categories (id, name, sex, season, dad)
    VALUES (11, 'Living Room', '?', 'quis', 'House-Decor');
INSERT INTO categories (id, name, sex, season, dad)
    VALUES (12, 'Outdoor', '?', 'et', 'House-Decor');
INSERT INTO categories (id, name, sex, season, dad)
    VALUES (13, 'Climbing', '?', 'cubilia', 'Activities');
INSERT INTO categories (id, name, sex, season, dad)
    VALUES (14, 'Hiking', '?', 'volutpat', 'Activities');
INSERT INTO categories (id, name, sex, season, dad)
    VALUES (15, 'Running', '?', 'commodo', 'Activities');
INSERT INTO categories (id, name, sex, season, dad)
    VALUES (16, 'Fishing', '?', 'facilisi', 'Activities');
INSERT INTO categories (id, name, sex, season, dad)
    VALUES (17, 'Hunting', '?', 'in', 'Activities');
-----------------------------------------
-- review
-----------------------------------------

INSERT INTO review (id, id_user, id_product, title, description, score)
    VALUES (1, 5, 5, 'Super Confortable', 'I''m between size 10 and 10.5 depending on the shoe, so I listened to other comments saying that these are a half size too small and got size 10. That was a BIG MISTAKE. They were NOT under-sized. I had to return and get another pair of 10.5. I suggest ordering your size and exchanging if necessary. Besides that, they are the most comfortable shoes I have ever put on my feet. Like walking on the moon! The lowest inside shoestring hole kinda bothers my foot but that will likely vary depending on the foot. As far as durability, I don''t think they are made to be work boots or would hold up very long in bad weather (water, snow, mud, etc), so don''t get them for that purpose. I like these shoes a lot!', 5);
INSERT INTO review (id, id_user, id_product, title, description, score)
    VALUES (2, 2, 6, 'This is like a sneaker', 'These boots are my best performing boots. By that I mean the most supportive and comfortable. They tighten so the whole foot is supported and super comfortable. They''re light as a sneaker. They''re so light that instinctively I don''t reach for them with snow on the ground so I can''t comment about that but I''ve never had wet feet. During the holidays in ''17 I bought a pair along with other brands. They were the most comfortable so I bought another pair last holiday season. They''re fabulous.', 4);
INSERT INTO review (id, id_user, id_product, title, description, score)
    VALUES (3, 3, 55, 'Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl.', 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.', 1);
INSERT INTO review (id, id_user, id_product, title, description, score)
    VALUES (4, 4, 77, 'Etiam faucibus cursus urna.', 'Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.', 5);
INSERT INTO review (id, id_user, id_product, title, description, score)
    VALUES (5, 5, 23, 'Phasellus in felis.', 'Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.', 0);
INSERT INTO review (id, id_user, id_product, title, description, score)
    VALUES (6, 6, 21, 'Ut at dolor quis odio consequat varius.', 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.', 0);
INSERT INTO review (id, id_user, id_product, title, description, score)
    VALUES (7, 7, 69, 'Pellentesque ultrices mattis odio.', 'Fusce consequat. Nulla nisl. Nunc nisl.', 3);
INSERT INTO review (id, id_user, id_product, title, description, score)
    VALUES (8, 8, 67, 'Aliquam quis turpis eget elit sodales scelerisque.', 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.', 4);
INSERT INTO review (id, id_user, id_product, title, description, score)
    VALUES (9, 9, 34, 'Nulla mollis molestie lorem.', 'In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.', 1);
INSERT INTO review (id, id_user, id_product, title, description, score)
    VALUES (10, 10, 57, 'Duis bibendum.', 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.', 4);
INSERT INTO review (id, id_user, id_product, title, description, score)
    VALUES (11, 11, 57, 'In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.', 'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.', 3);
INSERT INTO review (id, id_user, id_product, title, description, score)
    VALUES (12, 12, 48, 'Morbi a ipsum.', 'Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.', 1);
INSERT INTO review (id, id_user, id_product, title, description, score)
    VALUES (13, 13, 91, 'Curabitur in libero ut massa volutpat convallis.', 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.', 0);
INSERT INTO review (id, id_user, id_product, title, description, score)
    VALUES (14, 14, 88, 'Morbi vel lectus in quam fringilla rhoncus.', 'Phasellus in felis. Donec semper sapien a libero. Nam dui.', 0);
INSERT INTO review (id, id_user, id_product, title, description, score)
    VALUES (15, 15, 55, 'Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.', 'Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.', 2);
INSERT INTO review (id, id_user, id_product, title, description, score)
    VALUES (16, 16, 94, 'Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', 'Sed ante. Vivamus tortor. Duis mattis egestas metus.', 0);
INSERT INTO review (id, id_user, id_product, title, description, score)
    VALUES (17, 17, 91, 'Morbi non lectus.', 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', 4);
INSERT INTO review (id, id_user, id_product, title, description, score)
    VALUES (18, 18, 84, 'Quisque ut erat.', 'Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.', 5);
INSERT INTO review (id, id_user, id_product, title, description, score)
    VALUES (19, 19, 80, 'Nulla justo.', 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', 2);
INSERT INTO review (id, id_user, id_product, title, description, score)
    VALUES (20, 20, 42, 'Donec vitae nisi.', 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', 1);
-----------------------------------------
-- country
-----------------------------------------

INSERT INTO country (id, name)
    VALUES (1, 'Vietnam');
INSERT INTO country (id, name)
    VALUES (2, 'Philippines');
INSERT INTO country (id, name)
    VALUES (3, 'England');
INSERT INTO country (id, name)
    VALUES (4, 'Central African Republic');
INSERT INTO country (id, name)
    VALUES (5, 'China');
INSERT INTO country (id, name)
    VALUES (6, 'Portugal');
INSERT INTO country (id, name)
    VALUES (7, 'Norway');
INSERT INTO country (id, name)
    VALUES (8, 'Mexico');
INSERT INTO country (id, name)
    VALUES (9, 'Croatia');
INSERT INTO country (id, name)
    VALUES (10, 'Colombia');
INSERT INTO country (id, name)
    VALUES (11, 'China');
INSERT INTO country (id, name)
    VALUES (12, 'Bangladesh');
INSERT INTO country (id, name)
    VALUES (13, 'Luxembourg');
INSERT INTO country (id, name)
    VALUES (14, 'Peru');
INSERT INTO country (id, name)
    VALUES (15, 'China');
INSERT INTO country (id, name)
    VALUES (16, 'Spain');
INSERT INTO country (id, name)
    VALUES (17, 'Guatemala');
INSERT INTO country (id, name)
    VALUES (18, 'Thailand');
INSERT INTO country (id, name)
    VALUES (19, 'Russia');
INSERT INTO country (id, name)
    VALUES (20, 'United States');
-----------------------------------------
-- city
-----------------------------------------

INSERT INTO city (id, id_country, name)
    VALUES (1, 4, 'Taquara');
INSERT INTO city (id, id_country, name)
    VALUES (2, 13, 'Velká Bystřice');
INSERT INTO city (id, id_country, name)
    VALUES (3, 18, 'Zhufo');
INSERT INTO city (id, id_country, name)
    VALUES (4, 1, 'Mananum');
INSERT INTO city (id, id_country, name)
    VALUES (5, 9, 'Salcedo');
INSERT INTO city (id, id_country, name)
    VALUES (6, 20, 'Lishu');
INSERT INTO city (id, id_country, name)
    VALUES (7, 12, 'Sexmoan');
INSERT INTO city (id, id_country, name)
    VALUES (8, 4, 'Benzilan');
INSERT INTO city (id, id_country, name)
    VALUES (9, 13, 'Alindao');
INSERT INTO city (id, id_country, name)
    VALUES (10, 13, 'Arroyo Naranjo');
INSERT INTO city (id, id_country, name)
    VALUES (11, 12, 'Kuala Lumpur');
INSERT INTO city (id, id_country, name)
    VALUES (12, 7, 'Warlubie');
INSERT INTO city (id, id_country, name)
    VALUES (13, 20, 'Amiens');
INSERT INTO city (id, id_country, name)
    VALUES (14, 7, 'Villach');
INSERT INTO city (id, id_country, name)
    VALUES (15, 16, 'Sandakan');
INSERT INTO city (id, id_country, name)
    VALUES (16, 9, 'Nova Kakhovka');
INSERT INTO city (id, id_country, name)
    VALUES (17, 1, 'Rathnew');
INSERT INTO city (id, id_country, name)
    VALUES (18, 13, 'Nova Odesa');
INSERT INTO city (id, id_country, name)
    VALUES (19, 15, 'Maple Plain');
INSERT INTO city (id, id_country, name)
    VALUES (20, 3, 'Malitubog');
-----------------------------------------
-- address
-----------------------------------------

INSERT INTO address (id, door_number, id_user, id_city, street, zipCode, type_address)
    VALUES (1, 2332, 1, 12, 'Grim', '446600', 'home');
INSERT INTO address (id, door_number, id_user, id_city, street, zipCode, type_address)
    VALUES (2, 323132, 2, 4, 'Michigan', '06-121', 'work');
INSERT INTO address (id, door_number, id_user, id_city, street, zipCode, type_address)
    VALUES (3, 345, 3, 19, 'Pepper Wood', '70061', 'other');
INSERT INTO address (id, door_number, id_user, id_city, street, zipCode, type_address)
    VALUES (4, 453, 4, 19, 'Lighthouse Bay', '431-10', 'home');
INSERT INTO address (id, door_number, id_user, id_city, street, zipCode, type_address)
    VALUES (5, 234, 5, 20, 'Arrowood', '7104', 'work');
INSERT INTO address (id, door_number, id_user, id_city, street, zipCode, type_address)
    VALUES (6, 345, 6, 3, 'Anzinger', '662133', 'other');
INSERT INTO address (id, door_number, id_user, id_city, street, zipCode, type_address)
    VALUES (7, 34, 7, 12, 'American Ash', '744 88', 'work');
INSERT INTO address (id, door_number, id_user, id_city, street, zipCode, type_address)
    VALUES (8, 395, 8, 9, 'Nobel', '301649', 'work');
INSERT INTO address (id, door_number, id_user, id_city, street, zipCode, type_address)
    VALUES (9, 385, 9, 2, 'Artisan', '2350-259', 'work');
INSERT INTO address (id, door_number, id_user, id_city, street, zipCode, type_address)
    VALUES (10, 378, 10, 5, 'Nancy', 'L1X', 'work');
INSERT INTO address (id, door_number, id_user, id_city, street, zipCode, type_address)
    VALUES (11, 312, 11, 7, 'Melvin', '675 31', 'work');
INSERT INTO address (id, door_number, id_user, id_city, street, zipCode, type_address)
    VALUES (12, 324, 12, 2, 'Northview', '4890-223', 'work');
INSERT INTO address (id, door_number, id_user, id_city, street, zipCode, type_address)
    VALUES (13, 32, 13, 20, 'Westport', '8301', 'work');
INSERT INTO address (id, door_number, id_user, id_city, street, zipCode, type_address)
    VALUES (14, 34, 14, 15, 'Fordem', '22111', 'work');
INSERT INTO address (id, door_number, id_user, id_city, street, zipCode, type_address)
    VALUES (15, 98, 15, 4, 'Karstens', '58500-000', 'work');
INSERT INTO address (id, door_number, id_user, id_city, street, zipCode, type_address)
    VALUES (16, 87, 16, 9, 'Lien', '249070', 'work');
INSERT INTO address (id, door_number, id_user, id_city, street, zipCode, type_address)
    VALUES (17, 123, 17, 1, 'Commercial', '60078', 'work');
INSERT INTO address (id, door_number, id_user, id_city, street, zipCode, type_address)
    VALUES (18, 56, 18, 2, 'Anhalt', '7104', 'work');
INSERT INTO address (id, door_number, id_user, id_city, street, zipCode, type_address)
    VALUES (19, 34, 19, 8, 'Corben', '30902', 'work');
INSERT INTO address (id, door_number, id_user, id_city, street, zipCode, type_address)
    VALUES (20, 765, 20, 17, 'Nova', '399-8205', 'work');
INSERT INTO address (id, door_number, id_user, id_city, street, zipCode, type_address)
    VALUES (21, 56, 21, 4, 'Northridge', '82001', 'work');
INSERT INTO address (id, door_number, id_user, id_city, street, zipCode, type_address)
    VALUES (22, 456, 22, 17, 'Jenna', '28210', 'other');
INSERT INTO address (id, door_number, id_user, id_city, street, zipCode, type_address)
    VALUES (23, 456, 23, 11, 'Lunder', '21006', 'other');
INSERT INTO address (id, door_number, id_user, id_city, street, zipCode, type_address)
    VALUES (24, 42, 24, 18, 'Prairieview', '64800-000', 'other');
INSERT INTO address (id, door_number, id_user, id_city, street, zipCode, type_address)
    VALUES (25, 56, 25, 11, 'Evergreen', '2327', 'other');
INSERT INTO address (id, door_number, id_user, id_city, street, zipCode, type_address)
    VALUES (26, 78, 26, 6, 'Mayer', '28210', 'other');
INSERT INTO address (id, door_number, id_user, id_city, street, zipCode, type_address)
    VALUES (27, 56, 27, 2, 'Kings', '999-3503', 'other');
INSERT INTO address (id, door_number, id_user, id_city, street, zipCode, type_address)
    VALUES (28, 56, 28, 19, 'Oxford', '21006', 'other');
INSERT INTO address (id, door_number, id_user, id_city, street, zipCode, type_address)
    VALUES (29, 342, 29, 4, 'Golf Course', '142143', 'other');
INSERT INTO address (id, door_number, id_user, id_city, street, zipCode, type_address)
    VALUES (30, 53, 30, 15, 'Russell', '83404 CEDEX', 'other');
INSERT INTO address (id, door_number, id_user, id_city, street, zipCode, type_address)
    VALUES (31, 23, 31, 10, '1st', '1695', 'other');
INSERT INTO address (id, door_number, id_user, id_city, street, zipCode, type_address)
    VALUES (32, 787, 32, 7, 'Fieldstone', '733517', 'other');
INSERT INTO address (id, door_number, id_user, id_city, street, zipCode, type_address)
    VALUES (33, 98, 33, 8, 'Reinke', '6406', 'other');
INSERT INTO address (id, door_number, id_user, id_city, street, zipCode, type_address)
    VALUES (34, 98, 34, 16, 'Center', '10040', 'other');
INSERT INTO address (id, door_number, id_user, id_city, street, zipCode, type_address)
    VALUES (35, 12, 35, 19, 'Memorial', '19130', 'other');
INSERT INTO address (id, door_number, id_user, id_city, street, zipCode, type_address)
    VALUES (36, 123, 36, 3, 'Carpenter', '624857', 'other');
INSERT INTO address (id, door_number, id_user, id_city, street, zipCode, type_address)
    VALUES (37, 23, 37, 15, 'Memorial', '3255', 'other');
INSERT INTO address (id, door_number, id_user, id_city, street, zipCode, type_address)
    VALUES (38, 132, 38, 11, 'International', '47405', 'other');
INSERT INTO address (id, door_number, id_user, id_city, street, zipCode, type_address)
    VALUES (39, 123, 39, 17, 'Lindbergh', '419-0125', 'home');
INSERT INTO address (id, door_number, id_user, id_city, street, zipCode, type_address)
    VALUES (40, 123, 40, 11, 'Ridge Oak', '05-804', 'home');
INSERT INTO address (id, door_number, id_user, id_city, street, zipCode, type_address)
    VALUES (41, 45, 41, 1, 'Carey', '9630-311', 'home');
INSERT INTO address (id, door_number, id_user, id_city, street, zipCode, type_address)
    VALUES (42, 345, 42, 8, 'Sachtjen', '242467', 'home');
INSERT INTO address (id, door_number, id_user, id_city, street, zipCode, type_address)
    VALUES (43, 123, 43, 5, 'Killdeer', '374 53', 'home');
INSERT INTO address (id, door_number, id_user, id_city, street, zipCode, type_address)
    VALUES (44, 56, 44, 6, 'Manitowish', '30010', 'home');
INSERT INTO address (id, door_number, id_user, id_city, street, zipCode, type_address)
    VALUES (45, 34, 45, 9, 'Pleasure', '912 24', 'home');
INSERT INTO address (id, door_number, id_user, id_city, street, zipCode, type_address)
    VALUES (46, 987, 46, 4, 'Sycamore', '4750-521', 'home');
INSERT INTO address (id, door_number, id_user, id_city, street, zipCode, type_address)
    VALUES (47, 123, 47, 7, 'Eggendart', '141986', 'home');
INSERT INTO address (id, door_number, id_user, id_city, street, zipCode, type_address)
    VALUES (48, 123, 48, 3, 'Clemons', '7803', 'home');
INSERT INTO address (id, door_number, id_user, id_city, street, zipCode, type_address)
    VALUES (49, 321, 49, 8, 'Jenna', '10040', 'home');
INSERT INTO address (id, door_number, id_user, id_city, street, zipCode, type_address)
    VALUES (50, 654, 50, 13, 'Donald', '11403', 'home');
-----------------------------------------
-- "order"
-----------------------------------------

INSERT INTO "order" (id, id_user, id_address_invoce, date, total, state)
    VALUES (1, 46, 46, '2019/01/20', 68.3, 'Processing');
INSERT INTO "order" (id, id_user, id_address_invoce, date, total, state)
    VALUES (2, 31, 31, '2019/10/25', 22.23, 'Shipped');
INSERT INTO "order" (id, id_user, id_address_invoce, date, total, state)
    VALUES (3, 30, 30, '2019/07/25', 41.55, 'Delivered');
INSERT INTO "order" (id, id_user, id_address_invoce, date, total, state)
    VALUES (4, 28, 28, '2018/06/27', 7.97, 'Processing');
INSERT INTO "order" (id, id_user, id_address_invoce, date, total, state)
    VALUES (5, 3, 3, '2019/12/08', 73.53, 'Delivered');
INSERT INTO "order" (id, id_user, id_address_invoce, date, total, state)
    VALUES (6, 50, 50, '2018/05/19', 28.41, 'Delivered');
INSERT INTO "order" (id, id_user, id_address_invoce, date, total, state)
    VALUES (7, 19, 19, '2018/07/28', 45.25, 'Delivered');
INSERT INTO "order" (id, id_user, id_address_invoce, date, total, state)
    VALUES (8, 29, 29, '2019/07/07', 7.33, 'Processing');
INSERT INTO "order" (id, id_user, id_address_invoce, date, total, state)
    VALUES (9, 6, 6, '2019/10/10', 55.04, 'Processing');
INSERT INTO "order" (id, id_user, id_address_invoce, date, total, state)
    VALUES (10, 17, 17, '2018/06/19', 59.49, 'Processing');
INSERT INTO "order" (id, id_user, id_address_invoce, date, total, state)
    VALUES (11, 18, 18, '2020/03/22', 11.59, 'Processing');
INSERT INTO "order" (id, id_user, id_address_invoce, date, total, state)
    VALUES (12, 14, 14, '2019/03/21', 66.9, 'Delivered');
INSERT INTO "order" (id, id_user, id_address_invoce, date, total, state)
    VALUES (13, 6, 6, '2018/04/19', 82.14, 'Processing');
INSERT INTO "order" (id, id_user, id_address_invoce, date, total, state)
    VALUES (14, 29, 29, '2020/02/08', 50.15, 'Shipped');
INSERT INTO "order" (id, id_user, id_address_invoce, date, total, state)
    VALUES (15, 13, 13, '2018/04/27', 98.98, 'Processing');
INSERT INTO "order" (id, id_user, id_address_invoce, date, total, state)
    VALUES (16, 32, 32, '2018/11/07', 93.45, 'Shipped');
INSERT INTO "order" (id, id_user, id_address_invoce, date, total, state)
    VALUES (17, 33, 33, '2019/06/09', 84.31, 'Shipped');
INSERT INTO "order" (id, id_user, id_address_invoce, date, total, state)
    VALUES (18, 18, 18, '2018/09/04', 61.27, 'Shipped');
INSERT INTO "order" (id, id_user, id_address_invoce, date, total, state)
    VALUES (19, 35, 35, '2018/07/20', 21.0, 'Delivered');
INSERT INTO "order" (id, id_user, id_address_invoce, date, total, state)
    VALUES (20, 8, 8, '2018/12/09', 60.87, 'Processing');
INSERT INTO "order" (id, id_user, id_address_invoce, date, total, state)
    VALUES (21, 28, 28, '2019/11/30', 18.26, 'Processing');
INSERT INTO "order" (id, id_user, id_address_invoce, date, total, state)
    VALUES (22, 37, 37, '2018/10/19', 33.4, 'Processing');
INSERT INTO "order" (id, id_user, id_address_invoce, date, total, state)
    VALUES (23, 19, 19, '2018/04/21', 17.19, 'Delivered');
INSERT INTO "order" (id, id_user, id_address_invoce, date, total, state)
    VALUES (24, 42, 42, '2019/06/16', 94.93, 'Processing');
INSERT INTO "order" (id, id_user, id_address_invoce, date, total, state)
    VALUES (25, 46, 46, '2018/06/12', 72.55, 'Shipped');
INSERT INTO "order" (id, id_user, id_address_invoce, date, total, state)
    VALUES (26, 50, 50, '2019/04/14', 43.76, 'Shipped');
INSERT INTO "order" (id, id_user, id_address_invoce, date, total, state)
    VALUES (27, 41, 41, '2018/05/26', 26.48, 'Shipped');
INSERT INTO "order" (id, id_user, id_address_invoce, date, total, state)
    VALUES (28, 14, 14, '2019/11/22', 51.41, 'Shipped');
INSERT INTO "order" (id, id_user, id_address_invoce, date, total, state)
    VALUES (29, 26, 26, '2019/09/02', 68.96, 'Delivered');
INSERT INTO "order" (id, id_user, id_address_invoce, date, total, state)
    VALUES (30, 24, 24, '2018/10/06', 11.94, 'Shipped');
-----------------------------------------
-- line item
-----------------------------------------

INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (1, 73, 2, 74.78);
INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (2, 51, 3, 14.73);
INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (3, 7, 5, 80.09);
INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (4, 38, 8, 74.23);
INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (5, 85, 9, 69.11);
INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (6, 83, 3, 27.11);
INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (7, 41, 1, 42.09);
INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (8, 17, 5, 32.4);
INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (9, 27, 10, 17.29);
INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (10, 78, 9, 93.64);
INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (11, 31, 10, 42.98);
INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (12, 90, 10, 46.9);
INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (13, 17, 5, 8.69);
INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (14, 42, 2, 68.8);
INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (15, 57, 5, 22.32);
INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (16, 42, 7, 76.8);
INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (17, 42, 6, 89.61);
INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (18, 73, 6, 89.3);
INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (19, 96, 8, 46.94);
INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (20, 8, 8, 48.84);
INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (21, 23, 7, 5.85);
INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (22, 47, 9, 42.89);
INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (23, 70, 7, 88.93);
INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (24, 44, 4, 90.9);
INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (25, 92, 4, 78.82);
INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (26, 66, 3, 69.26);
INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (27, 77, 8, 5.56);
INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (28, 19, 2, 69.06);
INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (29, 53, 2, 67.51);
INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (30, 66, 5, 98.81);
INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (31, 31, 10, 83.65);
INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (32, 27, 10, 29.65);
INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (33, 62, 5, 14.67);
INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (34, 31, 10, 58.67);
INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (35, 83, 3, 66.29);
INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (36, 3, 3, 72.91);
INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (37, 80, 10, 81.77);
INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (38, 23, 1, 35.64);
INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (39, 16, 6, 94.46);
INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (40, 43, 10, 81.41);
INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (41, 32, 3, 42.77);
INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (42, 52, 2, 4.96);
INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (43, 23, 4, 18.43);
INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (44, 18, 2, 35.43);
INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (45, 91, 1, 85.04);
INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (46, 3, 4, 58.04);
INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (47, 98, 9, 36.79);
INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (48, 6, 4, 35.05);
INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (49, 37, 10, 46.84);
INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (50, 84, 2, 80.97);
INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (51, 78, 6, 31.46);
INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (52, 12, 10, 34.82);
INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (53, 10, 9, 2.87);
INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (54, 91, 9, 49.24);
INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (55, 72, 2, 4.51);
INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (56, 59, 4, 67.63);
INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (57, 32, 5, 10.58);
INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (58, 72, 5, 66.69);
INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (59, 57, 9, 11.14);
INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (60, 73, 7, 48.97);
INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (61, 20, 8, 79.04);
INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (62, 38, 8, 37.05);
INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (63, 61, 9, 85.25);
INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (64, 42, 1, 34.83);
INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (65, 61, 10, 82.29);
INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (66, 29, 7, 15.97);
INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (67, 90, 1, 14.29);
INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (68, 1, 2, 40.92);
INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (69, 12, 10, 82.77);
INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (70, 19, 3, 91.54);
INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (71, 45, 5, 18.45);
INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (72, 83, 3, 37.93);
INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (73, 29, 10, 87.47);
INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (74, 12, 9, 11.96);
INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (75, 32, 8, 78.79);
INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (76, 11, 5, 53.2);
INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (77, 51, 1, 78.2);
INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (78, 37, 8, 33.23);
INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (79, 33, 3, 40.09);
INSERT INTO line_item (id, id_product, quantity, price)
    VALUES (80, 38, 9, 64.4);
-----------------------------------------
-- line_item cart
-----------------------------------------

INSERT INTO line_item_cart (id_line_item, id_cart)
    VALUES (1, 27);
INSERT INTO line_item_cart (id_line_item, id_cart)
    VALUES (2, 34);
INSERT INTO line_item_cart (id_line_item, id_cart)
    VALUES (3, 34);
INSERT INTO line_item_cart (id_line_item, id_cart)
    VALUES (4, 2);
INSERT INTO line_item_cart (id_line_item, id_cart)
    VALUES (5, 42);
INSERT INTO line_item_cart (id_line_item, id_cart)
    VALUES (6, 24);
INSERT INTO line_item_cart (id_line_item, id_cart)
    VALUES (7, 9);
INSERT INTO line_item_cart (id_line_item, id_cart)
    VALUES (8, 12);
INSERT INTO line_item_cart (id_line_item, id_cart)
    VALUES (9, 38);
INSERT INTO line_item_cart (id_line_item, id_cart)
    VALUES (10, 21);
INSERT INTO line_item_cart (id_line_item, id_cart)
    VALUES (11, 32);
INSERT INTO line_item_cart (id_line_item, id_cart)
    VALUES (12, 29);
INSERT INTO line_item_cart (id_line_item, id_cart)
    VALUES (13, 20);
INSERT INTO line_item_cart (id_line_item, id_cart)
    VALUES (14, 3);
INSERT INTO line_item_cart (id_line_item, id_cart)
    VALUES (15, 45);
INSERT INTO line_item_cart (id_line_item, id_cart)
    VALUES (16, 35);
INSERT INTO line_item_cart (id_line_item, id_cart)
    VALUES (17, 30);
INSERT INTO line_item_cart (id_line_item, id_cart)
    VALUES (18, 7);
INSERT INTO line_item_cart (id_line_item, id_cart)
    VALUES (19, 25);
INSERT INTO line_item_cart (id_line_item, id_cart)
    VALUES (20, 8);
INSERT INTO line_item_cart (id_line_item, id_cart)
    VALUES (21, 33);
INSERT INTO line_item_cart (id_line_item, id_cart)
    VALUES (22, 4);
INSERT INTO line_item_cart (id_line_item, id_cart)
    VALUES (23, 9);
INSERT INTO line_item_cart (id_line_item, id_cart)
    VALUES (24, 45);
INSERT INTO line_item_cart (id_line_item, id_cart)
    VALUES (25, 27);
INSERT INTO line_item_cart (id_line_item, id_cart)
    VALUES (26, 45);
INSERT INTO line_item_cart (id_line_item, id_cart)
    VALUES (27, 42);
INSERT INTO line_item_cart (id_line_item, id_cart)
    VALUES (28, 20);
INSERT INTO line_item_cart (id_line_item, id_cart)
    VALUES (29, 41);
INSERT INTO line_item_cart (id_line_item, id_cart)
    VALUES (30, 32);
INSERT INTO line_item_cart (id_line_item, id_cart)
    VALUES (31, 5);
INSERT INTO line_item_cart (id_line_item, id_cart)
    VALUES (32, 24);
INSERT INTO line_item_cart (id_line_item, id_cart)
    VALUES (33, 35);
INSERT INTO line_item_cart (id_line_item, id_cart)
    VALUES (34, 30);
INSERT INTO line_item_cart (id_line_item, id_cart)
    VALUES (35, 27);
INSERT INTO line_item_cart (id_line_item, id_cart)
    VALUES (36, 43);
INSERT INTO line_item_cart (id_line_item, id_cart)
    VALUES (37, 27);
INSERT INTO line_item_cart (id_line_item, id_cart)
    VALUES (38, 20);
INSERT INTO line_item_cart (id_line_item, id_cart)
    VALUES (39, 16);
INSERT INTO line_item_cart (id_line_item, id_cart)
    VALUES (40, 48);
-----------------------------------------
-- line item order
-----------------------------------------

INSERT INTO line_item_order (id_line_item, id_order)
    VALUES (41, 14);
INSERT INTO line_item_order (id_line_item, id_order)
    VALUES (42, 14);
INSERT INTO line_item_order (id_line_item, id_order)
    VALUES (43, 3);
INSERT INTO line_item_order (id_line_item, id_order)
    VALUES (44, 13);
INSERT INTO line_item_order (id_line_item, id_order)
    VALUES (45, 22);
INSERT INTO line_item_order (id_line_item, id_order)
    VALUES (46, 7);
INSERT INTO line_item_order (id_line_item, id_order)
    VALUES (47, 18);
INSERT INTO line_item_order (id_line_item, id_order)
    VALUES (48, 27);
INSERT INTO line_item_order (id_line_item, id_order)
    VALUES (49, 30);
INSERT INTO line_item_order (id_line_item, id_order)
    VALUES (50, 14);
INSERT INTO line_item_order (id_line_item, id_order)
    VALUES (51, 21);
INSERT INTO line_item_order (id_line_item, id_order)
    VALUES (52, 14);
INSERT INTO line_item_order (id_line_item, id_order)
    VALUES (53, 22);
INSERT INTO line_item_order (id_line_item, id_order)
    VALUES (54, 24);
INSERT INTO line_item_order (id_line_item, id_order)
    VALUES (55, 16);
INSERT INTO line_item_order (id_line_item, id_order)
    VALUES (56, 18);
INSERT INTO line_item_order (id_line_item, id_order)
    VALUES (57, 15);
INSERT INTO line_item_order (id_line_item, id_order)
    VALUES (58, 6);
INSERT INTO line_item_order (id_line_item, id_order)
    VALUES (59, 16);
INSERT INTO line_item_order (id_line_item, id_order)
    VALUES (60, 15);
INSERT INTO line_item_order (id_line_item, id_order)
    VALUES (62, 28);
INSERT INTO line_item_order (id_line_item, id_order)
    VALUES (63, 4);
INSERT INTO line_item_order (id_line_item, id_order)
    VALUES (64, 11);
INSERT INTO line_item_order (id_line_item, id_order)
    VALUES (65, 18);
INSERT INTO line_item_order (id_line_item, id_order)
    VALUES (66, 22);
INSERT INTO line_item_order (id_line_item, id_order)
    VALUES (67, 6);
INSERT INTO line_item_order (id_line_item, id_order)
    VALUES (68, 7);
INSERT INTO line_item_order (id_line_item, id_order)
    VALUES (69, 14);
INSERT INTO line_item_order (id_line_item, id_order)
    VALUES (70, 12);
INSERT INTO line_item_order (id_line_item, id_order)
    VALUES (71, 25);
INSERT INTO line_item_order (id_line_item, id_order)
    VALUES (72, 26);
INSERT INTO line_item_order (id_line_item, id_order)
    VALUES (73, 11);
INSERT INTO line_item_order (id_line_item, id_order)
    VALUES (74, 25);
INSERT INTO line_item_order (id_line_item, id_order)
    VALUES (75, 7);
INSERT INTO line_item_order (id_line_item, id_order)
    VALUES (76, 5);
INSERT INTO line_item_order (id_line_item, id_order)
    VALUES (78, 26);
INSERT INTO line_item_order (id_line_item, id_order)
    VALUES (79, 5);
-----------------------------------------
-- brand
-----------------------------------------

INSERT INTO brand (id, name)
    VALUES (1, 'The North Face');
INSERT INTO brand (id, name)
    VALUES (2, 'Arc’teryx');
INSERT INTO brand (id, name)
    VALUES (3, 'Cotopaxi');
INSERT INTO brand (id, name)
    VALUES (4, 'Columbia');
INSERT INTO brand (id, name)
    VALUES (5, 'Kuhl');
INSERT INTO brand (id, name)
    VALUES (6, 'Kathmandu');
INSERT INTO brand (id, name)
    VALUES (7, 'Patagonia');
INSERT INTO brand (id, name)
    VALUES (8, 'Timberland');
INSERT INTO brand (id, name)
    VALUES (9, 'Marmot');
INSERT INTO brand (id, name)
    VALUES (10, 'Osprey');
INSERT INTO brand (id, name)
    VALUES (11, 'Bambool');
INSERT INTO brand (id, name)
    VALUES (12, 'Alps & Meters');
INSERT INTO brand (id, name)
    VALUES (13, 'Beyond Clothing');
INSERT INTO brand (id, name)
    VALUES (14, 'Black Yak');
INSERT INTO brand (id, name)
    VALUES (15, 'Duckworth');
INSERT INTO brand (id, name)
    VALUES (16, 'Goldwin');
INSERT INTO brand (id, name)
    VALUES (17, 'Good to Go');
INSERT INTO brand (id, name)
    VALUES (18, 'Heimplanet');
INSERT INTO brand (id, name)
    VALUES (19, 'Klattermusen');
INSERT INTO brand (id, name)
    VALUES (20, 'Matador');
-----------------------------------------
-- color
-----------------------------------------

INSERT INTO color (id, name)
    VALUES (1, 'Red');
INSERT INTO color (id, name)
    VALUES (2, 'Blue');
INSERT INTO color (id, name)
    VALUES (3, 'Black');
INSERT INTO color (id, name)
    VALUES (4, 'Navy');
INSERT INTO color (id, name)
    VALUES (5, 'Yellow');
INSERT INTO color (id, name)
    VALUES (6, 'Green');
INSERT INTO color (id, name)
    VALUES (7, 'Camell');
INSERT INTO color (id, name)
    VALUES (8, 'Purple');
INSERT INTO color (id, name)
    VALUES (9, 'Multi');
INSERT INTO color (id, name)
    VALUES (10, 'Brown');
-----------------------------------------
-- size
-----------------------------------------

INSERT INTO size (id, name)
    VALUES (1, 'XXS');
INSERT INTO size (id, name)
    VALUES (2, 'XS');
INSERT INTO size (id, name)
    VALUES (3, 'S');
INSERT INTO size (id, name)
    VALUES (4, 'M');
INSERT INTO size (id, name)
    VALUES (5, 'L');
INSERT INTO size (id, name)
    VALUES (6, 'XL');
INSERT INTO size (id, name)
    VALUES (7, 'XXL');
-----------------------------------------
-- favorites
-----------------------------------------

INSERT INTO favorites (id_user, id_product)
    VALUES (49, 40);
INSERT INTO favorites (id_user, id_product)
    VALUES (12, 44);
INSERT INTO favorites (id_user, id_product)
    VALUES (1, 90);
INSERT INTO favorites (id_user, id_product)
    VALUES (21, 96);
INSERT INTO favorites (id_user, id_product)
    VALUES (25, 8);
INSERT INTO favorites (id_user, id_product)
    VALUES (23, 60);
INSERT INTO favorites (id_user, id_product)
    VALUES (38, 28);
INSERT INTO favorites (id_user, id_product)
    VALUES (26, 66);
INSERT INTO favorites (id_user, id_product)
    VALUES (1, 57);
INSERT INTO favorites (id_user, id_product)
    VALUES (41, 96);
INSERT INTO favorites (id_user, id_product)
    VALUES (15, 76);
INSERT INTO favorites (id_user, id_product)
    VALUES (24, 21);
INSERT INTO favorites (id_user, id_product)
    VALUES (7, 60);
INSERT INTO favorites (id_user, id_product)
    VALUES (27, 25);
INSERT INTO favorites (id_user, id_product)
    VALUES (14, 64);
INSERT INTO favorites (id_user, id_product)
    VALUES (7, 1);
INSERT INTO favorites (id_user, id_product)
    VALUES (19, 98);
INSERT INTO favorites (id_user, id_product)
    VALUES (27, 59);
INSERT INTO favorites (id_user, id_product)
    VALUES (49, 6);
INSERT INTO favorites (id_user, id_product)
    VALUES (48, 81);
INSERT INTO favorites (id_user, id_product)
    VALUES (50, 85);
INSERT INTO favorites (id_user, id_product)
    VALUES (19, 2);
INSERT INTO favorites (id_user, id_product)
    VALUES (15, 27);
INSERT INTO favorites (id_user, id_product)
    VALUES (19, 22);
INSERT INTO favorites (id_user, id_product)
    VALUES (48, 23);
INSERT INTO favorites (id_user, id_product)
    VALUES (16, 14);
INSERT INTO favorites (id_user, id_product)
    VALUES (41, 12);
INSERT INTO favorites (id_user, id_product)
    VALUES (13, 75);
INSERT INTO favorites (id_user, id_product)
    VALUES (24, 96);
INSERT INTO favorites (id_user, id_product)
    VALUES (39, 67);
INSERT INTO favorites (id_user, id_product)
    VALUES (34, 40);
INSERT INTO favorites (id_user, id_product)
    VALUES (2, 5);
INSERT INTO favorites (id_user, id_product)
    VALUES (12, 72);
INSERT INTO favorites (id_user, id_product)
    VALUES (44, 85);
INSERT INTO favorites (id_user, id_product)
    VALUES (24, 24);
INSERT INTO favorites (id_user, id_product)
    VALUES (2, 42);
INSERT INTO favorites (id_user, id_product)
    VALUES (36, 41);
INSERT INTO favorites (id_user, id_product)
    VALUES (45, 95);
INSERT INTO favorites (id_user, id_product)
    VALUES (4, 47);
INSERT INTO favorites (id_user, id_product)
    VALUES (36, 62);
INSERT INTO favorites (id_user, id_product)
    VALUES (14, 59);
INSERT INTO favorites (id_user, id_product)
    VALUES (38, 82);
INSERT INTO favorites (id_user, id_product)
    VALUES (44, 8);
INSERT INTO favorites (id_user, id_product)
    VALUES (29, 30);
INSERT INTO favorites (id_user, id_product)
    VALUES (7, 24);
INSERT INTO favorites (id_user, id_product)
    VALUES (21, 5);
INSERT INTO favorites (id_user, id_product)
    VALUES (4, 24);
INSERT INTO favorites (id_user, id_product)
    VALUES (26, 36);
INSERT INTO favorites (id_user, id_product)
    VALUES (45, 30);
INSERT INTO favorites (id_user, id_product)
    VALUES (46, 64);
INSERT INTO favorites (id_user, id_product)
    VALUES (44, 82);
INSERT INTO favorites (id_user, id_product)
    VALUES (46, 45);
INSERT INTO favorites (id_user, id_product)
    VALUES (27, 15);
INSERT INTO favorites (id_user, id_product)
    VALUES (44, 5);
INSERT INTO favorites (id_user, id_product)
    VALUES (47, 99);
INSERT INTO favorites (id_user, id_product)
    VALUES (32, 73);
INSERT INTO favorites (id_user, id_product)
    VALUES (48, 34);
INSERT INTO favorites (id_user, id_product)
    VALUES (6, 44);
INSERT INTO favorites (id_user, id_product)
    VALUES (44, 68);
INSERT INTO favorites (id_user, id_product)
    VALUES (2, 49);
-----------------------------------------
-- report
-----------------------------------------

INSERT INTO report (id_review, id_user_reportee)
    VALUES (8, 18);
INSERT INTO report (id_review, id_user_reportee)
    VALUES (16, 19);
INSERT INTO report (id_review, id_user_reportee)
    VALUES (16, 1);
INSERT INTO report (id_review, id_user_reportee)
    VALUES (13, 46);
INSERT INTO report (id_review, id_user_reportee)
    VALUES (16, 11);
INSERT INTO report (id_review, id_user_reportee)
    VALUES (6, 30);
INSERT INTO report (id_review, id_user_reportee)
    VALUES (3, 3);
INSERT INTO report (id_review, id_user_reportee)
    VALUES (4, 49);
INSERT INTO report (id_review, id_user_reportee)
    VALUES (12, 36);
INSERT INTO report (id_review, id_user_reportee)
    VALUES (2, 20);
INSERT INTO report (id_review, id_user_reportee)
    VALUES (6, 41);
INSERT INTO report (id_review, id_user_reportee)
    VALUES (18, 12);
INSERT INTO report (id_review, id_user_reportee)
    VALUES (16, 28);
INSERT INTO report (id_review, id_user_reportee)
    VALUES (2, 43);
INSERT INTO report (id_review, id_user_reportee)
    VALUES (5, 9);
INSERT INTO report (id_review, id_user_reportee)
    VALUES (19, 42);
INSERT INTO report (id_review, id_user_reportee)
    VALUES (14, 11);
INSERT INTO report (id_review, id_user_reportee)
    VALUES (14, 37);
INSERT INTO report (id_review, id_user_reportee)
    VALUES (1, 7);
INSERT INTO report (id_review, id_user_reportee)
    VALUES (16, 6);
-----------------------------------------
-- reportear
-----------------------------------------

INSERT INTO reportear (id_review, id_user_reportear)
    VALUES (8, 12);
INSERT INTO reportear (id_review, id_user_reportear)
    VALUES (16, 10);
INSERT INTO reportear (id_review, id_user_reportear)
    VALUES (16, 15);
INSERT INTO reportear (id_review, id_user_reportear)
    VALUES (13, 41);
INSERT INTO reportear (id_review, id_user_reportear)
    VALUES (16, 34);
INSERT INTO reportear (id_review, id_user_reportear)
    VALUES (6, 12);
INSERT INTO reportear (id_review, id_user_reportear)
    VALUES (3, 9);
INSERT INTO reportear (id_review, id_user_reportear)
    VALUES (4, 4);
INSERT INTO reportear (id_review, id_user_reportear)
    VALUES (12, 26);
INSERT INTO reportear (id_review, id_user_reportear)
    VALUES (2, 19);
INSERT INTO reportear (id_review, id_user_reportear)
    VALUES (6, 1);
INSERT INTO reportear (id_review, id_user_reportear)
    VALUES (18, 42);
INSERT INTO reportear (id_review, id_user_reportear)
    VALUES (16, 48);
INSERT INTO reportear (id_review, id_user_reportear)
    VALUES (2, 45);
INSERT INTO reportear (id_review, id_user_reportear)
    VALUES (5, 37);
INSERT INTO reportear (id_review, id_user_reportear)
    VALUES (19, 12);
INSERT INTO reportear (id_review, id_user_reportear)
    VALUES (14, 14);
INSERT INTO reportear (id_review, id_user_reportear)
    VALUES (14, 48);
INSERT INTO reportear (id_review, id_user_reportear)
    VALUES (1, 9);
INSERT INTO reportear (id_review, id_user_reportear)
    VALUES (16, 2);
-----------------------------------------
-- analyze
-----------------------------------------

INSERT INTO "analyze" (id_review, id_user_analyze)
    VALUES (8, 35);
INSERT INTO "analyze" (id_review, id_user_analyze)
    VALUES (13, 35);
INSERT INTO "analyze" (id_review, id_user_analyze)
    VALUES (16, 35);
INSERT INTO "analyze" (id_review, id_user_analyze)
    VALUES (3, 35);
INSERT INTO "analyze" (id_review, id_user_analyze)
    VALUES (4, 35);
INSERT INTO "analyze" (id_review, id_user_analyze)
    VALUES (12, 35);
INSERT INTO "analyze" (id_review, id_user_analyze)
    VALUES (6, 35);
INSERT INTO "analyze" (id_review, id_user_analyze)
    VALUES (18, 35);
INSERT INTO "analyze" (id_review, id_user_analyze)
    VALUES (2, 35);
INSERT INTO "analyze" (id_review, id_user_analyze)
    VALUES (5, 35);
INSERT INTO "analyze" (id_review, id_user_analyze)
    VALUES (19, 35);
INSERT INTO "analyze" (id_review, id_user_analyze)
    VALUES (14, 35);
INSERT INTO "analyze" (id_review, id_user_analyze)
    VALUES (1, 35);
-----------------------------------------
-- product Category
-----------------------------------------

INSERT INTO product_categories (id_product, id_categories)
    VALUES (1, 6);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (2, 1);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (3, 7);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (3, 4);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (3, 13);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (4, 7);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (4, 4);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (4, 13);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (4, 17);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (5, 7);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (5, 4);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (5, 13);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (5, 17);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (6, 7);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (6, 4);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (6, 13);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (6, 17);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (7, 2);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (7, 13);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (7, 14);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (8, 2);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (8, 13);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (8, 14);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (9, 2);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (9, 13);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (9, 14);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (10, 2);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (10, 13);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (10, 14);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (11, 2);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (11, 13);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (11, 14);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (12, 2);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (12, 13);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (12, 14);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (13, 2);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (13, 13);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (13, 14);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (14, 2);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (14, 14);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (15, 2);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (15, 14);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (16, 2);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (16, 14);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (16, 16);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (16, 17);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (17, 2);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (17, 13);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (17, 14);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (17, 15);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (17, 17);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (18, 7);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (18, 13);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (18, 14);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (18, 15);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (18, 17);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (19, 6);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (19, 13);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (19, 14);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (19, 15);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (19, 17);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (20, 6);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (21, 6);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (22, 6);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (23, 6);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (24, 9);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (24, 12);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (24, 14);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (24, 17);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (25, 9);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (25, 12);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (25, 14);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (25, 17);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (26, 9);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (26, 12);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (26, 14);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (26, 17);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (27, 9);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (27, 12);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (27, 14);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (27, 17);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (28, 9);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (28, 12);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (28, 14);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (28, 17);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (29, 9);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (29, 12);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (29, 14);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (29, 17);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (30, 9);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (30, 12);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (30, 14);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (30, 17);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (31, 9);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (31, 12);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (31, 14);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (31, 17);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (32, 9);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (32, 12);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (32, 14);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (32, 17);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (33, 10);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (33, 12);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (33, 14);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (33, 15);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (33, 16);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (33, 17);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (34, 13);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (34, 14);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (34, 15);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (35, 13);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (35, 14);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (35, 15);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (36, 13);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (36, 14);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (36, 15);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (37, 13);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (37, 14);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (37, 15);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (38, 13);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (38, 14);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (38, 15);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (39, 4);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (39, 7);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (39, 16);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (40, 13);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (40, 14);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (40, 15);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (41, 13);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (41, 14);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (41, 15);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (42, 13);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (42, 14);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (42, 15);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (43, 4);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (43, 7);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (44, 1);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (45, 1);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (46, 2);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (47, 6);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (48, 2);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (49, 7);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (50, 5);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (50, 8);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (51, 9);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (52, 5);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (52, 8);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (53, 17);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (53, 14);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (54, 14);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (55, 13);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (56, 10);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (57, 9);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (58, 4);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (59, 13);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (60, 7);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (61, 1);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (62, 8);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (63, 8);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (64, 10);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (65, 15);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (66, 13);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (67, 11);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (68, 14);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (69, 1);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (70, 3);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (71, 16);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (72, 10);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (73, 16);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (74, 13);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (75, 16);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (76, 12);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (77, 13);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (78, 4);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (79, 7);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (80, 17);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (81, 11);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (82, 14);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (83, 9);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (84, 17);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (85, 17);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (86, 11);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (87, 14);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (88, 9);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (89, 17);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (90, 1);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (91, 5);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (92, 5);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (93, 6);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (94, 1);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (95, 11);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (96, 4);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (97, 4);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (98, 2);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (99, 7);
INSERT INTO product_categories (id_product, id_categories)
    VALUES (100, 4);
-----------------------------------------
-- product color
-----------------------------------------

INSERT INTO product_color (id_product, id_color)
    VALUES (1, 7);
INSERT INTO product_color (id_product, id_color)
    VALUES (1, 3);
INSERT INTO product_color (id_product, id_color)
    VALUES (1, 4);
INSERT INTO product_color (id_product, id_color)
    VALUES (2, 2);
INSERT INTO product_color (id_product, id_color)
    VALUES (2, 3);
INSERT INTO product_color (id_product, id_color)
    VALUES (2, 5);
INSERT INTO product_color (id_product, id_color)
    VALUES (3, 3);
INSERT INTO product_color (id_product, id_color)
    VALUES (3, 7);
INSERT INTO product_color (id_product, id_color)
    VALUES (3, 10);
INSERT INTO product_color (id_product, id_color)
    VALUES (4, 3);
INSERT INTO product_color (id_product, id_color)
    VALUES (4, 4);
INSERT INTO product_color (id_product, id_color)
    VALUES (4, 7);
INSERT INTO product_color (id_product, id_color)
    VALUES (4, 10);
INSERT INTO product_color (id_product, id_color)
    VALUES (5, 3);
INSERT INTO product_color (id_product, id_color)
    VALUES (5, 4);
INSERT INTO product_color (id_product, id_color)
    VALUES (5, 6);
INSERT INTO product_color (id_product, id_color)
    VALUES (5, 9);
INSERT INTO product_color (id_product, id_color)
    VALUES (6, 3);
INSERT INTO product_color (id_product, id_color)
    VALUES (6, 4);
INSERT INTO product_color (id_product, id_color)
    VALUES (6, 6);
INSERT INTO product_color (id_product, id_color)
    VALUES (6, 10);
INSERT INTO product_color (id_product, id_color)
    VALUES (7, 3);
INSERT INTO product_color (id_product, id_color)
    VALUES (7, 4);
INSERT INTO product_color (id_product, id_color)
    VALUES (7, 6);
INSERT INTO product_color (id_product, id_color)
    VALUES (7, 10);
INSERT INTO product_color (id_product, id_color)
    VALUES (8, 3);
INSERT INTO product_color (id_product, id_color)
    VALUES (9, 3);
INSERT INTO product_color (id_product, id_color)
    VALUES (9, 4);
INSERT INTO product_color (id_product, id_color)
    VALUES (10, 1);
INSERT INTO product_color (id_product, id_color)
    VALUES (11, 9);
INSERT INTO product_color (id_product, id_color)
    VALUES (12, 9);
INSERT INTO product_color (id_product, id_color)
    VALUES (13, 2);
INSERT INTO product_color (id_product, id_color)
    VALUES (14, 3);
INSERT INTO product_color (id_product, id_color)
    VALUES (15, 3);
INSERT INTO product_color (id_product, id_color)
    VALUES (15, 4);
INSERT INTO product_color (id_product, id_color)
    VALUES (16, 3);
INSERT INTO product_color (id_product, id_color)
    VALUES (16, 6);
INSERT INTO product_color (id_product, id_color)
    VALUES (16, 10);
INSERT INTO product_color (id_product, id_color)
    VALUES (17, 2);
INSERT INTO product_color (id_product, id_color)
    VALUES (17, 3);
INSERT INTO product_color (id_product, id_color)
    VALUES (17, 4);
INSERT INTO product_color (id_product, id_color)
    VALUES (17, 6);
INSERT INTO product_color (id_product, id_color)
    VALUES (18, 2);
INSERT INTO product_color (id_product, id_color)
    VALUES (18, 3);
INSERT INTO product_color (id_product, id_color)
    VALUES (18, 4);
INSERT INTO product_color (id_product, id_color)
    VALUES (18, 10);
INSERT INTO product_color (id_product, id_color)
    VALUES (18, 9);
INSERT INTO product_color (id_product, id_color)
    VALUES (19, 4);
INSERT INTO product_color (id_product, id_color)
    VALUES (19, 7);
INSERT INTO product_color (id_product, id_color)
    VALUES (19, 10);
INSERT INTO product_color (id_product, id_color)
    VALUES (19, 5);
INSERT INTO product_color (id_product, id_color)
    VALUES (20, 9);
INSERT INTO product_color (id_product, id_color)
    VALUES (21, 4);
INSERT INTO product_color (id_product, id_color)
    VALUES (22, 7);
INSERT INTO product_color (id_product, id_color)
    VALUES (23, 10);
INSERT INTO product_color (id_product, id_color)
    VALUES (24, 9);
INSERT INTO product_color (id_product, id_color)
    VALUES (25, 9);
INSERT INTO product_color (id_product, id_color)
    VALUES (26, 9);
INSERT INTO product_color (id_product, id_color)
    VALUES (27, 9);
INSERT INTO product_color (id_product, id_color)
    VALUES (28, 9);
INSERT INTO product_color (id_product, id_color)
    VALUES (29, 9);
INSERT INTO product_color (id_product, id_color)
    VALUES (30, 9);
INSERT INTO product_color (id_product, id_color)
    VALUES (31, 9);
INSERT INTO product_color (id_product, id_color)
    VALUES (32, 9);
INSERT INTO product_color (id_product, id_color)
    VALUES (33, 9);
INSERT INTO product_color (id_product, id_color)
    VALUES (34, 9);
INSERT INTO product_color (id_product, id_color)
    VALUES (35, 9);
INSERT INTO product_color (id_product, id_color)
    VALUES (36, 9);
INSERT INTO product_color (id_product, id_color)
    VALUES (37, 9);
INSERT INTO product_color (id_product, id_color)
    VALUES (38, 9);
INSERT INTO product_color (id_product, id_color)
    VALUES (39, 2);
INSERT INTO product_color (id_product, id_color)
    VALUES (39, 3);
INSERT INTO product_color (id_product, id_color)
    VALUES (39, 5);
INSERT INTO product_color (id_product, id_color)
    VALUES (40, 9);
INSERT INTO product_color (id_product, id_color)
    VALUES (41, 9);
INSERT INTO product_color (id_product, id_color)
    VALUES (42, 9);
INSERT INTO product_color (id_product, id_color)
    VALUES (43, 6);
INSERT INTO product_color (id_product, id_color)
    VALUES (44, 2);
INSERT INTO product_color (id_product, id_color)
    VALUES (45, 6);
INSERT INTO product_color (id_product, id_color)
    VALUES (46, 3);
INSERT INTO product_color (id_product, id_color)
    VALUES (47, 2);
INSERT INTO product_color (id_product, id_color)
    VALUES (48, 9);
INSERT INTO product_color (id_product, id_color)
    VALUES (49, 2);
INSERT INTO product_color (id_product, id_color)
    VALUES (50, 9);
INSERT INTO product_color (id_product, id_color)
    VALUES (51, 6);
INSERT INTO product_color (id_product, id_color)
    VALUES (52, 2);
INSERT INTO product_color (id_product, id_color)
    VALUES (53, 9);
INSERT INTO product_color (id_product, id_color)
    VALUES (54, 4);
INSERT INTO product_color (id_product, id_color)
    VALUES (55, 2);
INSERT INTO product_color (id_product, id_color)
    VALUES (56, 1);
INSERT INTO product_color (id_product, id_color)
    VALUES (57, 9);
INSERT INTO product_color (id_product, id_color)
    VALUES (58, 7);
INSERT INTO product_color (id_product, id_color)
    VALUES (59, 10);
INSERT INTO product_color (id_product, id_color)
    VALUES (60, 10);
INSERT INTO product_color (id_product, id_color)
    VALUES (61, 6);
INSERT INTO product_color (id_product, id_color)
    VALUES (62, 8);
INSERT INTO product_color (id_product, id_color)
    VALUES (63, 1);
INSERT INTO product_color (id_product, id_color)
    VALUES (64, 4);
INSERT INTO product_color (id_product, id_color)
    VALUES (65, 4);
INSERT INTO product_color (id_product, id_color)
    VALUES (66, 10);
INSERT INTO product_color (id_product, id_color)
    VALUES (67, 6);
INSERT INTO product_color (id_product, id_color)
    VALUES (68, 4);
INSERT INTO product_color (id_product, id_color)
    VALUES (69, 8);
INSERT INTO product_color (id_product, id_color)
    VALUES (70, 4);
INSERT INTO product_color (id_product, id_color)
    VALUES (71, 5);
INSERT INTO product_color (id_product, id_color)
    VALUES (72, 2);
INSERT INTO product_color (id_product, id_color)
    VALUES (73, 7);
INSERT INTO product_color (id_product, id_color)
    VALUES (74, 7);
INSERT INTO product_color (id_product, id_color)
    VALUES (75, 3);
INSERT INTO product_color (id_product, id_color)
    VALUES (76, 2);
INSERT INTO product_color (id_product, id_color)
    VALUES (77, 5);
INSERT INTO product_color (id_product, id_color)
    VALUES (78, 9);
INSERT INTO product_color (id_product, id_color)
    VALUES (79, 5);
INSERT INTO product_color (id_product, id_color)
    VALUES (80, 6);
INSERT INTO product_color (id_product, id_color)
    VALUES (81, 10);
INSERT INTO product_color (id_product, id_color)
    VALUES (82, 10);
INSERT INTO product_color (id_product, id_color)
    VALUES (83, 8);
INSERT INTO product_color (id_product, id_color)
    VALUES (84, 9);
INSERT INTO product_color (id_product, id_color)
    VALUES (85, 9);
INSERT INTO product_color (id_product, id_color)
    VALUES (86, 7);
INSERT INTO product_color (id_product, id_color)
    VALUES (87, 10);
INSERT INTO product_color (id_product, id_color)
    VALUES (88, 6);
INSERT INTO product_color (id_product, id_color)
    VALUES (89, 2);
INSERT INTO product_color (id_product, id_color)
    VALUES (90, 3);
INSERT INTO product_color (id_product, id_color)
    VALUES (91, 6);
INSERT INTO product_color (id_product, id_color)
    VALUES (92, 6);
INSERT INTO product_color (id_product, id_color)
    VALUES (93, 8);
INSERT INTO product_color (id_product, id_color)
    VALUES (94, 7);
INSERT INTO product_color (id_product, id_color)
    VALUES (95, 10);
INSERT INTO product_color (id_product, id_color)
    VALUES (96, 1);
INSERT INTO product_color (id_product, id_color)
    VALUES (97, 2);
INSERT INTO product_color (id_product, id_color)
    VALUES (98, 9);
INSERT INTO product_color (id_product, id_color)
    VALUES (99, 10);
INSERT INTO product_color (id_product, id_color)
    VALUES (100, 9);
-----------------------------------------
-- product size
-----------------------------------------

INSERT INTO product_size (id_product, id_size)
    VALUES (1, 3);
INSERT INTO product_size (id_product, id_size)
    VALUES (1, 4);
INSERT INTO product_size (id_product, id_size)
    VALUES (1, 5);
INSERT INTO product_size (id_product, id_size)
    VALUES (1, 6);
INSERT INTO product_size (id_product, id_size)
    VALUES (2, 1);
INSERT INTO product_size (id_product, id_size)
    VALUES (2, 2);
INSERT INTO product_size (id_product, id_size)
    VALUES (2, 3);
INSERT INTO product_size (id_product, id_size)
    VALUES (2, 4);
INSERT INTO product_size (id_product, id_size)
    VALUES (2, 5);
INSERT INTO product_size (id_product, id_size)
    VALUES (3, 3);
INSERT INTO product_size (id_product, id_size)
    VALUES (3, 4);
INSERT INTO product_size (id_product, id_size)
    VALUES (3, 5);
INSERT INTO product_size (id_product, id_size)
    VALUES (3, 6);
INSERT INTO product_size (id_product, id_size)
    VALUES (4, 3);
INSERT INTO product_size (id_product, id_size)
    VALUES (4, 4);
INSERT INTO product_size (id_product, id_size)
    VALUES (4, 5);
INSERT INTO product_size (id_product, id_size)
    VALUES (4, 6);
INSERT INTO product_size (id_product, id_size)
    VALUES (5, 3);
INSERT INTO product_size (id_product, id_size)
    VALUES (5, 4);
INSERT INTO product_size (id_product, id_size)
    VALUES (5, 5);
INSERT INTO product_size (id_product, id_size)
    VALUES (5, 6);
INSERT INTO product_size (id_product, id_size)
    VALUES (6, 3);
INSERT INTO product_size (id_product, id_size)
    VALUES (6, 4);
INSERT INTO product_size (id_product, id_size)
    VALUES (6, 5);
INSERT INTO product_size (id_product, id_size)
    VALUES (6, 6);
INSERT INTO product_size (id_product, id_size)
    VALUES (7, 3);
INSERT INTO product_size (id_product, id_size)
    VALUES (7, 4);
INSERT INTO product_size (id_product, id_size)
    VALUES (7, 5);
INSERT INTO product_size (id_product, id_size)
    VALUES (7, 6);
INSERT INTO product_size (id_product, id_size)
    VALUES (8, 3);
INSERT INTO product_size (id_product, id_size)
    VALUES (8, 4);
INSERT INTO product_size (id_product, id_size)
    VALUES (8, 5);
INSERT INTO product_size (id_product, id_size)
    VALUES (8, 6);
INSERT INTO product_size (id_product, id_size)
    VALUES (9, 3);
INSERT INTO product_size (id_product, id_size)
    VALUES (9, 4);
INSERT INTO product_size (id_product, id_size)
    VALUES (9, 5);
INSERT INTO product_size (id_product, id_size)
    VALUES (9, 6);
INSERT INTO product_size (id_product, id_size)
    VALUES (10, 3);
INSERT INTO product_size (id_product, id_size)
    VALUES (10, 4);
INSERT INTO product_size (id_product, id_size)
    VALUES (10, 5);
INSERT INTO product_size (id_product, id_size)
    VALUES (10, 6);
INSERT INTO product_size (id_product, id_size)
    VALUES (11, 3);
INSERT INTO product_size (id_product, id_size)
    VALUES (11, 4);
INSERT INTO product_size (id_product, id_size)
    VALUES (11, 5);
INSERT INTO product_size (id_product, id_size)
    VALUES (11, 6);
INSERT INTO product_size (id_product, id_size)
    VALUES (12, 3);
INSERT INTO product_size (id_product, id_size)
    VALUES (12, 4);
INSERT INTO product_size (id_product, id_size)
    VALUES (12, 5);
INSERT INTO product_size (id_product, id_size)
    VALUES (12, 6);
INSERT INTO product_size (id_product, id_size)
    VALUES (13, 3);
INSERT INTO product_size (id_product, id_size)
    VALUES (13, 4);
INSERT INTO product_size (id_product, id_size)
    VALUES (13, 5);
INSERT INTO product_size (id_product, id_size)
    VALUES (13, 6);
INSERT INTO product_size (id_product, id_size)
    VALUES (14, 3);
INSERT INTO product_size (id_product, id_size)
    VALUES (14, 4);
INSERT INTO product_size (id_product, id_size)
    VALUES (14, 5);
INSERT INTO product_size (id_product, id_size)
    VALUES (14, 6);
INSERT INTO product_size (id_product, id_size)
    VALUES (15, 3);
INSERT INTO product_size (id_product, id_size)
    VALUES (15, 4);
INSERT INTO product_size (id_product, id_size)
    VALUES (15, 5);
INSERT INTO product_size (id_product, id_size)
    VALUES (15, 6);
INSERT INTO product_size (id_product, id_size)
    VALUES (16, 3);
INSERT INTO product_size (id_product, id_size)
    VALUES (16, 4);
INSERT INTO product_size (id_product, id_size)
    VALUES (16, 5);
INSERT INTO product_size (id_product, id_size)
    VALUES (16, 6);
INSERT INTO product_size (id_product, id_size)
    VALUES (17, 3);
INSERT INTO product_size (id_product, id_size)
    VALUES (17, 4);
INSERT INTO product_size (id_product, id_size)
    VALUES (17, 5);
INSERT INTO product_size (id_product, id_size)
    VALUES (17, 6);
INSERT INTO product_size (id_product, id_size)
    VALUES (18, 3);
INSERT INTO product_size (id_product, id_size)
    VALUES (18, 4);
INSERT INTO product_size (id_product, id_size)
    VALUES (18, 5);
INSERT INTO product_size (id_product, id_size)
    VALUES (18, 6);
INSERT INTO product_size (id_product, id_size)
    VALUES (19, 3);
INSERT INTO product_size (id_product, id_size)
    VALUES (19, 4);
INSERT INTO product_size (id_product, id_size)
    VALUES (19, 5);
INSERT INTO product_size (id_product, id_size)
    VALUES (19, 6);
INSERT INTO product_size (id_product, id_size)
    VALUES (20, 3);
INSERT INTO product_size (id_product, id_size)
    VALUES (20, 4);
INSERT INTO product_size (id_product, id_size)
    VALUES (20, 5);
INSERT INTO product_size (id_product, id_size)
    VALUES (20, 6);
INSERT INTO product_size (id_product, id_size)
    VALUES (21, 3);
INSERT INTO product_size (id_product, id_size)
    VALUES (21, 4);
INSERT INTO product_size (id_product, id_size)
    VALUES (21, 5);
INSERT INTO product_size (id_product, id_size)
    VALUES (21, 6);
INSERT INTO product_size (id_product, id_size)
    VALUES (22, 3);
INSERT INTO product_size (id_product, id_size)
    VALUES (22, 4);
INSERT INTO product_size (id_product, id_size)
    VALUES (22, 5);
INSERT INTO product_size (id_product, id_size)
    VALUES (22, 6);
INSERT INTO product_size (id_product, id_size)
    VALUES (23, 3);
INSERT INTO product_size (id_product, id_size)
    VALUES (23, 4);
INSERT INTO product_size (id_product, id_size)
    VALUES (23, 5);
INSERT INTO product_size (id_product, id_size)
    VALUES (23, 6);
INSERT INTO product_size (id_product, id_size)
    VALUES (24, 5);
INSERT INTO product_size (id_product, id_size)
    VALUES (25, 5);
INSERT INTO product_size (id_product, id_size)
    VALUES (26, 6);
INSERT INTO product_size (id_product, id_size)
    VALUES (27, 4);
INSERT INTO product_size (id_product, id_size)
    VALUES (28, 4);
INSERT INTO product_size (id_product, id_size)
    VALUES (29, 7);
INSERT INTO product_size (id_product, id_size)
    VALUES (30, 7);
INSERT INTO product_size (id_product, id_size)
    VALUES (31, 2);
INSERT INTO product_size (id_product, id_size)
    VALUES (32, 1);
INSERT INTO product_size (id_product, id_size)
    VALUES (33, 1);
INSERT INTO product_size (id_product, id_size)
    VALUES (34, 3);
INSERT INTO product_size (id_product, id_size)
    VALUES (35, 3);
INSERT INTO product_size (id_product, id_size)
    VALUES (36, 4);
INSERT INTO product_size (id_product, id_size)
    VALUES (37, 4);
INSERT INTO product_size (id_product, id_size)
    VALUES (38, 3);
INSERT INTO product_size (id_product, id_size)
    VALUES (38, 4);
INSERT INTO product_size (id_product, id_size)
    VALUES (38, 5);
INSERT INTO product_size (id_product, id_size)
    VALUES (38, 6);
INSERT INTO product_size (id_product, id_size)
    VALUES (40, 4);
INSERT INTO product_size (id_product, id_size)
    VALUES (41, 4);
INSERT INTO product_size (id_product, id_size)
    VALUES (42, 5);
INSERT INTO product_size (id_product, id_size)
    VALUES (43, 3);
INSERT INTO product_size (id_product, id_size)
    VALUES (43, 4);
INSERT INTO product_size (id_product, id_size)
    VALUES (43, 5);
INSERT INTO product_size (id_product, id_size)
    VALUES (43, 6);
INSERT INTO product_size (id_product, id_size)
    VALUES (44, 3);
INSERT INTO product_size (id_product, id_size)
    VALUES (44, 4);
INSERT INTO product_size (id_product, id_size)
    VALUES (44, 5);
INSERT INTO product_size (id_product, id_size)
    VALUES (44, 6);
INSERT INTO product_size (id_product, id_size)
    VALUES (45, 3);
INSERT INTO product_size (id_product, id_size)
    VALUES (45, 4);
INSERT INTO product_size (id_product, id_size)
    VALUES (45, 5);
INSERT INTO product_size (id_product, id_size)
    VALUES (45, 6);
INSERT INTO product_size (id_product, id_size)
    VALUES (46, 3);
INSERT INTO product_size (id_product, id_size)
    VALUES (46, 4);
INSERT INTO product_size (id_product, id_size)
    VALUES (46, 5);
INSERT INTO product_size (id_product, id_size)
    VALUES (46, 6);
INSERT INTO product_size (id_product, id_size)
    VALUES (47, 3);
INSERT INTO product_size (id_product, id_size)
    VALUES (47, 4);
INSERT INTO product_size (id_product, id_size)
    VALUES (47, 5);
INSERT INTO product_size (id_product, id_size)
    VALUES (47, 6);
INSERT INTO product_size (id_product, id_size)
    VALUES (48, 3);
INSERT INTO product_size (id_product, id_size)
    VALUES (48, 4);
INSERT INTO product_size (id_product, id_size)
    VALUES (48, 5);
INSERT INTO product_size (id_product, id_size)
    VALUES (48, 6);
INSERT INTO product_size (id_product, id_size)
    VALUES (49, 3);
INSERT INTO product_size (id_product, id_size)
    VALUES (49, 4);
INSERT INTO product_size (id_product, id_size)
    VALUES (49, 5);
INSERT INTO product_size (id_product, id_size)
    VALUES (49, 6);
INSERT INTO product_size (id_product, id_size)
    VALUES (50, 4);
INSERT INTO product_size (id_product, id_size)
    VALUES (51, 5);
INSERT INTO product_size (id_product, id_size)
    VALUES (52, 3);
INSERT INTO product_size (id_product, id_size)
    VALUES (52, 4);
INSERT INTO product_size (id_product, id_size)
    VALUES (52, 5);
INSERT INTO product_size (id_product, id_size)
    VALUES (52, 6);
INSERT INTO product_size (id_product, id_size)
    VALUES (53, 4);
INSERT INTO product_size (id_product, id_size)
    VALUES (54, 4);
INSERT INTO product_size (id_product, id_size)
    VALUES (55, 5);
INSERT INTO product_size (id_product, id_size)
    VALUES (56, 5);
INSERT INTO product_size (id_product, id_size)
    VALUES (57, 2);
INSERT INTO product_size (id_product, id_size)
    VALUES (58, 2);
INSERT INTO product_size (id_product, id_size)
    VALUES (59, 4);
INSERT INTO product_size (id_product, id_size)
    VALUES (60, 1);
INSERT INTO product_size (id_product, id_size)
    VALUES (61, 2);
INSERT INTO product_size (id_product, id_size)
    VALUES (62, 7);
INSERT INTO product_size (id_product, id_size)
    VALUES (63, 6);
INSERT INTO product_size (id_product, id_size)
    VALUES (64, 3);
INSERT INTO product_size (id_product, id_size)
    VALUES (65, 1);
INSERT INTO product_size (id_product, id_size)
    VALUES (66, 6);
INSERT INTO product_size (id_product, id_size)
    VALUES (67, 6);
INSERT INTO product_size (id_product, id_size)
    VALUES (68, 3);
INSERT INTO product_size (id_product, id_size)
    VALUES (69, 1);
INSERT INTO product_size (id_product, id_size)
    VALUES (70, 3);
INSERT INTO product_size (id_product, id_size)
    VALUES (71, 5);
INSERT INTO product_size (id_product, id_size)
    VALUES (72, 2);
INSERT INTO product_size (id_product, id_size)
    VALUES (73, 3);
INSERT INTO product_size (id_product, id_size)
    VALUES (74, 2);
INSERT INTO product_size (id_product, id_size)
    VALUES (75, 5);
INSERT INTO product_size (id_product, id_size)
    VALUES (76, 4);
INSERT INTO product_size (id_product, id_size)
    VALUES (77, 5);
INSERT INTO product_size (id_product, id_size)
    VALUES (78, 6);
INSERT INTO product_size (id_product, id_size)
    VALUES (79, 6);
INSERT INTO product_size (id_product, id_size)
    VALUES (80, 1);
INSERT INTO product_size (id_product, id_size)
    VALUES (81, 7);
INSERT INTO product_size (id_product, id_size)
    VALUES (82, 6);
INSERT INTO product_size (id_product, id_size)
    VALUES (83, 7);
INSERT INTO product_size (id_product, id_size)
    VALUES (84, 7);
INSERT INTO product_size (id_product, id_size)
    VALUES (85, 3);
INSERT INTO product_size (id_product, id_size)
    VALUES (86, 7);
INSERT INTO product_size (id_product, id_size)
    VALUES (87, 6);
INSERT INTO product_size (id_product, id_size)
    VALUES (88, 2);
INSERT INTO product_size (id_product, id_size)
    VALUES (89, 1);
INSERT INTO product_size (id_product, id_size)
    VALUES (90, 1);
INSERT INTO product_size (id_product, id_size)
    VALUES (91, 5);
INSERT INTO product_size (id_product, id_size)
    VALUES (92, 6);
INSERT INTO product_size (id_product, id_size)
    VALUES (93, 4);
INSERT INTO product_size (id_product, id_size)
    VALUES (94, 1);
INSERT INTO product_size (id_product, id_size)
    VALUES (95, 4);
INSERT INTO product_size (id_product, id_size)
    VALUES (96, 7);
INSERT INTO product_size (id_product, id_size)
    VALUES (97, 3);
INSERT INTO product_size (id_product, id_size)
    VALUES (98, 1);
INSERT INTO product_size (id_product, id_size)
    VALUES (99, 3);
INSERT INTO product_size (id_product, id_size)
    VALUES (100, 1);
-----------------------------------------
-- product brand
-----------------------------------------

INSERT INTO product_brand (id_product, id_brand)
    VALUES (1, 1);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (2, 1);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (3, 7);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (4, 8);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (5, 8);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (6, 8);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (7, 4);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (8, 8);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (9, 8);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (10, 8);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (11, 8);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (12, 8);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (13, 8);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (14, 2);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (15, 10);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (16, 15);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (17, 8);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (18, 8);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (19, 16);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (20, 17);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (21, 14);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (22, 16);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (23, 19);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (24, 11);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (25, 11);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (26, 11);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (27, 11);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (28, 11);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (29, 11);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (30, 11);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (31, 11);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (32, 11);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (33, 11);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (34, 12);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (35, 12);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (36, 12);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (37, 12);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (38, 12);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (39, 13);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (40, 12);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (41, 12);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (42, 12);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (43, 17);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (44, 1);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (45, 1);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (46, 6);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (47, 14);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (48, 3);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (49, 18);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (50, 8);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (51, 6);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (52, 1);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (53, 5);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (54, 9);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (55, 15);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (56, 14);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (57, 6);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (58, 8);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (59, 15);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (60, 12);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (61, 11);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (62, 13);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (63, 14);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (64, 16);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (65, 8);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (66, 9);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (67, 6);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (68, 2);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (69, 10);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (70, 15);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (71, 7);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (72, 9);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (73, 3);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (74, 7);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (75, 13);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (76, 18);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (77, 5);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (78, 10);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (79, 20);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (80, 1);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (81, 1);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (82, 6);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (83, 4);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (84, 6);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (85, 13);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (86, 19);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (87, 11);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (88, 14);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (89, 3);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (90, 6);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (91, 1);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (92, 12);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (93, 6);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (94, 15);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (95, 18);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (96, 5);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (97, 8);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (98, 1);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (99, 16);
INSERT INTO product_brand (id_product, id_brand)
    VALUES (100, 11);
