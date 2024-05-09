

/*Creating Database*/
CREATE DATABASE PariHospital ; 

/*Account Table*/
USE PariHospital;

CREATE TABLE Account (
    USER_Id INT PRIMARY KEY,
    userName VARCHAR(50) NOT NULL,
    Password VARCHAR(50) NOT NULL,
);

/*Department Table*/
CREATE TABLE Department (
    DeptID INT IDENTITY(1,1) PRIMARY KEY,
    Dept_Name VARCHAR(255),
    manager VARCHAR(255),
    telephone VARCHAR(20),
    email VARCHAR(255)
);

/*Address Table*/
CREATE TABLE Address (
    Add_ID INT NOT NULL,
    Line1 VARCHAR(255) NOT NULL,
    Line2 VARCHAR(255) NOT NULL,
    PostCode INT (20) NOT NULL,
    City VARCHAR(100) NOT NULL
);

ALTER TABLE Address
ADD CONSTRAINT PK_Address PRIMARY KEY (Add_ID);


/*Doctor Table*/
CREATE TABLE Doctor(
    DoctorID INT PRIMARY KEY,
    USER_Id INT NOT NULL,
    DrName VARCHAR(50) NOT NULL,
    DrMname VARCHAR(50) NULL,
    Drlname VARCHAR(50) NOT NULL,
    DeptID INT NOT NULL,
    Add_ID INT NOT NULL,
    Speciality VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL,
    FOREIGN KEY (USER_Id) REFERENCES Account(User_Id)
);

ALTER TABLE Doctor
ADD CONSTRAINT FKnew_DeptID FOREIGN KEY (DeptID) REFERENCES Department(DeptID);
ALTER TABLE Doctor
ADD CONSTRAINT FK_Add_ID FOREIGN KEY (Add_ID) REFERENCES Address(Add_ID);



/*Insurance Table*/
CREATE TABLE Insurance (
    Insurance_ID INT IDENTITY(1,1) PRIMARY KEY,
    InsName VARCHAR(255)
);

/*Diagnosis Table*/
CREATE TABLE Diagnosis (
    Diag_ID INT IDENTITY(1,1) PRIMARY KEY,
    notes VARCHAR(1000)
);

/*Medicine Table*/
CREATE TABLE Medicine (
    medicine_ID INT IDENTITY(1,1) PRIMARY KEY,
    medicine_name VARCHAR(255)
);

/*Patient Table*/
CREATE TABLE Patient (
    PatientID INT IDENTITY(1,1) PRIMARY KEY,
    F_Name VARCHAR(50) NOT NULL,
    M_Name VARCHAR(50) NULL,
    L_Name VARCHAR(50) NOT NULL,
    Sex VARCHAR(20),
    DOB DATE,
    Insurance_ID INT, 
    Add_ID INT NULL,
    Diag_ID INT,
    Medicine_ID INT, 
    Email VARCHAR(50) NULL, 
    Telephone INT 20 NOT NULL,
    DateLeft DATE NULL
);
ALTER TABLE Patient
ADD CONSTRAINT FK_Insurance FOREIGN KEY (Insurance_ID) REFERENCES Insurance(Insurance_ID);
ALTER TABLE Patient
ADD CONSTRAINT FK_Add_ID FOREIGN KEY (Add_ID) REFERENCES Address(Add_ID);
 ALTER TABLE Patient
ADD CONSTRAINT FK_Diag_ID FOREIGN KEY (Diag_ID) REFERENCES Diagnosis(Diag_ID);
ALTER TABLE Patient
ADD CONSTRAINT FK_Medicine_ID FOREIGN KEY (medicine_ID) REFERENCES Medicine(medicine_ID);
ALTER TABLE Patient
ADD USER_Id INT FOREIGN KEY REFERENCES Account(USER_Id);


