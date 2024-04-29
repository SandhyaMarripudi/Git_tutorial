CREATE OR REPLACE
PROCEDURE lab.p_savetestmaster (IN iclob_testdetails text, INOUT on_returnvalue NUMERIC,
IN in_locationid NUMERIC,
IN in_viewabledraft NUMERIC,
IN in_viewableverify NUMERIC,
IN in_printabledraft NUMERIC,
IN in_printableverify NUMERIC,
IN in_printcount NUMERIC)
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $procedure$
DECLARE
	v_testdetails xml ;

v_testid NUMERIC ;

v_equip_linkid NUMERIC ;

v_methodologyid NUMERIC ;

v_mediaid NUMERIC ;

v_methodology_linkid NUMERIC ;

v_media_linkid NUMERIC ;

v_index xml ;

i NUMERIC ;

v_equipid NUMERIC ;

v_processingtype NUMERIC;
-- v_processingtype lab.testmaster.typeofprocessing%type ; 

v_counter NUMERIC ;
BEGIN
	SET
	search_path TO lab ;

CALL lab.lab_set_sequence ( 'S_METHODOLOGYLINKID',
'METHODOLOGY_LINK',
'METHODOLOGY_LINKID' ) ;

CALL lab.lab_set_sequence ( 'S_EQUIP_LINKID',
'TESTMASTER',
'EQUIP_LINKID') ;

CALL lab.lab_set_sequence ( 'S_METHODOLOGY_LINKID',
'TESTMASTER',
'METHODOLOGYLINKID') ;

CALL lab.lab_set_sequence ( 'S_MEDIA_LINKID',
'TESTMASTER',
'MEDIALINKID') ;

on_returnvalue := -1 ;

v_testdetails := xml (iclob_testdetails) ;

SELECT
	CASE
		WHEN (
		SELECT
			UNNEST ( xpath ( '/Test/TestId/text ( )',
			v_testdetails ) ) )::text = '' THEN NULL
		ELSE (
		SELECT
			UNNEST ( xpath ( '/Test/TestId/text ( )',
			v_testdetails ) ) )::text::NUMERIC
	END
INTO
	v_testid ;

raise notice '% ',
v_testid ;

IF v_testid = 0 THEN
--raise notice'if v_testid = 0 condition started'; 

 SELECT
	nextval ('lab.s_equip_linkid') INTO
	strict v_equip_linkid ;

SELECT
	nextval ('lab.s_methodology_linkid') INTO
	strict v_methodology_linkid ;

SELECT
	nextval ('lab.s_media_linkid') INTO
	strict v_media_linkid ;
--raise notice'%v_equip_linkid,%v_methodology_linkid,%v_media_linkid',v_equip_linkid,v_methodology_linkid,v_media_linkid; 

 
raise notice'i1 started1- 50';
-- select count (*) from lab.testmaster -- 41646

 INSERT
	INTO
	lab.testmaster ( testid,
	testcode,
	testname,
	departmentid,
	specimenid,
	typeofprocessing,
	quantityofsample,
	uom,
	containertypeid,
	typeofmethodology,
	testresultid,
	serviceid,
	expectedtimeofcompletion,
	timedependency,
	createdby,
	status,
	createddate,
	equip_linkid,
	methodologylinkid,
	medialinkid,
	specimencategory,
	nabl,
	comments,
	locationid,
	displayinlabreception,
	enableinsamplecoll,
	checkhivaccess,
	checkexternaltest,
	tokentype,
	noofstickers,
	viewableindraftmode,
	printableindraftmode,
	viewableinverifiedmode,
	printableinverifiedmode,
	printcount )
