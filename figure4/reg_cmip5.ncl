begin
diri = "/glade/work/chenxing/enso/"
dirip = "/glade/u/home/chenxing/enso/"

  yrs = 1861;1920;1950;
  yrl = 2004
  ymstrt= yrs*100+1
  ymlast= yrl*100+12

diri1 = "/glade/collections/cmip/cmip5/"
diri2 = "/glade/work/chenxing/CMIP5/historical/remap/tos/"
;from cdo_cmip_data.ncl
diri3 = "/glade/scratch/chenxing/cmip5/"
SEASON = (/"DJF","MAM","JJA","SON" /)

; MODEL5 = (/"ACCESS1-0","ACCESS1-3","bcc-csm1-1","BNU-ESM","CanESM2","CCSM4","CESM1-BGC",\;"bcc-csm1-1-m",
;       "CESM1-CAM5","CESM1-FASTCHEM","CESM1-WACCM","CMCC-CESM","CMCC-CM","CMCC-CMS",\
;       "CNRM-CM5","CSIRO-Mk3-6-0","FGOALS-g2","FGOALS-s2","FIO-ESM","GFDL-CM2p1",\;"CNRM-CM5-2""GFDL-CM3",
;       "GFDL-ESM2G","GISS-E2-H-CC","HadCM3","HadGEM2-AO",\;"GFDL-ESM2M","GISS-E2-H","GISS-E2-R-CC","GISS-E2-R",
;       "HadGEM2-CC","HadGEM2-ES","inmcm4","IPSL-CM5A-LR","IPSL-CM5A-MR","IPSL-CM5B-LR","MIROC5",\
;       "MIROC-ESM-CHEM","MIROC-ESM","MPI-ESM-LR","MPI-ESM-MR","MPI-ESM-P","MRI-CGCM3",\;"MRI-ESM1",
;       "NorESM1-ME","NorESM1-M"/)
;
; MODEL5_PLUS = (/"ACCESS1-0","ACCESS1-3","CanESM2","CESM1-CAM5","CNRM-CM5","CSIRO-Mk3-6-0","FGOALS-g2", "HadGEM2-CC",\;,"GFDL-CM3"
;           "HadGEM2-ES","IPSL-CM5A-LR","IPSL-CM5A-MR","MIROC5","MIROC-ESM-CHEM","MIROC-ESM",\
;           "MRI-CGCM3","NorESM1-ME", "NorESM1-M"/) ;explicitly have aerosol interaction included in CMIP5
;
; MODEL5_MINUS = (/"bcc-csm1-1","BNU-ESM","CCSM4","CESM1-BGC","CESM1-FASTCHEM","CESM1-WACCM",\
;               "CMCC-CESM","CMCC-CM","CMCC-CMS","FGOALS-s2","GFDL-CM2p1", "GFDL-ESM2G","MPI-ESM-LR",\
;               "HadCM3","inmcm4","MPI-ESM-MR","MPI-ESM-P"  /) ;explicitly no aerosol interaction included in CMIP5 "GFDL-ESM2M",
;
; MODEL5_LE = (/"CNRM-CM5", "CSIRO-Mk3-6-0", "GFDL-CM2p1","HadCM3", "CCSM4", \;"GISS-E2-H","GISS-E2-R",
;              "IPSL-CM5A-LR", "CanESM2", "MIROC5","CESM1-CAM5","HadGEM2-ES",\
;              "ACCESS1-0","ACCESS1-3","bcc-csm1-1","CESM1-FASTCHEM","FGOALS-g2",\
;              "FGOALS-s2","FIO-ESM","IPSL-CM5A-MR","MIROC-ESM","MPI-ESM-LR","MPI-ESM-MR","MRI-CGCM3","NorESM1-M",\
;              "BNU-ESM","CESM1-BGC","CESM1-WACCM","CMCC-CESM","CMCC-CM","CMCC-CMS",\
;              "GFDL-ESM2G","GISS-E2-H-CC","HadGEM2-AO","HadGEM2-CC","inmcm4","IPSL-CM5A-LR",\
;               "MIROC-ESM-CHEM","MPI-ESM-P","NorESM1-ME"/);"GFDL-CM3",
; nens5 = (/10,10,10,8,6,6,6,\
;          6,5,5,4,4,\
;          3,3,3,3,3,3,3,\
;          3,3,3,3,3,3,\
;          1,1,1,1,1,1,\
;          1,1,1,1,1,1,\
;          1,2,1 /);5,
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