/*Appointment Table*/
CREATE TABLE Appointment (
    AppointmentID INT IDENTITY(1,1) PRIMARY KEY,
    AppointmentDate DATE NOT NULL,
    AppointmentTime TIME NOT NULL,
    DeptID INT NOT NULL,
    PatientID INT NOT NULL,
    DoctorID INT NOT NULL,
    Status VARCHAR(50) NULL,
    
    CONSTRAINT FK_PatientID FOREIGN KEY (PatientID) REFERENCES Patient(PatientID),
    CONSTRAINT FK_DoctorID FOREIGN KEY (DoctorID) REFERENCES Doctor(DoctorID),
    CONSTRAINT FK_DeptID FOREIGN KEY (DeptID) REFERENCES Department(DeptID)
);


/*Completedappointment Table*/
CREATE TABLE Completedappointment (
    appID INT IDENTITY(1,1) PRIMARY KEY,
    Date DATE NOT NULL,
    Time TIME NOT NULL,
    DoctorID INT NOT NULL,
    PatientID INT,

    CONSTRAINT FK_NewDoctorID FOREIGN KEY (DoctorID) REFERENCES Doctor(DoctorID),
    CONSTRAINT FK_NewPatientID FOREIGN KEY (PatientID) REFERENCES Patient(PatientID)
);

/*Prescription Table*/
CREATE TABLE Prescription (
    PresID INT IDENTITY(1,1) PRIMARY KEY,
    appID INT,
    medicine_ID INT NULL,
    Medical_Order_Note VARCHAR(255) NULL,
    MedPrescriptionDate DATE,
    FOREIGN KEY (appID) REFERENCES Completedappointment(appID),
    FOREIGN KEY (medicine_ID) REFERENCES Medicine(medicine_ID)
);

/*Allergy Table*/
CREATE TABLE Allergy (
    allergy_ID INT IDENTITY(1,1) PRIMARY KEY,
    allergy_name VARCHAR(255)
	);

/*Review Table*/
CREATE TABLE Review (
    Review_ID INT IDENTITY(1,1) PRIMARY KEY,
    appID INT NOT NULL,
    feedback VARCHAR(1000),
    
    CONSTRAINT FK_CompletedAppointmentID FOREIGN KEY (appID) REFERENCES Completedappointment(appID)
);

/*table which is contains the informaion of patient and allergy*/
CREATE TABLE Patall (
    patallID INT IDENTITY(1,1) PRIMARY KEY,
    patientID INT,
    allergy_ID INT,
    Degree VARCHAR(255),
    
    CONSTRAINT FK_newpatientID_2 FOREIGN KEY (patientID) REFERENCES Patient(PatientID),
    CONSTRAINT FK_allergy_ID FOREIGN KEY (allergy_ID) REFERENCES Allergy(allergy_ID)
);

/*medipres Table*/
CREATE TABLE medipres (
    medipresID INT PRIMARY KEY,
    medicine_ID INT NOT NULL,
    presID INT NOT NULL,
    CONSTRAINT FK_Medicine FOREIGN KEY (medicine_ID) REFERENCES Medicine(medicine_ID),
    CONSTRAINT FK_Prescriber FOREIGN KEY (presID) REFERENCES Prescription(presID)
);


/*Medical Record View */
CREATE VIEW MedicalRecordsView AS
SELECT
    CA.appID,
    CA.Date,
    CA.Time,
    D.DoctorID,
    D.DrName,
    D.Speciality,
    P.PatientID,
    P.F_Name,
    P.DOB,
    DG.notes AS DiagnosisNotes,
    M.medicine_name AS PrescribedMedicine,
    PR.Medical_Order_Note AS PrescriptionNote,
    PR.MedPrescriptionDate AS PrescriptionDate,
    A.allergy_name AS Allergy
