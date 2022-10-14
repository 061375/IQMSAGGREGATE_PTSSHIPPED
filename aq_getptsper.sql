--aq_getptsper.sql
/** 
 * @title aq_getptsper
 * @about get the parts per qty for a FG item 
 * @author Jeremy Heminger
 * @date September 27, 2022
 * @last_update September 27, 2022
 * 
 * @version 1.0.0.0.3
 * 	@bugfix settled on using LIKE ... it's slow but it's about as good I can get
 * @version 1.0.0.0.2
 * 	@bugfix sometimes the first item in the sequence is NOT the main item
 * @version 1.0.0.0.1
 *  @bugfix some items don't have a sub assembly
 * @version 1.0.0.0
 *
 * @live true
 * */
create or replace function aq_getptsper(v_mfgno varchar2) return number
is 
	v_return number;
begin
	select ptsper into v_return from (
		select x.ptsper,x.edate_time from (
			select distinct o.ptsper,o.edate_time
				from
				standard s, partno p, bom_depend bd,sndop sn, opmat o, arinvt a, arinvt aa
				where 
				s.id = p.standard_id
				and p.id = bd.partno_id
				and p.arinvt_id = aa.id
				and bd.sndop_id = sn.id
				and sn.id = o.sndop_id
				and o.arinvt_id = a.id
				--and a.class = 'SA'
				--and o.seq = '1'
				and (a.descrip like 'SUB ASSEMBLY%' or a.descrip like 'BLOCK ASSEMBLY%')
				and s.mfgno = v_mfgno
			) x order by x.edate_time desc
	) where rownum = 1;
	return v_return;
end aq_getptsper;
