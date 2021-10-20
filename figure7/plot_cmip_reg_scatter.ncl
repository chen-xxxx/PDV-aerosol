load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/time_axis_labels.ncl"
begin
diri = "/glade/work/chenxing/enso/"
dirip = "/glade/u/home/chenxing/enso/"

  yrs = 1861;1950;
  yrl = 2004
  ymstrt= yrs*100+1
  ymlast= yrl*100+12

  yrs5 = 1861;1920;
  yrl5 = 2004
  yrs6 = 1850;1920;
  yrl6 = 2014


diri1 = "/glade/collections/cmip/cmip5/"
diri2 = "/glade/work/chenxing/CMIP5/historical/remap/tos/"
;from cdo_cmip_data.ncl
diri3 = "/glade/scratch/chenxing/cmip5/"
SEASON = (/"DJF","MAM","JJA","SON" /)

wks         = gsn_open_wks("png",dirip+"plot_cmip_reg_scatter")
plot = new(12, graphic)
; text1 = new(12, graphic)
; text2 = new(12, graphic)
; text3 = new(12, graphic)


; ; ;CMIP5 MODELS
; MODEL5 = (/"ACCESS1-0","ACCESS1-3","bcc-csm1-1","BNU-ESM","CanESM2","CCSM4","CESM1-BGC",\;"bcc-csm1-1-m",
;       "CESM1-CAM5","CESM1-FASTCHEM","CESM1-WACCM","CMCC-CESM","CMCC-CM","CMCC-CMS",\
;       "CNRM-CM5","CSIRO-Mk3-6-0","FGOALS-g2","FGOALS-s2","FIO-ESM","GFDL-CM2p1",\;"CNRM-CM5-2""GFDL-CM3",
;       "GFDL-ESM2G","GISS-E2-H-CC","HadCM3","HadGEM2-AO",\;"GFDL-ESM2M","GISS-E2-H","GISS-E2-R-CC","GISS-E2-R",
;       "HadGEM2-CC","HadGEM2-ES","inmcm4","IPSL-CM5A-LR","IPSL-CM5A-MR","IPSL-CM5B-LR","MIROC5",\
;       "MIROC-ESM-CHEM","MIROC-ESM","MPI-ESM-LR","MPI-ESM-MR","MPI-ESM-P","MRI-CGCM3",\;"MRI-ESM1",
;       "NorESM1-ME","NorESM1-M"/)
;
; ; M5_YES = (/"ACCESS1-0","ACCESS1-3","CanESM2","CESM1-CAM5","CNRM-CM5","CSIRO-Mk3-6-0","HadGEM2-CC",\;,"GFDL-CM3"
; ;           "HadGEM2-ES","IPSL-CM5A-LR","IPSL-CM5A-MR","MIROC5","MIROC-ESM-CHEM","MIROC-ESM",\
; ;           "MRI-CGCM3","NorESM1-M"/) ;explicitly have aerosol interaction included in CMIP5
;
; ; M5_NO = (/"bcc-csm1-1","BNU-ESM","CCSM4","CESM1-BGC","CESM1-FASTCHEM","CESM1-WACCM",\
; ;           "GFDL-ESM2G","MPI-ESM-LR"  /) ;explicitly no aerosol interaction included in CMIP5 "GFDL-ESM2M",
;
; MODEL5_LE = (/"CNRM-CM5", "CSIRO-Mk3-6-0", "GFDL-CM2p1","HadCM3", "CCSM4", \;"GISS-E2-H","GISS-E2-R",
;              "IPSL-CM5A-LR", "CanESM2", "MIROC5","CESM1-CAM5","HadGEM2-ES",\
;              "ACCESS1-0","ACCESS1-3","bcc-csm1-1","CESM1-FASTCHEM","FGOALS-g2",\
;              "FGOALS-s2","FIO-ESM","IPSL-CM5A-MR","MIROC-ESM","MPI-ESM-LR","MPI-ESM-MR","MRI-CGCM3","NorESM1-M"/);"GFDL-CM3",
; nens5 = (/10,10,10,8,6,6,6,\
;          6,5,5,4,4,\
;          3,3,3,3,3,3,3,\
;          3,3,3,3,3,3 /);5,
;
; M5_YES = (/"ACCESS1-0","ACCESS1-3","CanESM2","CESM1-CAM5","CNRM-CM5","CSIRO-Mk3-6-0",\;,"GFDL-CM3"
;           "HadGEM2-ES","IPSL-CM5A-LR","IPSL-CM5A-MR","MIROC5","MIROC-ESM",\
;           "MRI-CGCM3","NorESM1-M"/) ;explicitly have aerosol interaction included in CMIP5
;
; M5_NO = (/"bcc-csm1-1","CCSM4","CESM1-FASTCHEM","FGOALS-s2","FIO-ESM","GFDL-CM2p1","HadCM3",\;
;           "MPI-ESM-LR","MPI-ESM-MR"  /) ;explicitly no aerosol interaction included in CMIP5 "GFDL-ESM2M",
;
; ; MODEL5_ESM = (/"CanESM2","CESM1-CAM5","CESM1-FASTCHEM",\
; ;       "FIO-ESM","MIROC-ESM","MPI-ESM-LR","MPI-ESM-MR","NorESM1-M"/)
; ;
; ; MODEL5_CM = (/"ACCESS1-0","ACCESS1-3","bcc-csm1-1","CCSM4",\
; ;              "CNRM-CM5","CSIRO-Mk3-6-0","FGOALS-g2","FGOALS-s2","GFDL-CM2p1",\
; ;              "HadCM3","HadGEM2-ES","IPSL-CM5A-LR","IPSL-CM5A-MR","MIROC5", "MRI-CGCM3"/)
;
; ;; CMIP6 MODELS
; MODEL6 = (/"BCC-CSM2-MR","CAMS-CSM1-0","CanESM5","CESM2-FV2",\ ;"ACCESS-CM2","ACCESS-ESM1-5","BCC-ESM1",
;         "CESM2","CESM2-WACCM-FV2",\
;         "CESM2-WACCM","E3SM-1-0","FIO-ESM-2-0","GFDL-CM4",\;"E3SM-1-1","FGOALS-f3-L","FGOALS-g3","GFDL-ESM4",
;         "GISS-E2-1-G","INM-CM5-0","IPSL-CM6A-LR","MCM-UA-1-0","MIROC6",\;"GISS-E2-1-G-CC","GISS-E2-1-H",
;         "MPI-ESM1-2-HR","MPI-ESM1-2-LR","MRI-ESM2-0","NorCPM1","NorESM2-LM","SAM0-UNICON"/);"MPI-ESM-1-2-HAM","NESM3",
; ; MODEL6_ESM = (/"CanESM5","CESM2-FV2","CESM2","CESM2-WACCM-FV2",\
; ;         "CESM2-WACCM","E3SM-1-0","FIO-ESM-2-0",\
; ;         "MPI-ESM1-2-HR","MPI-ESM1-2-LR","MRI-ESM2-0","NorESM2-LM"/)
;
; ; MODEL6_CM = (/"BCC-CSM2-MR","CAMS-CSM1-0","GFDL-CM4","GISS-E2-1-G",\
; ;        "INM-CM5-0","IPSL-CM6A-LR","MCM-UA-1-0","MIROC6","NorCPM1","SAM0-UNICON" /)
; ; MODEL6 = (/"IPSL-CM6A-LR","NorCPM1", "CanESM5", "GISS-E2-1-G","CESM2","INM-CM5-0",\;"GISS-E2-1-H",
; ;   "MIROC6","MPI-ESM1-2-LR","MPI-ESM1-2-HR","MRI-ESM2-0","E3SM-1-0" /) ;large ensemble model in CMIP6 "NESM3",
;
;
; MODEL6_LE = (/"IPSL-CM6A-LR","NorCPM1", "CanESM5", "GISS-E2-1-G","CESM2","INM-CM5-0",\;"GISS-E2-1-H",
;   "MIROC6","MPI-ESM1-2-LR","MPI-ESM1-2-HR","MRI-ESM2-0","E3SM-1-0",\
;   "BCC-CSM2-MR","CESM2-FV2","CESM2-WACCM-FV2","CESM2-WACCM","FIO-ESM-2-0","NorESM2-LM" /) ;large ensemble model in CMIP6 "NESM3",
;
; nens6 = (/32,30,25,12,11, 10, 10,\;10,
;           10,7,5,5,\
;           3, 3,3,3,3,3/) ;ensemble number 5,
;
;
;
; MODEL6_ESM = (/"CanESM5","CESM2","E3SM-1-0",\
;         "MPI-ESM1-2-HR","MPI-ESM1-2-LR","MRI-ESM2-0"/)
;
; MODEL6_CM = (/"GISS-E2-1-G","INM-CM5-0","IPSL-CM6A-LR","MIROC6","NorCPM1" /)