FROM
    Completedappointment CA
    JOIN Doctor D ON CA.DoctorID = D.DoctorID
    JOIN Patient P ON CA.PatientID = P.PatientID
    LEFT JOIN Diagnosis DG ON CA.appID = DG.Diag_ID
    LEFT JOIN Prescription PR ON CA.appID = PR.appID
    LEFT JOIN Medicine M ON PR.medicine_ID = M.medicine_ID
    LEFT JOIN patall PA ON P.PatientID = PA.PatientID
    LEFT JOIN Allergy A ON PA.allergy_ID = A.allergy_ID;

/*Data Insertion*/

/*Inser data into Account Table*/
INSERT INTO Account (USER_Id, userName, Password)
VALUES 
    (10, 'U10', 'P10'),
    (11, 'U11', 'P11'),
	(12, 'U12', 'P12'),
	(13, 'U13', 'P13'),
	(14, 'U14', 'P14'),
	(15, 'U15', 'P15'),
	(16, 'U16', 'P16'),
	(17, 'U17', 'P17'),
	(18, 'U18', 'P18'),
	(19, 'U19', 'P19'),
	(20, 'U20', 'P20'),
	(21, 'U21', 'P21'),
	(22, 'U22', 'P22'),
	(23, 'U23', 'P23'),
	(24, 'U24', 'P24'),
	(25, 'U25', 'P25'),
	(26, 'U26', 'P26'),
	(27, 'U27', 'P27'),
	(28, 'U28', 'P28'),
    (29, 'U29', 'P29');

/*Insert Data into Department Table*/
INSERT INTO Department (Dept_Name, manager, telephone, email)
VALUES ('Emergency Medicine', 'Dr. Smith', '123-456-7890', 'smith@Parhospital.com');
INSERT INTO Department (Dept_Name, manager, telephone, email)
VALUES ('Cardiology', 'Dr. Johnson', '987-654-3210', 'johnson@Parhospital.com');
INSERT INTO Department (Dept_Name, manager, telephone, email)
VALUES ('Surgery', 'Dr. Anderson', '456-789-0123', 'anderson@Parhospital.com');
INSERT INTO Department (Dept_Name, manager, telephone, email)
VALUES ('Pediatrics', 'Dr. Williams', '789-012-3456', 'williams@Parhospital.com');
INSERT INTO Department (Dept_Name, manager, telephone, email)
VALUES ('Radiology', 'Dr. Brown', '321-654-9870', 'brown@Parhospital.com');
INSERT INTO Department (Dept_Name, manager, telephone, email)
VALUES ('Orthopedics', 'Dr. Martinez', '555-555-5555', 'martinez@Parhospital.com');
INSERT INTO Department (Dept_Name, manager, telephone, email)
VALUES ('Neurology', 'Dr. Lee', '666-666-6666', 'lee@Parhospital.com');
INSERT INTO Department (Dept_Name, manager, telephone, email)
VALUES ('Oncology', 'Dr. Taylor', '777-777-7777', 'taylor@Parhospital.com');
INSERT INTO Department (Dept_Name, manager, telephone, email)
VALUES ('Obstetrics and Gynecology', 'Dr. Garcia', '888-888-8888', 'garcia@Parhospital.com');
INSERT INTO Department (Dept_Name, manager, telephone, email)
VALUES ('Internal Medicine', 'Dr. Nguyen', '999-999-9999', 'nguyen@Parhospital.com');

 /*Insert Data into Doctor Table*/  
 INSERT INTO Doctor (DoctorID, USER_Id, DrName, DrMname, Drlname, DeptID, ADD_ID, Speciality, Email)
