with icu_seq as(
select s.hadm_id, s.stay_id, s.intime,
row_number() over (partition by s.hadm_id order by s.intime) as stay_num
from mimiciv_icu.icustays s
),
first_icu as(
	select q.hadm_id, q.stay_id, q.intime, a.hospital_expire_flag  
	from icu_seq q
	join mimiciv_hosp.admissions a on q.hadm_id = a.hadm_id 
	where stay_num  = 1
),
lactate_24h as(
	select f.hadm_id, f.stay_id , f.hospital_expire_flag,
	max(e.valuenum ) as max_lactate
	from first_icu f
	left join mimiciv_hosp.labevents e
	on f.hadm_id = e.hadm_id and e.itemid = 50813 and e.charttime between f.intime and f.intime + INTERVAL  '24 hours'
	group by f.hadm_id, f.stay_id , f.hospital_expire_flag
)
select
case 
	when h.max_lactate is null then '0: not measured'
	when h.max_lactate < 2 then '1: normal (<2)'
	when h.max_lactate < 4 then '2: elevated (2-4)'
	else '3: high (>=4)'
end as lactate_group,
count(*) as n_admissions, count(*) filter (where hospital_expire_flag = 1) as n_deaths,
round(count(*) filter (where hospital_expire_flag = 1) * 100.0 / count(h.hadm_id), 1) as mortality_pct
from lactate_24h h
group by lactate_group
order by lactate_group;