MODEL5_PLUS = (/"ACCESS1-0","ACCESS1-3","CanESM2","CESM1-CAM5","CNRM-CM5","CSIRO-Mk3-6-0","GFDL-CM3",\;
          "HadGEM2-ES","IPSL-CM5A-LR","IPSL-CM5A-MR","MIROC5","MIROC-ESM",\
          "MRI-CGCM3","NorESM1-M"/) ;explicitly have aerosol interaction included in CMIP5

MODEL5_MINUS = (/"bcc-csm1-1","CCSM4","CESM1-FASTCHEM","FGOALS-s2","FIO-ESM","GFDL-CM2p1","HadCM3",\;
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

i5y = new(dimsizes(MODEL5_PLUS), "integer")
do i = 0,dimsizes(MODEL5_PLUS)-1
  i5y(i) = ind(MODEL5.eq.MODEL5_PLUS(i))
end do
i5n = new(dimsizes(MODEL5_MINUS), "integer")
do i = 0,dimsizes(MODEL5_MINUS)-1
  i5n(i) = ind(MODEL5.eq.MODEL5_MINUS(i))
end do
i5le = new(dimsizes(MODEL5_LE), "integer")
do i = 0,dimsizes(MODEL5_LE)-1
  i5le(i) = ind(MODEL5.eq.MODEL5_LE(i))
end do

VAR = "tas" ;"clt" ;"netsw" ;"netcssw","od550aer" ;"cloudeffect";"tas" ; "rsds" "va" ;"psl" ;
EXP = "historical"
IND = "PDI" ;"mmeeof2" ;"mmeeof1" ;"GMAOD" ;"PDI2" ;"PDI"; "AR1Di" ;"SLPAL" ;"pdv";"TNA"; "AR1varm"; "TNA";
AA = "mme";"mme" ; "s";

nens_all = 10


; note, the max lag should not be more than N/4
ccr1 = new((/nm5, 72,144 /), "float") ;cross correlation pattern

do im = 0,nm5-1

;from pdv_cmip5_hist.ncl
;cmip5_historical_CanESM2_r4i1p1_pdv_1861-2004.nc
locs = systemfunc("ls "+diri+"cmip5/pdv/cmip5_historical_"+MODEL5(im)+"_*_pdv_1861-2004.nc")
printVarSummary(locs)
print(locs)
nsa = dimsizes(locs)

  aa = new((/nens_all, 72,144 /), "float")

do ia = 0,nsa-1

 locs_str = str_split(locs(ia), "_"); "/")
 print("'" + locs_str + "'")
  ENSN  = locs_str(3)

  print(MODEL5(im)+" ens "+ENSN)
      file_name = diri3+EXP+"/"+VAR+"/"+MODEL5(im)+"_"+VAR+"_historical_"+ENSN+".nc"
      file_name2 = diri+"cmip5/"+IND+"/cmip5_"+EXP+"_"+MODEL5(im)+"_"+ENSN+"_"+IND+"_1861-2004.nc"
    exists = isfilepresent(file_name)
    exists2 = isfilepresent(file_name2)
  if (AA.ne."mme") then
    if(.not.exists.or..not.exists2) then
      print(MODEL5(im)+" ens "+ENSN+" file not exist")
      print(file_name+" "+exists)
      print(file_name2+" "+exists2)
      continue
    else

    f   = addfile(file_name, "r")
    end if
  else
    if(.not.exists) then
      print(MODEL5(im)+" ens "+ENSN+" file not exist")
      continue
    else

    f   = addfile(file_name, "r")
    end if
  end if

  TIME2=f->time
  yyyymm2=cd_calendar(TIME2, -1)
  printMinMax(yyyymm2, True)
  ymstrts = ind(yyyymm2.eq.ymstrt)
  ymlasts = ind(yyyymm2.eq.ymlast)
  print(ymstrts+" <--start end--> "+ymlasts)

  if(VAR.eq."cloudeffect") then
    xx  = f->ce(ymstrts:ymlasts,:,:);
  else
    xx  = f->$VAR$(ymstrts:ymlasts,:,:);{85000},:,:);
  end if

  delete([/f,TIME2,yyyymm2/]);,lat,lon
  if(VAR.eq."pr") then
    xx = xx*24*3600 ;kg/s/m2-->24*3600mm/day
    xx@units = "mm/day"
  end if

  xa = rmMonAnnCycTLL(xx)

  xa_annual = month_to_annual(xa, 1)
  xa_sea = month_to_seasonN(xa, SEASON)
  ;season, year --> season * year one dimension
  ndim1 = dimsizes(xa_sea)
  xa_sea2 = reshape(xa_sea, (/ndim1(0)*ndim1(1),ndim1(2),ndim1(3) /) )
  xa_sea2!0 = "time"
  copy_VarMeta(xa(0,:,:), xa_sea2(0,:,:))

  ;---------read output---------------

  ; ;PDV
  ; ; from pdv_cmip5_hist.ncl
  ; f1   = addfile(diri+"cmip5/pdv/cmip5_"+EXP+"_"+MODEL5(im)+"_"+ENSN+"_pdv_1861-2004.nc", "r")
  ; pc  = f1->pc(0,(yrs-1861)*12:)


  ; ;;some index
  ; ;from cmip_index.ncl
  ; f1   = addfile(diri+"cmip5/"+IND+"/cmip5_"+EXP+"_"+MODEL5(im)+"_"+ENSN+"_"+IND+"_1861-2004.nc", "r")
  ; ; pc  = tofloat(f1->gmst((yrs-1861)*12:))
  ; pc  = tofloat(f1->index((yrs-1861)*12:))
  ; ; pc  = dtrend(pc, 0)

  ; ;global external forcing mode
  ; ;from mme_eof_cmip6.ncl
  ; f1   = addfile(diri+"cmip5/cmip5_historical_mme.eof_1861-2004.nc", "r")
  ; pc  = f1->pc(1,(yrs-1861)*12:)

  ; ;MME index
  ;from plot_cmip_index_xy.ncl
  f1 = addfile(diri+"cmip5_"+EXP+"_"+IND+"_mme.nc","r")
  ; if (.not.ismissing(ind(MODEL5_PLUS.eq.MODEL5(im))))then
  ;     pc = f1->cp5_plus_a
  ;     print(MODEL5(im)+" is PLUS ?")
  ; else if (.not.ismissing(ind(MODEL5_MINUS.eq.MODEL5(im))))then
  ;     pc = f1->cp5_minus_a
  ;     print(MODEL5(im)+" is MINUS ?")
  ;   else
  ; pc = f1->cp5_a
  ; end if
  ; end if
  pc = f1->cp5_a

  pc_annual = month_to_annual(pc, 1)
  ; pc_sea = month_to_seasonN(pc, SEASON)
  ; pc_sea2 = ndtooned(pc_sea)
  ; pc_sea2!0 = "time"
  delete([/xx/]);,xa_sea,pc_sea /])

