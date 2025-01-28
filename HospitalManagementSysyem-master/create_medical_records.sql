USE hospital;

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
  (SELECT id FROM patient WHERE email = 'patient@example.com'),
  (SELECT id FROM doctor WHERE email = 'test@doctor.com'),
  '2023-12-20',
  'Follow-up',
  'Mild flu',
  'Prescribed antibiotics',
  'Follow up in 1 week';

INSERT INTO `medical_records` (patient_id, doctor_id, visit_date, visit_type, diagnosis, treatment, notes)
SELECT 
  (SELECT id FROM patient WHERE email = 'patient@example.com'),
  (SELECT id FROM doctor WHERE email = 'test@doctor.com'),
  '2023-12-15',
  'General Checkup',
  'Routine checkup',
  'No treatment needed',
  'All vitals normal';