; ;CMIP5 MODELS
MODEL5 = (/"ACCESS1-0","ACCESS1-3","bcc-csm1-1-m","bcc-csm1-1","BNU-ESM","CanESM2","CCSM4","CESM1-BGC",\;
      "CESM1-CAM5","CESM1-FASTCHEM","CESM1-WACCM","CMCC-CESM","CMCC-CM","CMCC-CMS",\
      "CNRM-CM5","CNRM-CM5-2","CSIRO-Mk3-6-0","FGOALS-g2","FGOALS-s2","FIO-ESM","GFDL-CM2p1","GFDL-CM3",\;
      "GFDL-ESM2G","GFDL-ESM2M","GISS-E2-H-CC","GISS-E2-H","GISS-E2-R-CC","GISS-E2-R","HadCM3","HadGEM2-AO",\;
      "HadGEM2-CC","HadGEM2-ES","inmcm4","IPSL-CM5A-LR","IPSL-CM5A-MR","IPSL-CM5B-LR","MIROC5",\
      "MIROC-ESM-CHEM","MIROC-ESM","MPI-ESM-LR","MPI-ESM-MR","MPI-ESM-P","MRI-CGCM3","MRI-ESM1",\;
      "NorESM1-ME","NorESM1-M"/)

MODEL5_LE = (/"CNRM-CM5", "CSIRO-Mk3-6-0", "GFDL-CM2p1","HadCM3", "CCSM4","GISS-E2-H","GISS-E2-R", \;
             "IPSL-CM5A-LR", "CanESM2", "GFDL-CM3","MIROC5","CESM1-CAM5","HadGEM2-ES",\
             "ACCESS1-0","ACCESS1-3","bcc-csm1-1-m","bcc-csm1-1","CESM1-FASTCHEM","FGOALS-g2",\
             "FGOALS-s2","FIO-ESM","IPSL-CM5A-MR","MIROC-ESM","MPI-ESM-LR","MPI-ESM-MR","MRI-CGCM3","NorESM1-M"/);
