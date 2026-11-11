-- Load the MIMIC-IV Clinical Database Demo (v2.2) into PostgreSQL.
--
-- Before running:
--   1. Download the demo from https://physionet.org/content/mimic-iv-demo/ and extract it.
--   2. Decompress the .csv.gz files in hosp/ and icu/ to plain .csv.
--   3. Replace every "C:/path/to/mimic-iv-demo" below with the path of your extracted folder
--      (use forward slashes, also on Windows).
--
-- Run once from psql:  \i 'path/to/load_mimic.sql'
-- Creates a database called mimic with two schemas: mimiciv_hosp and mimiciv_icu.

\set ON_ERROR_STOP on
SET client_encoding = 'UTF8';

SELECT 'CREATE DATABASE mimic' WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'mimic')\gexec
\c mimic
SET client_encoding = 'UTF8';

DROP SCHEMA IF EXISTS mimiciv_hosp CASCADE;
DROP SCHEMA IF EXISTS mimiciv_icu CASCADE;
CREATE SCHEMA mimiciv_hosp;
CREATE SCHEMA mimiciv_icu;

-- hosp.admissions: 275 rows
CREATE TABLE mimiciv_hosp.admissions (
    subject_id INTEGER,
    hadm_id INTEGER PRIMARY KEY,
    admittime TIMESTAMP,
    dischtime TIMESTAMP,
    deathtime TIMESTAMP,
    admission_type TEXT,
    admit_provider_id TEXT,
    admission_location TEXT,
    discharge_location TEXT,
    insurance TEXT,
    language TEXT,
    marital_status TEXT,
    race TEXT,
    edregtime TIMESTAMP,
    edouttime TIMESTAMP,
    hospital_expire_flag INTEGER
);
\copy mimiciv_hosp.admissions FROM 'C:/path/to/mimic-iv-demo/hosp/admissions.csv' WITH (FORMAT csv, HEADER true)

-- hosp.d_hcpcs: 89200 rows
CREATE TABLE mimiciv_hosp.d_hcpcs (
    code TEXT,
    category INTEGER,
    long_description TEXT,
    short_description TEXT
);
\copy mimiciv_hosp.d_hcpcs FROM 'C:/path/to/mimic-iv-demo/hosp/d_hcpcs.csv' WITH (FORMAT csv, HEADER true)

-- hosp.d_icd_diagnoses: 109775 rows
CREATE TABLE mimiciv_hosp.d_icd_diagnoses (
    icd_code TEXT,
    icd_version INTEGER,
    long_title TEXT
);
\copy mimiciv_hosp.d_icd_diagnoses FROM 'C:/path/to/mimic-iv-demo/hosp/d_icd_diagnoses.csv' WITH (FORMAT csv, HEADER true)

-- hosp.d_icd_procedures: 85257 rows
CREATE TABLE mimiciv_hosp.d_icd_procedures (
    icd_code TEXT,
    icd_version INTEGER,
    long_title TEXT
);
\copy mimiciv_hosp.d_icd_procedures FROM 'C:/path/to/mimic-iv-demo/hosp/d_icd_procedures.csv' WITH (FORMAT csv, HEADER true)

-- hosp.d_labitems: 1622 rows
CREATE TABLE mimiciv_hosp.d_labitems (
    itemid INTEGER PRIMARY KEY,
    label TEXT,
    fluid TEXT,
    category TEXT
);
\copy mimiciv_hosp.d_labitems FROM 'C:/path/to/mimic-iv-demo/hosp/d_labitems.csv' WITH (FORMAT csv, HEADER true)

-- hosp.diagnoses_icd: 4506 rows
CREATE TABLE mimiciv_hosp.diagnoses_icd (
    subject_id INTEGER,
    hadm_id INTEGER,
    seq_num INTEGER,
    icd_code TEXT,
    icd_version INTEGER
);
\copy mimiciv_hosp.diagnoses_icd FROM 'C:/path/to/mimic-iv-demo/hosp/diagnoses_icd.csv' WITH (FORMAT csv, HEADER true)

-- hosp.drgcodes: 454 rows
CREATE TABLE mimiciv_hosp.drgcodes (
    subject_id INTEGER,
    hadm_id INTEGER,
    drg_type TEXT,
    drg_code TEXT,
    description TEXT,
    drg_severity INTEGER,
    drg_mortality INTEGER
);
\copy mimiciv_hosp.drgcodes FROM 'C:/path/to/mimic-iv-demo/hosp/drgcodes.csv' WITH (FORMAT csv, HEADER true)

