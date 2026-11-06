--TASK 2--
CREATE DATABASE TrainBookingDB;
GO

USE TrainBookingDB;
GO

--TASK 3--
CREATE TABLE Train (
    TrainID        INT PRIMARY KEY,
    TrainName      VARCHAR(100) NOT NULL,
    Source         VARCHAR(50)  NOT NULL,
    Destination    VARCHAR(50)  NOT NULL,
    TrainType      VARCHAR(30)  NOT NULL,
    DepartureTime  TIME         NOT NULL,
    ArrivalTime    TIME         NOT NULL
);
GO

--TASK 3--
CREATE TABLE Train (
    TrainID        INT PRIMARY KEY,
    TrainName      VARCHAR(100) NOT NULL,
    Source         VARCHAR(50)  NOT NULL,
    Destination    VARCHAR(50)  NOT NULL,
    TrainType      VARCHAR(30)  NOT NULL,
    DepartureTime  TIME         NOT NULL,
    ArrivalTime    TIME         NOT NULL
);
GO

--TASK 4 -- 
CREATE TABLE Passenger (
    PassengerID    INT PRIMARY KEY,
    PassengerName  VARCHAR(100) NOT NULL,
    NICNumber      VARCHAR(20)  UNIQUE,
    Age            INT,
    City           VARCHAR(50)
);
GO

--TASK 5 --
CREATE TABLE Booking (
    BookingID     INT PRIMARY KEY,
    TrainID       INT,
    PassengerID   INT,
    SeatNumber    INT           NOT NULL,
    TicketPrice   DECIMAL(10,2) NOT NULL,
    BookingDate   DATE          NOT NULL
);
GO

--TASK 6--
ALTER TABLE Booking
ADD CONSTRAINT FK_Booking_Train
    FOREIGN KEY (TrainID) REFERENCES Train(TrainID);

ALTER TABLE Booking
ADD CONSTRAINT FK_Booking_Passenger
    FOREIGN KEY (PassengerID) REFERENCES Passenger(PassengerID);
GO
EXEC sp_help 'Booking';
SELECT name AS ForeignKeyName,
       OBJECT_NAME(parent_object_id) AS ChildTable,
       OBJECT_NAME(referenced_object_id) AS ParentTable
FROM sys.foreign_keys;
GO

--PART B --
--TASK 7--
INSERT INTO Train VALUES (1, 'Udarata Menike', 'Colombo', 'Kandy',   'Express',   '05:55', '09:30');
INSERT INTO Train VALUES (2, 'Yal Devi',       'Colombo', 'Jaffna',  'Intercity', '06:45', '14:15');
INSERT INTO Train VALUES (3, 'Ruhunu Kumari',  'Colombo', 'Galle',   'Express',   '07:00', '09:45');
INSERT INTO Train VALUES (4, 'Podi Menike',    'Kandy',   'Colombo', 'Intercity', '08:30', '12:00');
INSERT INTO Train VALUES (5, 'Galu Kumari',    'Galle',   'Colombo', 'Express',   '09:15', '12:00');
INSERT INTO Train VALUES (6, 'Sagarika',       'Colombo', 'Matara',  'Intercity', '10:00', '13:30');
GO

--TASK 8--
INSERT INTO Passenger VALUES (1, 'Saman Perera',     '981234567V',   28, 'Colombo');
INSERT INTO Passenger VALUES (2, 'Anoma Silva',      '199045678901', 35, 'Colombo');
INSERT INTO Passenger VALUES (3, 'Sunil Fernando',   '200012345678', 22, 'Galle');
INSERT INTO Passenger VALUES (4, 'Kamal Jayasinghe', '975678901V',   45, 'Kandy');
INSERT INTO Passenger VALUES (5, 'Amali Perera',     '200234567890', 19, 'Colombo');
INSERT INTO Passenger VALUES (6, 'Nuwan Bandara',    '198834567890', 37, 'Galle');
GO