nens5 = (/10,10,10,8,6,6,6,6,6,\
         6,5,5,5,4,4,\
         3,3,3,3,3,3,3,3,\
         3,3,3,3,3,3 /);5,

M5_YES = (/"ACCESS1-0","ACCESS1-3","CanESM2","CESM1-CAM5","CESM1-FASTCHEM","CNRM-CM5","CSIRO-Mk3-6-0","FGOALS-g2","GFDL-CM3",\;
          "GISS-E2-H","GISS-E2-R","HadGEM2-ES","IPSL-CM5A-LR","IPSL-CM5A-MR","MIROC5","MIROC-ESM",\
          "MRI-CGCM3","NorESM1-M"/) ;explicitly have aerosol interaction included in CMIP5

M5_NO = (/"bcc-csm1-1","CCSM4","CESM1-FASTCHEM","FGOALS-s2","FIO-ESM","GFDL-CM2p1","HadCM3",\;
          "MPI-ESM-LR","MPI-ESM-MR"  /) ;explicitly no aerosol interaction included in CMIP5 "GFDL-ESM2M",

;; CMIP6 MODELS
MODEL6 = (/"BCC-CSM2-MR","BCC-ESM1","CAMS-CSM1-0","CanESM5","CESM2-FV2",\ ;"ACCESS-CM2","ACCESS-ESM1-5",
        "CESM2","CESM2-WACCM-FV2",\
        "CESM2-WACCM","E3SM-1-0","FGOALS-g3","FIO-ESM-2-0","GFDL-CM4","GFDL-ESM4",\;"E3SM-1-1","FGOALS-f3-L",
        "GISS-E2-1-G","GISS-E2-1-H","INM-CM5-0","IPSL-CM6A-LR","MCM-UA-1-0","MIROC6",\;"GISS-E2-1-G-CC",
        "MPI-ESM1-2-HR","MPI-ESM1-2-LR","MRI-ESM2-0","NESM3","NorCPM1","NorESM2-LM","SAM0-UNICON"/);"MPI-ESM-1-2-HAM",