-- hosp.emar: 35835 rows
CREATE TABLE mimiciv_hosp.emar (
    subject_id INTEGER,
    hadm_id INTEGER,
    emar_id TEXT,
    emar_seq INTEGER,
    poe_id TEXT,
    pharmacy_id INTEGER,
    enter_provider_id TEXT,
    charttime TIMESTAMP,
    medication TEXT,
    event_txt TEXT,
    scheduletime TIMESTAMP,
    storetime TIMESTAMP
);
\copy mimiciv_hosp.emar FROM 'C:/path/to/mimic-iv-demo/hosp/emar.csv' WITH (FORMAT csv, HEADER true)

-- hosp.emar_detail: 72018 rows
CREATE TABLE mimiciv_hosp.emar_detail (
    subject_id INTEGER,
    emar_id TEXT,
    emar_seq INTEGER,
    parent_field_ordinal DOUBLE PRECISION,
    administration_type TEXT,
    pharmacy_id INTEGER,
    barcode_type TEXT,
    reason_for_no_barcode TEXT,
    complete_dose_not_given TEXT,
    dose_due TEXT,
    dose_due_unit TEXT,
    dose_given TEXT,
    dose_given_unit TEXT,
    will_remainder_of_dose_be_given TEXT,
    product_amount_given DOUBLE PRECISION,
    product_unit TEXT,
    product_code TEXT,
    product_description TEXT,
    product_description_other TEXT,
    prior_infusion_rate DOUBLE PRECISION,
    infusion_rate DOUBLE PRECISION,
    infusion_rate_adjustment TEXT,
    infusion_rate_adjustment_amount INTEGER,
    infusion_rate_unit TEXT,
    route TEXT,
    infusion_complete TEXT,
    completion_interval TEXT,
    new_iv_bag_hung TEXT,
    continued_infusion_in_other_location TEXT,
    restart_interval TEXT,
    side TEXT,
    site TEXT,
    non_formulary_visual_verification TEXT
);
\copy mimiciv_hosp.emar_detail FROM 'C:/path/to/mimic-iv-demo/hosp/emar_detail.csv' WITH (FORMAT csv, HEADER true)

-- hosp.hcpcsevents: 61 rows
CREATE TABLE mimiciv_hosp.hcpcsevents (
    subject_id INTEGER,
    hadm_id INTEGER,
    chartdate DATE,
    hcpcs_cd TEXT,
    seq_num INTEGER,
    short_description TEXT
);
\copy mimiciv_hosp.hcpcsevents FROM 'C:/path/to/mimic-iv-demo/hosp/hcpcsevents.csv' WITH (FORMAT csv, HEADER true)

-- hosp.labevents: 107727 rows
CREATE TABLE mimiciv_hosp.labevents (
    labevent_id INTEGER,
    subject_id INTEGER,
    hadm_id INTEGER,
    specimen_id INTEGER,
    itemid INTEGER,
    order_provider_id TEXT,
    charttime TIMESTAMP,
    storetime TIMESTAMP,
    value TEXT,
    valuenum DOUBLE PRECISION,
    valueuom TEXT,
    ref_range_lower DOUBLE PRECISION,
    ref_range_upper DOUBLE PRECISION,
    flag TEXT,
    priority TEXT,
    comments TEXT
);
\copy mimiciv_hosp.labevents FROM 'C:/path/to/mimic-iv-demo/hosp/labevents.csv' WITH (FORMAT csv, HEADER true)

-- hosp.microbiologyevents: 2899 rows
CREATE TABLE mimiciv_hosp.microbiologyevents (
    microevent_id INTEGER,
    subject_id INTEGER,
    hadm_id INTEGER,
    micro_specimen_id INTEGER,
    order_provider_id TEXT,
    chartdate TIMESTAMP,
    charttime TIMESTAMP,
    spec_itemid INTEGER,
    spec_type_desc TEXT,
    test_seq INTEGER,
    storedate TIMESTAMP,
    storetime TIMESTAMP,
    test_itemid INTEGER,
    test_name TEXT,
    org_itemid INTEGER,
    org_name TEXT,
    isolate_num INTEGER,
    quantity TEXT,
    ab_itemid INTEGER,
    ab_name TEXT,
    dilution_text TEXT,
    dilution_comparison TEXT,
    dilution_value DOUBLE PRECISION,
    interpretation TEXT,
    comments TEXT
);
\copy mimiciv_hosp.microbiologyevents FROM 'C:/path/to/mimic-iv-demo/hosp/microbiologyevents.csv' WITH (FORMAT csv, HEADER true)

