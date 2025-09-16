create table Users
(
User_ID int NOT NULL,
First_Name varchar(10)  NOT NULL,
Last_Name varchar(10)  NOT NULL,
Birth_Date datetime,
Gender varchar(6)NOT NULL,
Email varchar(100) NOT NULL,
constraint user_id Primary key(User_ID)

);
--c

CREATE PROC sp_insert_users
    @User_ID INT,
    @First_Name VARCHAR(10),
    @Last_Name VARCHAR(10),
    @Birth_Date DATETIME,
    @Gender VARCHAR(6),
    @Email VARCHAR(100)
AS
BEGIN
    IF EXISTS (SELECT User_ID FROM Users WHERE User_ID = @User_ID)
BEGIN
    PRINT 'User_ID already exists'
    RETURN
END

    INSERT INTO Users (User_ID, First_Name, Last_Name, Birth_Date, Gender, Email)
    VALUES (@User_ID, @First_Name, @Last_Name, @Birth_Date, @Gender, @Email);
END;

exec sp_insert_users
@User_ID=6,
@First_Name='koko',
@Last_Name = 'Alaa', 
@Birth_Date = '2003-01-01', 
@Gender = 'Female', 
@Email = 'alklya@example.com';

--U
create proc sp_update_First_name_user
 @User_ID INT,
 @First_Name VARCHAR(10)
 with encryption
as
begin
if not exists(select User_ID from Users where User_ID=@User_ID)
begin
print 'User Doesnot Exist'
return
end
Update Users
set First_Name=@First_Name
where
User_ID=@User_ID
PRINT 'User updated'
end;

exec sp_update_First_name_user
@User_ID=1,
@First_Name='Noha';


--r
create proc sp_get_user
@User_ID INT
as
begin
    select * from Users where User_ID = @User_ID;
END;



--d
CREATE PROCEDURE sp_delete_user
@User_ID int
as
begin
    IF EXISTS (SELECT User_ID FROM Users WHERE User_ID = @User_ID)
	begin
	delete from Users where User_ID=@User_ID
	print'user deleted'
	end
	else
	begin
    print 'user not found.'
    END

end;

exec  sp_delete_user
@User_ID =1;
-------------------------------------------------------------------------
create table Moods
(
Mood_ID int NOT NULL,
User_ID int not null,
Level int check ( level <=10 and level >0),
Note varchar(1000) ,
Time time,
constraint mood_id Primary key(Mood_ID),
constraint fk_userid_mood foreign key (User_ID) references Users(User_ID)
);

--c
create procedure sp_insert_mood
@Mood_ID int,
@User_ID int,
@Level int,
@Note varchar(1000),
@Time time
as
begin
    insert into moods (Mood_ID, User_ID, Level, Note, Time)
    values (@Mood_ID, @User_ID, @Level, @Note, @Time)
end;


exec sp_insert_mood 
@Mood_ID = 1, 
@User_ID = 1, 
@Level = 7, 
@Note = 'Feeling okay', 
@Time = '14:00';

--u

create proc sp_update_mood
@Mood_ID int,
@User_ID int,
@Level int,
@Note varchar(1000),
@Time time
as
begin
    if exists (select * from moods where Mood_ID = @Mood_ID)
    begin
        update moods
        set User_ID = @User_ID, Level = @Level, Note = @Note, Time = @Time
        where Mood_ID = @Mood_ID;
        print 'mood updated';
    end
    else
    begin
        print 'mood not found';
    end
end;

exec sp_update_mood 
@Mood_ID = 1, 
@User_ID = 1,
@Level = 9, 
@Note = 'Better now', 
@Time = '15:00';

--d
create procedure sp_delete_mood
@Mood_ID int
as
begin
    if exists (select * from moods where Mood_ID = @Mood_ID)
    begin
        delete from moods where Mood_ID = @Mood_ID;
        print 'mood deleted';
    end
    else
    begin
        print 'mood not found';
    end
end;

exec sp_delete_mood @Mood_ID = 1;