VALUES (1, 10, 'John', NULL, 'Smith', 1, 201, 'Cardiology', 'john.smith@example.com');
INSERT INTO Doctor (DoctorID, USER_Id, DrName, DrMname, Drlname, DeptID, ADD_ID, Speciality, Email)
VALUES (2, 12, 'Jane', NULL, 'Doe', 2, 202, 'Gastroenterologist', 'jane.doe@example.com');
INSERT INTO Doctor (DoctorID, USER_Id, DrName, DrMname, Drlname, DeptID, ADD_ID, Speciality, Email)
VALUES (3, 14, 'Michael', NULL, 'Johnson', 3, 203, 'Surgery', 'michael.johnson@example.com');
INSERT INTO Doctor (DoctorID, USER_Id, DrName, DrMname, Drlname, DeptID, ADD_ID, Speciality, Email)
VALUES (4, 16, 'Emily', NULL, 'Brown', 1, 204, 'Cardiology', 'emily.brown@example.com');
INSERT INTO Doctor (DoctorID, USER_Id, DrName, DrMname, Drlname, DeptID, ADD_ID, Speciality, Email)
VALUES (5, 18, 'David', NULL, 'Wilson', 4, 205, 'Pediatrics', 'david.wilson@example.com');
INSERT INTO Doctor (DoctorID, USER_Id, DrName, DrMname, Drlname, DeptID, ADD_ID, Speciality, Email)
VALUES (6, 20, 'Sarah', NULL, 'Garcia', 5, 206, 'Radiology', 'sarah.garcia@example.com');
INSERT INTO Doctor (DoctorID, USER_Id, DrName, DrMname, Drlname, DeptID, ADD_ID, Speciality, Email)
VALUES (7, 22, 'James', NULL, 'Martinez', 3, 207, 'Surgery', 'james.martinez@example.com');
INSERT INTO Doctor (DoctorID, USER_Id, DrName, DrMname, Drlname, DeptID, ADD_ID, Speciality, Email)
VALUES (8, 24, 'Jessica', NULL, 'Lee', 6, 208, 'Orthopedics', 'jessica.lee@example.com');
INSERT INTO Doctor (DoctorID, USER_Id, DrName, DrMname, Drlname, DeptID, ADD_ID, Speciality, Email)
VALUES (9, 26, 'Daniel', NULL, 'Nguyen', 7, 209, 'Neurology', 'daniel.nguyen@example.com');
INSERT INTO Doctor (DoctorID, USER_Id, DrName, DrMname, Drlname, DeptID, ADD_ID, Speciality, Email)
VALUES (10, 28, 'Rachel', NULL, 'Taylor', 8, 210, 'Gastroentrologist', 'rachel.taylor@example.com');

/*Insert Data into Address Table*/
INSERT INTO Address (Add_ID, Line1, Line2, PostCode, City)
VALUES (1, '10 Downing Street', '', 'SW1A 2AA', 'London');
INSERT INTO Address (Add_ID, Line1, Line2, PostCode, City)
VALUES (2, '1 High Street', '', 'M1 1AB', 'Manchester');
INSERT INTO Address (Add_ID, Line1, Line2, PostCode, City)
VALUES (3, '15 Princes Street', '', 'EH2 2AN', 'Edinburgh');
INSERT INTO Address (Add_ID, Line1, Line2, PostCode, City)
VALUES (4, '20 Buchanan Street', '', 'G1 2FF', 'Glasgow');
INSERT INTO Address (Add_ID, Line1, Line2, PostCode, City)
VALUES (5, '5 Queen Street', '', 'CF10 2BS', 'Cardiff');
INSERT INTO Address (Add_ID, Line1, Line2, PostCode, City)
VALUES (6, '1 Broad Street', '', 'BS1 2AW', 'Bristol');
INSERT INTO Address (Add_ID, Line1, Line2, PostCode, City)
VALUES (7, '2 The Close', '', 'EX1 1AA', 'Exeter');
INSERT INTO Address (Add_ID, Line1, Line2, PostCode, City)
VALUES (8, '3 New Street', '', 'B2 4JN', 'Birmingham');
INSERT INTO Address (Add_ID, Line1, Line2, PostCode, City)
VALUES (9, '8 Princes Road', '', 'L8 1TG', 'Liverpool');
INSERT INTO Address (Add_ID, Line1, Line2, PostCode, City)
VALUES (10, '5 Rose Street', '', 'EH2 2PR', 'Edinburgh');