-- hosp.omr: 2964 rows
CREATE TABLE mimiciv_hosp.omr (
    subject_id INTEGER,
    chartdate DATE,
    seq_num INTEGER,
    result_name TEXT,
    result_value TEXT
);
\copy mimiciv_hosp.omr FROM 'C:/path/to/mimic-iv-demo/hosp/omr.csv' WITH (FORMAT csv, HEADER true)

-- hosp.patients: 100 rows
CREATE TABLE mimiciv_hosp.patients (
    subject_id INTEGER PRIMARY KEY,
    gender TEXT,
    anchor_age INTEGER,
    anchor_year INTEGER,
    anchor_year_group TEXT,
    dod DATE
);
\copy mimiciv_hosp.patients FROM 'C:/path/to/mimic-iv-demo/hosp/patients.csv' WITH (FORMAT csv, HEADER true)

-- hosp.pharmacy: 15306 rows
CREATE TABLE mimiciv_hosp.pharmacy (
    subject_id INTEGER,
    hadm_id INTEGER,
    pharmacy_id INTEGER,
    poe_id TEXT,
    starttime TIMESTAMP,
    stoptime TIMESTAMP,
    medication TEXT,
    proc_type TEXT,
    status TEXT,
    entertime TIMESTAMP,
    verifiedtime TIMESTAMP,
    route TEXT,
    frequency TEXT,
    disp_sched TEXT,
    infusion_type TEXT,
    sliding_scale TEXT,
    lockout_interval INTEGER,
    basal_rate DOUBLE PRECISION,
    one_hr_max DOUBLE PRECISION,
    doses_per_24_hrs INTEGER,
    duration INTEGER,
    duration_interval TEXT,
    expiration_value INTEGER,
    expiration_unit TEXT,
    expirationdate TEXT,
    dispensation TEXT,
    fill_quantity TEXT
);
\copy mimiciv_hosp.pharmacy FROM 'C:/path/to/mimic-iv-demo/hosp/pharmacy.csv' WITH (FORMAT csv, HEADER true)

-- hosp.poe: 45154 rows
CREATE TABLE mimiciv_hosp.poe (
    poe_id TEXT,
    poe_seq INTEGER,
    subject_id INTEGER,
    hadm_id INTEGER,
    ordertime TIMESTAMP,
    order_type TEXT,
    order_subtype TEXT,
    transaction_type TEXT,
    discontinue_of_poe_id TEXT,
    discontinued_by_poe_id TEXT,
    order_provider_id TEXT,
    order_status TEXT
);
\copy mimiciv_hosp.poe FROM 'C:/path/to/mimic-iv-demo/hosp/poe.csv' WITH (FORMAT csv, HEADER true)

-- hosp.poe_detail: 3795 rows
CREATE TABLE mimiciv_hosp.poe_detail (
    poe_id TEXT,
    poe_seq INTEGER,
    subject_id INTEGER,
    field_name TEXT,
    field_value TEXT
);
\copy mimiciv_hosp.poe_detail FROM 'C:/path/to/mimic-iv-demo/hosp/poe_detail.csv' WITH (FORMAT csv, HEADER true)

-- hosp.prescriptions: 18087 rows
CREATE TABLE mimiciv_hosp.prescriptions (
    subject_id INTEGER,
    hadm_id INTEGER,
    pharmacy_id INTEGER,
    poe_id TEXT,
    poe_seq INTEGER,
    order_provider_id TEXT,
    starttime TIMESTAMP,
    stoptime TIMESTAMP,
    drug_type TEXT,
    drug TEXT,
    formulary_drug_cd TEXT,
    gsn TEXT,
    ndc TEXT,
    prod_strength TEXT,
    form_rx TEXT,
    dose_val_rx TEXT,
    dose_unit_rx TEXT,
    form_val_disp TEXT,
    form_unit_disp TEXT,
    doses_per_24_hrs INTEGER,
    route TEXT
);
\copy mimiciv_hosp.prescriptions FROM 'C:/path/to/mimic-iv-demo/hosp/prescriptions.csv' WITH (FORMAT csv, HEADER true)