MODEL6_LE = (/"IPSL-CM6A-LR","NorCPM1", "CanESM5", "GISS-E2-1-G","CESM2","INM-CM5-0","GISS-E2-1-H",\;
  "MIROC6","MPI-ESM1-2-LR","MPI-ESM1-2-HR","MRI-ESM2-0","E3SM-1-0","NESM3",\
  "BCC-CSM2-MR","BCC-ESM1","CESM2-FV2","CESM2-WACCM-FV2","CESM2-WACCM","FGOALS-g3","FIO-ESM-2-0","NorESM2-LM" /) ;large ensemble model in CMIP6

nens6 = (/32,30,25,12,11, 10, 10,10,\;
          10,7,5,5,5,\
          3,3, 3,3,3,3,3,3/) ;ensemble number 5,

nm5 = dimsizes(MODEL5)
nm6 = dimsizes(MODEL6)

i5y = new(dimsizes(M5_YES), "integer")
do i = 0,dimsizes(M5_YES)-1
  i5y(i) = ind(MODEL5_LE.eq.M5_YES(i))
end do
i5n = new(dimsizes(M5_NO), "integer")
do i = 0,dimsizes(M5_NO)-1
  i5n(i) = ind(MODEL5_LE.eq.M5_NO(i))
end do
print("say yes "+i5y)
print("say no "+i5n)
i5le = new(dimsizes(MODEL5_LE), "integer")
do i = 0,dimsizes(MODEL5_LE)-1
  i5le(i) = ind(MODEL5.eq.MODEL5_LE(i))
end do
i6le = new(dimsizes(MODEL6_LE), "integer")
do i = 0,dimsizes(MODEL6_LE)-1
  i6le(i) = ind(MODEL6.eq.MODEL6_LE(i))
end do



; VAR = "ua" ;"psl" ;
EXP = "historical"
IND = "mmemmeeof2" ;"SLPAL" ;"pdv";"TNA"; "AR1Di" ;"AR1varm"; "TNA";

VAR15 = "tas"
VAR1 = "ts"
VAR2 = "clt"
;---------read output---------------
; from reg_cmip5.ncl reg_cmip6.ncl
;cmip5_reg_SLPAL_historical_tas_1861-2004.nc
f1   = addfile(diri+"cmip5_reg_"+IND+"_historical_"+VAR15+"_"+yrs5+"-"+yrl5+".nc", "r")
t5  = f1->ccr1
f1   = addfile(diri+"cmip5_reg_"+IND+"_historical_"+VAR2+"_"+yrs5+"-"+yrl5+".nc", "r")
u5  = f1->ccr1

f2   = addfile(diri+"cmip6_reg_"+IND+"_historical_"+VAR1+"_"+yrs6+"-"+yrl6+".nc", "r")
t6  = f2->ccr1
f2   = addfile(diri+"cmip6_reg_"+IND+"_historical_"+VAR2+"_"+yrs6+"-"+yrl6+".nc", "r")
u6  = f2->ccr1

; printVarSummary(t5)
; printVarSummary(t6)
; printVarSummary(u5)
; printVarSummary(u6)

;---------radiation---------------
; from reg_cmip5_rs.ncl reg_cmip6_rs.ncl
; f1   = addfile(diri+"cmip5_reg_"+IND+"_"+EXP+"_rsds-rsus_"+yrs5+"-"+yrl5+".nc", "r")
f1   = addfile(diri+"cmip5_reg_"+IND+"_"+EXP+"_netsw_"+yrs5+"-"+yrl5+".nc", "r")
r5  = f1->ccr1

; f2   = addfile(diri+"cmip6_reg_"+IND+"_"+EXP+"_rsds-rsus_"+yrs6+"-"+yrl6+".nc", "r")
f2   = addfile(diri+"cmip6_reg_"+IND+"_"+EXP+"_netsw_"+yrs6+"-"+yrl6+".nc", "r")
r6  = f2->ccr1

