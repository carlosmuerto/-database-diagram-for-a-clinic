CREATE DATABASE clinic;

BEGIN;

CREATE TABLE medical_histories (
	id INT GENERATED BY DEFAULT AS IDENTITY NOT NULL,
	admitted_at TIMESTAMP NOT NULL,
	patient_id INT NOT NULL,
	status VARCHAR NOT NULL,
	PRIMARY KEY(id)
);

CREATE TABLE patients (
	id INT GENERATED BY DEFAULT AS IDENTITY NOT NULL,
	name VARCHAR NOT NULL,
	date_of_birth DATE NOT NULL,
	PRIMARY KEY(id)
);

CREATE TABLE invoices (
	id INT GENERATED BY DEFAULT AS IDENTITY NOT NULL,
	total_amount DECIMAL NOT NULL,
	generated_at TIMESTAMP NOT NULL,
	payed_at TIMESTAMP NOT NULL,
	medical_history_id INT NOT NULL,
	PRIMARY KEY(id)
);

CREATE TABLE treatments (
	id INT GENERATED BY DEFAULT AS IDENTITY NOT NULL,
	type VARCHAR NOT NULL,
	name VARCHAR NOT NULL,
	PRIMARY KEY(id)
);

CREATE TABLE invoice_items (
	id INT GENERATED BY DEFAULT AS IDENTITY NOT NULL,
	unit_price DECIMAL NOT NULL,
	quantity int NOT NULL DEFAULT 0,
	total_price DECIMAL NOT NULL,
	invoice_id INT NOT NULL,
	treatment_id INT NOT NULL,
	PRIMARY KEY(id)
);

SAVEPOINT  createTables;

ALTER TABLE medical_histories
	ADD CONSTRAINT fk_medical_histories
	FOREIGN KEY (patient_id)
	REFERENCES patients (id);


COMMIT;

BEGIN;

ALTER TABLE invoices
  ADD CONSTRAINT fk_invoices
  FOREIGN KEY (medical_history_id)
  REFERENCES medical_histories (id);
  
ALTER TABLE invoice_items
  ADD CONSTRAINT fk_invoice_id
  FOREIGN KEY (invoice_id)
  REFERENCES invoices (id);
  
ALTER TABLE invoice_items
  ADD CONSTRAINT fk_treatments
  FOREIGN KEY (treatment_id)
  REFERENCES treatments (id);
  
SAVEPOINT  createOnToManyRel;

CREATE TABLE treatments_medical_histories (
  treatment_id INT NOT NULL,
  medical_history_id INT NOT NULL,
  CONSTRAINT treatments_medical_historiess_pkey PRIMARY KEY (treatment_id, medical_history_id)
);

ALTER TABLE treatments_medical_histories
  ADD CONSTRAINT fk_treatment_id
  FOREIGN KEY (treatment_id)
  REFERENCES treatments (id);
  
ALTER TABLE treatments_medical_histories
  ADD CONSTRAINT fk_medical_history_id
  FOREIGN KEY (medical_history_id)
  REFERENCES medical_histories (id);
  
SAVEPOINT  createMAnyToManyRel;

CREATE INDEX med_pati ON medical_histories (patient_id);

CREATE INDEX med_hist ON invoices (medical_history_id);

CREATE INDEX inv_item_invoices ON invoice_items (invoice_id);

CREATE INDEX inv_item_treatment ON invoice_items (treatment_id);

SAVEPOINT  createSimpleIndexs;

COMMIT;