;------------filter----------------------
fyr   = 8.
ihp   = 0                             ; low-pass filter: ihp = 0; high-pass ihp = 1; band-pass ihp = 2.
sigma = 1.0                           ; Lanczos sigma
nWgt  = toint(fyr*12*1+1); fyr)+1 ;                           ; odd only
fca   = 1./(fyr*12)
fcb   = -999.
wgt  = filwgts_lanczos (nWgt, ihp, fca, fcb, sigma )
pc_ft = wgt_runave_n_Wrap( pc, wgt,  0, 0 )   ;opt < 0 : utilize cyclic conditions

; ???
pc_ft = dim_standardize_n_Wrap(pc_ft, 0, 0)

;-----------regression-------------
aa(ia,:,:) = regCoef(pc_ft,xa(lat|:,lon|:,time|:));, tval, df);Y

copy_VarCoords(xa(0,:,:), aa(ia,:,:))

delete([/locs_str,pc,xa_sea2/]);,pc_sea2,xa
end do

;ensemble mean
ccr1(im,:,:) = dim_avg_n_Wrap(aa, 0)

delete([/locs/]);,x_Lead1

end do

ccr1!0 = "model"
printVarSummary(ccr1)

;--------output-------------
; fon=diri+"cmip5_reg_"+IND+"_"+EXP+"_"+VAR+"_"+yrs+"-"+yrl+".nc";
fon=diri+"cmip5_reg_mme"+IND+"_"+EXP+"_"+VAR+"_"+yrs+"-"+yrl+".nc";
system("rm -f "+fon)
fo=addfile(fon,"c")
fo->ccr1 = ccr1

