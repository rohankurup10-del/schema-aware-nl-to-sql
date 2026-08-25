-- Create the 'patients' table
CREATE TABLE patients (
    patient_id INTEGER PRIMARY KEY,
    first_name TEXT,
    last_name TEXT,
    date_of_birth DATE,
    gender TEXT,
    contact_number TEXT,
    address TEXT
);

-- Insert sample data into 'patients'
INSERT INTO patients (first_name, last_name, date_of_birth, gender, contact_number, address) VALUES
('John', 'Doe', '1980-01-01', 'Male', '555-1234', '123 Elm St, Springfield'),
('Jane', 'Smith', '1990-02-15', 'Female', '555-5678', '456 Oak St, Springfield'),
('Robert', 'Brown', '1975-03-30', 'Male', '555-7890', '789 Pine St, Springfield'),
('Emily', 'Davis', '1985-07-20', 'Female', '555-2468', '101 Maple St, Springfield'),
('Michael', 'Miller', '2000-05-10', 'Male', '555-3691', '202 Birch St, Springfield'),
('Olivia', 'Taylor', '1995-12-01', 'Female', '555-4812', '303 Cedar St, Springfield'),
('Daniel', 'Wilson', '1978-08-19', 'Male', '555-5923', '404 Redwood St, Springfield'),
('Sophia', 'Moore', '1992-09-25', 'Female', '555-6034', '505 Cherry St, Springfield'),
('James', 'Anderson', '1982-06-12', 'Male', '555-7145', '606 Walnut St, Springfield'),
('Ava', 'Thomas', '1998-04-18', 'Female', '555-8256', '707 Ash St, Springfield');

-- Create the 'doctors' table
CREATE TABLE doctors (
    doctor_id INTEGER PRIMARY KEY,
    first_name TEXT,
    last_name TEXT,
    specialty TEXT,
    contact_number TEXT,
    department_id INTEGER
);

-- Insert sample data into 'doctors'
INSERT INTO doctors (first_name, last_name, specialty, contact_number, department_id) VALUES
('Dr. Alice', 'Jones', 'Cardiologist', '555-2234', 1),
('Dr. Bob', 'White', 'Dermatologist', '555-3345', 2),
('Dr. Carol', 'Green', 'Orthopedic', '555-4456', 3),
('Dr. David', 'Black', 'Neurologist', '555-5567', 4),
('Dr. Eve', 'Red', 'Pediatrician', '555-6678', 5),
('Dr. Frank', 'Blue', 'General Surgeon', '555-7789', 6),
('Dr. Grace', 'Yellow', 'Gastroenterologist', '555-8890', 7),
('Dr. Henry', 'Purple', 'Urologist', '555-9901', 8),
('Dr. Iris', 'Pink', 'Psychiatrist', '555-1112', 9),
('Dr. Jack', 'Grey', 'Dentist', '555-2223', 10);

-- Create the 'appointments' table
CREATE TABLE appointments (
    appointment_id INTEGER PRIMARY KEY,
    patient_id INTEGER,
    doctor_id INTEGER,
    appointment_date DATE,
    appointment_time TIME,
    diagnosis TEXT,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
);

-- Insert sample data into 'appointments'
INSERT INTO appointments (patient_id, doctor_id, appointment_date, appointment_time, diagnosis) VALUES
(1, 1, '2025-02-10', '09:00', 'Hypertension'),
(2, 2, '2025-02-11', '10:30', 'Skin rash'),
(3, 3, '2025-02-12', '14:00', 'Joint pain'),
(4, 4, '2025-02-13', '08:45', 'Migraines'),
(5, 5, '2025-02-14', '11:30', 'Flu'),
(6, 6, '2025-02-15', '13:00', 'Appendicitis'),
(7, 7, '2025-02-16', '15:00', 'Stomach ulcers'),
(8, 8, '2025-02-17', '16:30', 'Urinary tract infection'),
(9, 9, '2025-02-18', '17:15', 'Depression'),
(10, 10, '2025-02-19', '10:00', 'Cavity');

-- Create the 'departments' table
CREATE TABLE departments (
    department_id INTEGER PRIMARY KEY,
    name TEXT
);

-- Insert sample data into 'departments'
INSERT INTO departments (name) VALUES
('Cardiology'),
('Dermatology'),
('Orthopedics'),
('Neurology'),
('Pediatrics'),
('General Surgery'),
('Gastroenterology'),
('Urology'),
('Psychiatry'),
('Dentistry');

-- Create the 'medications' table
CREATE TABLE medications (
    medication_id INTEGER PRIMARY KEY,
    name TEXT,
    dosage TEXT,
    patient_id INTEGER,
    doctor_id INTEGER,
    prescription_date DATE,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
);

-- Insert sample data into 'medications'
INSERT INTO medications (name, dosage, patient_id, doctor_id, prescription_date) VALUES
('Amlodipine', '5mg daily', 1, 1, '2025-02-10'),
('Hydrocortisone', '2.5mg twice daily', 2, 2, '2025-02-11'),
('Ibuprofen', '200mg as needed', 3, 3, '2025-02-12'),
('Sumatriptan', '50mg as needed', 4, 4, '2025-02-13'),
('Oseltamivir', '75mg twice daily', 5, 5, '2025-02-14'),
('Morphine', '10mg every 4 hours', 6, 6, '2025-02-15'),
('Omeprazole', '20mg daily', 7, 7, '2025-02-16'),
('Ciprofloxacin', '500mg twice daily', 8, 8, '2025-02-17'),
('Sertraline', '50mg daily', 9, 9, '2025-02-18'),
('Amoxicillin', '500mg every 8 hours', 10, 10, '2025-02-19');

-- Create the 'hospital_bills' table
CREATE TABLE hospital_bills (
    bill_id INTEGER PRIMARY KEY,
    patient_id INTEGER,
    total_amount DECIMAL(10, 2),
    bill_date DATE,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
);

-- Insert sample data into 'hospital_bills'
INSERT INTO hospital_bills (patient_id, total_amount, bill_date) VALUES
(1, 1500.50, '2025-02-10'),
(2, 1200.75, '2025-02-11'),
(3, 1000.25, '2025-02-12'),
(4, 800.00, '2025-02-13'),
(5, 200.00, '2025-02-14'),
(6, 500.50, '2025-02-15'),
(7, 1200.00, '2025-02-16'),
(8, 300.50, '2025-02-17'),
(9, 400.75, '2025-02-18'),
(10, 600.25, '2025-02-19');