/*Inssert Data into Insurance Table*/
INSERT INTO Insurance (InsName) VALUES ('Life Insurance');
INSERT INTO Insurance (InsName) VALUES ('Health Insurance');
INSERT INTO Insurance (InsName) VALUES ('Car Insurance');
INSERT INTO Insurance (InsName) VALUES ('Home Insurance');
INSERT INTO Insurance (InsName) VALUES ('Travel Insurance');
INSERT INTO Insurance (InsName) VALUES ('Pet Insurance');
INSERT INTO Insurance (InsName) VALUES ('Renter''s Insurance');

/*Insert data into diagnosis Table*/
SET IDENTITY_INSERT Diagnosis ON;

INSERT INTO Diagnosis (Diag_ID, notes) VALUES (1, 'Patient has a fever and sore throat.');
INSERT INTO Diagnosis (Diag_ID, notes) VALUES (2, 'Patient presents with abdominal pain and nausea.');
INSERT INTO Diagnosis (Diag_ID, notes) VALUES (3, 'Patient reports persistent cough and difficulty breathing.');
INSERT INTO Diagnosis (Diag_ID, notes) VALUES (4, 'Patient has a history of hypertension and complains of headaches.');
INSERT INTO Diagnosis (Diag_ID, notes) VALUES (5, 'Patient has a fractured arm due to a fall.');
INSERT INTO Diagnosis (Diag_ID, notes) VALUES (6, 'Patient is experiencing anxiety and panic attacks.');
INSERT INTO Diagnosis (Diag_ID, notes) VALUES (7, 'Patient is diagnosed with diabetes and requires insulin therapy.');
INSERT INTO Diagnosis (Diag_ID, notes) VALUES (8, 'Patient complains of joint pain and swelling.');
INSERT INTO Diagnosis (Diag_ID, notes) VALUES (9, 'Patient is diagnosed with pneumonia and prescribed antibiotics.');
INSERT INTO Diagnosis (Diag_ID, notes) VALUES (10, 'Patient has a breast cancer.');
INSERT INTO Diagnosis (Diag_ID, notes) VALUES (11, 'Patient has a blood cancer.');
INSERT INTO Diagnosis (Diag_ID, notes) VALUES (12, 'Patient has a alzhimer.');
INSERT INTO Diagnosis (Diag_ID, notes) VALUES (13, 'Patient has a Colon cancer.');
INSERT INTO Diagnosis (Diag_ID, notes) VALUES (14, 'Patient has a Anemia.');
INSERT INTO Diagnosis (Diag_ID, notes) VALUES (15, 'Patient has a Backache.');

SET IDENTITY_INSERT Diagnosis OFF;

/*Insert Data into Medicine Table*/
INSERT INTO Medicine (medicine_name) VALUES ('Paracetamol');
INSERT INTO Medicine (medicine_name) VALUES ('Ibuprofen');
INSERT INTO Medicine (medicine_name) VALUES ('Aspirin');
INSERT INTO Medicine (medicine_name) VALUES ('Amoxicillin');
INSERT INTO Medicine (medicine_name) VALUES ('Lisinopril');
INSERT INTO Medicine (medicine_name) VALUES ('Simvastatin');
INSERT INTO Medicine (medicine_name) VALUES ('Metformin');
INSERT INTO Medicine (medicine_name) VALUES ('Loratadine');
INSERT INTO Medicine (medicine_name) VALUES ('Omeprazole');
INSERT INTO Medicine (medicine_name) VALUES ('Metoprolol');
INSERT INTO Medicine (medicine_name) VALUES ('Warfarin');
INSERT INTO Medicine (medicine_name) VALUES ('Ciprofloxacin');
INSERT INTO Medicine (medicine_name) VALUES ('Atorvastatin');
INSERT INTO Medicine (medicine_name) VALUES ('Levothyroxine');
INSERT INTO Medicine (medicine_name) VALUES ('Amlodipine');
INSERT INTO Medicine (medicine_name) VALUES ('Prednisone');
INSERT INTO Medicine (medicine_name) VALUES ('Azithromycin');
INSERT INTO Medicine (medicine_name) VALUES ('Tramadol');
INSERT INTO Medicine (medicine_name) VALUES ('Diazepam');
INSERT INTO Medicine (medicine_name) VALUES ('Morphine');

