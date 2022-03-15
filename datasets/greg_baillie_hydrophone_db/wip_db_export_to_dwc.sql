// From Greg:
// > This is a query I use to extract what I think are relevant fields from our database (or hard-coded terms where those fields/terms are missing). 
// It is not yet clear to me if these would be occurrences or events.
// This is for a single deployment of a single hydrophone, where there are human annotations of something like an orca. 
// This might not be satisfactory for OBIS yet, but it's a work-in-progress.


SELECT  d.deviceid, ah.startdate, ah.annotationsourceid, al.annotation, al.taxonid, al.taxonomyid
FROM    device  d
        JOIN    annotation_hdr  ah  ON  (
            ah.resourcetypeid = 1000
            AND ah.annotationsourceid = 5
            AND ah.resourceid = d.deviceid
        )
        JOIN     annotation_line al  ON  al.annotationhdrid = ah.annotationhdrid
WHERE   d.devicetypeid  =176
        AND al.annotation ILIKE '%orca%'
ORDER BY d.deviceid, ah.startdate;
        
        
SELECT  // Required
        CONCAT(
            REPLACE(s.sitename, ' ', '_'),
            '_',
            TO_CHAR(ah.startdate, 'DDMONYYYY:HH24:MI:SS.MS'),
            '_',
            'Orcinus_orca'
         ) AS occurrenceID,                                                                                     //occurrenceID	Station_95_Date_09JAN1997:14:35:00.000_Atractosteus_spatula
        'HumanObservation' as basisOfRecord,                                                                    //basisOfRecord	HumanObservation
        'Orcinus orca (Linnaeus, 1758)' as scientificName,                                                      //scientificName	Atractosteus spatula
        'urn:lsid:marinespecies.org:taxname:137102' as scientificNameID,                                        //scientificNameID	urn:lsid:marinespecies.org:taxname:218214
        TO_CHAR(ah.startdate, 'YYYY-MM-DD"T"HH24:MI:SS"Z"') as eventDate,                                       //eventDate	2009-02-20T08:40Z
        (SELECT value FROM fixedvalueposition WHERE siteid=s.siteid AND sensortypeid=86) as decimalLatitude,    //decimalLatitude	-41.0983423
        (SELECT value FROM fixedvalueposition WHERE siteid=s.siteid AND sensortypeid=140) as decimalLongitude,  //decimalLongitude	-121.1761111
        'present' as occurrenceStatus,                                                                          //occurrenceStatus	US
        NULL as countryCode,                                                                                    //countryCode,
        'Animalia' as kingdom,                                                                                  //kingdom	Animalia
        'WGS84' as geodeticDatum,                                                                               //geodeticDatum
        // Additional
        (SELECT value FROM fixedvalueposition WHERE siteid=s.siteid AND sensortypeid=96),                       //minimumDepthInMeters	0.1
        (SELECT value FROM fixedvalueposition WHERE siteid=s.siteid AND sensortypeid=96),                       //maximumDepthInMeters	10.5
        // coordinateUncertaintyInMeters -- ??                                                                  //coordinateUncertaintyInMeters	0.1
        'Hydrophone',                                                                                           //samplingProtocol	2
        // organismQuantityType                                                                                 //organismQuantityType	Relative Abundance
        xpath(
            '/n:resource/n:titles/n:title/text()',
            dds.datacitemetadata::xml,
            '{{n,http://datacite.org/schema/kernel-4}}'
        )  as  datasetName,                                                                                      //datasetName	 	extract title from XML?
        //dataGeneralizations                                                                                   //dataGeneralizations
        //informationWithheld - COULD BE IMPORTANT FOR REAL_TIME ANNOTATIONS?                                   //informationWithheld
        //institutionCode                                                                                       //institutionCode
        
        // Suggested in chat for distinguishing between human- and machine-annotated
        du.firstname || ' ' || du.lastname AS idenitifedBy                                                      // identifiedBy <- Human
		// identifiedByID <- ORCID
		// identificationReferences <- software PAM
FROM    device  d
        JOIN    annotation_hdr  ah  ON  (
            ah.resourcetypeid = 1000
            AND ah.annotationsourceid = 5
            AND ah.resourceid = d.deviceid
        )
        JOIN    annotation_line al  ON  al.annotationhdrid = ah.annotationhdrid
        JOIN    sitedevice  sd  ON (
            sd.deviceid = d.deviceid
            AND sd.datefrom = (
                SELECT  datefrom
                FROM    sitedevice
                WHERE   deviceid=d.deviceid
                        AND datefrom <= ah.startdate
                ORDER BY datefrom DESC LIMIT 1
            )
        )
        JOIN    site                s   ON  s.siteid    =   sd.siteid
        LEFT JOIN    pi_doidataset       dds ON  (
            dds.sitedeviceid    =   sd.sitedeviceid
            AND dds.doidataset  LIKE '10.3%'
            AND dds.createddate = (
                SELECT  MAX(createddate)
                FROM    pi_doidataset
                WHERE   sitedeviceid=sd.sitedeviceid
                        AND doidataset  LIKE '10.3%'
            )
        )
        JOIN    dmasuser du              ON  du.dmasuserid  =   ah.createdby
WHERE   d.devicecategoryid = 19
        AND sd.sitedeviceid = 1189210
        AND (
            al.annotation ILIKE '%orca%'
        );
        
SELECT * FROM sensortype;

SELECT * FROM annotation_hdr WHERE annotationhdrid=186744

SELECT xpath('/n:resource/n:titles/n:title/text()', dds.datacitemetadata::xml, '{{n,http://datacite.org/schema/kernel-4}}')
FROM    pi_doidataset dds
WHERE   doidataset LIKE '10.3%'
LIMIT 10;

SELECT datacitemetadata
FROM    pi_doidataset dds
WHERE   doidataset LIKE '10.3%'
LIMIT 10;
