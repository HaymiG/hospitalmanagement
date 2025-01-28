USE hospital;

-- Drop tables in correct order (due to foreign key constraints)
DROP TABLE IF EXISTS `appointments`;
DROP TABLE IF EXISTS `medical_records`;
DROP TABLE IF EXISTS `prescriptions`;
DROP TABLE IF EXISTS `notifications`;
DROP TABLE IF EXISTS `patient`;
DROP TABLE IF EXISTS `doctor`;
DROP TABLE IF EXISTS `users`;

-- Create users table first
CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL UNIQUE,
  `password` varchar(100) NOT NULL,
  `user_type` varchar(20) NOT NULL DEFAULT 'general',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;

-- Insert sample user
INSERT INTO `users` (username, password, user_type)
VALUES ('sumeya', 'password123', 'general');

-- Create doctor table
CREATE TABLE IF NOT EXISTS `doctor` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fname` varchar(100) NOT NULL,
  `lname` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL UNIQUE,
  `password` varchar(100) NOT NULL,
  `specialization` varchar(100),
  `contact` varchar(15),
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;

-- Insert sample doctor
INSERT INTO `doctor` (fname, lname, email, password, specialization, contact)
VALUES 
('Sarah', 'Johnson', 'test@doctor.com', 'doctor123', 'General Medicine', '9876543210'),
('Michael', 'Chen', 'chen@doctor.com', 'doctor123', 'Cardiology', '9876543211'),
('Emily', 'Williams', 'williams@doctor.com', 'doctor123', 'Pediatrics', '9876543212'),
('James', 'Smith', 'smith@doctor.com', 'doctor123', 'Orthopedics', '9876543213'),
('Maria', 'Garcia', 'garcia@doctor.com', 'doctor123', 'Dermatology', '9876543214');

-- Create patient table
CREATE TABLE IF NOT EXISTS `patient` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fname` varchar(100) DEFAULT NULL,
  `lname` varchar(100) DEFAULT NULL,
  `email` varchar(100) NOT NULL UNIQUE,
  `password` varchar(100) NOT NULL,
  `gender` varchar(10) DEFAULT NULL,
  `dob` date DEFAULT NULL,
  `blood_group` varchar(5) DEFAULT NULL,
  `mobile` varchar(15) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `medical_history` text DEFAULT NULL,
  `emergency_contact_name` varchar(100) DEFAULT NULL,
  `emergency_contact_phone` varchar(15) DEFAULT NULL,
  `profile_completed` boolean DEFAULT FALSE,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;

-- Insert sample patient
INSERT INTO `patient` (email, password)
VALUES ('sumeya@test.com', 'password123');

-- Create medical_records table
CREATE TABLE IF NOT EXISTS `medical_records` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `patient_id` int(11) NOT NULL,
  `doctor_id` int(11) NOT NULL,
  `visit_date` date NOT NULL,
  `visit_type` varchar(100) NOT NULL,
  `diagnosis` text,
  `treatment` text,
  `notes` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `patient_id` (`patient_id`),
  KEY `doctor_id` (`doctor_id`),
  CONSTRAINT `medical_records_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `patient` (`id`),
  CONSTRAINT `medical_records_ibfk_2` FOREIGN KEY (`doctor_id`) REFERENCES `doctor` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;

-- Insert sample medical records
INSERT INTO `medical_records` (patient_id, doctor_id, visit_date, visit_type, diagnosis, treatment, notes)
SELECT 
  (SELECT id FROM patient WHERE email = 'sumeya@test.com'),
  (SELECT id FROM doctor WHERE email = 'test@doctor.com'),
  '2023-12-20',
  'Follow-up',
  'Mild flu',
  'Prescribed antibiotics',
  'Follow up in 1 week';

INSERT INTO `medical_records` (patient_id, doctor_id, visit_date, visit_type, diagnosis, treatment, notes)
SELECT 
  (SELECT id FROM patient WHERE email = 'sumeya@test.com'),
  (SELECT id FROM doctor WHERE email = 'test@doctor.com'),
  '2023-12-15',
  'General Checkup',
  'Routine checkup',
  'No treatment needed',
  'All vitals normal';

-- Create notifications table
CREATE TABLE IF NOT EXISTS `notifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `user_type` enum('patient','doctor','admin') NOT NULL,
  `message` text NOT NULL,
  `is_read` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Create prescriptions table
CREATE TABLE IF NOT EXISTS `prescriptions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `patient_id` int(11) NOT NULL,
  `doctor_id` int(11) NOT NULL,
  `medication_name` varchar(255) NOT NULL,
  `dosage` varchar(100) NOT NULL,
  `frequency` varchar(100) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `status` varchar(20) DEFAULT 'active',
  `notes` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `patient_id` (`patient_id`),
  KEY `doctor_id` (`doctor_id`),
  CONSTRAINT `prescriptions_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `patient` (`id`),
  CONSTRAINT `prescriptions_ibfk_2` FOREIGN KEY (`doctor_id`) REFERENCES `doctor` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Insert sample prescriptions
INSERT INTO `prescriptions` (patient_id, doctor_id, medication_name, dosage, frequency, start_date, end_date, status, notes)
SELECT 
  (SELECT id FROM patient WHERE email = 'sumeya@test.com'),
  (SELECT id FROM doctor WHERE email = 'test@doctor.com'),
  'Amoxicillin',
  '500mg',
  'Twice daily',
  CURDATE(),
  DATE_ADD(CURDATE(), INTERVAL 7 DAY),
  'active',
  'Take with food';

INSERT INTO `prescriptions` (patient_id, doctor_id, medication_name, dosage, frequency, start_date, end_date, status, notes)
SELECT 
  (SELECT id FROM patient WHERE email = 'sumeya@test.com'),
  (SELECT id FROM doctor WHERE email = 'williams@doctor.com'),
  'Ibuprofen',
  '400mg',
  'As needed for pain',
  CURDATE(),
  DATE_ADD(CURDATE(), INTERVAL 14 DAY),
  'active',
  'Do not exceed 4 doses in 24 hours';

-- Create appointments table
CREATE TABLE IF NOT EXISTS `appointments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `patient_id` int(11) NOT NULL,
  `doctor_id` int(11) NOT NULL,
  `appointment_date` date NOT NULL,
  `appointment_time` time NOT NULL,
  `status` varchar(20) DEFAULT 'pending',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `patient_id` (`patient_id`),
  KEY `doctor_id` (`doctor_id`),
  CONSTRAINT `appointments_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `patient` (`id`),
  CONSTRAINT `appointments_ibfk_2` FOREIGN KEY (`doctor_id`) REFERENCES `doctor` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;

-- Insert sample appointments
INSERT INTO `appointments` (patient_id, doctor_id, appointment_date, appointment_time, status)
SELECT 
  (SELECT id FROM patient WHERE email = 'sumeya@test.com'),
  (SELECT id FROM doctor WHERE email = 'test@doctor.com'),
  CURDATE(),
  '10:00:00',
  'scheduled';