/*Insert Data into Patient Table*/
SET IDENTITY_INSERT Patient ON;

INSERT INTO Patient (PatientID, F_Name, M_Name, L_Name, Sex, DOB, Insurance_ID, Add_ID, Diag_ID, Medicine_ID, Email, Telephone, DateLeft) 
VALUES 
(1, 'Alice', 'Grace', 'Johnson', 'Female', '1992-06-10', 5, 5, 3, 1, 'alice.johnson@example.com', '1112223334', NULL),
(2, 'David', NULL, 'Brown', 'Male', '1980-09-17', 3, 6, 6, 5, 'david.brown@example.com', '4445556667', NULL),
(3, 'Sophia', 'Ella', 'Martinez', 'Female', '1975-12-05', 1, 7, 9, 10, 'sophia.martinez@example.com', '7778889990', NULL),
(4, 'William', 'James', 'Taylor', 'Male', '1988-02-28', 6, 8, 2, 15, 'william.taylor@example.com', '1234567890', NULL),
(5, 'Olivia', NULL, 'Anderson', 'Female', '1996-04-15', 4, 9, 7, 20, 'olivia.anderson@example.com', '9876543210', NULL),
(6, 'Daniel', NULL, 'White', 'Male', '1983-07-20', 2, 10, 10, 2, 'daniel.white@example.com', '5556667778', NULL),
(7, 'Isabella', 'Grace', 'Wilson', 'Female', '1990-10-30', 7, 1, 11, 10, 'isabella.wilson@example.com', '3334445556', NULL),
(8, 'Alexander', NULL, 'Clark', 'Male', '1986-03-25', 5, 2, 12, 12, 'alexander.clark@example.com', '9990001112', NULL),
(9, 'Mia', 'Ava', 'Lewis', 'Female', '1977-08-12', 3, 3, 13, 2, 'mia.lewis@example.com', '1112223334', NULL),
(10, 'James', NULL, 'Harris', 'Male', '1994-11-07', 1, 4, 14, 4, 'james.harris@example.com', '7778889990', NULL),
(11, 'Charlotte', NULL, 'King', 'Female', '1981-01-22', 6, 5, 15, 5, 'charlotte.king@example.com', '5556667778', NULL),
(12, 'Benjamin', 'Thomas', 'Lee', 'Male', '1998-05-18', 4, 6, 6, 16, 'benjamin.lee@example.com', '3334445556', NULL),
(13, 'Amelia', NULL, 'Young', 'Female', '1984-09-03', 2, 7, 15, 19, 'amelia.young@example.com', '9990001112', NULL),
(14, 'Jacob', 'Matthew', 'Scott', 'Male', '1979-12-28', 7, 8, 1, 8, 'jacob.scott@example.com', '1112223334', NULL),
(15, 'Evelyn', 'Sophia', 'Green', 'Female', '1991-02-14', 5, 9, 11, 19, 'evelyn.green@example.com', '7778889990', NULL),
(16, 'John', NULL, 'Smith', 'Male', '1984-04-20', 3, 10, 10, 10, 'john.smith@example.com', '1234567890', NULL),
(17, 'Mary', 'Elizabeth', 'Jones', 'Female', '1984-01-01', 1, 1, 13, 20, 'mary.jones@example.com', '9876543210', NULL);

SET IDENTITY_INSERT Patient OFF;

