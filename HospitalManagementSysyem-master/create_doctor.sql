USE hospital;

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
('Sarah', 'Johnson', 'test@doctor.com', 'doctor123', 'General Medicine', '9876543210');