; f1   = addfile(diri+"cmip5_reg_"+IND+"_"+EXP+"_rsdscs-rsuscs_"+yrs5+"-"+yrl5+".nc", "r")
f1   = addfile(diri+"cmip5_reg_"+IND+"_"+EXP+"_netcssw_"+yrs5+"-"+yrl5+".nc", "r")
c5  = f1->ccr1

; f2   = addfile(diri+"cmip6_reg_"+IND+"_"+EXP+"_rsdscs-rsuscs_"+yrs6+"-"+yrl6+".nc", "r")
f2   = addfile(diri+"cmip6_reg_"+IND+"_"+EXP+"_netcssw_"+yrs6+"-"+yrl6+".nc", "r")
c6  = f2->ccr1

; from reg_cmip5.ncl reg_cmip6.ncl
f1   = addfile(diri+"cmip5_reg_"+IND+"_"+EXP+"_cloudeffect_"+yrs5+"-"+yrl5+".nc", "r")
d5  = f1->ccr1

f2   = addfile(diri+"cmip6_reg_"+IND+"_"+EXP+"_cloudeffect_"+yrs6+"-"+yrl6+".nc", "r")
d6  = f2->ccr1

; printVarSummary(r5)
; printVarSummary(r6)
; printVarSummary(c5)
; printVarSummary(c6)


; ;cloud effect: all - clearsky
; d5 = r5
; d6 = r6
; d5 = r5 - c5
; d6 = r6 - c6

Yn5 = [/d5,u5/] ;c5 ;u5;
Yn6 = [/d6,u6/] ;c6 ;u6;
VYn  = (/"cloud effect","cloud cover" /);"clear sky rs";"cloud cover" ;
BYmin = (/-2.8,-0.2/)
BYmax = (/0.8,0.6/)

do i = 0,1
XX5 = t5
XX6 = t6
YY5 = Yn5[i];u5 ;d5 ;c5 ;u5;
YY6 = Yn6[i];u6 ;d6 ;c6 ;u6;
VX  = "TS"
VY  = VYn(i) ;"cloud effect";"clear sky rs";"cloud cover" ;
; printVarSummary(YY5)
;---------------area average--------------------
; Pacific dipole (tripole) SST index2 (adapted from Dong et al. 2014 GRL):
;a 30-45N, 145E-180W b 10S-6N,160W-110W. b-a

lat = t5&lat
rad    = 4.0*atan(1.0)/180.0
clat   = cos(lat*rad)
copy_VarCoords(t5(0,:,0), clat)

NLAT1 =   45.
SLAT1 =   30.
WLON1 =  145.
ELON1 =  180.

NLAT2 =  6.
SLAT2 =  -10.
WLON2 =  360.-160.;
ELON2 =  360.-110.;
; print(i5le)

g1 = wgt_areaave_Wrap(XX5(i5le,{SLAT1:NLAT1},{WLON1:ELON1}),clat({SLAT1:NLAT1}), 1.0, 1)
g2 = wgt_areaave_Wrap(XX5(i5le,{SLAT2:NLAT2},{WLON2:ELON2}),clat({SLAT2:NLAT2}), 1.0, 1)
x5 = g1
; x5 = g2 - g1
g1 = wgt_areaave_Wrap(YY5(i5le,{SLAT1:NLAT1},{WLON1:ELON1}),clat({SLAT1:NLAT1}), 1.0, 1)
g2 = wgt_areaave_Wrap(YY5(i5le,{SLAT2:NLAT2},{WLON2:ELON2}),clat({SLAT2:NLAT2}), 1.0, 1)
y5 = g1
; y5 = g2 - g1

z1 = wgt_areaave_Wrap(XX6(i6le,{SLAT1:NLAT1},{WLON1:ELON1}),clat({SLAT1:NLAT1}), 1.0, 1)
z2 = wgt_areaave_Wrap(XX6(i6le,{SLAT2:NLAT2},{WLON2:ELON2}),clat({SLAT2:NLAT2}), 1.0, 1)
x6 = z1
; x6 = z2 - z1
z1 = wgt_areaave_Wrap(YY6(i6le,{SLAT1:NLAT1},{WLON1:ELON1}),clat({SLAT1:NLAT1}), 1.0, 1)
z2 = wgt_areaave_Wrap(YY6(i6le,{SLAT2:NLAT2},{WLON2:ELON2}),clat({SLAT2:NLAT2}), 1.0, 1)
y6 = z1
; y6 = z2 - z1

