%=================================================%
% NAME                                            %
%  write_fl_cremp_coral_occurrence_csv.m                     %
% PURPOSE:                                        %
%  The purpose of this program read and           %
%  convert data to proper units und format 		  %
% HISTORY:                                        %
%  Marion Stoessel, April 2017                    %
% Department of Oceanography                      %
%  Texas A&M University                           %
%  Copyright TAMU                                 %
% Modified:                                       %
%  July 2019, January 2021                        %
%=================================================%

close all; clear all; clc;

% initialize metadata for netcdf files and some variables
disp(' start ');
disp('**********************************');
disp('**********************************');
%                          * *| * *1 * *| * *2 * *| * *3 * *| * *4 * *| * *5 * *| * *6 * *| * *7 * *| * *8 * *| * *9 * *| * *@ * *| * *1 * *| * *2 * *| * *3 * *| * *4 * *| * *5 * *| * *6 * *| * *7 * *| * *8 * *| * *9 * *| * *# * *| * *1 * *| * *2 * *| * *3 * *| * *4 * *| * *5 * *| * *6 * *| * *7 * *| * *8 * *| * *9 * *| * *$ * *| * *1 * *| * *2 * *| * *3 * *| * *4 * *| * *5 * *| * *6 * *| * *7 * *| * *8 * *| * *9 * *| * *0 * *| * *1 * *| * *2 * *| * *3 * *| * *4 * *| * *5 * *| * *6 * *| * *7 * *| * *8 * *| * *9 * *| * *0 * *| * *1 * *| * *2 * *| * *3 * *| * *4 * *| * *5 * *| * *6 * *| * *7 * *| * *8 * *| * *9 * *| * *0 * *| * *1 * *| * *2 * *| * *3 * *| * *4 * *| * *5 * *| * *6 * *| * *7 * *| * *8 * *| * *9 * *| * *0 * *| * *1 * *| * *2 * *| * *3 * *| * *4 * *| * *5 * *| * *6 * *| * *7 * *| * *8 * *| * *9 * *| * *0 * *| * *1 * *| * *2 * *| * *3 * *| * *4 * *| * *5 * *| * *6 * *| * *7 * *| * *8 * *| * *9 * *| * *0 * *| * *1 * *| * *2 * *| * *3 * *| * *4 * *| * *5 * *| * *6 * *| * *7 * *| * *8 * *| * *9 * *| * *0 * *| * *1 * *| * *2 * *| * *3 * *| * *4 * *| * *5 * *| * *6 * *| * *7 * *| * *8 * *| * *9 * *| * *0 * *| * *1 * *| * *2 * *| * *3 * *| * *4 * *| * *5 * *| * *6 * *| * *7 * *| * *8 * *| * *9 * *| * *0 * *| * *1 * *| * *2 * *| * *3 * *| * *4 * *| * *5 * *| * *6 * *| * *7 * *| * *8 * *| * *9 * *| * *0 * *| * *1 * *| * *2 * *| * *3 * *| * *4 * *| * *5 * *| * *6 * *| * *7 * *| * *8 * *| * *9 * *| * *0 * *| * *1 * *| * *2 * *| * *3 * *| * *4 * *| * *5 * *| * *6 * *| * *7 * *| * *8 * *| * *9 * *| * *0 * *| * *1 * *| * *2 * *| * *3 * *| * *4 * *| * *5 * *| * *6 * *| * *7 * *| * *8 * *| * *9 * *| * *0 * *| * *1 * *| * *2 * *| * *3 * *| * *4 * *| * *5 * *| * *6 * *| * *7 * *| * *8 * *| * *9 * *| * *0 * *| * *1 * *| * *2 * *| * *3 * *| * *4 * *| * *5 * *| * *6 * *| * *7 * *| * *8 * *| * *9 * *| * *0 
bibliographicCitation = 'http://ocean.floridamarine.org/FKNMS_WQPP/coral.htm';
%references            = 'http://ocean.floridamarine.org/FKNMS_WQPP/coral.htm, http://gcoos4.tamu.edu:8080/erddap/info/index.html?page=1&itemsPerPage=1000';
commentToStations1    = 'The data sets includes data from about 1/3 of the transect that had been surveyed for all survey stations in the past. This is reflected in the number of points counted for each station. This way all the years of the survey are directly comparable as the data reflects the same survey area (Mike Collela).'; %299
%reference             = 'Ruzicka R, Colella M, Semon K, Brinkhuis V, Morrison J, Kidney J, Porter J, Meyers  M, Christman M, and Colee J. 2010. CREMP 2009 Final Report. Fish & Wildlife Research Institute/Florida Fish & Wildlife Conservation Commission. Saint Petersburg, FL. 110 pp ';
associatedReferences  = 'Ruzicka R, Colella M, Semon K, Brinkhuis V, Morrison J, Kidney J, Porter J, Meyers  M, Christman M, and Colee J. 2010. CREMP 2009 Final Report. Fish & Wildlife Research Institute/Florida Fish & Wildlife Conservation Commission. Saint Petersburg, FL. 110 pp '; 
%samplingProtocol1     = 'Video Transect Method for Coral Reef Monitoring';
samplingProtocol1     = 'CREMP sites consist of two to four monitoring stations delimited by permanent markers. Stations are approximately 2m x 22m and are generally perpendicular to the shoreline. Three video transects (benthic survey), a station species inventory (SSI), and a clioniad sponge survey are conducted annually at each station.'; %316
%                         * *| * *1 * *| * *2 * *| * *3 * *| * *4 * *| * *5 * *| * *6 * *| * *7 * *| * *8 * *| * *9 * *| * *@ * *| * *1 * *| * *2 * *| * *3 * *| * *4 * *| * *5 * *| * *6 * *| * *7 * *| * *8 * *| * *9 * *| * *# * *| * *1 * *| * *2 * *| * *3 * *| * *4 * *| * *5 * *| * *6 * *| * *7 * *| * *8 * *| * *9 * *| * *$ * *| * *1 * *| * *2 * *| * *3 * *| * *4 * *| * *5 * *| * *6 * *| * *7 * *| * *8 * *| * *9 * *| * *0 
samplingeffort1       = 'Two observers conducted simultaneous 15-20 minute inventories within the roughly 22 x 2 m video stations'; 
TimeZone              = '-05:00';

license1          = 'http://creativecommons.org/publicdomain/zero/1.0/legalcode';
title             = 'Coral Reef Evaluation and Monitoring Project (CREMP)';
summa             = 'The purpose of the Coral Reef Evaluation and Monitoring Project (CREMP) is to monitor the status and trends of selected reefs in the Florida Keys National Marine Sanctuary(FKNMS).CREMP assessments have been conducted annually at fixed sites since 1996 and data collectedprovides information on the temporal changes in benthic cover and diversity of stony corals andassociated marine flora and fauna. The core field methods continue to be underwatervideography and timed coral species inventories. Findings presented in this report include datafrom 109 stations at 37 sites sampled from 1996 through 2008 in the Florida Keys and 1999 through 2008 in the Dry Tortugas. The report describes the annual differences (between 2007 and 2008) in the percent cover of major benthic taxa (stony corals, octocorals, sponges, and macroalgae), mean coral species richness and the incidence of stony coral conditions. Additionally, it examines the long-term trends of the major benthic taxa, five coral complex, Montastraea cavernosa, Colpophyllia natans, Siderastrea siderea, and Porites astreoides) and the clionaid sponge, Cliona delitrix.';
source            = 'Coral monitoring Project';
sea_name          = 'Gulf of Mexico';
program_name      = 'Florida Keys National Marine Sanctiary Water Quality Protection Program';
project_name      = 'Coral Reef Evaluation and Monitoring Project (CREMP)';%52
naming_authority  = 'fwri.fwc';
country           = 'USA';
institution       = 'Florida Fish and Wildlife Conservation Commission - Fish and Wildlife Research Institute (FWC-FWRI)';
keywords          = 'Gulf of Mexico, Florida keys, Dry Tortugas, coral monitoring';
keywords_vocab    = 'GCMD Science Keywords Version 9.1.5, CF Standard Names v72';
instrument_vocab  = 'GCMD Science Keywords Version 9.1.5';
platform_vocab    = 'https://mmisw.org/ont/ioos/platform';
instrument        = 'Sony CCD-VX3 camera';
platform          = 'unknown';
platform_name     = 'unknown';
platform_id       = 'unknown';
creator_name      = 'James Porter';
creator_url       = 'http://www.ecology.uga.edu/facultyMember.php?Porter-32/';
creator_email     = 'jporter@uga.edu';
creator_phone     = '1-706-542-3410';
creator_sector    = 'academic';
creator_address   = 'Ecology building';
creator_city      = 'Athens';
creator_state     = 'Georgia';
creator_postalcode = '30602';
creator_country   = 'USA';
creator_inst      = 'University of Georgia, Odum School of Ecology';
creator_type      = 'person';
contrib_name      = 'Michael Colella';
contrib_role      = 'Research Scientist, Coral Program';
contrib_email     = 'Mike.Colella@MyFWC.com';
contrib_url       = 'unknown';
contrib_phone     = '1-727-892-4128';
contrib_role_vocab = 'https://vocab.nerc.ac.uk/collection/G04/current/';
contrib_inst      = 'Florida Fish & Wildlife Conservation Commission, Fish & Wildlife Research Institute ';
contrib_type      = 'person';
contrib_country   = 'USA';
processor_name    = 'Marion Stoessel';
processor_role    = 'Senior Research Associate/Data Manager';
processor_email   = 'mstoessel@ocean.tamu.edu';
processor_url     = 'https://oceanography.tamu.edu/people/profiles/research-staff/stosselmarion.html';
processor_phone   = '+1-979-845-7662';
processor_address = '3146 TAMU, Eller O&M Building';
processor_city    = 'College Station';
processor_state   = 'Texas';
processor_postalcode = '77843';
processor_country = 'USA';
processor_inst    = 'GCOOS at Texas A&M University, Dept. of Oceanography';
processor_type    = 'person';
publisher_email   = 'data@gcoos.org';
publisher_inst    = 'Gulf of Mexico Coastal Ocean Observing System';
publisher_name    = 'GCOOS';
publisher_phone   = '+1-979-458-3274';
publisher_role    = 'Data Manager';
publisher_address = '3146 TAMU, Eller O&M Building';
publisher_city    = 'College Station';
publisher_state   = 'Texas';
publisher_postalcode = '77843';
publisher_country = 'USA';
publisher_type    = 'person';
publisher_url     = 'https://gcoos.org';
meta_link         = 'http://gcoos4.tamu.edu:8080/erddap/info/index.html?page=1&itemsPerPage=1000';
infoUrl           = 'http://gcoos4.tamu.edu:8080/erddap/info/index.html?page=1&itemsPerPage=1000';
geospatial_bounds = 'POLYGON (24.00 -83.10, 26.00, -83.10, 26.00, -80.00, 24.00 -80.00,  24.00 -83.10)';
comment0          =  commentToStations1; 
comment1          = 'Variable description can also be found in: http://rs.tdwg.org/dwc/terms/index.htm#institutionID';
acknowledgment    = 'Thank you to all involved';
value             = 'unknwon';
date_created      = '20180515T22:12:00';
date_issued       = '20180515T22:12:00';
date_modified     = datestr(now,'yyyy-mm-ddTHH:MM:SSZ');
date_metadata_modified = datestr(now,'yyyy-mm-ddTHH:MM:SSZ');
history           = 'v2.1, May 15, 2018, v2.2 22:12:00; July 25, 2019; v2.3 June 5, 2020';
product_version   = 'v2.3.1';
FillValue = -99999.; fillvalue = -99999.; fillvalue = -999.99; fillvalue2 = -999;
%
HabClass       = {'BCP','HB','OD','OS','P','1R','2R','3R','FT','NS'}; % Habitat code in file
HabClassName   = {'Back Country Patch Reef','Hard Bottom','Deep Fore Reef','Shallow Fore Reef',...
                  'Patch Reef','first Reef','Second Reef','Third Reef','Nearshore','Fate Tracking'};
