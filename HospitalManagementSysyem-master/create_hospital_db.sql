CREATE DATABASE IF NOT EXISTS hospital;
USE hospital;

DROP TABLE IF EXISTS `doctor`;
CREATE TABLE `doctor` (
  `id` int(11) NOT NULL,
  `fname` varchar(100) default NULL,
  `lname` varchar(100) default NULL,
  `gender` varchar(100) default NULL,
  `mobile` varchar(100) default NULL,
  `city` varchar(100) default NULL,
  `email` varchar(100) default NULL,
  `password` varchar(100) default NULL,
  `age` varchar(100) default NULL,
  `address` varchar(100) default NULL,
  `date` varchar(100) default NULL,
  `qualification` varchar(100) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `doctor` VALUES 
(1, 'Test', 'Doctor', 'Male', '1234567890', 'Test City', 'test@doctor.com', 'doctor123', '35', 'Test Address', '2024-01-01', 'MBBS'),
(2, 'John', 'Smith', 'Male', '9876543210', 'New York', 'john@doctor.com', 'doctor123', '40', '123 Medical St', '2024-01-01', 'MD');
