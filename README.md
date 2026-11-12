# mimic-sql-analysis

SQL analyses of hospital admission and ICU data from the MIMIC-IV Clinical Database Demo. Each query answers a question that hospitals and health organizations routinely track, such as readmissions and length of stay. The repository contains code only; the data is not included.

## Requirements

- PostgreSQL. The queries were written and run on a local PostgreSQL server and use PostgreSQL syntax.
- An SQL client. The queries were developed in DBeaver; any client that connects to PostgreSQL works.
- The [MIMIC-IV Clinical Database Demo v2.2](https://physionet.org/content/mimic-iv-demo/) (open access, ODbL license): de-identified records of 100 patients and 275 hospital admissions from Beth Israel Deaconess Medical Center, Boston.

## Project Structure

| Path | Contents |
| --- | --- |
| `setup/load_mimic.sql` | Creates the `mimic` database and loads the demo tables into the schemas `mimiciv_hosp` and `mimiciv_icu`. |
| `01_readmission_rate.sql` | 30-day readmission rate. |
| `02_icu_los_by_unit.sql` | ICU length of stay and in-hospital mortality by care unit. |

## Setup

1. Download and extract the demo from PhysioNet, then decompress the `.csv.gz` files in `hosp/` and `icu/`.
2. In `setup/load_mimic.sql`, replace `C:/path/to/mimic-iv-demo` with the path of the extracted folder.
3. Run the script once from `psql`:

```text
\i 'path/to/setup/load_mimic.sql'
```

4. Connect your SQL client to the `mimic` database and run any analysis file.

MIMIC shifts all dates to the years 2100–2200 for de-identification. Intervals between dates of the same patient are preserved, so durations and gaps between admissions are valid.

## Analyses

| File | Question | Main SQL techniques |
| --- | --- | --- |
| `01_readmission_rate.sql` | What share of discharges is followed by a readmission within 30 days? | CTEs, `LAG` window function, date arithmetic, `CASE WHEN`, `FILTER` |
| `02_icu_los_by_unit.sql` | How long are ICU stays in each care unit, and what share of admissions with an ICU stay ends in in-hospital death? | CTE, `JOIN`, `ROW_NUMBER` window function, `PERCENTILE_CONT`, `FILTER` |

### 01 – 30-day readmission rate

An admission is counted as a 30-day readmission if it started 30 days or less after the same patient's previous discharge. The rate is calculated per discharge: admissions that ended in in-hospital death are excluded from the denominator, since those patients could not be readmitted.

| Measure | Value |
| --- | --- |
| Total admissions | 275 |
| 30-day readmissions | 53 |
| Readmissions as share of all admissions | 19.3% |
| Discharges (alive) | 260 |
| 30-day readmission rate, per discharge | 20.4% |

The demo includes 100 patients, so these values describe the sample and not the hospital population. Planned and unplanned readmissions are not distinguished, and readmissions to other hospitals are not captured.

### 02 – ICU length of stay and mortality by care unit

Length of stay is calculated per ICU stay. An admission can include more than one ICU stay (140 stays in 128 admissions), so mortality is calculated per admission: each admission is counted once and assigned to the care unit of its first ICU stay. Mortality refers to death at any point during the hospital admission, not necessarily in the ICU.

| Care unit | ICU stays | Mean LOS (days) | Median LOS (days) | Admissions | Deaths | Mortality |
| --- | --- | --- | --- | --- | --- | --- |
| Surgical ICU (SICU) | 29 | 2.8 | 1.8 | 27 | 2 | 7.4% |
| Medical ICU (MICU) | 29 | 4.0 | 2.9 | 25 | 5 | 20.0% |
| Cardiac Vascular ICU (CVICU) | 25 | 2.2 | 2.0 | 25 | 0 | 0.0% |
| Medical/Surgical ICU (MICU/SICU) | 23 | 4.2 | 2.9 | 22 | 3 | 13.6% |
| Trauma SICU (TSICU) | 16 | 4.1 | 2.0 | 15 | 1 | 6.7% |
| Coronary Care Unit (CCU) | 13 | 5.4 | 5.0 | 10 | 3 | 30.0% |
| Neuro Surgical ICU (Neuro SICU) | 3 | 6.3 | 5.5 | 2 | 1 | 50.0% |
| Neuro Stepdown | 1 | 7.7 | 7.7 | 1 | 0 | 0.0% |
| Neuro Intermediate | 1 | 0.9 | 0.9 | 1 | 0 | 0.0% |

All 15 in-hospital deaths in the demo occurred in admissions that included an ICU stay. The three neuro units have one to three stays each, so their values are not informative.