-- hosp.procedures_icd: 722 rows
CREATE TABLE mimiciv_hosp.procedures_icd (
    subject_id INTEGER,
    hadm_id INTEGER,
    seq_num INTEGER,
    chartdate DATE,
    icd_code TEXT,
    icd_version INTEGER
);
\copy mimiciv_hosp.procedures_icd FROM 'C:/path/to/mimic-iv-demo/hosp/procedures_icd.csv' WITH (FORMAT csv, HEADER true)

-- hosp.provider: 40508 rows
CREATE TABLE mimiciv_hosp.provider (
    provider_id TEXT
);
\copy mimiciv_hosp.provider FROM 'C:/path/to/mimic-iv-demo/hosp/provider.csv' WITH (FORMAT csv, HEADER true)

-- hosp.services: 319 rows
CREATE TABLE mimiciv_hosp.services (
    subject_id INTEGER,
    hadm_id INTEGER,
    transfertime TIMESTAMP,
    prev_service TEXT,
    curr_service TEXT
);
\copy mimiciv_hosp.services FROM 'C:/path/to/mimic-iv-demo/hosp/services.csv' WITH (FORMAT csv, HEADER true)

-- hosp.transfers: 1190 rows
CREATE TABLE mimiciv_hosp.transfers (
    subject_id INTEGER,
    hadm_id INTEGER,
    transfer_id INTEGER,
    eventtype TEXT,
    careunit TEXT,
    intime TIMESTAMP,
    outtime TIMESTAMP
);
\copy mimiciv_hosp.transfers FROM 'C:/path/to/mimic-iv-demo/hosp/transfers.csv' WITH (FORMAT csv, HEADER true)

-- icu.caregiver: 15468 rows
CREATE TABLE mimiciv_icu.caregiver (
    caregiver_id INTEGER
);
\copy mimiciv_icu.caregiver FROM 'C:/path/to/mimic-iv-demo/icu/caregiver.csv' WITH (FORMAT csv, HEADER true)

-- icu.chartevents: 668862 rows
CREATE TABLE mimiciv_icu.chartevents (
    subject_id INTEGER,
    hadm_id INTEGER,
    stay_id INTEGER,
    caregiver_id INTEGER,
    charttime TIMESTAMP,
    storetime TIMESTAMP,
    itemid INTEGER,
    value TEXT,
    valuenum DOUBLE PRECISION,
    valueuom TEXT,
    warning INTEGER
);
\copy mimiciv_icu.chartevents FROM 'C:/path/to/mimic-iv-demo/icu/chartevents.csv' WITH (FORMAT csv, HEADER true)

-- icu.d_items: 4014 rows
CREATE TABLE mimiciv_icu.d_items (
    itemid INTEGER PRIMARY KEY,
    label TEXT,
    abbreviation TEXT,
    linksto TEXT,
    category TEXT,
    unitname TEXT,
    param_type TEXT,
    lownormalvalue INTEGER,
    highnormalvalue DOUBLE PRECISION
);
\copy mimiciv_icu.d_items FROM 'C:/path/to/mimic-iv-demo/icu/d_items.csv' WITH (FORMAT csv, HEADER true)

-- icu.datetimeevents: 15280 rows
CREATE TABLE mimiciv_icu.datetimeevents (
    subject_id INTEGER,
    hadm_id INTEGER,
    stay_id INTEGER,
    caregiver_id INTEGER,
    charttime TIMESTAMP,
    storetime TIMESTAMP,
    itemid INTEGER,
    value TIMESTAMP,
    valueuom TEXT,
    warning INTEGER
);
\copy mimiciv_icu.datetimeevents FROM 'C:/path/to/mimic-iv-demo/icu/datetimeevents.csv' WITH (FORMAT csv, HEADER true)

-- icu.icustays: 140 rows
CREATE TABLE mimiciv_icu.icustays (
    subject_id INTEGER,
    hadm_id INTEGER,
    stay_id INTEGER PRIMARY KEY,
    first_careunit TEXT,
    last_careunit TEXT,
    intime TIMESTAMP,
    outtime TIMESTAMP,
    los DOUBLE PRECISION
);
\copy mimiciv_icu.icustays FROM 'C:/path/to/mimic-iv-demo/icu/icustays.csv' WITH (FORMAT csv, HEADER true)