--TASK 9 --
INSERT INTO Booking VALUES (101, 1, 1, 12, 1500.00, '2025-10-01');
INSERT INTO Booking VALUES (102, 2, 2,  5, 2500.00, '2025-10-03');
INSERT INTO Booking VALUES (103, 3, 3, 20,  800.00, '2025-10-05');
INSERT INTO Booking VALUES (104, 4, 4,  8, 1200.00, '2025-10-01');
INSERT INTO Booking VALUES (105, 5, 1, 15, 3200.00, '2025-10-07');
INSERT INTO Booking VALUES (106, 1, 5,  3,  950.00, '2025-10-09');
INSERT INTO Booking VALUES (107, 2, 2, 18, 2800.00, '2025-10-10');
INSERT INTO Booking VALUES (108, 5, 3, 11, 1750.00, '2025-10-12');
GO

--TASK 10--
SELECT * FROM Train;
SELECT * FROM Passenger;
SELECT * FROM Booking;
GO

--PART 6--
--TASK 11--
SELECT * FROM Train WHERE Source = 'Colombo';

--TASK 12--
SELECT TrainName, Destination FROM Train WHERE Destination = 'Kandy';

--TASK 13--
SELECT t.TrainName, b.TicketPrice
FROM Booking b
JOIN Train t ON b.TrainID = t.TrainID
WHERE b.TicketPrice > 1000;

--TASK 14--
SELECT PassengerName, Age FROM Passenger WHERE Age BETWEEN 20 AND 40;

--TASK 15--
SELECT * FROM Passenger WHERE City = 'Colombo' AND Age > 25;

--TASK 16--
SELECT * FROM Passenger WHERE City = 'Colombo' OR City = 'Galle';

--TASK 17--
SELECT * FROM Train WHERE NOT Destination = 'Colombo';

--TASK 18--
SELECT * FROM Train
WHERE (TrainType = 'Express' OR TrainType = 'Intercity')
  AND Destination = 'Colombo';

--TASK 19--
SELECT PassengerName FROM Passenger WHERE PassengerName LIKE 'S%';

--TASK 20--
SELECT * FROM Booking WHERE TicketPrice BETWEEN 1000 AND 3000;
GO

--PART D--
--TASK 21--
SELECT p.PassengerName, t.TrainName, b.TicketPrice
FROM Booking b
INNER JOIN Passenger p ON b.PassengerID = p.PassengerID
INNER JOIN Train t     ON b.TrainID = t.TrainID;

--TASK 22--
SELECT t.TrainName, p.PassengerName, b.SeatNumber, b.BookingDate
FROM Booking b
JOIN Train t     ON b.TrainID = t.TrainID
JOIN Passenger p ON b.PassengerID = p.PassengerID;

--TASK 23--
SELECT t.*, b.BookingID, b.PassengerID, b.SeatNumber, b.TicketPrice, b.BookingDate
FROM Train t
LEFT JOIN Booking b ON t.TrainID = b.TrainID;

--TASK 24--
SELECT p.PassengerName, COUNT(b.BookingID) AS BookingCount
FROM Passenger p
JOIN Booking b ON p.PassengerID = b.PassengerID
GROUP BY p.PassengerName;

--TASK 25--
SELECT t.TrainName, AVG(b.TicketPrice) AS AverageTicketPrice
FROM Train t
JOIN Booking b ON t.TrainID = b.TrainID
GROUP BY t.TrainName;
GO

--PART E --
--TASK 26--
SELECT DISTINCT PassengerName
FROM Passenger
WHERE PassengerID IN (
    SELECT PassengerID FROM Booking
    WHERE TicketPrice > (SELECT AVG(TicketPrice) FROM Booking)
);

--TASK 27--
SELECT TrainName
FROM Train
WHERE TrainID IN (
    SELECT TrainID FROM Booking WHERE TicketPrice > 2000
);

--TASK 28--
SELECT PassengerName
FROM Passenger p
WHERE EXISTS (
    SELECT 1 FROM Booking b WHERE b.PassengerID = p.PassengerID
);

--TASK 29--
SELECT DISTINCT t.TrainName
FROM Train t
JOIN Booking b ON t.TrainID = b.TrainID
WHERE b.TicketPrice > (
    SELECT MAX(TicketPrice) FROM Booking
    WHERE TrainID IN (SELECT TrainID FROM Train WHERE Destination = 'Kandy')
);

--TASK 30--
SELECT PassengerName
FROM Passenger
WHERE PassengerID IN (
    SELECT PassengerID FROM Booking
    WHERE TrainID IN (
        SELECT TrainID FROM Train WHERE Destination = 'Colombo'
    )
);
GO