exit
;---------read output---------------
f1   = addfile(diri+"cmip5_reg_mme"+IND+"_"+EXP+"_"+VAR+"_"+yrs+"-"+yrl+".nc", "r")
ccr1  = f1->ccr1

f2   = addfile(diri+"cmip6_reg_mme"+IND+"_"+EXP+"_ts_1850-2014.nc", "r")
ccr2  = f2->ccr1


f1   = addfile(diri+"cmip5_reg_mme"+IND+"_"+EXP+"_ua_"+yrs+"-"+yrl+".nc", "r")
ua1  = f1->ccr1
f2   = addfile(diri+"cmip6_reg_mme"+IND+"_"+EXP+"_ua_1850-2014.nc", "r")
ua2  = f2->ccr1
f1   = addfile(diri+"cmip5_reg_mme"+IND+"_"+EXP+"_va_"+yrs+"-"+yrl+".nc", "r")
va1  = f1->ccr1
f2   = addfile(diri+"cmip6_reg_mme"+IND+"_"+EXP+"_va_1850-2014.nc", "r")
va2  = f2->ccr1

;;----------composite-----------------
;MME
com_ccr = dim_avg_n_Wrap(ccr1 , 0)
printVarSummary(com_ccr)
com_ccr_y = dim_avg_n_Wrap(ccr1(i5y,:,:) , 0)
com_ccr_n = dim_avg_n_Wrap(ccr1(i5n,:,:) , 0)
; com_ccr_le = dim_avg_n_Wrap(ccr1(i5le,:,:) , 0)
com_ua = dim_avg_n_Wrap(ua1 , 0)
printVarSummary(com_ua)
com_ua_y = dim_avg_n_Wrap(ua1(i5y,:,:) , 0)
com_ua_n = dim_avg_n_Wrap(ua1(i5n,:,:) , 0)
com_va = dim_avg_n_Wrap(va1 , 0)
printVarSummary(com_va)
com_va_y = dim_avg_n_Wrap(va1(i5y,:,:) , 0)
com_va_n = dim_avg_n_Wrap(va1(i5n,:,:) , 0)

;CMIP6
com_ccr6 = dim_avg_n_Wrap(ccr2 , 0)
com_ua6 = dim_avg_n_Wrap(ua2 , 0)
com_va6 = dim_avg_n_Wrap(va2 , 0)

printMinMax(com_ccr, 0)
printMinMax(com_ua, 0)
; ;-------t-test---------------------------------
; pra_std = dim_stddev_n_Wrap(ccr, 0)

; df = pra_avg_p1
; df = nens(im)
; b = pra_avg_p1
; b = 0.5
; pr_tval = pra_avg_p1
; pr_tval = (pra_avg_p1-0)*sqrt(40)/pra_std
; pr_prob = (1.-betainc( df/(df+pr_tval^2), df/2.0, b))*100.  ; probability in %
; printMinMax(pr_prob, 0)

; delete([/df,b/])

; sig_pra1 = pra_avg_p1
; sig_pra1 = where(pr_prob.ge.90., abs(pra_avg_p1), pra_avg_p1@_FillValue)

;--------------plot-------------------
wks = gsn_open_wks("ps", dirip+"cmip5_reg");
plot = new(30,graphic)                ; create graphic array
plot1 = new(30,graphic)                ; create graphic array
plot2 = new(30,graphic)                ; create graphic array
plot3 = new(30,graphic)                ; create graphic array
gsn_define_colormap(wks, "NCV_blu_red")


res2 = True
res2@gsnDraw = False        ;dont draw
res2@gsnFrame = False        ;dont advance frame
res2@gsnLeftString = ""
res2@gsnRightString = ""
vcres = res2

res2@vpWidthF  = 0.6