VALUES (
CASE
	WHEN (
	SELECT
		UNNEST ( xpath ( '/Test/ServiceId/text ()',
		v_testdetails ) ) )::text = '' THEN NULL
	ELSE (
	SELECT
		UNNEST ( xpath ( '/Test/ServiceId/text ()',
		v_testdetails ) ) )::text::NUMERIC
END ,
 CASE
	WHEN (
	SELECT
		UNNEST ( xpath ( '/Test/TestCode/text () ',
		v_testdetails ) ) )::text = '' THEN NULL
	ELSE (
	SELECT
		UNNEST ( xpath ( '/Test/TestCode/text () ',
		v_testdetails ) ) )::text
END ,
 CASE
	WHEN (
	SELECT
		UNNEST ( xpath ( '/Test/ServiceName/text () ',
		v_testdetails ) ) )::text = '' THEN NULL
	ELSE (
	SELECT
		UNNEST ( xpath ( '/Test/ServiceName/text () ',
		v_testdetails ) ) )::text
END,
 CASE
	WHEN (
	SELECT
		UNNEST ( xpath ( '/Test/DepartmentID/text () ',
		v_testdetails ) ) )::text = '' THEN NULL
	ELSE (
	SELECT
		UNNEST ( xpath ( '/Test/DepartmentID/text () ',
		v_testdetails ) ) )::text
END ,
 CASE
	WHEN (
	SELECT
		UNNEST ( xpath ( '/Test/SpecimenId/text () ',
		v_testdetails ) ) )::text = '' THEN NULL
	ELSE (
	SELECT
		UNNEST ( xpath ( '/Test/SpecimenId/text () ',
		v_testdetails ) ) )::text::NUMERIC
END,
 CASE
	WHEN (
	SELECT
		UNNEST ( xpath ( '/Test/TypeOfProcessing/text ()',
		v_testdetails ) ) )::text = '' THEN NULL
	ELSE (
	SELECT
		UNNEST ( xpath ( '/Test/TypeOfProcessing/text ()',
		v_testdetails ) ) )::text::NUMERIC
END,
 CASE
	WHEN (
	SELECT
		UNNEST ( xpath ( '/Test/quantityRequired/text () ',
		v_testdetails ) ) )::text = '' THEN NULL
	ELSE (
	SELECT
		UNNEST ( xpath ( '/Test/quantityRequired/text () ',
		v_testdetails ) ) )::text::numeric
END,
 CASE
	WHEN (
	SELECT
		UNNEST ( xpath ( '/Test/Unit/text () ',
		v_testdetails ) ) )::text = '' THEN NULL
	ELSE (
	SELECT
		UNNEST ( xpath ( '/Test/Unit/text () ',
		v_testdetails ) ) )::text::NUMERIC
END ,
 CASE
	WHEN (
	SELECT
		UNNEST ( xpath ( '/Test/ContainerdetailId/text () ',
		v_testdetails ) ) )::text = '' THEN NULL
	ELSE (
	SELECT
		UNNEST ( xpath ( '/Test/ContainerdetailId/text () ',
		v_testdetails ) ) )::text::NUMERIC
END,
 CASE
	WHEN (
	SELECT
		UNNEST ( xpath ( '/Test/Methodology/text () ',
		v_testdetails ) ) )::text = '' THEN NULL
	ELSE (
	SELECT
		UNNEST ( xpath ( '/Test/Methodology/text () ',
		v_testdetails ) ) )::text::NUMERIC
END,
 CASE
	WHEN (
	SELECT
		UNNEST ( xpath ( '/Test/TestResultFormat/text ()',
		v_testdetails ) ) )::text = '' THEN NULL
	ELSE (
	SELECT
		UNNEST ( xpath ( '/Test/TestResultFormat/text ()',
		v_testdetails ) ) )::text::NUMERIC
END,
 CASE
	WHEN (
	SELECT
		UNNEST ( xpath ( '/Test/ServiceId/text () ',
		v_testdetails ) ) )::text = '' THEN NULL
	ELSE (
	SELECT
		UNNEST ( xpath ( '/Test/ServiceId/text () ',
		v_testdetails ) ) )::text::NUMERIC
END,
 CASE
	WHEN (
	SELECT
		UNNEST ( xpath ( '/Test/ProcessingTime/text () ',
		v_testdetails ) ) )::text = '' THEN NULL
	ELSE (
	SELECT
		UNNEST ( xpath ( '/Test/ProcessingTime/text () ',
		v_testdetails ) ) )::text
END,
 CASE
	WHEN (
	SELECT
		UNNEST ( xpath ( '/Test/TimeDependent/text () ',
		v_testdetails ) ) )::text = '' THEN NULL
	ELSE (
	SELECT
		UNNEST ( xpath ( '/Test/TimeDependent/text () ',
		v_testdetails ) ) )::text
END,
 CASE
	WHEN (
	SELECT
		UNNEST ( xpath ( '/Test/LoginId/text () ',
		v_testdetails ) ) )::text = '' THEN NULL
	ELSE (
	SELECT
		UNNEST ( xpath ( '/Test/LoginId/text () ',
		v_testdetails ) ) )::text
END, 
 1,
clock_timestamp ( ),
v_equip_linkid,
v_methodology_linkid,
v_media_linkid,
 CASE
	WHEN (
	SELECT
		UNNEST ( xpath ( '/Test/SpecimenCategory/text ()',
		v_testdetails ) ) )::text = '' THEN NULL
	ELSE (
	SELECT
		UNNEST ( xpath ( '/Test/SpecimenCategory/text ()',
		v_testdetails ) ) )::text::NUMERIC
END,
 CASE
	WHEN (
	SELECT
		UNNEST ( xpath ( '/Test/NABL/text () ',
		v_testdetails ) ) )::text = '' THEN NULL
	ELSE (
	SELECT
		UNNEST ( xpath ( '/Test/NABL/text () ',
		v_testdetails ) ) )::text
END , 
 REPLACE ( REPLACE ( REPLACE ( REPLACE ( REPLACE ( CASE
	WHEN (
	SELECT
		UNNEST ( xpath ( '/Test/COMMENTS/text () ',
		v_testdetails ) ) )::text = '' THEN NULL
	ELSE (
	SELECT
		UNNEST ( xpath ( '/Test/COMMENTS/text () ',
		v_testdetails ) ) )::text
END,
' ; 
 '::text,
'>'::text ),
' ; 
 ',
'<' ),
' ; 
 ',
'&' ),
' ; 
 ',
'' ),
' ; 
 ',
'''' ),
in_locationid,
 CASE
	WHEN (
	SELECT
		UNNEST ( xpath ( '/Test/LabReception/text () ',
		v_testdetails ) ) )::text = '' THEN NULL
	ELSE (
	SELECT
		UNNEST ( xpath ( '/Test/LabReception/text () ',
		v_testdetails ) ) )::text
END ,
 CASE
	WHEN (
	SELECT
		UNNEST ( xpath ( '/Test/SampleCollection/text () ',
		v_testdetails ) ) )::text = '' THEN NULL
	ELSE (
	SELECT
		UNNEST ( xpath ( '/Test/SampleCollection/text () ',
		v_testdetails ) ) )::text
END,
 CASE
	WHEN (
	SELECT
		UNNEST ( xpath ( '/Test/CHECKHIVACCESS/text ()',
		v_testdetails ) ) )::text = '' THEN NULL
	ELSE (
	SELECT
		UNNEST ( xpath ( '/Test/CHECKHIVACCESS/text ()',
		v_testdetails ) ) )::text
END,
 CASE
	WHEN (
	SELECT
		UNNEST ( xpath ( '/Test/CHECKEXTERNALTEST/text () ',
		v_testdetails ) ) )::text = '' THEN NULL
	ELSE (
	SELECT
		UNNEST ( xpath ( '/Test/CHECKEXTERNALTEST/text () ',
		v_testdetails ) ) )::text
END ,
 CASE
	WHEN (
	SELECT
		UNNEST ( xpath ( '/Test/TOKENTYPE/text () ',
		v_testdetails ) ) )::text = '' THEN NULL
	ELSE (
	SELECT
		UNNEST ( xpath ( '/Test/TOKENTYPE/text () ',
		v_testdetails ) ) )::text
END,
 CASE
	WHEN (
	SELECT
		UNNEST ( xpath ( '/Test/NOOFSTICKERS/text () ',
		v_testdetails ) ) )::text = '' THEN NULL
	ELSE (
	SELECT
		UNNEST ( xpath ( '/Test/NOOFSTICKERS/text () ',
		v_testdetails ) ) )::text
END, 
 in_viewabledraft,
in_printabledraft,
in_viewableverify,
in_printableverify,
in_printcount );
--raise notice'insertion completed1'; 

 
i := 1 ;

SELECT
	CASE
		WHEN (
		SELECT
			UNNEST ( xpath ( '/Test/TypeOfProcessing/text ()',
			v_testdetails ) ) )::text = '' THEN NULL
		ELSE (
		SELECT
			UNNEST ( xpath ( '/Test/TypeOfProcessing/text ()',
			v_testdetails ) ) )::text::NUMERIC
	END
 INTO
	strict v_processingtype ;
--raise notice'%v_processingtype',v_processingtype; 
--raise notice'1st if started'; 

 IF ( v_processingtype <> 324 )THEN 
 LOOP
--select unnest ( xpath ( '/Test/EquipmentID/Equipment/EquipmentID[' || i || ']',v_testdetails ) )into v_index ; 

v_index := (
SELECT
	UNNEST ( xpath ( '/Test/EquipmentID/Equipment/EquipmentID[' || i || ']',
	v_testdetails ) ));

EXIT
WHEN v_index IS NULL ;

SELECT
	CASE
		WHEN (
		SELECT
			UNNEST ( xpath ( '/EquipmentID/@ID',
			v_index ) ) )::text = '' THEN NULL
		ELSE (
		SELECT
			UNNEST ( xpath ( '/EquipmentID/@ID',
			v_index ) ) )::text::NUMERIC
	END
INTO
	v_equipid ;

raise notice'I s125';
-- select count (*) from lab.equipment_module_link -- 520

 INSERT
	INTO
	lab.equipment_module_link
VALUES ( v_equip_linkid,
v_equipid,
nextval ('lab.s_equipment_module_linkid'),
1 ) ;

i := i + 1 ;
END
LOOP
;
END IF ;
--raise notice'1st if ended'; 
LOOP
	--select unnest ( xpath ( '/Test/MethodologyID/Methodology/MethodologyID[' || i || ']',v_testdetails ) )into v_index ; 

	v_index := (
	SELECT
		UNNEST ( xpath ( '/Test/MethodologyID/Methodology/MethodologyID[' || i || ']',
		v_testdetails ) ));

EXIT
WHEN v_index IS NULL ;

SELECT
	CASE
		WHEN (
		SELECT
			UNNEST ( xpath ( '/MethodologyID/@ID',
			v_index ) ) )::text = '' THEN NULL
		ELSE (
		SELECT
			UNNEST ( xpath ( '/MethodologyID/@ID',
			v_index ) ) )::text::NUMERIC
	END
INTO
	v_methodologyid ;

raise notice'i2 s138';
-- select count (*) from lab.methodology_link -- 805

 INSERT
	INTO
	lab.methodology_link
VALUES ( nextval ('lab.s_methodologylinkid'),
v_methodologyid,
v_methodology_linkid,
1 ) ;

i := i + 1 ;
END
LOOP
;
LOOP
	--select unnest ( xpath ( '/Test/MethodologyID/Media/MediaID[' || i || ']',v_testdetails ) )into v_index ; 

	v_index := (
	SELECT
		UNNEST ( xpath ( '/Test/MethodologyID/Media/MediaID[' || i || ']',
		v_testdetails ) ));

EXIT
WHEN v_index IS NULL ;

SELECT
	CASE
		WHEN (
		SELECT
			UNNEST ( xpath ( '/MediaID/@ID',
			v_index ) ) )::text = '' THEN NULL
		ELSE (
		SELECT
			UNNEST ( xpath ( '/MediaID/@ID',
			v_index ) ) )::text::NUMERIC
	END
INTO
	v_mediaid ;

raise notice'i3 s149';
-- select count (*) from lab.media_link -- 63

 INSERT
	INTO
	lab.media_link
VALUES ( nextval ('lab.s_medialinkid'),
v_mediaid,
v_media_linkid,
1 ) ;

i := i + 1 ;
END
LOOP
;

on_returnvalue := 0 ;
ELSE
--raise notice'if v_testid = 0 condition else started'; 

 SELECT
	tm1.equip_linkid,
	tm1.methodologylinkid,
	tm1.medialinkid
INTO
	strict v_equip_linkid,
	v_methodology_linkid,
	v_media_linkid
FROM
	lab.testmaster tm1
WHERE
	tm1.serviceid = CASE
		WHEN (
		SELECT
			UNNEST ( xpath ( '/Test/ServiceId/text ()',
			v_testdetails ) ) )::text = '' THEN NULL
		ELSE (
		SELECT
			UNNEST ( xpath ( '/Test/ServiceId/text ()',
			v_testdetails ) ) )::text::NUMERIC
	END
	AND tm1.locationid = in_locationid::text ;

raise notice'update started1';

UPDATE
	lab.testmaster
SET
	testname =
CASE
		WHEN (
		SELECT
			UNNEST ( xpath ( '/Test/ServiceName/text () ',
			v_testdetails ) ) )::text = '' THEN NULL
		ELSE (
		SELECT
			UNNEST ( xpath ( '/Test/ServiceName/text () ',
			v_testdetails ) ) )::text
	END,
	testcode = CASE
		WHEN (
		SELECT
			UNNEST ( xpath ( '/Test/TestCode/text () ',
			v_testdetails ) ) )::text = '' THEN NULL
		ELSE (
		SELECT
			UNNEST ( xpath ( '/Test/TestCode/text () ',
			v_testdetails ) ) )::text
	END,
	departmentid = CASE
		WHEN (
		SELECT
			UNNEST ( xpath ( '/Test/DepartmentID/text () ',
			v_testdetails ) ) )::text = '' THEN NULL
		ELSE (
		SELECT
			UNNEST ( xpath ( '/Test/DepartmentID/text () ',
			v_testdetails ) ) )::text
	END,
	specimenid = CASE
		WHEN (
		SELECT
			UNNEST ( xpath ( '/Test/SpecimenId/text () ',
			v_testdetails ) ) )::text = '' THEN NULL
		ELSE (
		SELECT
			UNNEST ( xpath ( '/Test/SpecimenId/text () ',
			v_testdetails ) ) )::text::NUMERIC
	END,
	typeofprocessing = CASE
		WHEN (
		SELECT
			UNNEST ( xpath ( '/Test/TypeOfProcessing/text () ',
			v_testdetails ) ) )::text = '' THEN NULL
		ELSE (
		SELECT
			UNNEST ( xpath ( '/Test/TypeOfProcessing/text () ',
			v_testdetails ) ) )::text::NUMERIC
	END,
	quantityofsample = CASE
		WHEN (
		SELECT
			UNNEST ( xpath ( '/Test/quantityRequired/text () ',
			v_testdetails ) ) )::text = '' THEN NULL
		ELSE (
		SELECT
			UNNEST ( xpath ( '/Test/quantityRequired/text () ',
			v_testdetails ) ) )::text
	END,
	uom = CASE
		WHEN (
		SELECT
			UNNEST ( xpath ( '/Test/Unit/text () ',
			v_testdetails ) ) )::text = '' THEN NULL
		ELSE (
		SELECT
			UNNEST ( xpath ( '/Test/Unit/text () ',
			v_testdetails ) ) )::text::NUMERIC
	END,
	containertypeid = CASE
		WHEN (
		SELECT
			UNNEST ( xpath ( '/Test/ContainerdetailId/text () ',
			v_testdetails ) ) )::text = '' THEN NULL
		ELSE (
		SELECT
			UNNEST ( xpath ( '/Test/ContainerdetailId/text () ',
			v_testdetails ) ) )::text::NUMERIC
	END,
	typeofmethodology = CASE
		WHEN (
		SELECT
			UNNEST ( xpath ( '/Test/Methodology/text ()',
			v_testdetails ) ) )::text = '' THEN NULL
		ELSE (
		SELECT
			UNNEST ( xpath ( '/Test/Methodology/text ()',
			v_testdetails ) ) )::text::NUMERIC
	END,
	testresultid = CASE
		WHEN (
		SELECT
			UNNEST ( xpath ( '/Test/TestResultFormat/text () ',
			v_testdetails ) ) )::text = '' THEN NULL
		ELSE (
		SELECT
			UNNEST ( xpath ( '/Test/TestResultFormat/text () ',
			v_testdetails ) ) )::text::NUMERIC
	END,
	expectedtimeofcompletion = CASE
		WHEN (
		SELECT
			UNNEST ( xpath ( '/Test/ProcessingTime/text () ',
			v_testdetails ) ) )::text = '' THEN NULL
		ELSE (
		SELECT
			UNNEST ( xpath ( '/Test/ProcessingTime/text () ',
			v_testdetails ) ) )::text
	END,
	timedependency = CASE
		WHEN (
		SELECT
			UNNEST ( xpath ( '/Test/TimeDependent/text () ',
			v_testdetails ) ) )::text = '' THEN NULL
		ELSE (
		SELECT
			UNNEST ( xpath ( '/Test/TimeDependent/text () ',
			v_testdetails ) ) )::text
	END ,
	updatedby = CASE
		WHEN (
		SELECT
			UNNEST ( xpath ( '/Test/LoginId/text () ',
			v_testdetails ) ) )::text = '' THEN NULL
		ELSE (
		SELECT
			UNNEST ( xpath ( '/Test/LoginId/text () ',
			v_testdetails ) ) )::text
	END,
	updateddate = clock_timestamp ( ),
	specimencategory = CASE
		WHEN (
		SELECT
			UNNEST ( xpath ( '/Test/SpecimenCategory/text () ',
			v_testdetails ) ) )::text = '' THEN NULL
		ELSE (
		SELECT
			UNNEST ( xpath ( '/Test/SpecimenCategory/text () ',
			v_testdetails ) ) )::text::NUMERIC
	END,
	nabl = CASE
		WHEN (
		SELECT
			UNNEST ( xpath ( '/Test/NABL/text () ',
			v_testdetails ) ) )::text = '' THEN NULL
		ELSE (
		SELECT
			UNNEST ( xpath ( '/Test/NABL/text () ',
			v_testdetails ) ) )::text
	END,
	displayinlabreception = CASE
		WHEN (
		SELECT
			UNNEST ( xpath ( '/Test/LabReception/text () ',
			v_testdetails ) ) )::text = '' THEN NULL
		ELSE (
		SELECT
			UNNEST ( xpath ( '/Test/LabReception/text () ',
			v_testdetails ) ) )::text
	END ,
	enableinsamplecoll = CASE
		WHEN (
		SELECT
			UNNEST ( xpath ( '/Test/SampleCollection/text () ',
			v_testdetails ) ) )::text = '' THEN NULL
		ELSE (
		SELECT
			UNNEST ( xpath ( '/Test/SampleCollection/text () ',
			v_testdetails ) ) )::text
	END ,
	checkhivaccess = CASE
		WHEN (
		SELECT
			UNNEST ( xpath ( '/Test/CHECKHIVACCESS/text () ',
			v_testdetails ) ) )::text = '' THEN NULL
		ELSE (
		SELECT
			UNNEST ( xpath ( '/Test/CHECKHIVACCESS/text () ',
			v_testdetails ) ) )::text
	END,
	checkexternaltest = CASE
		WHEN (
		SELECT
			UNNEST ( xpath ( '/Test/CHECKEXTERNALTEST/text () ',
			v_testdetails ) ) )::text = '' THEN NULL
		ELSE (
		SELECT
			UNNEST ( xpath ( '/Test/CHECKEXTERNALTEST/text () ',
			v_testdetails ) ) )::text
	END,
	tokentype = CASE
		WHEN (
		SELECT
			UNNEST ( xpath ( '/Test/TOKENTYPE/text () ',
			v_testdetails ) ) )::text = '' THEN NULL
		ELSE (
		SELECT
			UNNEST ( xpath ( '/Test/TOKENTYPE/text () ',
			v_testdetails ) ) )::text
	END ,
	noofstickers = CASE
		WHEN (
		SELECT
			UNNEST ( xpath ( '/Test/NOOFSTICKERS/text () ',
			v_testdetails ) ) )::text = '' THEN NULL
		ELSE (
		SELECT
			UNNEST ( xpath ( '/Test/NOOFSTICKERS/text () ',
			v_testdetails ) ) )::text
	END,
	comments = REPLACE ( REPLACE ( REPLACE ( REPLACE ( REPLACE ( CASE
		WHEN (
		SELECT
			UNNEST ( xpath ( '/Test/COMMENTS/text () ',
			v_testdetails ) ) )::text = '' THEN NULL
		ELSE (
		SELECT
			UNNEST ( xpath ( '/Test/COMMENTS/text () ',
			v_testdetails ) ) )::text
	END ,
	' ; 
 '::text,
	'>'::text ),
	' ; 
 ',
	'<' ),
	' ; 
 ',
	'&' ),
	' ; 
 ',
	'' ),
	' ; 
 ',
	'''' ),
	viewableindraftmode = in_viewabledraft,
	viewableinverifiedmode = in_viewableverify,
	printableindraftmode = in_printabledraft,
	printableinverifiedmode = in_printableverify,
	printcount = in_printcount
WHERE
	serviceid = CASE
		WHEN (
		SELECT
			UNNEST ( xpath ( '/Test/ServiceId/text () ',
			v_testdetails ) ) )::text = '' THEN NULL
		ELSE (
		SELECT
			UNNEST ( xpath ( '/Test/ServiceId/text () ',
			v_testdetails ) ) )::text::NUMERIC
	END
	AND locationid = in_locationid::text ;
--raise notice'update eompleted1'; 

 
 
 SELECT
	CASE
		WHEN (
		SELECT
			UNNEST ( xpath ( '/Test/TypeOfProcessing/text () ',
			v_testdetails ) ) )::text = '' THEN NULL
		ELSE (
		SELECT
			UNNEST ( xpath ( '/Test/TypeOfProcessing/text () ',
			v_testdetails ) ) )::text::NUMERIC
	END
INTO
	strict v_processingtype ;
--raise notice'%v_processingtype',v_processingtype; 

 
 IF ( v_processingtype <> 324 ) THEN
--raise notice'if v_processingtype condition started'; 

i := 1 ;

UPDATE
	lab.equipment_module_link
SET
	status = 0
WHERE
	equip_linkid = v_equip_linkid ;
LOOP
	--select unnest ( xpath ( '/Test/EquipmentID/Equipment/EquipmentID[' || i || ']',v_testdetails ) )into v_index ; 

	v_index := (
	SELECT
		UNNEST ( xpath ( '/Test/EquipmentID/Equipment/EquipmentID[' || i || ']',
		v_testdetails ) ));

EXIT
WHEN v_index IS NULL ;

SELECT
	CASE
		WHEN (
		SELECT
			UNNEST ( xpath ( '/EquipmentID/@ID',
			v_index ) ) )::text = '' THEN NULL
		ELSE (
		SELECT
			UNNEST ( xpath ( '/EquipmentID/@ID',
			v_index ) ) )::text::NUMERIC
	END
INTO
	v_equipid ;
--raise notice'%v_equipid',v_equipid; 

 
 SELECT
	count (1) INTO
	strict v_counter
FROM
	lab.equipment_module_link
WHERE
	equip_linkid = v_equip_linkid
	AND equipmentid = v_equipid ;
--raise notice'%v_counter',v_counter; 

 
 
 IF ( v_counter = 0 )THEN 
 raise notice'i4 & 2nd if started';
-- select count (*) from lab.equipment_module_link --520

 INSERT
	INTO
	lab.equipment_module_link
VALUES ( v_equip_linkid,
v_equipid,
nextval ('lab.s_equipment_module_linkid'),
1 ) ;

raise notice '% ,% ',
v_equip_linkid,
v_equipid ;
ELSE 
 UPDATE
	lab.equipment_module_link
SET
	status = 1
WHERE
	equip_linkid = v_equip_linkid
	AND equipmentid = v_equipid ;
END IF ;

i := i + 1 ;
END
LOOP
;

on_returnvalue := 0 ;
ELSE
--raise notice'if v_processingtype condition else started'; 

 UPDATE
	lab.equipment_module_link
SET
	status = 0
WHERE
	equip_linkid = v_equip_linkid ;
END IF ;
--raise notice'if v_processingtype condition ended'; 

i := 1 ;

UPDATE
	lab.methodology_link
SET
	status = 0
WHERE
	methodologylinkid = v_methodology_linkid ;
LOOP
	--select unnest ( xpath ( '/Test/MethodologyID/Methodology/MethodologyID[' || i || ']',v_testdetails ) )into v_index ; 

	v_index := (
	SELECT
		UNNEST ( xpath ( '/Test/MethodologyID/Methodology/MethodologyID[' || i || ']',
		v_testdetails ) ));

EXIT
WHEN v_index IS NULL ;

SELECT
	CASE
		WHEN (
		SELECT
			UNNEST ( xpath ( '/MethodologyID/@ID',
			v_index ) ) )::text = '' THEN NULL
		ELSE (
		SELECT
			UNNEST ( xpath ( '/MethodologyID/@ID',
			v_index ) ) )::text::NUMERIC
	END
INTO
	v_methodologyid ;

SELECT
	count (1) INTO
	strict v_counter
FROM
	lab.methodology_link
WHERE
	typeofmethodology = v_methodologyid
	AND methodologylinkid = v_methodology_linkid ;

IF ( v_counter = 0 )THEN 
 raise notice 'i5 s268';
-- select count (*) from lab.methodology_link --805

 INSERT
	INTO
	lab.methodology_link
SELECT
	nextval ('lab.s_methodologylinkid'),
	v_methodologyid,
	v_methodology_linkid,
	1 ;
ELSE 
 UPDATE
	lab.methodology_link
SET
	status = 1
WHERE
	methodologylinkid = v_methodology_linkid
	AND typeofmethodology = v_methodologyid ;
END IF ;

i := i + 1 ;
END
LOOP
;
END IF ;
--raise notice'if v_testid = 0 condition ended'; 

i := 1 ;

UPDATE
	lab.media_link
SET
	status = 0
WHERE
	medialinkid = v_media_linkid ;
LOOP
	--select unnest ( xpath ( '/Test/MediaID/Media/MediaID[' || i || ']',v_testdetails ) )into v_index ; 

	v_index := (
	SELECT
		UNNEST ( xpath ( '/Test/MediaID/Media/MediaID[' || i || ']',
		v_testdetails ) ));

EXIT
WHEN v_index IS NULL ;

SELECT
	CASE
		WHEN (
		SELECT
			UNNEST ( xpath ( '/MediaID/@ID',
			v_index ) ) )::text = '' THEN NULL
		ELSE (
		SELECT
			UNNEST ( xpath ( '/MediaID/@ID',
			v_index ) ) )::text::NUMERIC
	END
INTO
	v_mediaid ;

SELECT
	count (1) INTO
	strict v_counter
FROM
	lab.media_link
WHERE
	mediaid = v_mediaid
	AND medialinkid = v_media_linkid ;

IF ( v_counter = 0 )THEN 
 raise notice 'i6 s288';
-- select count (*) from lab.media_link -- 63

 INSERT
	INTO
	lab.media_link
VALUES ( nextval ('lab.s_medialinkid'),
v_mediaid,
v_media_linkid,
1 ) ;
ELSE 
 UPDATE
	lab.media_link
SET
	status = 1
WHERE
	medialinkid = v_media_linkid
	AND mediaid = v_mediaid ;
END IF ;

i := i + 1 ;
END
LOOP
;

on_returnvalue := 0 ;
END ;

$procedure$
;