-- icu.ingredientevents: 25728 rows
CREATE TABLE mimiciv_icu.ingredientevents (
    subject_id INTEGER,
    hadm_id INTEGER,
    stay_id INTEGER,
    caregiver_id INTEGER,
    starttime TIMESTAMP,
    endtime TIMESTAMP,
    storetime TIMESTAMP,
    itemid INTEGER,
    amount DOUBLE PRECISION,
    amountuom TEXT,
    rate DOUBLE PRECISION,
    rateuom TEXT,
    orderid INTEGER,
    linkorderid INTEGER,
    statusdescription TEXT,
    originalamount INTEGER,
    originalrate DOUBLE PRECISION
);
\copy mimiciv_icu.ingredientevents FROM 'C:/path/to/mimic-iv-demo/icu/ingredientevents.csv' WITH (FORMAT csv, HEADER true)

-- icu.inputevents: 20404 rows
CREATE TABLE mimiciv_icu.inputevents (
    subject_id INTEGER,
    hadm_id INTEGER,
    stay_id INTEGER,
    caregiver_id INTEGER,
    starttime TIMESTAMP,
    endtime TIMESTAMP,
    storetime TIMESTAMP,
    itemid INTEGER,
    amount DOUBLE PRECISION,
    amountuom TEXT,
    rate DOUBLE PRECISION,
    rateuom TEXT,
    orderid INTEGER,
    linkorderid INTEGER,
    ordercategoryname TEXT,
    secondaryordercategoryname TEXT,
    ordercomponenttypedescription TEXT,
    ordercategorydescription TEXT,
    patientweight DOUBLE PRECISION,
    totalamount DOUBLE PRECISION,
    totalamountuom TEXT,
    isopenbag INTEGER,
    continueinnextdept INTEGER,
    statusdescription TEXT,
    originalamount DOUBLE PRECISION,
    originalrate DOUBLE PRECISION
);
\copy mimiciv_icu.inputevents FROM 'C:/path/to/mimic-iv-demo/icu/inputevents.csv' WITH (FORMAT csv, HEADER true)

-- icu.outputevents: 9362 rows
CREATE TABLE mimiciv_icu.outputevents (
    subject_id INTEGER,
    hadm_id INTEGER,
    stay_id INTEGER,
    caregiver_id INTEGER,
    charttime TIMESTAMP,
    storetime TIMESTAMP,
    itemid INTEGER,
    value INTEGER,
    valueuom TEXT
);
\copy mimiciv_icu.outputevents FROM 'C:/path/to/mimic-iv-demo/icu/outputevents.csv' WITH (FORMAT csv, HEADER true)

-- icu.procedureevents: 1468 rows
CREATE TABLE mimiciv_icu.procedureevents (
    subject_id INTEGER,
    hadm_id INTEGER,
    stay_id INTEGER,
    caregiver_id INTEGER,
    starttime TIMESTAMP,
    endtime TIMESTAMP,
    storetime TIMESTAMP,
    itemid INTEGER,
    value DOUBLE PRECISION,
    valueuom TEXT,
    location TEXT,
    locationcategory TEXT,
    orderid INTEGER,
    linkorderid INTEGER,
    ordercategoryname TEXT,
    ordercategorydescription TEXT,
    patientweight DOUBLE PRECISION,
    isopenbag INTEGER,
    continueinnextdept INTEGER,
    statusdescription TEXT,
    ORIGINALAMOUNT DOUBLE PRECISION,
    ORIGINALRATE INTEGER
);
\copy mimiciv_icu.procedureevents FROM 'C:/path/to/mimic-iv-demo/icu/procedureevents.csv' WITH (FORMAT csv, HEADER true)

-- Row counts, to check that every table loaded
SELECT table_schema, table_name FROM information_schema.tables WHERE table_schema LIKE 'mimiciv_%' ORDER BY 1, 2;
SELECT 'patients' AS table_name, COUNT(*) FROM mimiciv_hosp.patients UNION ALL SELECT 'admissions', COUNT(*) FROM mimiciv_hosp.admissions UNION ALL SELECT 'icustays', COUNT(*) FROM mimiciv_icu.icustays UNION ALL SELECT 'labevents', COUNT(*) FROM mimiciv_hosp.labevents UNION ALL SELECT 'chartevents', COUNT(*) FROM mimiciv_icu.chartevents;
