-- Create patient notifications table if not exists
CREATE TABLE IF NOT EXISTS patient_notifications (
    id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT,
    title VARCHAR(200),
    message TEXT,
    is_read BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patient(id)
);

-- Insert some test notifications for patient ID 2
INSERT INTO patient_notifications (patient_id, title, message) VALUES
(2, 'Appointment Confirmed', 'Your appointment with Dr. Smith has been confirmed for tomorrow at 10:00 AM.'),
(2, 'Prescription Updated', 'Your prescription for Amoxicillin has been updated. Please check your prescriptions.'),
(2, 'Lab Results Available', 'Your recent lab test results are now available. Please consult with your doctor.'),
(2, 'Appointment Reminder', 'Reminder: You have an upcoming appointment next week.');
