INSERT INTO `addon_account` (name, label, shared) VALUES
	('society_ltd', 'LTD Sud', 1)
;

INSERT INTO `datastore` (name, label, shared) VALUES
	('society_ltd', 'LTD Sud', 1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES
	('society_ltd', 'LTD Sud', 1)
;

INSERT INTO `jobs` (name, label) VALUES
	('ltd','LTD Sud')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
	('ltd',0,'recruit','Stagiaire',20,'{}','{}'),
	('ltd',1,'boss','Patron',100,'{}','{}')
;

INSERT INTO `items` (`name`, `label`, `limit`, `rare`, `can_remove`) VALUES
('bread', 'Pain', 20, 0, 1),
('bonbons', 'Paquet de Bonbons', 20, 0, 1),
('chips', 'Paquet de Chips', 20, 0, 1),
('cookie', 'Cookie', 20, 0, 1),
('donuts', 'Donuts', 20, 0, 1),
('hamburger', 'Hamburger', 20, 0, 1),
('muffin', 'Muffin', 20, 0, 1),
('nutellab', 'Nuttela Bready', 20, 0, 1),
('beer', 'Bière', 20, 0, 1),
('icetea', 'IceTea', 20, 0, 1),
('jusfruit', 'Jus de Fruit', 20, 0, 1),
('martini', 'Martini', 20, 0, 1),
('mojito', 'Mojito', 20, 0, 1),
('oasis', 'Oasis', 20, 0, 1),
('orangina', 'Orangina', 20, 0, 1),
('pepsi', 'Pepsi', 20, 0, 1);