/*Insert Data into Appointment Table*/
INSERT INTO Appointment (AppointmentDate, AppointmentTime, DeptID, PatientID, DoctorID, Status) 
VALUES 
('2024-05-21', '10:00', 1, 10, 2, 'compeleted'),
('2024-05-22', '11:30', 2, 16, 10, 'Pending'),
('2024-05-23', '14:00', 3, 13, 2, 'completed'),
('2024-05-24', '09:45', 1, 10, 10, 'Pending'),
('2024-05-25', '13:15', 2, 7, 2, 'Pending'),
('2024-06-20', '10:00:00', 1, 17, 1, 'Pending'),
('2024-06-21', '14:30:00', 3, 6, 2, 'Pending'),
('2024-06-22', '09:45:00', 5, 15, 3, 'Pending'),
('2024-06-23', '11:15:00', 7, 4, 4, 'Pending'),
('2024-06-24', '16:00:00', 9, 8, 5, 'Pending'),
('2024-06-25', '12:30:00', 2, 6, 9, 'Pending'),
('2024-06-26', '08:45:00', 4, 7, 2, 'Pending'),
('2024-06-27', '13:00:00', 6, 13, 3, 'Pending'),
('2024-06-28', '15:45:00', 8, 12, 4, 'Pending'),
('2024-06-29', '10:30:00', 10, 10, 5, 'Pending');
DELETE from Appointment;

/*Insert Data into completedappointment Table*/
INSERT INTO Completedappointment (Date, Time, DoctorID, PatientID)
VALUES
    ('2024-04-22', '08:00:00', 1, 1),
    ('2024-04-23', '09:00:00', 2, 2),
    ('2024-04-24', '10:00:00', 3, 3),
    ('2024-04-25', '11:00:00', 1, 4),
    ('2024-04-26', '12:00:00', 2, 5),
    ('2024-04-27', '13:00:00', 3, 6),
    ('2024-04-28', '14:00:00', 1, 7),
    ('2024-04-29', '15:00:00', 2, 8),
    ('2024-04-30', '16:00:00', 3, 9),
    ('2024-05-01', '17:00:00', 1, 10);

/*Insert Data into prescription Table*/
SET IDENTITY_INSERT Prescription ON;

INSERT INTO Prescription (PresID, appID, medicine_ID, Medical_Order_Note, MedPrescriptionDate)
VALUES 
(1, 1, 1, 'Take twice a day after meals', '2024-04-25'),
(2, 2, 12, 'Take one tablet daily in the morning', '2024-04-26'),
(3, 3, 13, 'Take as needed for pain relief', '2024-04-27'),
(4, 4, 4, 'Take with food, once daily', '2024-04-28'),
(5, 5, 15, 'Apply to affected area twice a day', '2024-04-29'),
(6, 6, 16, 'Take two tablets before bedtime', '2024-04-30'),
(7, 7, 7, 'Take with meals, three times daily', '2024-05-01'),
(8, 8, 10, 'Take one capsule every 12 hours', '2024-05-02'),
(9, 9, 9, 'Use twice daily', '2024-05-03'),
(10, 10, 11, 'Take with water, once daily after breakfast', '2024-05-04');

SET IDENTITY_INSERT Prescription OFF;

/*Insert Data Into Allergy Table*/
INSERT INTO Allergy (allergy_name)
VALUES 
    ('Peanuts'),
    ('Shellfish'),
    ('Pollen'),
    ('Penicillin'),
    ('Dust'),
    ('Eggs'),
    ('Milk'),
    ('Soy'),
    ('Wheat'),
    ('Fish');

/*Insert Data into Review Table*/
SET IDENTITY_INSERT Review ON;

INSERT INTO Review (Review_ID, appID, feedback)
VALUES 
(1, 1, 'Great service and friendly staff.'),
(2, 2, 'The doctor was very knowledgeable and helpful.'),
(3, 3, 'I had to wait too long for my appointment.'),
(4, 4, 'The medication prescribed worked well for me.'),
(5, 5, 'The clinic was clean and well-maintained.'),
(6, 6, 'The staff was polite and professional.'),
(7, 7, 'I experienced some side effects from the medication.'),
(8, 8, 'The doctor explained my condition clearly.'),
(9, 9, 'The appointment scheduling process was smooth.'),
(10, 10, 'The waiting area was comfortable.');

