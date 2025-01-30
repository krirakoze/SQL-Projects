select Agent_Name,to_char(Transfer_On,'MON-YYYY') "MONTH",count(distinct Mobile_Number) unique_subs,count(distinct Transfer_Id) Volume,sum(Transaction_Value) value,
sum(revenue) revenue from(
SELECT mti.TRANSFER_ID Transfer_Id, mti.transfer_date Transfer_On,sst.service_type Service_Type,sst.service_name Service_Name,
    mti.transaction_type Transaction_Type,mti.entry_type "CR/DR",mti.second_party_account_id Mobile_Number,
                mti.transfer_value / 100 Transaction_Value,mti2.transfer_value/100 revenue,
    mti.post_balance/100 "Post Balance",
    (select u.msisdn from ecokash.users u where u.user_id = mti.party_id) "Transactor",
    (select u.user_name||' '||u.last_name from ecokash.users u where u.user_id = mti.party_id) Agent_Name
FROM ecokash.sys_service_types sst, ecokash.mtx_transaction_items mti, ecokash.mtx_transaction_items mti2, ecokash.mtx_transaction_header mth
WHERE mti.transfer_status = 'TS'
AND mti.transfer_id=mti2.transfer_id
AND mti2.wallet_number='101IND03'
AND mti.service_type = sst.service_type
AND mth.transfer_id=mti.transfer_id 
AND mti.transaction_type = 'MP'
and sst.service_type<>'O2C'
AND mti.party_id in (select a.user_id 
                                 from ecokash.users a, ecokash.mtx_categories cat, ecokash.mtx_wallet w
                                 where cat.domain_code = 'DISTWS'
                                 and a.msisdn = w.msisdn
                                 --and a.status='Y'
                                 and cat.category_code = a.category_code
                                 and w.user_grade in ('REMAGENT0','REMAGENT1','REMAGENT','REMAGENT2')
                                 and a.msisdn not in('79098909','76200905')
                                 and w.payment_type_id = 12)
AND mti.transfer_date >= to_date('01/11/2021','dd/mm/yyyy') AND mti.transfer_date < to_date('28/02/2022','dd/mm/yyyy')+1

UNION ALL

SELECT mti.TRANSFER_ID Transfer_Id, mti.transfer_date Transfer_On,sst.service_type Service_Type,sst.service_name Service_Name,
    mti.transaction_type Transaction_Type,mti.entry_type "CR/DR",mti.second_party_account_id Mobile_Number,
                mti.transfer_value / 100 Transaction_Value,0 revenue,
    mti.post_balance/100 "Post Balance",
    (select u.msisdn from ecokash.users u where u.user_id = mti.party_id) "Transactor",
    (select u.user_name||' '||u.last_name from ecokash.users u where u.user_id = mti.party_id) Agent_Name
FROM ecokash.sys_service_types sst, ecokash.mtx_transaction_items mti,ecokash.mtx_transaction_header mth
WHERE mti.transfer_status = 'TS'
AND mti.service_type = sst.service_type
AND mth.transfer_id=mti.transfer_id 
AND mti.transaction_type = 'MP'
and sst.service_type<>'O2C'
AND mti.party_id in (select a.user_id 
                                 from ecokash.users a, ecokash.mtx_categories cat, ecokash.mtx_wallet w
                                 where cat.domain_code = 'DISTWS'
                                 and a.msisdn = w.msisdn
                                 --and a.status='Y'
                                 and cat.category_code = a.category_code
                                 and w.user_grade in ('REMAGENT0','REMAGENT1','REMAGENT','REMAGENT2')
                                 and a.msisdn not in('79098909','76200905')
                                 and w.payment_type_id = 12)
AND mti.party_id not in(
SELECT distinct mti.party_id
FROM ecokash.sys_service_types sst, ecokash.mtx_transaction_items mti, ecokash.mtx_transaction_items mti2, ecokash.mtx_transaction_header mth
WHERE mti.transfer_status = 'TS'
AND mti.transfer_id=mti2.transfer_id
AND mti2.wallet_number='101IND03'
AND mti.service_type = sst.service_type
AND mth.transfer_id=mti.transfer_id 
AND mti.transaction_type = 'MP'
and sst.service_type<>'O2C'
AND mti.party_id in (select a.user_id 
                                 from ecokash.users a, ecokash.mtx_categories cat, ecokash.mtx_wallet w
                                 where cat.domain_code = 'DISTWS'
                                 and a.msisdn = w.msisdn
                                 --and a.status='Y'
                                 and cat.category_code = a.category_code
                                 and w.user_grade in ('REMAGENT0','REMAGENT1','REMAGENT','REMAGENT2')
                                 and a.msisdn not in('79098909','76200905')
                                 and w.payment_type_id = 12)
AND mti.transfer_date >= to_date('01/11/2021','dd/mm/yyyy') AND mti.transfer_date < to_date('28/02/2022','dd/mm/yyyy')+1
)
AND mti.transfer_date >= to_date('01/11/2021','dd/mm/yyyy') AND mti.transfer_date < to_date('28/02/2022','dd/mm/yyyy')+1
) group by Agent_Name,to_char(Transfer_On,'MON-YYYY');