CREATE OR REPLACE
PROCEDURE lab.p_getlabscheduleslip(
	IN in_lrn NUMERIC,
	IN iv_locationid CHARACTER VARYING,
	INOUT ocur_patientdetails refcursor,
	INOUT ocur_labscheduleslip refcursor)
LANGUAGE 'plpgsql'
    SECURITY DEFINER 
AS $BODY$
BEGIN
	SET search_path TO lab,oracle ;
--set search_path TO lab,oracle ; 

--raise notice 'started';

--raise notice 'update start';

/*update lab.tokencountermapping tcm set tcm.scheduleslipgendate = clock_timestamp ( )where 
 tcm.lrn = in_lrn and tcm.locationid = iv_locationid and tcm.scheduleslipgendate is null ; */

 UPDATE
	lab.tokencountermapping tcm
SET
	scheduleslipgendate = clock_timestamp ( )::timestamp
	WHERE 
 tcm.lrn = in_lrn
	AND tcm.locationid = iv_locationid
	AND tcm.scheduleslipgendate IS NULL ;

--raise notice 'update end';

--raise notice 'cur1 start';

OPEN ocur_patientdetails FOR
SELECT
	rr.lrn,
	rr.uhid,
	rr.patientserviceno,
	lab.fn_getpatientdetails (rr.uhid) patientdetails,
	( CASE
		WHEN rr.patientservice = 'IP' THEN lab.fn_getprimarysecdoctor ( rr.patientserviceno,
		rr.locationid )
		ELSE
 lab.fn_getreferraldoctor ( rr.patientserviceno,
		rr.locationid )
	END )AS doctorsname,
	lab.fn_formatdate_for_display (clock_timestamp ()::timestamp)datetime
FROM
	lab.raiserequest rr
WHERE
	rr.lrn = in_lrn
	AND rr.locationid = iv_locationid ;

--raise notice 'cur1 end';

--raise notice 'cur2 start';

OPEN ocur_labscheduleslip FOR
SELECT
	( CASE
		WHEN LENGTH (a.reportcollectiondatetime)= 17 THEN 
 substr ( a.reportcollectiondatetime,
		1,
		11 )|| ' ' || substr ( a.reportcollectiondatetime,
		12 )
		ELSE
 a.reportcollectiondatetime
	END )reportcollectiondatetime,
	a.investigations,
	a.testid,
	a.serviceid
FROM
	(
	SELECT
		DISTINCT lab.f_getreportingtimeprofile ( in_lrn,
		iv_locationid,
		sm.serviceid )reportcollectiondatetime,
		sm.servicename investigations,
		sm.servicename testid,
		sm.serviceid
	FROM
		lab.requesttests rt
	INNER JOIN billing.vw_servicemaster sm 
 ON
		sm.serviceid = rt.itemcode
	WHERE
		rt.lrn = in_lrn
		AND sm.locationid = iv_locationid
		AND rt.itemtype = 3
		AND rt.teststatus = 1
		AND rt.billingstatus = 1
UNION
	SELECT
		DISTINCT lab.f_getreportingtimefortest ( in_lrn,
		iv_locationid,
		rt.testid )reportcollectiondatetime,
		tm.testname investigations,
		tm.testname testid,
		tm.testid serviceid
	FROM
		lab.requesttests rt
	INNER JOIN lab.testmaster tm ON
		tm.testid = rt.testid
	WHERE
		rt.lrn = in_lrn
		AND tm.locationid = iv_locationid
		AND rt.itemtype = 1
		AND rt.teststatus = 1
		AND rt.billingstatus = 1
	ORDER BY
		testid,
		reportcollectiondatetime DESC )a ;

--raise notice 'cur2 end';

EXECUTE 'TRUNCATE TABLE lab.REPORTINGTIME' ;

--raise notice 'ended';
END ;

$BODY$;