SUBREGION_NR   = {'DT','LK','MK','UK','BC','DC','PBC','MC'};
SUBREGION_NAME = {'Dry_Tortugas','Lower Keys','Middle Keys','Upper Keys','Broward County','Dade County','Palm Beach'...
                  'Martin County'};
TIME_SEEN      = {'1=first 5 minutes','2=5-10 minutes','3=after 10 minutes'};
Region         = { 'National Park Services Dry Tortuga','Florida Keys National Marine Sactuary','Southeast Florida Coral Reef Evaluation and Monitoring Project'};
reg            = {'NPSDT','FKNMS','SECREMP'};
anf_datum      = {'1996-05-01'};

% File path and moorings
%filedir  = '/Volumes/MeineMacDaten3/GOM#1/GOMRI/MBON/Coral_reefs/Yearly_revisited_data/';
%filedir2 = '/Volumes/MeineMacDaten3/GOM#1/GOMRI/MBON/Coral_reefs/Yearly_revisited_data/nc/fk.v2.3.1/Occurrence/';
%filedir2 = '/Volumes/MeineMacDaten3/GOM#1/GOMRI/MBON/Coral_reefs/Yearly_revisited_data/nc/dt.v2.3.1/Occurrence/';
filedir = '/Users/mstoessel/GOMRI/MBON/Coral_reefs/yearly_revisited_data/';
%filedir2 = '/Users/mstoessel/GOMRI/MBON/Coral_reefs/yearly_revisited_data/nc/fk.v2.3.1/Occurrence/';
filedir2 = '/Users/mstoessel/GOMRI/MBON/Coral_reefs/Yearly_revisited_data/nc/dt.v2.3.1/Occurrence/';
%filedir  = '/Users/marion/GOMRI/MBON/Coral_reefs/yearly_revisited_data/';
%filedir2 = '/Users/marion/GOMRI/MBON/Coral_reefs/yearly_revisited_data/nc/dt.v2.3.1/Occurrence/';
%filedir2 = '/Users/marion/GOMRI/MBON/Coral_reefs/yearly_revisited_data/nc/fk.v2.3.1/Occurrence/';

mona = {'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'};
monu = {'01','02','03','04','05','06','07','08','09','10','11','12'};
dinu = {'dt','fk'}; dina = {'DT','FKNMS'};

ab = char(dinu(1));  % select dt = Dry Tortugas data or fk = Florida Keys data
cd = char(dina(1));
% Data information
% Read  dt/fk_Station_List_Master_160920.csv

file1 = [filedir,ab,'_Station_List_Master_160920.csv']
fprintf(1,'%s\n',file1);
fid01 = fopen(file1,'r');
l00a = textscan(fid01,...
    '%s %s %s %s %s %s %s %s %s %s %s %s %s',1,'Delimiter',',');
%     *  *  *  *  |  *  *  *  *  1  *  *  *  *  |  *  *  *  *  2  *  *  *  *  |  
le = 0;
while ~feof(fid01)    
                
     l00 = textscan(fid01,...
    '%s %s %s %s %s %s %d %d %d %f %f %f %f',1,'Delimiter',',');
%     *  *  *  *  |  *  *  *  *  1  *  *  *  *  |  *  *  *  *  2  *  *  *  *  |  
     if ~isempty(l00{1})
      le =le + 1;
%      
      region1{le}        = char(l00{1});
      site_code{le}      = char(l00{4});
      site_id{le}        = char(l00{5});      
      site_name{le}      = char(l00{6});        
      habitat_id{le}     = char(l00{3});
      subregion_code{le} = char(l00{2});
      station_id(le)     = l00{7};      
      first_year1(le)    = l00{8};
      last_year1(le)     = l00{9};
      transect_length(le)= l00{10};
      depth(le)          = l00{11};
      latitude1(le)      = l00{12};
      longitude1(le)     = l00{13};
     end
end

%Read coral species data file
file2 = [filedir,'CREMP_Coral_Species_1996-2015_new.csv']
fprintf(1,'%s\n',file2);
fid02 = fopen(file2, 'r');
l02a = textscan(fid02,...
   '%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s',1,'Delimiter',',');
%    *  *  *  *  |  *  *  *  *  1  *  *  *  *  |  *  *  *  *  2  *  *  *  *  |
la = 0;
while ~feof(fid02)
                
     l02a = textscan(fid02,...
    '%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s',1,'Delimiter',',');
%     *  *  *  *  |  *  *  *  *  1  *  *  *  *  |  *  *  *  *  2  *  *  *  *  |
     if ~isempty(l02a{1})
      la =la + 1;
%      
      latinname{la}        = char(l02a{1});
      commonname{la}       = char(l02a{2});
      aphiaID1{la}         = char(l02a{3});
      taxonomicStatus1{la} = char(l02a{5});
      if(isempty(char(l02a{6})) == 1)
        authoritya{la}     = '';
        authorityb{la}     = '';
        authority1{la}     = '';
      else
        authoritya{la}     = char(l02a{6});
        year1{la}          = char(l02a{7});
        authority1{la}     = [authoritya{la},',',year1{la}];
      end
      acceptedId1{la}      = char(l02a{8});
      acceptedName1{la}    = char(l02a{9});
      if(isempty(char(l02a{10})) == 1)
        authority2{la}     = '';
        year2{la}          = '';
        acc_authority{la}  = '';
      else
        authority2{la}     = char(l02a{10});
        year2{la}          = char(l02a{11});
        acc_authority{la}  = [authority2{la},',',year2{la}];
      end
      kingdom1{la}         = char(l02a{12});
      phylum1{la}          = char(l02a{13});
      class1{la}           = char(l02a{14});
      order1{la}           = char(l02a{15});
      family1{la}          = char(l02a{16});
      genus1{la}           = char(l02a{17});
      species1{la}         = char(l02a{18});
     end
 end
% Read coral data files
 disp('read coral site file');
 file_id = dir(fullfile(filedir,[ab,'_CREMP_Pcount_',cd,'_*_300trns.csv']));

 for m = 1:length(file_id)
 %for m = 1:18
   filid = file_id(m).name
   filnr = filid(end-7:end-4)
   l01  = 1;
   l02  = 2;
   l03  = 3;
   l04  = 4;
   l05  = 5;
   l08  = 8;
   l10  = 10;
   l14  = 14;
   l15  = 15;
   l18  = 18;
   l20  = 20;
   l25  = 25;
   l30  = 30;
   l35  = 35;
   l40  = 40;
   l45  = 45;
   l50  = 50;
   l55  = 55;
   l60  = 60;
   l65  = 65;
   l70  = 70;
   l75  = 75;
   l80  = 80;
   l90  = 90;
   l100 = 100;
   l105 = 105;
   l260 = 260;
   l316 = 316;
   lre  = 390;
   lcom1 = 1790;
   lcom2 = 750;
  value  = ' ';
  filein = [filedir,file_id(m).name];
  filid  = file_id(m).name;
  fili = [filid(1:end-4),'_','yearly_revisited'];

  fprintf(1,'%s\n',filein);

  FILENAME1 = [filedir2,strcat(fili,'_OBIS_occurrence_v2.3.1.nc')]
  fid = fopen(filein, 'r');
  disp('**********************************');
  disp(' process new file ');
  disp('**********************************');
  if(strcmp(filid(1:2),'dt') == 1)
  % Read 1st line in data file
   l01a    = textscan(fid,...
    '%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s',1,'delimiter',','); %1996 #76
%     *  *  *  *  |  *  *  *  *  1  *  *  *  *  |  *  *  *  *  2  *  *  *  *  |  *  *  *  *  3  *  *  *  *  |  *  *  *  *  4  *  *  *  *  |  *  *  *  *  5  *  *  *  *  |  *  *  *  *  6  *  *  *  *  |  *  *  *  *  7  *  *  *  *  |  *  *
    lu = length(l01a);
    lui  = 0;
    for i=9:lu
        an                      = sprintf('%35s',char(l01a{i})); % read coral species names
        artc(:,i-8)             = an;
        lui = lui +1;
    end
    % Read 2nd to lines in datafile
    li = 0; 
    while ~feof(fid)
       l03 = textscan(fid,...      
    '%f %s %s %s %d %s %f %f %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s',1,'Delimiter',',');  %1996 #76
%     *  *  *  *  |  *  *  *  *  1  *  *  *  *  |  *  *  *  *  2  *  *  *  *  |  *  *  *  *  3  *  *  *  *  |  *  *  *  *  4  *  *  *  *  |  *  *  *  *  5  *  *  *  *  |  *  *  *  *  6  *  *  *  *  |  *  *  *  *  7  *  *  *  *  |  *  *                   
    if ~isempty(l03{1})  
      li = li + 1;
