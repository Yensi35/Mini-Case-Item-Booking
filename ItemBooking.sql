
CREATE TABLE Customer(
CustomerID CHAR (5) PRIMARY KEY NOT NULL,
	CustomerName VARCHAR (50),
	CustomerBOD DATE,
	CustomerEmail VARCHAR (30),
	CustomerTelp VARCHAR (15)
)

INSERT INTO Customer
	VALUES  ('CR001','Yensi','1999-11-02','yensi@gmail.com','087809373321'),
			('CR002','Lim','1998-03-07','limm@gmail.com','0837944950'),
			('CR003','Emma','2000-06-08','emma@gmail.com','081347651186'),
			('CR004','Lisa','1997-07-12','lisa@gmail.com','087817653987'),
			('CR005','Nicco','1999-03-03','nicco@gmail.com','081398265411')

CREATE Table Booking(
	BookingID CHAR (5) PRIMARY KEY NOT NULL,
	CustomerID CHAR (5)
	REFERENCES Customer
	ON UPDATE CASCADE
	ON DELETE CASCADE,
	BookingDate DATE,
	BookingTime VARCHAR (10)
)

INSERT INTO Booking
	VALUES ('BK001','CR001','2019-01-01','09.00 WIB'),
		   ('BK002','CR002','2019-01-01','09.01 WIB'),
		   ('BK003','CR003','2019-01-02','09.37 WIB'),
		   ('BK004','CR005','2019-02-03','13.28 WIB'),
		   ('BK005','CR005','2019-02-04','11.10 WIB')


INSERT INTO Booking
	VALUES ('BK006','CR001','2019-02-01','10.00 WIB'),
		   ('BK007','CR003','2019-02-03','14.32 WIB')

CREATE TABLE Item(
	ItemID CHAR (5) PRIMARY KEY NOT NULL,
	ItemName VARCHAR (50),
	IteamWeight VARCHAR (10),
	ItemPrice INT,
	ProductCode VARCHAR (10)
)

INSERT INTO Item
	VALUES ('TF341','Logitech M280','500 gr',75000,'TFL28'),
		   ('TF246','Logitech G102','400 gr',102000,'TFL10'),
		   ('FA524','Free Wolf X8','450 gr',135000,'FAWX8'),
		   ('TF817','Logitech U812','400 gr',125000,'TFL12')

CREATE TABLE BookingDetail(
	BookingID CHAR (5) NOT NULL
	REFERENCES Booking(BookingID)
	ON UPDATE CASCADE
	ON DELETE CASCADE,
	ItemID CHAR (5) NOT NULL
	REFERENCES Item(ItemID)
	ON UPDATE CASCADE
	ON DELETE CASCADE,
	QTY INT DEFAULT 0,
	Status VARCHAR (10) NOT NULL
)

ALTER TABLE BookingDetail
ADD CONSTRAINT PK_Booking_Item PRIMARY KEY CLUSTERED (BookingID, ItemID)

INSERT INTO BookingDetail
	VALUES  ('BK001','FA524','1','PENDING'),
			('BK002','TF246','2','BOOKED'),
			('BK003','TF341','1','BOOKED'),
			('BK004','TF341','3','BOOKED'),
			('BK005','FA524','3','BOOKED')

INSERT INTO BookingDetail
	VALUES	('BK006','TF246','1','BOOKED'),
			('BK007','FA524','2','PENDING')

--2. Tampilkan ItemName yang harganya berkisar 50.000 - 100.000

SELECT ItemName, ItemPrice
FROM Item
WHERE ItemPrice BETWEEN 50000 AND 100000;
--YENSI

/*3. Tampilkan nama dan nomor telepon Customer yang melakukan booking
     pada tanggal 1 Januari 2019 dan dengan status PENDING */

SELECT CustomerName, CustomerTelp
FROM Customer
	INNER JOIN Booking ON Booking.CustomerID=Customer.CustomerID
	INNER JOIN BookingDetail ON Booking.BookingID=BookingDetail.BookingID
WHERE BookingDate = '2019-01-01' AND Status = 'PENDING'
--YENSI

/*4.Tampilkan : a. Jumlah item yang di booking
                b. Jumlah booking per bulan, urutkan dari bulan dengan
				   jumlah booking terbanyak*/

SELECT SUM(QTY) AS Total_Item_Booked
FROM Booking
INNER JOIN BookingDetail ON Booking.BookingID=BookingDetail.BookingID
WHERE Status = 'BOOKED'

SELECT SUM(QTY) AS Total_Item_Booked, BookingDate
FROM BookingDetail
INNER JOIN Booking ON Booking.BookingID=BookingDetail.BookingID
WHERE Status = 'BOOKED'
GROUP BY BookingDate
ORDER BY SUM(QTY) DESC

--5.Tampilkan BookingID dan Status yang memiliki jumlah item lebih dari 2

SELECT BookingID, Status
FROM BookingDetail
WHERE QTY >2

--6. Tampilkan nama Customer yang melakukan booking pada tanggal 1 Januari

SELECT Customer.CustomerID, Customer.CustomerName, Booking.BookingID,
       Item.ItemID, Booking.BookingDate
	FROM Booking
	INNER JOIN Customer ON Booking.CustomerID=Customer.CustomerID
	INNER JOIN BookingDetail ON Booking.BookingID=BookingDetail.BookingID
	INNER JOIN Item ON BookingDetail.ItemID=Item.ItemID
	WHERE BookingDate = '2019-01-01' AND Status='BOOKED'

/*7. Tampilkan CustomerID, CustomerName, BookingID, ItemID, BookingDate
     dari data Customer yang status booking nya PENDING*/

SELECT Customer.CustomerID, Customer.CustomerName, Booking.BookingID,
       Item.ItemID, Booking.BookingDate
	FROM Booking
	INNER JOIN Customer ON Booking.CustomerID=Customer.CustomerID
	INNER JOIN BookingDetail ON Booking.BookingID=BookingDetail.BookingID
	INNER JOIN Item ON BookingDetail.ItemID=Item.ItemID
	WHERE Status='PENDING'

--8. Tampilkan ItemID dan ItemName mana saja yang sudah pernah di booking

SELECT ItemID, ItemName
FROM Item	
	WHERE ItemID = ANY (SELECT ItemID FROM BookingDetail WHERE Status = 'BOOKED')


SELECT DISTINCT Item.ItemID, Item.ItemName
FROM Item
	INNER JOIN BookingDetail ON Item.ItemID=BookingDetail.ItemID
	WHERE Status = 'BOOKED'

--9. Tampilkan CustomerID, CustomerName yang belum pernah melakukan booking

SELECT Customer.CustomerID, Customer.CustomerName
	FROM Customer
	WHERE CustomerID NOT IN (SELECT CustomerID FROM Booking)

--10. Tampilkan total booking tiap item, kemudian urutkan dari total order terbanyak
SELECT Item.ItemName, SUM(QTY) AS Total_Order
FROM Item
	INNER JOIN BookingDetail ON Item.ItemID=BookingDetail.ItemID
	WHERE Status = 'BOOKED'
	GROUP BY ItemName
	ORDER BY SUM(QTY) DESC
	