printVarSummary(x5)
printVarSummary(y6)
print(y6)
print(y5)

; ;------------read global external forcing mode-----------
; ; from mme_eof_cmip6.ncl
;
;   f1   = addfile(diri+"cmip5/cmip5_historical_mme.eof_1861-2004.nc", "r")
;   meof5_mo  = f1->pc(0,:)
;   f1   = addfile(diri+"cmip6/cmip6_historical_mme.eof_1850-2014.nc", "r")
;   meof6_mo  = f1->pc(0,:)
;
; printVarSummary(meof5_mo)
;
; meof5 = month_to_annual(meof5_mo, 1)
; meof6 = month_to_annual(meof6_mo, 1)
; printVarSummary(meof5)
; printVarSummary(meof6)


;=========plot=========================

res = True
res@gsnFrame = False
res@gsnDraw  = False

res@xyMarkLineMode     = "Markers"  ; choose which have markers
; res@xyDashPatterns      = 1                      ; solid line
  res@xyMarker         =  1                      ; choose type of marker
  res@xyMarkerSizeF     = 0.01                     ; Marker size (default 0.01)
;   res@xyLineThicknesses   = (/1,2/)                ; set second line to 2

res@xyMarkerOpacityF = 1.0
  res@tmYROn                 = False    ; right off
;res@vpWidthF    = 0.5        ; Make plots wider
;res@vpHeightF   = 0.5
res@tmXTOn              = False   ; Turn off top tickmarks
res@tmYLMinorOn         = False   ; Turn off left minor tickmarks
res@tmXMajorGrid                = True
res@tmYMajorGrid                = True
res@tmXMajorGridThicknessF      = 1.0
res@tmYMajorGridThicknessF      = 1.0
res@tmXMajorGridLineDashPattern = 2
res@tmYMajorGridLineDashPattern = 2

res@gsnRightString = ""
res@gsnLeftString = ""
res@gsnLeftStringFontHeightF = 0.03
res@gsnRightStringFontHeightF = 0.03

res@xyMonoMarkerColor  = False ;True ;          ; Allow different colors for markers
 ; res@xyMonoDashPattern        = True              ; all solid



;colors = read_colormap_file("default") ;("BkBlAqGrYeOrReViWh200");("default");("cosam");"GMT_paired"
  res@xyMarkLineMode     = "Markers"  ; choose which have markers
  ; res@xyMarker         =  9

  ; res@xyMarkerColors             = colors;ispan(1, nm+7, 1)

  res@gsnYRefLine = 0;avg(index_pro)
  res@gsnYRefLineThicknessF = 2.
  res@gsnYRefLineDashPattern = 1
  res@gsnXRefLine = 0;avg(index_vwso)
  res@gsnXRefLineThicknessF = 2.
  res@gsnXRefLineDashPattern = 1
  res@tiMainString             = ""


res@trXMinF             = -0.5
res@trXMaxF             =  0.5
res@trYMinF             = BYmin(i);-2.8 ;-0.2 ;-0.5 ;
res@trYMaxF             = BYmax(i) ;0.8 ; 0.6 ;  0.2 ;

res@tiXAxisString = VX
res@tiYAxisString = VY


  cor1 = escorc(x5, y5)
  cor2 = escorc(x6, y6)


res@xyMarkerColor = "black"
res@xyMarkerSizeF = 0.03

; res@gsnLeftString = "CMIP5"
; res@gsnLeftString = "R="+sprintf("%3.2f", cor1)
plot(i) = gsn_csm_xy(wks, x5 , y5, res)
; res@gsnLeftString = "CMIP6"
; res@gsnRightString = "R="+sprintf("%3.2f", cor2)
plota = gsn_csm_xy(wks, x6 , y6,res)
overlay(plot(i),plota)