SET IDENTITY_INSERT Review OFF;

/*Insert Data Into patall Table*/
INSERT INTO Patall (patientID, allergy_ID, Degree)
VALUES 
    (1, 1, 'Severe'),
    (1, 2, 'Moderate'),
    (2, 3, 'Mild'),
    (3, 1, 'Moderate'),
    (3, 4, 'Severe'),
    (4, 5, 'Mild'),
    (5, 2, 'Severe');

/*Insert Data into medipress table*/

INSERT INTO medipres (medipresID, medicine_ID, presID) 
VALUES 
(1, 1, 5),
(2, 10, 2),
(3, 12, 4),
(4, 4, 6),
(5, 16, 3),
(6, 8, 9),
(7, 17, 4),
(8, 11, 1),
(9, 9, 2),
(10, 14, 7);

/*Part 2*/

/*Add the constraint to check that the appointment date is not in the past.*/

ALTER TABLE dbo.Appointment
ADD CONSTRAINT CHK_AppointmentDate CHECK (AppointmentDate >= CAST(GETDATE() AS DATE));

/*all the patients with older than 40 and have Cancer in diagnosis*/

SELECT DISTINCT M.PatientID, M.DiagnosisNotes
FROM MedicalRecordsView M
WHERE M.DiagnosisNotes LIKE '%cancer%';

/*stored procedure */
CREATE PROCEDURE SearchMedicineByName
    @MedicineName VARCHAR(100)
AS
BEGIN
    SELECT *
    FROM MedicineTable
    WHERE MedicineName LIKE '%' + @MedicineName + '%'
    ORDER BY PrescribedDate DESC;
END;

CREATE PROCEDURE GetPatientDetailsForToday
    @PatientID INT
AS
BEGIN
    SELECT DiagnosisNotes AS Diagnosis, Allergy
    FROM MedicalRecordsView
    WHERE PatientID = @PatientID
    AND CONVERT(date, Date) = CONVERT(date, GETDATE());
END;

CREATE PROCEDURE UpdateDoctorDetails
    @DoctorID INT,
    @NewName VARCHAR(100),
    @NewSpecialization VARCHAR(100)
AS
BEGIN
    UPDATE DoctorTable
    SET Name = @NewName,
        Specialization = @NewSpecialization
    WHERE DoctorID = @DoctorID;
END;

CREATE PROCEDURE DeleteCompletedAppointments
AS
BEGIN
    DELETE FROM Appointments
    WHERE Status = 'Completed';
END;

/*Appointment View */
CREATE VIEW CurrentAppointmentsView AS
SELECT
    CA.appID,
    CA.Date,
    CA.Time,
    D.DoctorID,
    D.DrName,
    D.Speciality,
    DEP.Dept_Name AS Department,
    R.Review_ID,
    R.Feedback
FROM
    Completedappointment CA
    JOIN Doctor D ON CA.DoctorID = D.DoctorID
    JOIN Department DEP ON D.DeptID = DEP.DeptID
    LEFT JOIN Review R ON CA.appID = R.appID;

/*change the status of cancelled appointment to available*/
CREATE TRIGGER UpdateAppointmentState
ON Appointment
AFTER UPDATE
AS
BEGIN
    IF UPDATE(Status)
    BEGIN
        UPDATE Appointment
        SET Status = 'available'
        FROM inserted
        WHERE Appointment.AppointmentID = inserted.AppointmentID
          AND inserted.Status = 'cancelled';
    END
END;

/*count the number of compeleted appointment which is done by Gastroenterologist*/
SELECT COUNT(*) AS CompletedAppointments
FROM Appointment AS A
JOIN Doctor AS D ON A.DoctorID = D.DoctorID
WHERE A.Status = 'completed'
AND D.Speciality = 'Gastroenterologist';






	