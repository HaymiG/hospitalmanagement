USE hospital;

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

-- Add some sample appointments for testing
INSERT INTO `appointments` (patient_id, doctor_id, appointment_date, appointment_time, status)
SELECT 
  (SELECT id FROM patient WHERE email = 'patient@example.com'),
  (SELECT id FROM doctor WHERE email = 'test@doctor.com'),
  CURDATE(),
  '10:00:00',
  'scheduled';

INSERT INTO `appointments` (patient_id, doctor_id, appointment_date, appointment_time, status)
SELECT 
  (SELECT id FROM patient WHERE email = 'patient@example.com'),
  (SELECT id FROM doctor WHERE email = 'test@doctor.com'),
  CURDATE(),
  '14:30:00',
  'scheduled';
