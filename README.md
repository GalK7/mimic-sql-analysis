# mimic-sql-analysis

SQL analyses of hospital admission data from the MIMIC-IV Clinical Database Demo. Each query answers a question that hospitals and health organizations routinely track, such as readmissions and length of stay. The repository contains code only; the data is not included.

## Requirements

- PostgreSQL. The queries were written and run on a local PostgreSQL server and use PostgreSQL syntax.
- An SQL client. The queries were developed in DBeaver; any client that connects to PostgreSQL works.
- The [MIMIC-IV Clinical Database Demo v2.2](https://physionet.org/content/mimic-iv-demo/) (open access, ODbL license): de-identified records of 100 patients and 275 hospital admissions from Beth Israel Deaconess Medical Center, Boston.

## Project Structure

| Path | Contents |
| --- | --- |
| `setup/load_mimic.sql` | Creates the `mimic` database and loads the demo tables into the schemas `mimiciv_hosp` and `mimiciv_icu`. |
| `01_readmission_rate.sql` | 30-day readmission rate. |

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