;;regression line
XC = array_append_record (x5, x6, 0)
YC = array_append_record (y5, y6, 0)

res@gsnLeftString = ""
res@gsnRightString = ""
res@xyMarkLineMode = "Lines"
rco = regline (XC , YC)                  ; linear regression
yregro = rco*XC + rco@yintercept                               ; regression
plot1 = gsn_csm_xy(wks, XC , yregro,res)
overlay(plot(i), plot1)

;;--------two sample nonparametric tests------------
;Kolmogorov–Smirnov test

; print(ind(.not.ismissing(y5)))
; print(ind(.not.ismissing(y6)))
; print(x5(i5y))
; print(x5(i5n))
p_ks = kolsm2_n(x5(i5y),x5(i5n),0)
print(p_ks)
ap = y5(i5y)
bp = y5(i5n)
i5yn = ind(.not.ismissing(ap))
i5nn = ind(.not.ismissing(bp))
; print(ap(i5yn))
; print(bp(i5nn))
p_ks = kolsm2_n(ap(i5yn),bp(i5nn),0)
print(p_ks)
delete([/ap,bp,i5nn,i5yn/])

; ;;--------add STD lines of models--------------
;
; x5_std = stddev(x5)
; x6_std = stddev(x6)
; y5_std = stddev(y5)
; y6_std = stddev(y6)
; x5_mme = avg(x5)
; x6_mme = avg(x6)
; y5_mme = avg(y5)
; y6_mme = avg(y6)
;
; ;-- polyline
;   ax5 = 0.95
;   ax6 = 0.98
;   by5 = 0.08
;   by6 = 0.05
;
;   x = (/ ax5,ax5,ax6,ax6/)
;   y = (/y5_mme-y5_std, y5_mme+y5_std, y6_mme-y6_std, y6_mme+y6_std/)
;
;   plres                        =  True
;   plres@gsLineThicknessF       =  2.0        ;-- set line thickness
;   plres@gsLineColor            = "grey55"       ;-- set line color
;   plres@gsFillOpacityF         =  0.5         ;-- set opacity of polygon
  ; poly1 = gsn_add_polyline(wks,plot(i), x, y, plres)  ;-- add polyline to map
  ;
  ; x = (/x5_mme-x5_std, x5_mme+x5_std, x6_mme-x6_std, x6_mme+x6_std/)
  ; y = (/ by5,by5,by6,by6/)
  ; poly1 = gsn_add_polyline(wks,plot(i), x, y, plres)  ;-- add polyline to map
  ;
  ; pmres                        =  True
  ; pmres@gsMarkerColor          = "blue"       ;-- marker color
  ; pmres@gsMarkerSizeF          =  0.01        ;-- set size of marker
  ; pmres@gsLineThicknessF       =  5.          ;-- marker line thickness
  ; pmres@gsMarkerIndex = 6
  ;
  ; plmk = gsn_add_polymarker(wks,plot(i),(/ ax5, x5_mme, ax6, x6_mme/),(/ y5_mme, by5, y6_mme, by6/),pmres)

; rco6 = regline (x6 , y6)                  ; linear regression
; yregro6 = rco6*x6 + rco6@yintercept                               ; regression
; plot1 = gsn_csm_xy(wks, x6 , yregro6,res)
; overlay(plot(i), plot1)
;
;; different symbles for each model
; mark_model = ispan(1, nm, 1)
; mark_model(0:6)   = 3 ;6
; mark_model(7:13)  = 7
; mark_model(14:20) = 12 ;8
; mark_model(21:27) = 9
; mark_model(28:31) = 8
;
; colors1  = (/"dodgerblue2","purple","deeppink2","firebrick","darkorange2","goldenrod3", "forestgreen"/);,"aquamarine"
; color_model = tostring(ispan(1, nm, 1))
; color_model(0:6)   =  colors1
; color_model(7:13)  = colors1
; color_model(14:20) = colors1
; color_model(21:27) = colors1
; color_model(28:31) = colors1(:3)
;
; res@xyMarkerSizeF = 0.01
; res@xyMarkerSizes = 0.01
; res@xyMarkerThicknessF = 3.;3.5
; do ik = 0,nm-1
;  res@xyMarker         =  mark_model(ik)
;   res@xyMarkerColor             = color_model(ik)
;   plotm = gsn_csm_xy(wks, (/y_all(ix,7+ik,iyr),y_all(ix,7+ik,iyr)/) ,(/y_all(iy,7+ik,iyr),y_all(iy,7+ik,iyr)/),res)
;   overlay(plot(i), plotm)
; end do
;
;************************************************
; Attach text to plot using plot coordinates.
;************************************************
  txres               = True                     ; text mods desired
  txres@txFontHeightF = 0.015                     ; font smaller. default big

  txres@txFontColor = "grey55"
  ; text1  = gsn_add_text(wks,plot(i),MODEL5_LE,x5,y5,txres)
  text2  = gsn_add_text(wks,plot(i),MODEL6_LE,x6,y6,txres)

  txres@txFontColor = "red"
  text3  = gsn_add_text(wks,plot(i),M5_YES,x5(i5y),y5(i5y),txres)

  txres@txFontColor = "blue"
  text4  = gsn_add_text(wks,plot(i),M5_NO,x5(i5n),y5(i5n),txres)

