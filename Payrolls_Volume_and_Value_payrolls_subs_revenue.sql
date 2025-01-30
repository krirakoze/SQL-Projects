select month,sum(unique_active_bulk_payers) active_bulk_payers,sum(unique_active_subs) unique_active_subs,sum(volume) volume,sum(value) value,sum(revenue) revenue from(
select to_char(mti.transfer_date,'MON-YYYY') month,count(distinct mti.party_id) unique_active_bulk_payers,count(distinct mti.second_party) unique_active_subs,
sum(decode(mti.entry_type,'CR',-1,'DR',1,0)) volume,sum(decode(mti.entry_type,'CR',-mti.transfer_value,mti.transfer_value)/100) value,
sum(mti2.transfer_value/100) revenue
from ecokash.mtx_transaction_items mti,
ecokash.mtx_transaction_items mti2,
ecokash.mtx_transaction_header mth,
ecokash.SYS_SERVICE_TYPES s,
ecokash.mtx_wallet w,
ecokash.users p
where mti.transfer_id = mth.transfer_id
and mti.transfer_id=mti2.transfer_id
and mti2.wallet_number='101IND03'
and mti.wallet_number = w.wallet_number
and mti.payment_type_id = 12
and mti.service_type = s.service_type
and mti.category_code in (select category_code from ecokash.mtx_categories where domain_code = 'EMPLOYER')
AND (mti.second_party_account_id) NOT IN (select u.BILLER_CODE from mmukila.REMITT_BILLERS_CODE u)
and mti.transfer_status = 'TS'
and mti.second_party_category_code = 'SUBS'
--and mti.party_id != 'TOPUP4ECONET'
and mti.party_id = p.user_id
AND (
     mth.SERVICE_TYPE IN  ('PAYROLL','MTREQ')
     AND mti.TRANSACTION_TYPE = 'MP'
     OR (
     mth.SERVICE_TYPE IN ('ROLLBACK','TXNCORRECT')
     and exists (select d.TRANSFER_ID from ecokash.MTX_TRANSACTION_ITEMS d 
     where d.TRANSFER_ID = mth.ATTR_2_VALUE and d.SERVICE_TYPE IN  ('PAYROLL','MTREQ')
     AND mti.TRANSACTION_TYPE = 'MR')
     ))
and mti.transfer_date >= to_date('01/03/2020','dd/mm/yyyy') and  mti.TRANSFER_DATE <  to_date('13/11/2020','dd/mm/yyyy') + 1
group by to_char(mti.transfer_date,'MON-YYYY')

UNION ALL

select to_char(mti.transfer_date,'MON-YYYY') month,count(distinct mti.party_id) unique_active_bulk_payers,count(distinct mti.second_party) unique_active_subs,
sum(decode(mti.entry_type,'CR',-1,'DR',1,0)) volume,sum(decode(mti.entry_type,'CR',-mti.transfer_value,mti.transfer_value)/100) value,
0 revenue
from ecokash.mtx_transaction_items mti,
ecokash.mtx_transaction_header mth,
ecokash.SYS_SERVICE_TYPES s,
ecokash.mtx_wallet w,
ecokash.users p
where mti.transfer_id = mth.transfer_id
and mti.wallet_number = w.wallet_number
and mti.payment_type_id = 12
and mti.service_type = s.service_type
and mti.category_code in (select category_code from ecokash.mtx_categories where domain_code = 'EMPLOYER')
AND (mti.second_party_account_id) NOT IN (select u.BILLER_CODE from mmukila.REMITT_BILLERS_CODE u)
and mti.transfer_status = 'TS'
and mti.second_party_category_code = 'SUBS'
--and mti.party_id != 'TOPUP4ECONET'
and mti.party_id = p.user_id
AND (
     mth.SERVICE_TYPE IN  ('PAYROLL','MTREQ')
     AND mti.TRANSACTION_TYPE = 'MP'
     OR (
     mth.SERVICE_TYPE IN ('ROLLBACK','TXNCORRECT')
     and exists (select d.TRANSFER_ID from ecokash.MTX_TRANSACTION_ITEMS d 
     where d.TRANSFER_ID = mth.ATTR_2_VALUE and d.SERVICE_TYPE IN  ('PAYROLL','MTREQ')
     AND mti.TRANSACTION_TYPE = 'MR')
     ))
and p.msisdn not in(
select p.msisdn
from ecokash.mtx_transaction_items mti,
ecokash.mtx_transaction_items mti2,
ecokash.mtx_transaction_header mth,
ecokash.SYS_SERVICE_TYPES s,
ecokash.mtx_wallet w,
ecokash.users p
where mti.transfer_id = mth.transfer_id
and mti.transfer_id=mti2.transfer_id
and mti2.wallet_number='101IND03'
and mti.wallet_number = w.wallet_number
and mti.payment_type_id = 12
and mti.service_type = s.service_type
and mti.category_code in (select category_code from ecokash.mtx_categories where domain_code = 'EMPLOYER')
AND (mti.second_party_account_id) NOT IN (select u.BILLER_CODE from mmukila.REMITT_BILLERS_CODE u)
and mti.transfer_status = 'TS'
and mti.second_party_category_code = 'SUBS'
--and mti.party_id != 'TOPUP4ECONET'
and mti.party_id = p.user_id
AND (
     mth.SERVICE_TYPE IN  ('PAYROLL','MTREQ')
     AND mti.TRANSACTION_TYPE = 'MP'
     OR (
     mth.SERVICE_TYPE IN ('ROLLBACK','TXNCORRECT')
     and exists (select d.TRANSFER_ID from ecokash.MTX_TRANSACTION_ITEMS d 
     where d.TRANSFER_ID = mth.ATTR_2_VALUE and d.SERVICE_TYPE IN  ('PAYROLL','MTREQ')
     AND mti.TRANSACTION_TYPE = 'MR')
     ))
and mti.transfer_date >= to_date('01/03/2020','dd/mm/yyyy') and  mti.TRANSFER_DATE <  to_date('13/11/2020','dd/mm/yyyy') + 1
group by p.msisdn
) 
and mti.transfer_date >= to_date('01/03/2020','dd/mm/yyyy') and  mti.TRANSFER_DATE <  to_date('13/11/2020','dd/mm/yyyy') + 1
group by to_char(mti.transfer_date,'MON-YYYY'),0
) group by month;