%      
      jahr1(li)              = l03{1};
      subregion_id1(li)      = strtrim(l03{2});
      habitat_id1(li)        = strtrim(l03{3});
      sitec                  = char(l03{4});
      site_cd1(:,li)         = strtrim(sitec);
      site_id1(li)           = l03{5};
      siten                  = strtrim(char(l03{6}));
      site_name1(:,li)       = sprintf('%25s',siten);      
      station_nr1(li)        = l03{7};
      avgOfPoints1(li)       = l03{8};
      for i=9:length(l03)
         anr                 = sprintf('%15s',char(l03{i}));
         if(strcmp(strtrim(anr),'NS') == 1 || strcmp(strtrim(anr),'') == 1 || strcmp(strtrim(anr),'NaN') == 1)
           artn(li,i-8)      = 0;
         else
           artn(li,i-8)      = str2double(anr);
         end
      end
      eventDate1(li) = jahr1(li);
%      msi(:,li)  = strcat(site_cd1(:,li),'_',num2str(station_nr1(li)),'_',num2str(jahr1(li))); %l12
      subSampleID(:,li)   = strcat(num2str(station_nr1(li)),'_',num2str(site_id1(li)));
      parentEventId1(:,li) = sprintf('%14s',strcat(num2str(jahr1(li)),'_',char(subregion_id1(li)),'_',char(sitec),'_',num2str(site_id1(li))));
      eventId1(:,li)       = sprintf('%18s',strcat(num2str(jahr1(li)),'_',char(subregion_id1(li)),'_',char(sitec),'_',num2str(site_id1(li)),'_',num2str(station_nr1(li))));
%{
      ms1(:,li)           = strcat(site_cd1(:,li),'_',num2str(site_id1(li)),'_');
      ms2(:,li)           = strcat(num2str(station_nr1(li)),'_',num2str(jahr1(li)));
      msi(:,li)           = strcat(ms1(:,li),ms2(:,li));
      msid1(:,li)         = sprintf('%15s',char(msi(:,li)));
%}
     end
       
     dataId1(1:l45,li) = sprintf('%45s',(strtrim(strcat('CoralReefEvaluationAndMonitoringProject-',num2str(jahr1(1)))))); %l44    
    end
 elseif(strcmp(filid(1:2),'fk') == 1)
% Read 1st line in data file
   l01a    = textscan(fid,...
    '%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s',1,'delimiter',','); %fk 80
%     *  *  *  *  |  *  *  *  *  1  *  *  *  *  |  *  *  *  *  2  *  *  *  *  |  *  *  *  *  3  *  *  *  *  |  *  *  *  *  4  *  *  *  *  |  *  *  *  *  5  *  *  *  *  |  *  *  *  *  6  *  *  *  *  |  *  *  *  *  7  *  *  *  *  |  *  *  *  *  8  *  *
    lu = length(l01a);
    lui  = 0;
    for i=9:lu
        an                      = sprintf('%35s',char(l01a{i}));
        artc(:,i-8)             = an;
        lui = lui +1;
    end
 % Read 2nd to lines in datafile   
    li = 0; 
    while ~feof(fid)
       l03 = textscan(fid,...
    '%f %s %s %s %d %s %f %f %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s',1,'Delimiter',',');  %fk 80       
%     *  *  *  *  |  *  *  *  *  1  *  *  *  *  |  *  *  *  *  2  *  *  *  *  |  *  *  *  *  3  *  *  *  *  |  *  *  *  *  4  *  *  *  *  |  *  *  *  *  5  *  *  *  *  |  *  *  *  *  6  *  *  *  *  |  *  *  *  *  7  *  *  *  *  |  *  *  *  *  8  *  *          
         
    if ~isempty(l03{1})  
      li = li + 1;
%      
      jahr1(li)              = l03{1};
      subregion_id1(li)      = strtrim(l03{2});
      habitat_id1(li)        = strtrim(l03{3});
      sitec                  = char(l03{4});
      site_cd1(:,li)         = sitec;
      site_id1(li)           = l03{5};
      siten                  = char(l03{6});
      site_name1(:,li)       = sprintf('%25s',strtrim(siten));      
      station_nr1(li)        = l03{7};
      avgOfPoints1(li)       = l03{8};
      for i=9:length(l03)
         anr                      = sprintf('%15s',char(l03{i}));
         if(strcmp(strtrim(anr),'NS')== 1 || strcmp(strtrim(anr),'') == 1 || strcmp(strtrim(anr),'NaN') == 1)
           artn(li,i-8)           = 0;
         else
           artn(li,i-8)           = str2double(anr);
         end
      end
      eventDate1(li) = jahr1(li);
%      msi(:,li)  = strcat(site_cd1(:,li),'_',num2str(site_id1(li)),'_',num2str(station_nr1(li)),'_',num2str(jahr1(li))); %l12
      subSampleID(:,li)   = strcat(num2str(station_nr1(li)),'_',num2str(site_id1(li)));%6
      parentEventId1(:,li) = sprintf('%14s',strcat(num2str(jahr1(li)),'_',char(subregion_id1(li)),'_',char(sitec),'_',num2str(site_id1(li)))); %14
      eventId1(:,li)       = sprintf('%18s',strcat(num2str(jahr1(li)),'_',char(subregion_id1(li)),'_',char(sitec),'_',num2str(site_id1(li)),'_',num2str(station_nr1(li))));%18
%{    
      ms1(:,li)  = strcat(site_cd1(:,li),'_',num2str(site_id1(li)),'_');
      ms2(:,li)  = strcat(num2str(station_nr1(li)),'_',num2str(jahr1(li)));
      msi(:,li)  = strcat(ms1(:,li),ms2(:,li));
      msid1(:,li)      = sprintf('%15s',char(msi(:,li)));
%}      
     end
       
     dataId1(1:l45,li) = sprintf('%45s',(strcat('CoralReefEvaluationAndMonitoringProject-',num2str(jahr1(1))))); %l44    
    end       
  end
  disp('finished reading coral file');
  li  % number of lines in file
  zle = li    
  for fe = 1:li
        statia     = station_nr1(fe);
        in1        = find(station_id == statia); %find depth using station_nr from read Station list Master file
        dep_01(fe) = depth(in1);
  end
  unista  = unique(station_nr1(:));
  depmin  = zeros(1,li,'double');
  depmax  = zeros(1,li,'double');
  depmean = zeros(1,li,'double');
    
  for al = 1:length(unista)
      uni         = find(unista(al)== station_nr1);
      depmin(al)  = min(dep_01(uni(1)));
      depmax(al)  = max(dep_01(uni(1)));
      depmean(al) = mean(dep_01(uni(1)));
  end
  
  id_ori ='Coral_Reef_Evaluation_and_Monitoring_Project';  %l44
  profile_name = {[ab,'_coral_reef_evaluation_and_monitoring_project_',num2str(jahr1(1))]} %l49
  if(strcmp(ab,'dt'))
   dataset_name = sprintf('%65s',['Coral Reef Evaluation and Monitoring Project Dry Tortugas ',num2str(jahr1(1))]); %l62
  end
  %                                *   *    |    *    2    *    3    *    4    *    5    *    6    *    7
  if(strcmp(ab,'fk'))
   dataset_name = sprintf('%65s',['Coral Reef Evaluation and Monitoring Project Florida Keys ',num2str(jahr1(1))]); %l62
  end
  title = 'Coral Reef Evaluation and Monitoring Project (CREMP)'; % l52  

% Names = repmat({'Sample Text'}, 10, 1); names = cell(10,1); x = char(zeros(1,100));
% search and combine data from read in files; assign values to darwin core variables
la1 = lui;
fa = 0;
 for ii =1:la1   
  for fa = 1:li       
       fi = fa + (ii - 1)*li;
       jahr(fa)             = jahr1(fa); 
       jahr2(fi)            = jahr1(fa);
       stati                = station_nr1(fa);
       ina                  = find(station_id == stati);
       latitude(fa)         = latitude1(ina); 
       lat1(fi)             = latitude1(ina);
       longitude(fa)        = longitude1(ina); 
       lon1(fi)             = longitude1(ina);
       station_nr(fa)       = station_id(fa);
       sta_nr(fi)           = station_id(fa);
       habitatID(:,fa)      = sprintf('%5s',strcat(char(habitat_id1(fa))));
       hab_id(:,fi)         = sprintf('%5s',strcat(char(habitat_id1(fa))));
       siteCode(:,fa)       = sprintf('%5s',strcat(char(site_cd1(:,fa))));
       sitecod(:,fi)         = sprintf('%5s',strcat(char(site_cd1(:,fa))));
       siteID(fa)           = site_id1(fa);
       siteid(fi)           = site_id1(fa);
       siteName(:,fa)       = site_name1(:,fa);
       sitenam(:,fi)        = site_name1(:,fa);
       %siteName(fa,ii,:)   = sprintf('%25s',strcat(char(site_name1(:,fa))));
       first_year(fa)       = first_year1(ina);
       first_y(fi)          = first_year1(ina);
       last_year(fa)        = last_year1(ina);
       last_y(fi)           = last_year1(ina);
       waterDepth(fa)       = dep_01(fa);
       water_dep(fi)        = dep_01(fa);
       depmin1(fa)          = min(dep_01(fa));
       depmi1(fi)           = min(dep_01(fa));
       depmax1(fa)          = max(dep_01(fa));
       depma1(fi)           = max(dep_01(fa));
       avgOfPoints(fa)      = avgOfPoints1(fa);
       ave_poin(fi)         = avgOfPoints1(fa);
       transectLengthInMeters(fa) = transect_length(ina(1));
       transect_len(fi)     = transect_length(ina(1));
       eventDate(1:4,fi)      = num2str(eventDate1(fa));
       parentEventID(:,fi)  = parentEventId1(:,fa);
       eventID(:,fi)        = eventId1(:,fa);
%       msid(fa,ii,:)           = msid1(:,fa);
       dataID(:,fi)         = dataId1(:,fa);
       arc                  = strtrim(artc(:,ii))'; 
       if(strmatch(strtrim(arc),'Madracis aurentenra') == 1)
         arc = 'Madracis auretenra';
       end
       latin                   = strtrim(char(latinname{:}));
       common                  = strtrim(char(commonname{:}));
       ind                     = strmatch(strtrim(arc),latin);
       if(isempty(ind) == 1)
           ind = strmatch(strtrim(arc),common); 
       end      
       scientificName(:,fi) = sprintf('%35s',strcat(char(latinname(ind(1)))));
       vernacularName(:,fi) = sprintf('%35s',strcat(char(commonname(ind(1)))));
       if(isempty(char(aphiaID1(ind(1)))) == 1)
         scientificNameID(:,fi) = sprintf('%45s','');
       else 
         scientificNameID(:,fi)= sprintf('%45s',strcat('urn:lsid:marinespecies.org:taxname:',char(aphiaID1(ind(1))))); %35+6
       end   
       acceptedNameUsage(:,fi)   = sprintf('%35s',strcat(char(acceptedName1(ind(1)))));
       if(isempty(char(acceptedId1(ind(1)))) == 1)
         acceptedNameUsageID(:,fi) = sprintf('%45s','');
       else 
         acceptedNameUsageID(:,fi) = sprintf('%45s',strcat('urn:lsid:marinespecies.org:taxname:',char(acceptedId1(ind(1)))));
       end