--r
create procedure sp_read_moods
as
begin
    select * from moods
end;

exec sp_read_moods;

---------------------------------------------------------------------------
Create table Diary(
Diary_ID int Not null,
User_ID int not null,
Date date ,
Text_Written varchar(200) not null,
constraint fk_User_ID_Diary foreign keY (User_ID) references Users(User_ID),
constraint pk_Diary_id primary key (Diary_ID)
);

--c
CREATE proc sp_insert_diary
    @Diary_ID INT,
    @User_ID INT,
    @Date DATE,
    @Text_Written VARCHAR(200)
AS
BEGIN
    INSERT INTO Diary (Diary_ID, User_ID, Date, Text_Written)
    VALUES (@Diary_ID, @User_ID, @Date, @Text_Written);
END;
exec sp_insert_diary
    @diary_id = 101,
    @user_id = 1,
    @date = '2025-08-09',
    @text_written = 'Today was a great day!';
--r
CREATE PROC sp_read_diary
AS
BEGIN
    SELECT * FROM Diary;
END;
EXEC sp_read_diary;

--u
CREATE PROC sp_update_diary
    @Diary_ID INT,
    @User_ID INT,
    @Date DATE,
    @Text_Written VARCHAR(200)
AS
BEGIN
    UPDATE Diary
    SET User_ID = @User_ID,
        Date = @Date,
        Text_Written = @Text_Written
    WHERE Diary_ID = @Diary_ID;
END;
EXEC sp_update_diary 
    @Diary_ID = 101,
    @User_ID = 1,
    @Date = '2025-08-09',
    @Text_Written = 'Updated diary entry text here.';

	--d
create proc sp_delete_diary
@diary_id int
as
begin
delete from diary
where diary_id = @diary_id;
end;

exec sp_delete_diary 101;

--------------------------------------------------------------------------
Create table Therapist(
Therapist_ID int Not null,
First_Name varchar(10)  NOT NULL,
Last_Name varchar(10)  NOT NULL,
Job varchar(50) not null,
Email varchar(100) NOT NULL,
constraint pk_Therapist_ID primary key (Therapist_ID)
);

--c
CREATE PROCEDURE sp_insert_therapist
    @Therapist_ID INT,
    @First_Name VARCHAR(10),
    @Last_Name VARCHAR(10),
    @Job VARCHAR(50),
    @Email VARCHAR(100)
AS
BEGIN
    INSERT INTO Therapist (Therapist_ID, First_Name, Last_Name, Job, Email)
    VALUES (@Therapist_ID, @First_Name, @Last_Name, @Job, @Email);
END;

EXEC sp_insert_therapist 
    @Therapist_ID = 6,
    @First_Name = 'mahi',
    @Last_Name = 'Doe',
    @Job = 'Psychologist',
    @Email = 'john.doe@example.com';


--r
CREATE PROCEDURE sp_read_therapist
AS
BEGIN
    SELECT * FROM Therapist;
END;
EXEC sp_read_therapist;

--u
CREATE PROCEDURE sp_update_therapist
    @Therapist_ID INT,
    @First_Name VARCHAR(10),
    @Last_Name VARCHAR(10),
    @Job VARCHAR(50),
    @Email VARCHAR(100)
AS
BEGIN
    UPDATE Therapist
    SET First_Name = @First_Name,
        Last_Name = @Last_Name,
        Job = @Job,
        Email = @Email
    WHERE Therapist_ID = @Therapist_ID;
END;

EXEC sp_update_therapist 
    @Therapist_ID = 1,
    @First_Name = 'Jane',
    @Last_Name = 'Doe',
    @Job = 'Clinical Therapist',
    @Email = 'jane.doe@example.com';


--d
CREATE PROCEDURE sp_delete_therapist
    @Therapist_ID INT
AS
BEGIN
    DELETE FROM Therapist
    WHERE Therapist_ID = @Therapist_ID;
END;

EXEC sp_delete_therapist 
    @Therapist_ID = 1;