res2@mpCenterLonF = 180.
res2@mpFillOn = False
res2@mpFillDrawOrder = "PostDraw"
 ; res2@mpMaxLatF                   = NLAT         ; choose subregion
 ; res2@mpMinLatF                   = SLAT
 ; res2@mpMaxLonF                   = ELON
 ; res2@mpMinLonF                   = WLON
res2@gsnAddCyclic = True ;False
res2@cnFillOn = True;False ;
res2@cnLinesOn = False;True ;
res2@cnLineLabelsOn = False

res2@gsnLeftStringFontHeightF = 0.03
res2@gsnRightStringFontHeightF = res2@gsnLeftStringFontHeightF
res2@lbLabelBarOn = False;
res2@lbOrientation = "Horizontal"
res2@lbBoxLinesOn  = False
res2@lbTitleOn        =  True                ; turn on title
res2@lbLabelStride    = 2
res2@lbTitleString    = ""                ; title string
res2@lbTitlePosition  = "Right"              ; title position
res2@lbTitleFontHeightF= .015                ; make title smaller
; res2@lbTitleDirection = "Across"
res2@lbTitleExtentF   = 0.01 ;Default: 0.15
res2@lbLabelFontHeightF = 0.01  ;Default: 0.02
; res2@pmLabelBarWidthF = 0.05

res2@cnLevelSelectionMode  = "ManualLevels"
res2@cnMinLevelValF        = -2.0
res2@cnMaxLevelValF        =  2.0
res2@cnLevelSpacingF       =  res2@cnMaxLevelValF/10.


res2@gsnLeftString = ""
    res2@gsnRightString = "CMIP6"
    plot(0) = gsn_csm_contour_map_ce(wks, com_ccr6, res2)
    res2@gsnRightString = "CMIP5"
    plot(1) = gsn_csm_contour_map_ce(wks, com_ccr, res2)
    res2@gsnRightString = "CMIP5(plus)"
    plot(2) = gsn_csm_contour_map_ce(wks, com_ccr_y, res2)
    res2@gsnRightString = "CMIP5(minus)"
    plot(3) = gsn_csm_contour_map_ce(wks, com_ccr_n, res2)

  ; vcres@vcGlyphStyle            = "CurlyVector"    ; turn on curly vectors
  ; vcres@vcMinFracLengthF        = 0.08
  ; vcres@vcMinDistanceF          = 0.02
  vcres@vcRefMagnitudeF         = 0.5            ; define vector ref mag
  vcres@vcRefLengthF            = 0.02              ; define length of vec ref

  vcres@vcRefAnnoOn             = True
  vcres@vcRefAnnoPerimOn          = False          ;参考矢量的边框
  vcres@vcRefAnnoString2          = "m/s"            ;not draw the word"reference vector"
  vcres@vcRefAnnoOrthogonalPosF = -.15            ; move ref vector up


  vcres@lbLabelBarOn = False
  vcres@vcFillArrowFillColor = "black"

  vector= gsn_csm_vector(wks,com_ua6,com_va6,vcres)
  overlay(plot(0),vector)
  vector= gsn_csm_vector(wks,com_ua,com_va,vcres)
  overlay(plot(1),vector)
  vector= gsn_csm_vector(wks,com_ua_y,com_va_y,vcres)
  overlay(plot(2),vector)
  vector= gsn_csm_vector(wks,com_ua_n,com_va_n,vcres)
  overlay(plot(3),vector)

resk = True
;resk@txFontHeightF = 0.03
resk@gsnPanelLabelBar   = True                 ; add common colorbar
resk@gsnMaximize = True
resk@gsnPaperOrientation = "portrait"   ; force portrait
resk@lbBoxEndCapStyle = "TriangleBothEnds"
resk@lbOrientation = "Horizontal"
resk@lbBoxLinesOn = False
; resk@lbTitleString = com_ccr@units
;resk@lbBoxMinorExtentF = 0.2
resk@lbLabelFontHeightF = 0.01  ;Default: 0.02
;resk@pmLabelBarWidthF = 0.1
;resk@pmLabelBarHeightF = 0.2
;resk@pmLabelBarParallelPosF = 0.3 ;default 0.5
;resk@pmLabelBarOrthogonalPosF = 0.005 ;default 0.02
resk@txString = VAR+" regressed onto "+IND+" "+yrs+"-"+yrl
gsn_panel(wks,plot,(/2,2/),resk)


end
