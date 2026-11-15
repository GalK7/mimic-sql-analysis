with adm_age as(
	select a.hadm_id, a.subject_id, a.hospital_expire_flag,
	p.anchor_age + (extract(year from a.admittime) - p.anchor_year ) as age_at_admission
	from mimiciv_hosp.admissions a 
	join mimiciv_hosp.patients p 
	on a.subject_id  = p.subject_id
),
adm_group as(
select hadm_id, hospital_expire_flag,
case
	when age_at_admission < 40 then '1: <40'
	when age_at_admission < 65 then '2: 40-64'
	when age_at_admission < 80 then '3: 65-79'
	else '4: >= 80'
end as age_group
from adm_age
),
icu_adm as(
	select distinct hadm_id
	from mimiciv_icu.icustays
)
select g.age_group, count(g.hadm_id) as n_admissions, 
count(*) filter (where i.hadm_id is not NULL) as n_icu,
round(count(*) filter (where i.hadm_id is not NULL) * 100.0 / count(g.hadm_id), 1) as icu_pct,
count(g.hadm_id) filter (where g.hospital_expire_flag = 1) as n_deaths,
round(count(g.hadm_id) filter (where g.hospital_expire_flag = 1) * 100.0 / count(g.hadm_id), 1) as mortality_pct
from adm_group g
left join icu_adm i on g.hadm_id = i.hadm_id
group by g.age_group
order by age_group;