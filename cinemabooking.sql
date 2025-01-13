-- Tạo cơ sở dữ liệu
CREATE DATABASE Cinemabooking;
GO

USE Cinemabooking;
GO

-- Bảng Users (Quản lý người dùng)
CREATE TABLE Users (
    UserID INT PRIMARY KEY IDENTITY(1,1),
    FullName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) UNIQUE NOT NULL,
    PasswordHash NVARCHAR(255) NOT NULL,
    PhoneNumber NVARCHAR(15),
    Role NVARCHAR(20) DEFAULT 'Customer',
    Status NVARCHAR(20) DEFAULT 'Active',
    CreatedAt DATETIME DEFAULT GETDATE()
);
GO

-- Bảng Movies (Quản lý phim)
CREATE TABLE Movies (
    MovieID INT PRIMARY KEY IDENTITY(1,1),
    Title NVARCHAR(200) NOT NULL,
    Genre NVARCHAR(100),
    Duration INT NOT NULL, -- Thời lượng phim (phút)
    Actors NVARCHAR(MAX),
    Description NVARCHAR(MAX),
    PosterUrl NVARCHAR(255), -- Đường dẫn ảnh poster
    ReleaseDate DATE,
    Status NVARCHAR(20) DEFAULT 'Showing'
);
GO
-- Bảng Cinemas (Phòng chiếu)
CREATE TABLE Cinemas (
    CinemaID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL,
    TotalSeats INT NOT NULL,
    Status NVARCHAR(20) DEFAULT 'Active'
);
GO

-- Bảng Showtimes (Suất chiếu)
CREATE TABLE Showtimes (
    ShowtimeID INT PRIMARY KEY IDENTITY(1,1),
    MovieID INT NOT NULL,
    CinemaID INT NOT NULL,
    ShowDate DATE NOT NULL,
    ShowTime TIME NOT NULL,
    Status NVARCHAR(20) DEFAULT 'Active',
    FOREIGN KEY (MovieID) REFERENCES Movies(MovieID),
    FOREIGN KEY (CinemaID) REFERENCES Cinemas(CinemaID)
);
GO

-- Bảng Seats (Ghế ngồi)
CREATE TABLE Seats (
    SeatID INT PRIMARY KEY IDENTITY(1,1),
    CinemaID INT NOT NULL,
    SeatNumber NVARCHAR(10) NOT NULL, -- Ví dụ: A1, A2, B1
    Status NVARCHAR(20) DEFAULT 'Available',
    FOREIGN KEY (CinemaID) REFERENCES Cinemas(CinemaID)
);
GO
-- Bảng Bookings (Đặt vé)
CREATE TABLE Bookings (
    BookingID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT NOT NULL,
    ShowtimeID INT NOT NULL,
    BookingDate DATETIME DEFAULT GETDATE(),
    TotalAmount DECIMAL(10, 2) NOT NULL,
    PaymentStatus NVARCHAR(20) DEFAULT 'Pending',
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (ShowtimeID) REFERENCES Showtimes(ShowtimeID)
);
GO
-- Bảng BookingDetails (Chi tiết đặt vé)
CREATE TABLE BookingDetails (
    BookingDetailID INT PRIMARY KEY IDENTITY(1,1),
    BookingID INT NOT NULL,
    SeatID INT NOT NULL,
    Price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID),
    FOREIGN KEY (SeatID) REFERENCES Seats(SeatID)
);
GO
-- Bảng Reviews (Đánh giá và bình luận)
CREATE TABLE Reviews (
    ReviewID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT NOT NULL,
    MovieID INT NOT NULL,
    Rating INT CHECK (Rating BETWEEN 1 AND 5),
    Comment NVARCHAR(MAX),
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (MovieID) REFERENCES Movies(MovieID)
);
GO
-- Bảng Ads (Quản lý banner quảng cáo)
CREATE TABLE Ads (
    AdID INT PRIMARY KEY IDENTITY(1,1),
    Title NVARCHAR(100) NOT NULL,
    ImageUrl NVARCHAR(255),
    Status NVARCHAR(20) DEFAULT 'Active',
    CreatedAt DATETIME DEFAULT GETDATE()
);
GO
-- Tạo bảng Permissions để quản lý quyền của người dùng
CREATE TABLE Permissions (
    PermissionID INT PRIMARY KEY IDENTITY(1,1), -- Khóa chính
    UserID INT NOT NULL, -- Liên kết tới bảng Users
    CanManageMovies BIT DEFAULT 0, -- Quyền quản lý phim
    CanManageShowtimes BIT DEFAULT 0, -- Quyền quản lý suất chiếu
    CanManageBookings BIT DEFAULT 0, -- Quyền quản lý đặt vé
    CanManageSeats BIT DEFAULT 0, -- Quyền quản lý ghế
    CanManageAds BIT DEFAULT 0, -- Quyền quản lý quảng cáo
    CreatedAt DATETIME DEFAULT GETDATE(), -- Ngày tạo phân quyền
    FOREIGN KEY (UserID) REFERENCES Users(UserID) -- Ràng buộc khóa ngoại
);
GO