% search the taxonomic tree to find highest level taxonomic order
       family(:,fi)         = sprintf('%35s',strcat(char(family1(ind(1)))));   fam = strcat(char(family1(ind(1))));
       order(:,fi)          = sprintf('%30s',strcat(char(order1(ind(1)))));    ord = strcat(char(order1(ind(1))));
       class(:,fi)          = sprintf('%20s',strcat(char(class1(ind(1)))));    cla = strcat(char(class1(ind(1))));
       phylum(:,fi)         = sprintf('%20s',strcat(char(phylum1(ind(1)))));   phy = strcat(char(phylum1(ind(1))));
       kingdom(:,fi)        = sprintf('%15s',strcat(char(kingdom1(ind(1)))));  kin = strcat(char(kingdom1(ind(1))));
       taxonomicStatus(:,fi) = sprintf('%10s',strcat(char(taxonomicStatus1(ind(1)))));
       k0                   = strfind(char(latinname(ind(1))),' ');
       lati                 = char(latinname(ind(1)));
       genus(:,fi)          = sprintf('%20s',lati(1:k0-1));     gen = lati(1:k0-1);
       species(:,fi)        = sprintf('%20s',lati(k0+1:end));   spe = lati(k0+1:end);
       if(strcmp(spe,'sp_') == 1 )
           taxonRank(:,fi)  = sprintf('%10s',strcat(char('Genus')));
           specificEpithet(:,fi)= sprintf('%20s',char(' '));
       elseif(strfind(spe,'complex') ~= 0 )
           taxonRank(:,fi)  = sprintf('%10s',strcat(char('Genus')));
           specificEpithet(:,fi)= sprintf('%20s',char(' '));
       elseif(isempty(spe)) 
           taxonRank(:,fi)  = sprintf('%10s',strcat(char('Genus')));
           specificEpithet(:,fi)= sprintf('%20s',char(' '));
       else
           taxonRank(:,fi)  = sprintf('%10s',strcat(char('Species')));
           specificEpithet(:,fi)= sprintf('%20s',char(lati(k0+1:end)));
       end
       if(isempty(gen))
           taxonRank(:,fi)  = sprintf('%10s',strcat(char('Family')));
           specificEpithet(:,fi)= sprintf('%20s',char(' '));
           genus(:,fi)      = sprintf('%20s',' ');
       end
       if(isempty(fam))
           taxonRank(:,fi)  = sprintf('%10s',strcat(char('Order')));
           specificEpithet(:,fi)= sprintf('%20s',char(' '));
           genus(:,fi)      = sprintf('%20s',' ');
       end
       if(isempty(ord))
           taxonRank(:,fi)     = sprintf('%10s',strcat(char('Class')));
           specificEpithet(:,fi)= sprintf('%20s',char(' '));
           genus(:,fi)         = sprintf('%20s',' ');
       end
       if(isempty(cla))
           taxonRank(:,fi)     = sprintf('%10s',strcat(char('Phylum')));
           specificEpithet(:,fi)= sprintf('%20s',char(' '));
           genus(:,fi)         = sprintf('%20s',' ');
       end
       if(isempty(phy))
           taxonRank(:,fi)      = sprintf('%10s',strcat(char('Kingdom')));
           specificEpithet(:,fi)= sprintf('%20s',char(' '));
           genus(:,fi)          = sprintf('%20s',' ');
       end
       if(isempty(kin))
           taxonRank(:,fi)      = sprintf('%10s',strcat(char(' ')));
           specificEpithet(:,fi)= sprintf('%20s',char(' '));
           genus(:,fi)          = sprintf('%20s',' ');
       end
       authority(:,fi)         = sprintf('%35s',strcat(char(authority1(ind(1)))));
       acceptedauthority(:,fi) = sprintf('%35s',strcat(char(acc_authority(ind(1)))));