-----------------------------------------------------------------------------
create table Appointments
(
Appointments_ID int NOT NULL,
Therapist_ID int Not null,
User_ID int Not null,
Status varchar(100)  NOT NULL,
note varchar(200)  NOT NULL,
Date datetime,
constraint Appointments_ID Primary key(Appointments_ID),
constraint fk_User_ID_Appointments foreign keY (User_ID) references Users(User_ID),
constraint fk_Therapist_ID_Appointments foreign keY (Therapist_ID) references Therapist(Therapist_ID)

);

--c
CREATE PROCEDURE sp_insert_appointment
    @Appointments_ID INT,
    @Therapist_ID INT,
    @User_ID INT,
    @Status VARCHAR(100),
    @Note VARCHAR(200),
    @Date DATETIME
AS
BEGIN
    INSERT INTO Appointments (Appointments_ID, Therapist_ID, User_ID, Status, Note, Date)
    VALUES (@Appointments_ID, @Therapist_ID, @User_ID, @Status, @Note, @Date);
END;

EXEC sp_insert_appointment
    @Appointments_ID = 2,
    @Therapist_ID = 2,
    @User_ID = 6,
    @Status = 'Confirmed',
    @Note = 'First session',
    @Date = '2025-08-10 10:00:00';


	--r
CREATE PROCEDURE sp_read_appointments
AS
BEGIN
    SELECT * FROM Appointments;
END;

EXEC sp_read_appointments;

--u
CREATE PROCEDURE sp_update_appointment
    @Appointments_ID INT,
    @Therapist_ID INT,
    @User_ID INT,
    @Status VARCHAR(100),
    @Note VARCHAR(200),
    @Date DATETIME
AS
BEGIN
    UPDATE Appointments
    SET Therapist_ID = @Therapist_ID,
        User_ID = @User_ID,
        Status = @Status,
        Note = @Note,
        Date = @Date
    WHERE Appointments_ID = @Appointments_ID;
END;


EXEC sp_insert_appointment
    @Appointments_ID = 65,
    @Therapist_ID = 1,
    @User_ID = 6,
    @Status = 'confirmed',
    @Note = 'Rescheduled by client',
    @Date = '2025-08-15 13:00:00';

	--d
CREATE PROCEDURE sp_delete_appointment
    @Appointments_ID INT
AS
BEGIN
    DELETE FROM Appointments
    WHERE Appointments_ID = @Appointments_ID;
END;

EXEC sp_delete_appointment
    @Appointments_ID = 1;

-----------------------------------------------------------------------------
create table Activity
(
Activity_ID int NOT NULL,
Activity_Name varchar(100)  NOT NULL,
constraint Activity_ID Primary key(Activity_ID)

);
--------------------------------------------------------------------------
create table User_Activities(
User_ID int NOT NULL,
Activity_ID int NOT NULL,
Time time,
constraint fk_User_ID_User_Activities foreign keY (User_ID) references Users(User_ID),
constraint fk_Activity_ID_User_Activities foreign keY (Activity_ID) references Activity(Activity_ID)
);

--buss 1 analyze session distribution between therapists.


SELECT U.User_ID, U.First_Name + ' ' + U.Last_Name AS User_Name,
       T.First_Name + ' ' + T.Last_Name AS Therapist_Name,
       A.Date, A.Status, A.Note
FROM 
    Appointments A
JOIN 
    Users U ON A.User_ID = U.User_ID
JOIN 
    Therapist T ON A.Therapist_ID = T.Therapist_ID
ORDER BY 
    U.User_ID, A.Date DESC;

--buss 2 howw many  appoint each user has and the status

SELECT 
    U.User_ID,
    U.First_Name + ' ' + U.Last_Name AS User_Name,
    A.Status,
    COUNT(*) AS Appointment_Count
FROM 
    Appointments A
JOIN 
    Users U ON A.User_ID = U.User_ID
GROUP BY 
    U.User_ID, U.First_Name, U.Last_Name, A.Status
ORDER BY 
    Appointment_Count DESC;

