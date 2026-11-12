with icu_stays as (
	select i.hadm_id as adm_id,
	i.stay_id as stay_id,
	i.first_careunit as care_unit,
	i.intime as in_time,
	i.los as los,
	a.hospital_expire_flag as adm_outcome,
	row_number() over (partition by i.hadm_id order by i.intime) as stay_num
	from mimiciv_icu.icustays i 
	join mimiciv_hosp.admissions a
	on i.hadm_id = a.hadm_id
)
select care_unit,
count(distinct stay_id ) as n_stays,
round(avg(los)::numeric, 1) as avg_los,
round(percentile_cont(0.5) within group (order by los)::numeric, 1) as med_los,
count(*) filter (where stay_num = 1) as n_admissions,
count(*) filter (where stay_num = 1 and adm_outcome = 1) as n_deaths,
round((count(*) filter (where stay_num = 1 and adm_outcome = 1)) * 100.0 / count(*) filter (where stay_num = 1), 1) as mortality_pct
from icu_stays
group by care_unit
order by n_stays desc;