%       inb                    = strmatch(scientificName(:,fa),artc(ii,:))
       organismQuantity(fi)    = artn(fa,ii);
 %      organismQuantity(fi)   = artn(fa,ind(1));
       occurrenceID(:,fi)      = sprintf('%35s',strcat(eventId1(:,fa)','_',char(aphiaID1(ind(1))),'_',num2str(fi)));%18+9+6
       organismQuantityType(:,fi) = sprintf('%25s',strcat(char('Organisms per sample Area')));
       if(organismQuantity(fi) == 0)
         occurrenceStatus(:,fi) = sprintf('%10s',strcat(char('absent'))); 
       else
         occurrenceStatus(:,fi) = sprintf('%10s',strcat(char('present')));
       end
       habi                 = strtrim(char(habitat_id1{fa}));
       k1                   = find(ismember(HabClass,habi));
       habitat(:,fa)           = sprintf('%35s',strcat(char(HabClassName(k1(1)))));
       hab(:,fi)               = sprintf('%35s',strcat(char(HabClassName(k1(1)))));
       re01                    = char(strtrim(subregion_id1(fa)));
       subRegionID(:,fa)       = sprintf('%2s',strcat(char(strtrim(subregion_id1(fa)))));
       subreg_id(:,fi)         = sprintf('%2s',strcat(char(strtrim(subregion_id1(fa)))));
       re1                     = find(ismember(SUBREGION_NR,re01));
       reg2                    = char(SUBREGION_NAME);
       locality(:,fa)          = sprintf('%50s',strcat(strtrim(site_name1(:,fa)'),',',strtrim(reg2(re1(1),:))));
       local(:,fi)             = sprintf('%50s',strcat(strtrim(site_name1(:,fa)'),',',strtrim(reg2(re1(1),:))));
       bottomType(:,fa)        = sprintf('%35s',strcat(strtrim(char(HabClassName(k1(1))))));
       bot_type(:,fi)          = sprintf('%35s',strcat(strtrim(char(HabClassName(k1(1))))));
       samplingProtocol(:,fa)  = sprintf('%316s',strcat(strtrim(samplingProtocol1)));
       samp_prot(:,fi)         = sprintf('%316s',strcat(strtrim(samplingProtocol1)));
       samplingEffort(:,fa)    = sprintf('%105s',strcat(strtrim(samplingeffort1)));
       samp_eff(:,fi)           = sprintf('%105s',strcat(strtrim(samplingeffort1)));
       biblio_cita(:,fa)       = sprintf('%50s',bibliographicCitation);
       bibl_cita(:,fi)         = sprintf('%50s',bibliographicCitation);
       aref_0(:,fa)             = sprintf('%260s',strcat(char(associatedReferences)));
       arefe_0(:,fi)            = sprintf('%260s',strcat(char(associatedReferences)));
       reg3                    = char(region1);
       region(:,fa)            = sprintf('%20s',strcat(reg3(ina,:)));
       regi(:,fi)             = sprintf('%20s',strcat(reg3(ina,:)));
  end
 end
   disp('finish sorting variables')
   zlen = length(latitude);
   types = lui; % amount o coral types
   obs = zlen * types
  fclose(fid);

%- Yearday to seconds since 1970-01-01 00:00:00
%   jahr = date1
    ref_time = '1970-01-01 00:00:00';
    nusec1 = zeros(1,zlen,'double')-999;
    for i =1:zlen
     [nusec1(i)] = year2sec1970(jahr(i),04,01,0,0,0);
    end
    nusec = zeros(1,obs,'double')-999;
    for i =1:obs
    [nusec(i)] =year2sec1970(jahr2(i),04,01,0,0,0);
    end

    timst  = [(num2str(jahr(1))),'-040-1T00:00:00Z'];    %start time of observation
    timend = [(num2str(jahr(zlen))),'-11-01T00:00:00Z']; %end time of observation
    tanf  = datenum(timst,'yyyy-mm-ddTHH:MM:SSZ');
    tend  = datenum(timend,'yyyy-mm-ddTHH:MM:SSZ');
    dt    = datestr((tend-tanf),'yyyy-mm-dd HH:MM:SS');
    dy    = datestr((tend-tanf), 'yy');
    dm    = num2str(str2num(datestr((tend-tanf), 'mm')) -1);
    dd    = datestr((tend-tanf), 'dd');
    dth   = datestr((tend-tanf), 'HH');
    dtm   = datestr((tend-tanf), 'MM');
    dts   = datestr((tend-tanf), 'SS');
    time_coverage_duration   = ['P',dy,'Y',dm,'M',dd,'D','T',dth,'H',dtm,'M',dts,'S']
    time_coverage_resolution = 'unknown';

    latmin = min(latitude);
    latmax = max(latitude);
    lonmin = min(longitude);
    lonmax = max(longitude);
  
    clear in1 ind jahr mon tag re1 re01 regio leng numbers time_seen stra ista 
    clear msi ms1 prisa prot stra1
disp('write .nc file, 610');
       
%- Create Variables in NetCDF File : FILENAME1 OBIS Occurrence
disp('----- OBIS Occurrence ----');
nccreate(FILENAME1,'time',...
			'Dimensions',{'Observations=Samples*Types (74)' obs}	,...
            'Datatype','double'		,...
			'Format','netcdf4','FillValue',fillvalue);
ncwrite(FILENAME1,'time', nusec);
ncwriteatt(FILENAME1,'time','_CoordinateAxisType','Time');
ncwriteatt(FILENAME1,'time','long_name','time');
ncwriteatt(FILENAME1,'time','standard_name','time');
ncwriteatt(FILENAME1,'time','standard_name_url','http://mmisw.org/ont/ioos/parameter/time');
ncwriteatt(FILENAME1,'time','units', ['Seconds since ',ref_time] );
ncwriteatt(FILENAME1,'time','valid_min',min(nusec));
ncwriteatt(FILENAME1,'time','valid_max',max(nusec));
ncwriteatt(FILENAME1,'time','missing_value',fillvalue);
ncwriteatt(FILENAME1,'time','calendar','gregorian');
ncwriteatt(FILENAME1,'time','axis','T');
ncwriteatt(FILENAME1,'time','coverage_content_type','time');
ncwriteatt(FILENAME1,'time','ioos_category','time')
ncwriteatt(FILENAME1,'time','ancillary_variables', value);
ncwriteatt(FILENAME1,'time','comment','Measurements were performed between April and September sometimes weather perminting into November, but no specific date was given.');
disp('Time');

nccreate(FILENAME1,'eventDate',...
			'Dimensions',{'len04' l04 'Observations' obs}	,...
            'Datatype','char'		,...
			'Format','netcdf4');
ncwrite(FILENAME1,'eventDate', eventDate);
ncwriteatt(FILENAME1,'eventDate','long_name','Event Date');
ncwriteatt(FILENAME1,'eventDate','standard_name','time');
ncwriteatt(FILENAME1,'eventDate','standard_name_url','http://mmisw.org/ont/cf/parameter/time');
ncwriteatt(FILENAME1,'eventDate','units','year');
ncwriteatt(FILENAME1,'eventDate','missing_value',fillvalue2);
ncwriteatt(FILENAME1,'eventDate','description','The date and time of observation expressed in local time using the standard ISO 8601:2004(E).');
ncwriteatt(FILENAME1,'eventDate','coverage_content_type','referenceInformation');
ncwriteatt(FILENAME1,'eventDate','ioos_category','time');

nccreate(FILENAME1,'latitude',...
			'Dimensions',{'Observations' obs}	,...
			'Datatype','double'		,...
			'Format','netcdf4','FillValue',fillvalue);
ncwrite(FILENAME1,'latitude', lat1);
ncwriteatt(FILENAME1,'latitude','long_name','latitude'	);
ncwriteatt(FILENAME1,'latitude','standard_name','latitude');
ncwriteatt(FILENAME1,'latitude','standard_name_url','http://mmisw.org/ont/cf/parameter/latitude');
ncwriteatt(FILENAME1,'latitude','units','degree_north');
ncwriteatt(FILENAME1,'latitude','axis','Y'	);
ncwriteatt(FILENAME1,'latitude','valid_min',latmin);
ncwriteatt(FILENAME1,'latitude','valid_max',latmax);
ncwriteatt(FILENAME1,'latitude','missing_value',fillvalue	);
ncwriteatt(FILENAME1,'latitude','coverage_content_type','coordinate');
ncwriteatt(FILENAME1,'latitude','ioos_category','location');
ncwriteatt(FILENAME1,'latitude','ancillary_variables', value);
ncwriteatt(FILENAME1,'latitude','description','The position of the observation north or south of the equator in decimal degrees.');
ncwriteatt(FILENAME1,'latitude','comment','These are indeed separate stations with slightly different depths and lengths.  There should be 4 CREMP stations at the majority of CREMP sites.  Many of the stations at a single site have the same coordinates because they are located using the one set of coordinates and navigated to underwater.  At a number of sites, particularly our offshore shallow sites but there are others, stations are farther apart and separate coordinates are provided.');
disp('latitude, 1283');

nccreate(FILENAME1,'longitude',...
			'Dimensions',{'Observations' obs}	,...
			'Datatype','double'		,...
			'Format','netcdf4','FillValue',fillvalue);
ncwrite(FILENAME1,'longitude', lon1);
ncwriteatt(FILENAME1,'longitude','long_name','longitude');
ncwriteatt(FILENAME1,'longitude','standard_name','longitude');
ncwriteatt(FILENAME1,'longitude','standard_name_url','http://mmisw.org/ont/cf/parameter/longitude');
ncwriteatt(FILENAME1,'longitude','units','degree_east'	);
ncwriteatt(FILENAME1,'longitude','axis','X');
ncwriteatt(FILENAME1,'longitude','valid_min',lonmin	);
ncwriteatt(FILENAME1,'longitude','valid_max',lonmax	);
ncwriteatt(FILENAME1,'longitude','FillValue',fillvalue	);
ncwriteatt(FILENAME1,'longitude','coverage_content_type','coordinate');
ncwriteatt(FILENAME1,'longitude','ioos_category','location');
ncwriteatt(FILENAME1,'longitude','ancillary_variables', value);
ncwriteatt(FILENAME1,'longitude','description','The position of the observation east or west of the prime meridian in decimal degrees.');
ncwriteatt(FILENAME1,'longitude','comment','These are indeed separate stations with slightly different depths and lengths.  There should be 4 CREMP stations at the majority of CREMP sites.  Many of the stations at a single site have the same coordinates because they are located using the one set of coordinates and navigated to underwater.  At a number of sites, particularly our offshore shallow sites but there are others, stations are farther apart and separate coordinates are provided.');
disp('longitude');

for fi =1:obs
       data_name(:,fi)         = sprintf('%65s',dataset_name);
end
nccreate(FILENAME1,'datasetName',...
            'Dimensions',{'len65' l65 'Observations' obs }    ,...
            'Datatype','char'        ,...
            'Format','netcdf4');
ncwrite(FILENAME1,'datasetName', data_name);
ncwriteatt(FILENAME1,'datasetName','long_name','Dataset Name');
ncwriteatt(FILENAME1,'datasetName','standard_name','data_set_name');
ncwriteatt(FILENAME1,'datasetName','standard_name_url','http://mmisw.org/ont/cf/parameter/unknow');
ncwriteatt(FILENAME1,'datasetName','description','The name identifying the data set from which the record was derived. ');
ncwriteatt(FILENAME1,'datasetName','coverage_content_type','referenceInformation');
ncwriteatt(FILENAME1,'datasetName','ioos_category','identifier');
disp('data_name'); clear data_name;

nccreate(FILENAME1,'eventID',...
			'Dimensions',{'len18' l18 'Observations' obs }	,...
            'Datatype','char'		,...
			'Format','netcdf4');
ncwrite(FILENAME1,'eventID', eventID);
ncwriteatt(FILENAME1,'eventID','long_name','Event Identification Number (Year_subRegionID_habitatID_SiteCode_siteID_station#)');
ncwriteatt(FILENAME1,'eventID','standard_name','data_set_identification');
ncwriteatt(FILENAME1,'eventID','standard_name_url','http://mmisw.org/ont/cf/parameter/unknow');
ncwriteatt(FILENAME1,'eventID','description','An identifier for the set of information associated with an Event. May be a global unique identifier or an identifier specific to the data set.');
ncwriteatt(FILENAME1,'eventID','coverage_content_type','referenceInformation');
ncwriteatt(FILENAME1,'eventID','ioos_category','identifier');disp('eventID');
disp('eventID, 1376');

for fi =1:obs
      basisOfRecord(:,fi)       = sprintf('%20s','HumanObservation');
end
nccreate(FILENAME1,'basisOfRecord'			,...
			'Dimensions',{'len20' l20 'Observations' obs }	,...
			'Datatype','char'		,...
			'Format','netcdf4');
ncwrite(FILENAME1,'basisOfRecord', basisOfRecord);
ncwriteatt(FILENAME1,'basisOfRecord','long_name','basis Of Record');
ncwriteatt(FILENAME1,'basisOfRecord','standard_name','basis Of Record');
ncwriteatt(FILENAME1,'basisOfRecord','standard_name_url','http://mmisw.org/ont/cf/parameter/unknow');
ncwriteatt(FILENAME1,'basisOfRecord','description','Identifies the source of information or observation that generated the biological occurrence record. (http://rs.tdwg.org/dwc/terms/#basisOfRecord)');
ncwriteatt(FILENAME1,'basisOfRecord','coverage_content_type','auxiliaryInformation');
ncwriteatt(FILENAME1,'basisOfRecord','ioos_category','other');
disp('1389, basisOfRecord'); clear basisOfRecord

for fi =1:obs
      recordedBy(:,fi)       = sprintf('%10s','CREMP');
end
nccreate(FILENAME1,'recordedBy'			,...
			'Dimensions',{'len10' l10 'Observations' obs }	,...
			'Datatype','char'		,...
			'Format','netcdf4');
ncwrite(FILENAME1,'recordedBy', recordedBy);
ncwriteatt(FILENAME1,'recordedBy','long_name','recorded By');
ncwriteatt(FILENAME1,'recordedBy', 'stanard_name','recorded_by');
ncwriteatt(FILENAME1,'recordedBy','standard_name_url','http://mmisw.org/ont/cf/parameter/unknow');
ncwriteatt(FILENAME1,'recordedBy','description','CREMP = Coral Reef Evaluation & Monitoring Project');
ncwriteatt(FILENAME1,'recordedBy','description','The name or other identifier of individual(s) or institution(s) responsible for making the observation and recording it in electronic form. Can be a list delimited by semicolon.');
ncwriteatt(FILENAME1,'recordedBy','coverage_content_type','auxiliaryInformation');
ncwriteatt(FILENAME1,'recordedBy','ioos_category','other');
clear basisOfRecord

nccreate(FILENAME1,'occurrenceID',...
			'Dimensions',{'len35' l35 'Observations' obs }	,...
            'Datatype','char'		,...
			'Format','netcdf4');
ncwrite(FILENAME1,'occurrenceID',occurrenceID);
ncwriteatt(FILENAME1,'occurrenceID','long_name','occurrence identification (Year_subRegionID_habitatID_SiteCode_siteID_station#_scientificNameID)');
ncwriteatt(FILENAME1,'occurrenceID','standard_name','occurrence_identification');
ncwriteatt(FILENAME1,'occurrenceID','standard_name_url','http://mmisw.org/ont/cf/parameter/unknow');
ncwriteatt(FILENAME1,'occurrenceID','description','An identifier for the Occurrence (as opposed to a particular digital record of the occurrence). In the absence of a persistent global unique identifier, construct one from a combination of identifiers in the record that will most closely make the occurrenceID globally unique.');
ncwriteatt(FILENAME1,'occurrenceID','coverage_content_type','auxiliaryInformation');
ncwriteatt(FILENAME1,'occurrenceID','ioos_category','identifier');

nccreate(FILENAME1,'organismQuantity'			,...
			'Dimensions',{'Observations' obs}	,...
			'Datatype','double'		,...
			'Format','netcdf4','FillValue',fillvalue);
ncwrite(FILENAME1,'organismQuantity', organismQuantity);
ncwriteatt(FILENAME1,'organismQuantity','long_name','Number of Organism per sample Area in Square Meters(value x 100 = percent coverage).');
ncwriteatt(FILENAME1,'organismQuantity','standard_name','Organism_per_sample_area')
ncwriteatt(FILENAME1,'organismQuantity','standard_name_url','http://mmisw.org/ont/cf/parameter/unknow');
ncwriteatt(FILENAME1,'organismQuantity','units','%');
ncwriteatt(FILENAME1,'organismQuantity','valid_min',min(organismQuantity));
ncwriteatt(FILENAME1,'organismQuantity','valid_max',max(organismQuantity));
ncwriteatt(FILENAME1,'organismQuantity','missing_value',fillvalue);
ncwriteatt(FILENAME1,'organismQuantity','description','A number or enumeration value for the quantity of organisms.');
ncwriteatt(FILENAME1,'organismQuantity','coverage_content_type','physicalMeasuremnet');
ncwriteatt(FILENAME1,'organismQuantity','ioos_category','biology');

nccreate(FILENAME1,'organismQuantityType'			,...
			'Dimensions',{'len25' l25 'Observations' obs}	,...
			'Datatype','char'		,...
			'Format','netcdf4');
ncwrite(FILENAME1,'organismQuantityType', organismQuantityType);
ncwriteatt(FILENAME1,'organismQuantityType','long_name','Percent Coverage');
ncwriteatt(FILENAME1,'organismQuantityType','standard_name','percent_coverage');
ncwriteatt(FILENAME1,'organismQuantityType','standard_name_url','http://mmisw.org/ont/cf/parameter/unknow');
ncwriteatt(FILENAME1,'organismQuantityType','description','The type of quantification system used for the quantity of organisms; e.g., "27" for organismQuantity with "individuals" for organismQuantityType; "12.5" for organismQuantity with "%biomass" for organismQuantityType.');
ncwriteatt(FILENAME1,'organismQuantityType','coverage_content_type','auxiliaryInformation');
ncwriteatt(FILENAME1,'organismQuantityType','ioos_category','Biology');

nccreate(FILENAME1,'occurrenceStatus'			,...
			'Dimensions',{'len10' l10 'Observations' obs }	,...
			'Datatype','char'		,...
			'Format','netcdf4');
ncwrite(FILENAME1,'occurrenceStatus', occurrenceStatus);
ncwriteatt(FILENAME1,'occurrenceStatus','long_name','A statement about the presence or absence of a Taxon at a Location.');
ncwriteatt(FILENAME1,'occurrenceStatus','standard_name','taxon_status');
ncwriteatt(FILENAME1,'occurrenceStatus','standard_name_url','http://mmisw.org/ont/cf/parameter/unknow');
ncwriteatt(FILENAME1,'occurrenceStatus','description','A statement about the presence or absence of a Taxon at a Location. Recommended best practice is to use a controlled vocabulary.');
ncwriteatt(FILENAME1,'occurrenceStatus','coverage_content_type','auxiliaryInformation');
ncwriteatt(FILENAME1,'occurrenceStatus','ioos_category','Biology');

nccreate(FILENAME1,'scientificName'			,...
			'Dimensions',{'len35' l35 'Observations' obs }	,...
			'Datatype','char'		,...
			'Format','netcdf4');
ncwrite(FILENAME1,'scientificName',scientificName);
ncwriteatt(FILENAME1,'scientificName','long_name','Scientific Name');
ncwriteatt(FILENAME1,'scientificName','standard_name','scientific_name');
ncwriteatt(FILENAME1,'scientificName','standard_name_url','http://mmisw.org/ont/cf/parameter/unknow');
ncwriteatt(FILENAME1,'scientificName','description','The full scientific name, with authorship and date information if known. When forming part of an Identification, this should be the name in lowest level taxonomic rank that can be determined.');
ncwriteatt(FILENAME1,'scientificName','coverage_content_type','referenceInformation');
ncwriteatt(FILENAME1,'scientificName','ioos_category','taxonomy');
clear scientificName

nccreate(FILENAME1,'acceptedNameUsage'			,...
			'Dimensions',{'len35' l35 'Observations' obs }	,...
			'Datatype','char'		,...
			'Format','netcdf4');
ncwrite(FILENAME1,'acceptedNameUsage',acceptedNameUsage);
ncwriteatt(FILENAME1,'acceptedNameUsage','long_name','accepted Name Usage');
ncwriteatt(FILENAME1,'acceptedNameUsage','standard_name','accepted_name_usage');
ncwriteatt(FILENAME1,'acceptedNameUsage','standard_name_url','http://mmisw.org/ont/cf/parameter/unknow');
ncwriteatt(FILENAME1,'acceptedNameUsage','description','The full name, with authorship and date information if known, of the currently valid (zoological) or accepted (botanical) taxon.');
ncwriteatt(FILENAME1,'acceptedNameUsage','coverage_content_type','referenceInformation');
ncwriteatt(FILENAME1,'acceptedNameUsage','ioos_category','taxonomy');
clear acceptedNameUsage;

nccreate(FILENAME1,'vernacularName'			,...
			'Dimensions',{'len35' l35 'Observations' obs }	,...
			'Datatype','char'		,...
			'Format','netcdf4');
ncwrite(FILENAME1,'vernacularName', vernacularName);
ncwriteatt(FILENAME1,'vernacularName','long_name','Common, vernacular Name');
ncwriteatt(FILENAME1,'vernacularName','standard_name','vernacular_name');
ncwriteatt(FILENAME1,'vernacularName','standard_name_url','http://mmisw.org/ont/cf/parameter/unknow');
ncwriteatt(FILENAME1,'vernacularName','description','A common or vernacular name for the taxon observed.');
ncwriteatt(FILENAME1,'vernacularName','coverage_content_type','referenceInformation');
ncwriteatt(FILENAME1,'vernacularName','ioos_category','taxonomy');

nccreate(FILENAME1,'scientificNameID'			,...
			'Dimensions',{ 'len45' l45 'Observations' obs}	,...
			'Datatype','char'		,...
			'Format','netcdf4');
ncwrite(FILENAME1,'scientificNameID',scientificNameID);
ncwriteatt(FILENAME1,'scientificNameID','long_name','World Register of Marine Species (WoRMS) Aphia Database Identification Number');
ncwriteatt(FILENAME1,'scientificNameID','standard_name','Aphia_Database_Identification_Number');
ncwriteatt(FILENAME1,'scientificNameID','standard_name_url','http://mmisw.org/ont/cf/parameter/unknow');
ncwriteatt(FILENAME1,'scientificNameID','description','A unique taxon identifier obtained by validation of the taxon name with the World Register of Marine Species (WoRMS), www.marinespecies.org.');
ncwriteatt(FILENAME1,'scientificNameID','coverage_content_type','referenceInformation');
ncwriteatt(FILENAME1,'scientificNameID','ioos_category','identifier');
clear scientificNameID

nccreate(FILENAME1,'acceptedNameUsageID'			,...
			'Dimensions',{'len45' l45 'Observations' obs }	,...
			'Datatype','char'		,...
			'Format','netcdf4');
ncwrite(FILENAME1,'acceptedNameUsageID',acceptedNameUsageID);
ncwriteatt(FILENAME1,'acceptedNameUsageID','long_name','Accepted WoRMS Aphia Database Identification Number');
ncwriteatt(FILENAME1,'acceptedNameUsageID','standard_name','accepted_Aphia_Database_Identification_Number');
ncwriteatt(FILENAME1,'acceptedNameUsageID','standard_name_url','http://mmisw.org/ont/cf/parameter/unknow');
ncwriteatt(FILENAME1,'acceptedNameUsageID','description','An identifier for the name usage (documented meaning of the name according to a source) of the currently valid (zoological) or accepted (botanical) taxon.');
ncwriteatt(FILENAME1,'acceptedNameUsageID','coverage_content_type','referenceInformation');
ncwriteatt(FILENAME1,'acceptedNameUsageID','ioos_category','identifier');
clear acceptedID

nccreate(FILENAME1,'kingdom'			,...
			'Dimensions',{'len15' l15 'Observations' obs }	,...
			'Datatype','char'		,...
			'Format','netcdf4');
ncwrite(FILENAME1,'kingdom',kingdom);
ncwriteatt(FILENAME1,'kingdom','long_name','Kingdom');
ncwriteatt(FILENAME1,'kingdom','standard_name','kingdom');
ncwriteatt(FILENAME1,'kingdom','standard_name_url','http://mmisw.org/ont/cf/parameter/unknow');
ncwriteatt(FILENAME1,'kingdom','description','The full scientific name of the kingdom in which the taxon is classified.');
ncwriteatt(FILENAME1,'kingdom','coverage_content_type','referenceInformation');
ncwriteatt(FILENAME1,'kingdom','ioos_category','taxonomy');
clear kingdom

nccreate(FILENAME1,'phylum'			,...
			'Dimensions',{'len20' l20 'Observations' obs }	,...
			'Datatype','char'		,...
			'Format','netcdf4');
ncwrite(FILENAME1,'phylum',phylum);
ncwriteatt(FILENAME1,'phylum','long_name','Phylum');
ncwriteatt(FILENAME1,'phylum','standard_name','phylum');
ncwriteatt(FILENAME1,'phylum','standard_name_url','http://mmisw.org/ont/cf/parameter/unknow');
ncwriteatt(FILENAME1,'phylum','description','The full scientific name of the phylum in which the taxon is classified.');
ncwriteatt(FILENAME1,'phylum','coverage_content_type','referenceInformation');
ncwriteatt(FILENAME1,'phylum','ioos_category','taxonomy');
clear phylum

nccreate(FILENAME1,'class'			,...
			'Dimensions',{'len20' l20 'Observations' obs}	,...
			'Datatype','char'		,...
			'Format','netcdf4');
ncwrite(FILENAME1,'class',class);
ncwriteatt(FILENAME1,'class','long_name','Class');
ncwriteatt(FILENAME1,'class','standard_name','class');
ncwriteatt(FILENAME1,'class','standard_name_url','http://mmisw.org/ont/cf/parameter/unknow');
ncwriteatt(FILENAME1,'class','description','The full scientific name of the class in which the taxon is classified.');
ncwriteatt(FILENAME1,'class','coverage_content_type','referenceInformation');
ncwriteatt(FILENAME1,'class','ioos_category','taxonomy');
clear class

nccreate(FILENAME1,'order'			,...
			'Dimensions',{'len30' l30 'Observations' obs}	,...
			'Datatype','char'		,...
			'Format','netcdf4');
ncwrite(FILENAME1,'order',order);
ncwriteatt(FILENAME1,'order','long_name','Order');
ncwriteatt(FILENAME1,'order','standard_name','order');
ncwriteatt(FILENAME1,'order','standard_name_url','http://mmisw.org/ont/cf/parameter/unknow');
ncwriteatt(FILENAME1,'order','description','The full scientific name of the order in which the taxon is classified.');
ncwriteatt(FILENAME1,'order','coverage_content_type','referenceInformation');
ncwriteatt(FILENAME1,'order','ioos_category','taxonomy');
clear order

nccreate(FILENAME1,'family'			,...
			'Dimensions',{'len35' l35 'Observations' obs}	,...
			'Datatype','char'		,...
			'Format','netcdf4');
ncwrite(FILENAME1,'family',family);
ncwriteatt(FILENAME1,'family','long_name','Family');
ncwriteatt(FILENAME1,'family','standard_name','family');
ncwriteatt(FILENAME1,'family','standard_name_url','http://mmisw.org/ont/cf/parameter/unknow');
ncwriteatt(FILENAME1,'family','description','The full scientific name of the family in which the taxon is classified.');
ncwriteatt(FILENAME1,'family','coverage_content_type','referenceInformation');
ncwriteatt(FILENAME1,'family','ioos_category','taxonomy');
clear family
disp('1530, family');

nccreate(FILENAME1,'genus'			,...
			'Dimensions',{'len20' l20 'Observations' obs}	,...
			'Datatype','char'		,...
			'Format','netcdf4');
ncwrite(FILENAME1,'genus', genus);
ncwriteatt(FILENAME1,'genus','long_name','Genus');
ncwriteatt(FILENAME1,'genus','standard_name','genus');
ncwriteatt(FILENAME1,'genus','standard_name_url','http://mmisw.org/ont/cf/parameter/unknow');
ncwriteatt(FILENAME1,'genus','description','The full scientific name of the genus in which the taxon is classified.');
ncwriteatt(FILENAME1,'genus','coverage_content_type','referenceInformation');
ncwriteatt(FILENAME1,'genus','ioos_category','taxonomy');
clear genus

nccreate(FILENAME1,'specificEpithet'			,...
			'Dimensions',{'len20' l20 'Observations' obs}	,...
			'Datatype','char'		,...
			'Format','netcdf4');
ncwrite(FILENAME1,'specificEpithet',specificEpithet);
ncwriteatt(FILENAME1,'specificEpithet','long_name','Species Name');
ncwriteatt(FILENAME1,'specificEpithet','standard_name','species_name');
ncwriteatt(FILENAME1,'specificEpithet','standard_name_url','http://mmisw.org/ont/cf/parameter/unknow');
ncwriteatt(FILENAME1,'specificEpithet','description','Species Name');
ncwriteatt(FILENAME1,'specificEpithet','description','The full scientific name of the species in which the taxon is classified.');
ncwriteatt(FILENAME1,'specificEpithet','coverage_content_type','referenceInformation');
ncwriteatt(FILENAME1,'specificEpithet','ioos_category','taxonomy');
clear specificEpithet 

nccreate(FILENAME1,'taxonRank'			,...
			'Dimensions',{'len10' l10 'Observations' obs}	,...
			'Datatype','char'		,...
			'Format','netcdf4');
ncwrite(FILENAME1,'taxonRank', taxonRank);
ncwriteatt(FILENAME1,'taxonRank','long_name','Taxon Rank,taxonomic hierarchy of the Scientific Name');
ncwriteatt(FILENAME1,'taxonRank','standard_name','taxon_rank');
ncwriteatt(FILENAME1,'taxonRank','standard_name_url','http://mmisw.org/ont/cf/parameter/unknow');
ncwriteatt(FILENAME1,'taxonRank','description','The taxonomic rank of the most specific name in the scientificName. Recommended best practice is to use a controlled vocabulary.');
ncwriteatt(FILENAME1,'taxonRank','coverage_content_type','referenceInformation');
ncwriteatt(FILENAME1,'taxonRank','coverage_content_type','referenceInformation');
ncwriteatt(FILENAME1,'taxonRank','ioos_category','taxonomy');
disp('taxonRank,1561');

nccreate(FILENAME1,'scientificNameAuthorship'            ,...
            'Dimensions',{'len35' l35 'Observations' obs}    ,...
            'Datatype','char'        ,...
            'Format','netcdf4');
ncwrite(FILENAME1,    'scientificNameAuthorship',authority);
ncwriteatt(FILENAME1,'scientificNameAuthorship','long_name','Authorship information for the scientificName');
ncwriteatt(FILENAME1,'scientificNameAuthorship','standard_name','authorship_information');
ncwriteatt(FILENAME1,'scientificNameAuthorship','standard_name_url','http://mmisw.org/ont/cf/parameter/unknow');
ncwriteatt(FILENAME1,'scientificNameAuthorship','description','The authorship information for the scientificName formatted according to the conventions of the applicable nomenclaturalCode.');
ncwriteatt(FILENAME1,'scientificNameAuthorship','coverage_content_type','referenceInformation');
ncwriteatt(FILENAME1,'scientificNameAuthorship','ioos_category','taxonomy');

nccreate(FILENAME1,'acceptedNameAuthorship'            ,...
            'Dimensions',{'len35' l35 'Observations' obs}    ,...
            'Datatype','char'        ,...
            'Format','netcdf4');
ncwrite(FILENAME1,    'acceptedNameAuthorship',acceptedauthority);
ncwriteatt(FILENAME1,'acceptedNameAuthorship','long_name','accepted Authorship information for the scientificName');
ncwriteatt(FILENAME1,'acceptedNameAuthorship','standard_name','accepted_authorship_information');
ncwriteatt(FILENAME1,'acceptedNameAuthorship','standard_name_url','http://mmisw.org/ont/cf/parameter/unknow');
ncwriteatt(FILENAME1,'acceptedNameAuthorship','description','The authorship information for the scientificName formatted according to the conventions of the applicable nomenclaturalCode.');
ncwriteatt(FILENAME1,'acceptedNameAuthorship','coverage_content_type','referenceInformation');
ncwriteatt(FILENAME1,'acceptedNameAuthorship','ioos_category','taxonomy');

nccreate(FILENAME1,'taxonomicStatus'			,...
			'Dimensions',{'len10' l10 'Observations' obs}	,...
			'Datatype','char'		,...
			'Format','netcdf4');
ncwrite(FILENAME1,'taxonomicStatus', taxonomicStatus);
ncwriteatt(FILENAME1,'taxonomicStatus','long_name','Taxonomic Status: Accepted; Unaccepted');
ncwriteatt(FILENAME1,'taxonomicStatus','standard_name','taxonomic_status');
ncwriteatt(FILENAME1,'taxonomicStatus','standard_name_url','http://mmisw.org/ont/cf/parameter/unknow');
ncwriteatt(FILENAME1,'taxonomicStatus','description','The status of the use of the scientificName as a label for a taxon..');
ncwriteatt(FILENAME1,'taxonomicStatus','coverage_content_type','referenceInformation');
ncwriteatt(FILENAME1,'taxonomicStatus','ioos_category','taxonomy');
clear taxonomicStatus

nccreate(FILENAME1,'associatedReferences',...
			'Dimensions',{'len260' l260 'Observations' obs}	,...
            'Datatype','char'		,...
			'Format','netcdf4');
ncwrite(FILENAME1,'associatedReferences', arefe_0);
ncwriteatt(FILENAME1,'associatedReferences','long_name','associatedReferences');
ncwriteatt(FILENAME1,'associatedReferences','standard_name','associatedReferences');
ncwriteatt(FILENAME1,'associatedReferences','standard_name_url','http://mmisw.org/ont/cf/parameter/unknow');
ncwriteatt(FILENAME1,'associatedReferences','description','A list (concatenated and separated) of identifiers (publication, bibliographic reference, global unique identifier, URI) of literature associated with the Occurrence.');
ncwriteatt(FILENAME1,'associatedReferences','coverage_content_type','referenceInformation');
ncwriteatt(FILENAME1,'associatedReferences','ioos_category','other');

lopm = 0.0; sma = 6378137.0; infl = 298.257223563;
nccreate(FILENAME1,   'crs'	,...
         'Datatype','int32'		,...
         'Format', 'netcdf4','FillValue',fillvalue2);
ncwriteatt(FILENAME1,'crs', 'grid_mapping_name', 'latitude_longitude');
ncwriteatt(FILENAME1,'crs', 'longitude_of_prime_meridian', lopm) ;
ncwriteatt(FILENAME1,'crs', 'semi_major_axis', sma) ;
ncwriteatt(FILENAME1,'crs', 'inverse_flattening', infl);
ncwriteatt(FILENAME1,'crs', 'epsg_code' , 'EPSG:4326') ;
%ncwriteatt(FILENAME1,'crs', 'standard_name_url','http://mmisw.org/ont/cf/parameter/unknown');
%ncwriteatt(FILENAME1,'crs', 'missing_value',fillvalue2);
%ncwriteatt(FILENAME1,'crs', 'units','unknown');

% Global Variables
ncwriteatt(FILENAME1,'/','ncei_template_version','NCEI_NetCDF_Point_Template_v2.0');
ncwriteatt(FILENAME1,'/','featureType','Point');
ncwriteatt(FILENAME1,'/','cdm_data_type','Point'    );
ncwriteatt(FILENAME1,'/','Conventions','CF-1.6, ACDD-1.3, IOOS-1.2');
ncwriteatt(FILENAME1,'/','processing_level','Geophysical units from raw data');
ncwriteatt(FILENAME1,'/','license', license1);
ncwriteatt(FILENAME1,'/','keywords_vocabulary', keywords_vocab);
ncwriteatt(FILENAME1,'/','keywords', keywords);
ncwriteatt(FILENAME1,'/','standard_name_vocabulary','CF Standard Name Table v72');
ncwriteatt(FILENAME1,'/','title', title);
ncwriteatt(FILENAME1,'/','summary', summa);
ncwriteatt(FILENAME1,'/','sea_name', sea_name);
ncwriteatt(FILENAME1,'/','id', id_ori);
ncwriteatt(FILENAME1,'/','source', samplingProtocol(1,:));
ncwriteatt(FILENAME1,'/','instrument', instrument);
ncwriteatt(FILENAME1,'/','instrument_vocabulary',instrument_vocab);
ncwriteatt(FILENAME1,'/','platform', platform);
ncwriteatt(FILENAME1,'/','platform_name', platform_name);
ncwriteatt(FILENAME1,'/','platform_id', platform_id);
ncwriteatt(FILENAME1,'/','platform_vocabulary',platform_vocab);
ncwriteatt(FILENAME1,'/','time_coverage_start', timst);
ncwriteatt(FILENAME1,'/','time_coverage_end', timend);
ncwriteatt(FILENAME1,'/','time_coverage_duration',time_coverage_duration);
ncwriteatt(FILENAME1,'/','time_coverage_resolution', time_coverage_resolution);
ncwriteatt(FILENAME1,'/','geospatial_lat_min', latmin);
ncwriteatt(FILENAME1,'/','geospatial_lat_max', latmax);
ncwriteatt(FILENAME1,'/','geospatial_lat_units','degree_north');
ncwriteatt(FILENAME1,'/','geospatial_lat_resolution',nanmean(latmax - latmin));
ncwriteatt(FILENAME1,'/','geospatial_lon_min', lonmin);
ncwriteatt(FILENAME1,'/','geospatial_lon_max', lonmax);
ncwriteatt(FILENAME1,'/','geospatial_lon_units','degree_east');
ncwriteatt(FILENAME1,'/','geospatial_lon_resolution',nanmean(lonmax - lonmin));
ncwriteatt(FILENAME1,'/','geospatial_vertical_min', min(depmin));
ncwriteatt(FILENAME1,'/','geospatial_vertical_max', max(depmax));
ncwriteatt(FILENAME1,'/','geospatial_vertical_units','m');
ncwriteatt(FILENAME1,'/','geospatial_vertical_resolution', nanmean(max(depmax)-min(depmin)));
ncwriteatt(FILENAME1,'/','geospatial_vertical_positive','down');
ncwriteatt(FILENAME1,'/','geospatial_bounds',geospatial_bounds);
ncwriteatt(FILENAME1,'/','geospatial_bounds_crs','EPSG:4326');
ncwriteatt(FILENAME1,'/','geospatial_bounds_vertical_crs','EPSG:5831') ;
ncwriteatt(FILENAME1,'/','Country',country);
ncwriteatt(FILENAME1,'/','institution', institution);
ncwriteatt(FILENAME1,'/','program', program_name);
ncwriteatt(FILENAME1,'/','project', project_name);
ncwriteatt(FILENAME1,'/','naming_authority',naming_authority)
%ncwriteatt(FILENAME1,'/','references',references);
ncwriteatt(FILENAME1,'/','references',associatedReferences);
ncwriteatt(FILENAME1,'/','references2',bibliographicCitation);
ncwriteatt(FILENAME1,'/','acknowledgment',acknowledgment)
ncwriteatt(FILENAME1,'/','date_created',date_created);
ncwriteatt(FILENAME1,'/','date_issued',date_issued)
ncwriteatt(FILENAME1,'/','date_modified', date_modified);
ncwriteatt(FILENAME1,'/','date_metadata_modified',date_metadata_modified);
ncwriteatt(FILENAME1,'/','creator_name', creator_name);
ncwriteatt(FILENAME1,'/','creator_email', creator_email);
ncwriteatt(FILENAME1,'/','creator_url', creator_url);
ncwriteatt(FILENAME1,'/','creator_phone', creator_phone);
ncwriteatt(FILENAME1,'/','creator_sector',creator_sector);
ncwriteatt(FILENAME1,'/','creator_address',creator_address);
ncwriteatt(FILENAME1,'/','creator_city',creator_city);
ncwriteatt(FILENAME1,'/','creator_state',creator_state);
ncwriteatt(FILENAME1,'/','creator_postalcode', creator_postalcode);
ncwriteatt(FILENAME1,'/','creator_country',creator_country);
ncwriteatt(FILENAME1,'/','creator_institution', creator_inst);
ncwriteatt(FILENAME1,'/','creator_type', creator_type);
ncwriteatt(FILENAME1,'/','contributor_name', contrib_name);
ncwriteatt(FILENAME1,'/','contributor_role', contrib_role);
ncwriteatt(FILENAME1,'/','contributor_email', contrib_email);
ncwriteatt(FILENAME1,'/','contributor_url', contrib_url);
ncwriteatt(FILENAME1,'/','contributor_phone', contrib_phone);
ncwriteatt(FILENAME1,'/','contributor_role_vocabulary',contrib_role_vocab);
ncwriteatt(FILENAME1,'/','contributor_institution',contrib_inst);
ncwriteatt(FILENAME1,'/','contributor_country',contrib_country);
ncwriteatt(FILENAME1,'/','contributor_type',contrib_type);
ncwriteatt(FILENAME1,'/','publisher_name', publisher_name);
ncwriteatt(FILENAME1,'/','publisher_role',publisher_role);
ncwriteatt(FILENAME1,'/','publisher_email', publisher_email);
ncwriteatt(FILENAME1,'/','publisher_url', publisher_url);
ncwriteatt(FILENAME1,'/','publisher_phone', publisher_phone);
ncwriteatt(FILENAME1,'/','publisher_address',publisher_address);
ncwriteatt(FILENAME1,'/','publisher_city',publisher_city);
ncwriteatt(FILENAME1,'/','publisher_state',publisher_state);
ncwriteatt(FILENAME1,'/','publisher_postalcode',publisher_postalcode);
ncwriteatt(FILENAME1,'/','publisher_country',publisher_country);
ncwriteatt(FILENAME1,'/','publisher_institution', publisher_inst);
ncwriteatt(FILENAME1,'/','publisher_type', publisher_type);
ncwriteatt(FILENAME1,'/','processor_name', processor_name);
ncwriteatt(FILENAME1,'/','processor_role', processor_role);
ncwriteatt(FILENAME1,'/','processor_email', processor_email);
ncwriteatt(FILENAME1,'/','processor_url', processor_url);
ncwriteatt(FILENAME1,'/','processor_phone', processor_phone);
ncwriteatt(FILENAME1,'/','processor_address',processor_address);
ncwriteatt(FILENAME1,'/','processor_city',processor_city);
ncwriteatt(FILENAME1,'/','processor_state',processor_state);
ncwriteatt(FILENAME1,'/','processor_postalcode', processor_postalcode);
ncwriteatt(FILENAME1,'/','processor_country', processor_country);
ncwriteatt(FILENAME1,'/','processor_institution', processor_inst);
ncwriteatt(FILENAME1,'/','processor_type', processor_type);
ncwriteatt(FILENAME1,'/','metadata_link', meta_link);
ncwriteatt(FILENAME1,'/','infoUrl', infoUrl);
ncwriteatt(FILENAME1,'/','history',history);
ncwriteatt(FILENAME1,'/','product_version',product_version);
ncwriteatt(FILENAME1,'/','comment0', commentToStations1);

W =  ['end of file: ', filid]; disp (W);

clear l00 l00a l01a l01a1 l02 l02a l03 la0 timst timend jahr mon tag 
clear xmis1_0 xmis2_0 rel_back_0 zlen zli mamon mimon matag mitag
clear l01 l02 l03 l04 l05 l08 l10 l14 l15 l18 l20 l25 l30 l35 l40 l45 l50 
clear l55 l60 l65 l70 l80 l90 l100 l260 l316 lcom1 lcom2 lbin lre fi gi 
clear in1 uni unista dep_01 depmin depmax data asso_ref ref_0 la lbi li al
clear siten sitec zle tim_01 first_year first_year2 last_year last_year2
clear stati reg reg2 reg3 msid1 habi arc ina inb ind msid tsn 
clear species lati latin la1 artc artn arc an anr lui lu filnr samts samplepoints
clear filein filid FILENAME FILENAME1 FILENAME2 FILENAME3 depmi depma
clear jahr1 subregion_id1 habitat_id1 sitec site_cd1 site_id1 siten site_name1
clear station_nr1 avgOfPoints1 ave_poin lat1 lon1 sta_nr
clear mod_site mote ms1 ms2 msi statia dataId1 parentEventId1 eventId1 eventDate1
clear dataID parentEventID eventID eventDate zlen zlen1 zlen2 zlen3 zlen4 zlenx
clear jahr stati ina latitude longitude station_nr habitatID siteCode sitecod siteID siteid
clear siteName sitenam first_year first_y last_year last_y waterDepth water_dep     
clear depmin1 depmi1 depmax1 depma1 avgOfPoints transectLengthInMeters tranlsect_len eventDate 
clear dataID arc latin ind  scientificName vernacularName family order class phylum kingdom taxonomicStatus
clear acceptedName acceptedauthority acceptedNameUsageID acceptedNameUsage
clear genus species taxonRank specificEpithet aphiaID acceptedID scientificNameID
clear authority organismQuantity common depmean nusec nusec1 jahr2 refe_0 regi  
clear occurrenceID occurenceStatus habi k1 habitat re01 subRegionID subreg_id re1 reg2 locality bottomType   
clear samplingProtocol samplingEffort biblio_cita ref_0 reg3 region language type license ownerInstitutionCode
clear data_name geodeticDatum basisOfRecord StateProvince waterBody country1 recordedBy
clear minimumDepthInMeters maximumDepthInMeters organismQuantityType stateProvince
clear subSampleId aref_0 arefe_0 hab_id bibl_cita bot_type hab local occurrenceStatus
clear samp_eff samp_prot type1 dataset_name
end
clear region1 site_code site_id site_name habitat_id subregion_code station_id first_year1
clear last_year1 transect_length depth latitude1 longitude1 obs lonmax lonmin latmax latmin
clear sub_inst cruise station creator cr_email project_name title summa
clear country meta_link sea_name value id_ori gri_udi mona monu contrib_n avgOfPoints 
clear class1 com_fam commonname kingdom1 latinname genus1 species1 family1 order1 
clear phylum1 aphiaID1 tsn1 authoritya authorityb authority1 stratname sub_region_code 
clear biblio_cita site_name1 acceptedId1 acceptedName1 taxonomicStatus1
clear subregion_id1 subregion_nr1 station_id site_length latitude longitude
clear first_year1 last_year1 references associatedReferences bibliographicCitation
clear fid fid0 fid01 file1 file2 file_id filedir filedir2 fillvalue source 
clear site_nr site_cd1 ref_time reference license1 type1
clear pri_sam_unit station_nr lat_0 lon_0 dep_0 under_visibility mpp_gris_nr
clear habitat_cd zone_nr sub_reg_nr mpa_nr species_nr species_cd specificEpithet leng
clear HabClass HabClassName Region SUBREGION_NAME SUBREGION_NR TIME_SEEN types obs
clear creator_email creator_inst creator_name creator_phone creator_type
clear creator_url contributor_email contributor_inst contributor_name
clear contributor_phone contributor_role contributor_type contributor_url
clear processor_email processor_inst processor_name processor_phone processor_role
clear processor_type processor_url profile_name publisher_email publisher_inst publisher_name
clear publisher_phone publisher_role publisher_type publisher_url institution keywords
clear anf_datum associatedReferences bibliographicCitation TimeZone samplingProtocol1
clear commentToStations1 samplingeffort1 dina dinu ab cd fa fe fid02 fili i ia ii k0 le 

disp '*******  end of write_fl_cremp_coral_csv.m program  *******'
