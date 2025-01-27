-- Add location table - represent a restaurant's location
-- add reference for user reference a location
CREATE TABLE User (
    UserID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Role ENUM('Chef', 'Waiter', 'Customer', 'Owner') NOT NULL,
    ContactDetails VARCHAR(255),
    Login VARCHAR(255) NOT NULL UNIQUE,
    Password VARCHAR(255) NOT NULL,
    CreationDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ModificationDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- no modification needed
CREATE TABLE Dish (
    DishID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Description TEXT,
    Price DECIMAL(10, 2) NOT NULL,
    PreparationTime INT NOT NULL,
    ImageLink VARCHAR(255),
    CreationDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ModificationDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Menu should associate with one location only
CREATE TABLE Menu (
    MenuID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Description TEXT,
    CreationDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ModificationDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- no modification needed
CREATE TABLE MenuDish (
    MenuID INT,
    DishID INT,
    Status ENUM('Available', 'Unavailable') NOT NULL,
    PRIMARY KEY (MenuID, DishID),
    FOREIGN KEY (MenuID) REFERENCES Menu(MenuID) ON DELETE CASCADE,
    FOREIGN KEY (DishID) REFERENCES Dish(DishID) ON DELETE CASCADE
);

-- add reference to location
CREATE TABLE DiningTable (
    TableID INT AUTO_INCREMENT PRIMARY KEY,
    Capacity INT NOT NULL,
    Location VARCHAR(255)
);

-- add reference to location
CREATE TABLE Reservation (
    ReservationID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT,
    TableID INT,
    ReservationTime TIMESTAMP NOT NULL,
    SpecialRequests TEXT,
    Status ENUM('Pending', 'Confirmed', 'Cancelled') NOT NULL,
    FOREIGN KEY (UserID) REFERENCES User(UserID) ON DELETE CASCADE,
    FOREIGN KEY (TableID) REFERENCES DiningTable(TableID) ON DELETE CASCADE
);

-- add reference to location
CREATE TABLE MealOrder (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT,
    TableID INT,
    OrderTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Status ENUM('Pending', 'Preparing', 'Served', 'Completed') NOT NULL,
    FOREIGN KEY (UserID) REFERENCES User(UserID) ON DELETE CASCADE,
    FOREIGN KEY (TableID) REFERENCES DiningTable(TableID) ON DELETE CASCADE
);

-- add reference to location
CREATE TABLE OrderItem (
    OrderItemID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT,
    DishID INT,
    Quantity INT NOT NULL,
    SpecialRequests TEXT,
    FOREIGN KEY (OrderID) REFERENCES MealOrder(OrderID) ON DELETE CASCADE,
    FOREIGN KEY (DishID) REFERENCES Dish(DishID) ON DELETE CASCADE
);

-- add reference to location
CREATE TABLE Receipt (
    ReceiptID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT,
    Amount DECIMAL(10, 2) NOT NULL,
    PaymentMethod ENUM('Cash', 'Card', 'Online') NOT NULL,
    PaymentTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (OrderID) REFERENCES MealOrder(OrderID) ON DELETE CASCADE
);

-- add reference to location
CREATE TABLE Report (
    ReportID INT AUTO_INCREMENT PRIMARY KEY,
    ReportType ENUM('Daily', 'Monthly', 'Yearly') NOT NULL,
    GeneratedTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Content TEXT
);

-- no need modification
CREATE TABLE Revenue (
    RevenueID INT AUTO_INCREMENT PRIMARY KEY,
    Amount DECIMAL(10, 2) NOT NULL,
    Date DATE NOT NULL
);


-- Fix code:
CREATE TABLE Location (
    LocationID INT AUTO_INCREMENT PRIMARY KEY,
    Address VARCHAR(255) NOT NULL,
    City VARCHAR(255) NOT NULL,
    State VARCHAR(255) NOT NULL,
    ZipCode VARCHAR(10),
    Country VARCHAR(255) NOT NULL,
    CreationDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ModificationDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
ALTER TABLE User
ADD COLUMN LocationID INT,
ADD FOREIGN KEY (LocationID) REFERENCES Location(LocationID) ON DELETE SET NULL;
ALTER TABLE Menu
ADD COLUMN LocationID INT,
ADD FOREIGN KEY (LocationID) REFERENCES Location(LocationID) ON DELETE CASCADE;
ALTER TABLE DiningTable
ADD COLUMN LocationID INT,
ADD FOREIGN KEY (LocationID) REFERENCES Location(LocationID) ON DELETE CASCADE;
ALTER TABLE Reservation
ADD COLUMN LocationID INT,
ADD FOREIGN KEY (LocationID) REFERENCES Location(LocationID) ON DELETE CASCADE;
ALTER TABLE MealOrder
ADD COLUMN LocationID INT,
ADD FOREIGN KEY (LocationID) REFERENCES Location(LocationID) ON DELETE CASCADE;
ALTER TABLE Receipt
ADD COLUMN LocationID INT,
ADD FOREIGN KEY (LocationID) REFERENCES Location(LocationID) ON DELETE CASCADE;
ALTER TABLE Report
ADD COLUMN LocationID INT,
ADD FOREIGN KEY (LocationID) REFERENCES Location(LocationID) ON DELETE CASCADE;
