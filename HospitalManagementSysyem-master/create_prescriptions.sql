-- Create prescriptions table if not exists
CREATE TABLE IF NOT EXISTS prescriptions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT,
    doctor_id INT,
    medication_name VARCHAR(100),
    dosage VARCHAR(50),
    frequency VARCHAR(50),
    start_date DATE,
    end_date DATE,
    status VARCHAR(20),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patient(id),
    FOREIGN KEY (doctor_id) REFERENCES doctor(id)
);

-- Insert test prescriptions
INSERT INTO prescriptions (patient_id, doctor_id, medication_name, dosage, frequency, start_date, end_date, status, notes)
VALUES 
(2, 1, 'Amoxicillin', '500mg', 'Three times daily', '2024-12-25', '2025-01-02', 'active', 'Take with food'),
(2, 1, 'Paracetamol', '650mg', 'As needed', '2024-12-25', '2025-01-10', 'active', 'Take for fever or pain'),
(2, 2, 'Vitamin D3', '1000 IU', 'Once daily', '2024-12-20', '2025-02-20', 'active', 'Take in the morning'),
(2, 2, 'Calcium', '500mg', 'Twice daily', '2024-12-20', '2025-02-20', 'active', 'Take with Vitamin D3');
