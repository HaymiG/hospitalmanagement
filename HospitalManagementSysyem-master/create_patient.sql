USE hospital;

CREATE TABLE IF NOT EXISTS `patient` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fname` varchar(100) NOT NULL,
  `lname` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(100) NOT NULL,
  `gender` varchar(10),
  `age` int,
  `mobile` varchar(15),
  `address` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;

-- Add a sample patient for testing
INSERT INTO `patient` (fname, lname, email, password, gender, age, mobile, address)
VALUES 
('John', 'Doe', 'patient@example.com', 'patient123', 'Male', 30, '1234567890', '123 Patient St');
