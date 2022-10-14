/** 
 * @title aq_aggregate_pts_sales
 * @about get sales data including individual parts in packages
 * @author Jeremy Heminger
 * @date October 14, 2022
 * @last_update October 14, 2022
 * @dependency aq_getptsper
 * @version 1.0.0.0
 *
 * @live true
 * */
select 
    group_code,
    -- uncomment to expand and view itemno (be sure to add to group by)
    --itemno,
    sum(each_ordered) as each_ordered,
    sum(pts_ordered) AS pts_ordered,
    sum(sales_order_cost) AS sales_order_cost,
    sum(each_shipped) as each_shipped,
    sum(pts_shipped) as pts_shipped,
    sum(shipped_sold) as shipped_sold,
    sum(each_invoiced) as each_invoiced,
    sum(pts_invoiced) as pts_invoiced,
    sum(invoiced_sold) as invoiced_sold
from (
    select
        a.itemno,
        a.group_code,
        nvl(aq_getptsper(a.itemno),1) as ptsper,
        sum(nvl(c.total_qty_ord,0)) as each_ordered,
        sum(nvl(c.total_qty_ord,0) * nvl(c.unit_price,0)) as sales_order_cost,
        sum(nvl(aq_getptsper(a.itemno),1) * nvl(c.total_qty_ord,0)) as pts_ordered,
        sum(nvl(c.qtyshipped,0)) as each_shipped,
        sum(nvl(aq_getptsper(a.itemno),1) * nvl(c.qtyshipped,0)) as pts_shipped,
        sum(nvl(c.qtyshipped,0) * nvl(c.unit_price,0)) as shipped_sold,
        sum(nvl(c.invoiced_qty,0)) as each_invoiced,
        sum(nvl(aq_getptsper(a.itemno),1) * nvl(c.invoiced_qty,0)) as pts_invoiced,
        sum(nvl(c.invoiced_qty,0)* nvl(c.unit_price,0)) as invoiced_sold
    from c_ship_hist c, arinvt a where
        c.SHIPMENT_TYPE<>'CUM SHIP ADJUSTMENT'
        and c.arinvt_id = a.id
        and a.group_code is not null
        -- uncomment to filter by group_code
        --and a.group_code in('S4','S2','L5','M2','W2','G1','L1','L3','S1','L4','F8','L2','H1','F2','G4','F7','W4','M1','W3','G3','G2','BQ1','K1','A1','AF-2','AF-3','BQ1')
        --and a.group_code = 'S4'
        -- uncomment to filter by itemno
        --and a.itemno in ('102627','102814','107419','108504','102530','107014','108520','108549','107901','108405','102612','102815','108707','107403','107202')
        --and a.itemno = ''
        and c.shipdate between '01-Jan-22' and '31-Oct-22'
    group by a.itemno,a.group_code
) group by group_code--,itemno
order by group_code
;