delete([/text2,text3,text4/])
end do

txres@txFontHeightF = 0.02                     ; font smaller. default big
txres@txFontColor = "red"
text5  = gsn_add_text(wks,plot(1),"PLUS(CMIP5)",res@trXMaxF-0.17,BYmax(1)-0.05,txres)
text8  = gsn_add_text(wks,plot(0),"PLUS(CMIP5)",res@trXMaxF-0.17,BYmax(0)-2.5,txres)
txres@txFontColor = "blue"
text6  = gsn_add_text(wks,plot(1),"MINUS(CMIP5)",res@trXMaxF-0.17,BYmax(1)-0.10,txres)
text9  = gsn_add_text(wks,plot(0),"MINUS(CMIP5)",res@trXMaxF-0.17,BYmax(0)-2.8,txres)
txres@txFontColor = "grey55"
text7  = gsn_add_text(wks,plot(1),"CMIP6",res@trXMaxF-0.17,BYmax(1)-0.15,txres)
text1  = gsn_add_text(wks,plot(0),"CMIP6",res@trXMaxF-0.17,BYmax(0)-3.0,txres)

;   ;----------------------------------------------------------------------
;   ; Draw some markers and text. of each model
;   ;----------------------------------------------------------------------
;   xpos = fspan(0.1, 0.9, nm)
;   xpos(0:6)   = fspan(0.15, 0.8, 7)
;   xpos(7:13)  = fspan(0.15, 0.8, 7)
;   xpos(14:20) = fspan(0.15, 0.8, 7)
;   xpos(21:27) = fspan(0.15, 0.8, 7)
;   xpos(28:31) = fspan(0.15, 0.48, 4)
;
;   ypos = fspan(0.1, 0.9, nm)
;   ypos(0:6)   =  0.23
;   ypos(7:13)  = 0.18
;   ypos(14:20) = 0.13
;   ypos(21:27) = 0.08
;   ypos(28:31) = 0.03
;
;     mkres               = True         ; Marker resources
;     txres               = True         ; Text resources
;     txres@txFontHeightF = 0.01
;     txres@txJust        = "CenterCenter"
;     do ik = 0,nm-1
;        mkres@gsMarkerThicknessF = 3.;3.5
;        mkres@gsMarkerSizeF      = 0.01
;        mkres@gsMarkerIndex      = mark_model(ik)
;        mkres@gsMarkerColor      = color_model(ik)
;
;        gsn_polymarker_ndc(wks,           xpos(ik),ypos(ik),mkres)
;        gsn_text_ndc      (wks,model_c(ik),xpos(ik),ypos(ik)-0.02,txres)
;     end do
;     ; drawNDCGrid(wks)   ; Draw helpful grid lines showing NDC square.
;     ; gsn_panel(wks, plot(i), (/1,1/), resk) ;why all viewport changed after using gsn_panel?!


      resk = True
      resk@txFontHeightF = 0.02
      ; resk@gsnMaximize = True
      resk@gsnPaperOrientation = "portrait"   ; force portrait

      resk@txString  = ""
      ; drawNDCGrid(wks)
      gsn_panel(wks,plot,(/2,1/),resk);



end
