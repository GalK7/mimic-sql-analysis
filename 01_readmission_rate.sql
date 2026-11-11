with adm_seq as(
	select a.subject_id , a.hadm_id , a.admittime , a.dischtime,a.hospital_expire_flag,
	LAG(a.dischtime ) over (partition by a.subject_id order by a.admittime) as prev_dischtime
	from mimiciv_hosp.admissions a
),
adm_gap as(
	select subject_id, hadm_id , admittime, prev_dischtime,hospital_expire_flag,
	admittime::date - prev_dischtime::date as days_since_prev
	from adm_seq 
),
adm_flag as(
	select subject_id, hadm_id, hospital_expire_flag, 
	case
		when days_since_prev <= 30 then 1
		else 0
	end as readmit_30
	from adm_gap
)
select count(hadm_id) as total_adm, 
sum(readmit_30) as n_readmit_30, 
round(sum(readmit_30)*100.0/count(hadm_id),1) as pct_of_all_adm, 
count(hadm_id) filter (where hospital_expire_flag = 0) as n_discharges,
round(sum(readmit_30)*100.0 / count(hadm_id) filter (where hospital_expire_flag = 0), 1) as readmit_30_rate
from adm_flag 