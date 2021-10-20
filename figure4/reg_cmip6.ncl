begin
diri = "/glade/work/chenxing/enso/"
dirip = "/glade/u/home/chenxing/enso/"


  yrs = 1850;1920;1950;
  yrl = 2014
  ymstrt= yrs*100+1
  ymlast= yrl*100+12

diri1 = "/glade/collections/cmip/cmip6/"
diri2 = "/glade/work/chenxing/CMIP6/historical/remap/tos/"
;from cdo_cmip_data.ncl
diri3 = "/glade/scratch/chenxing/cmip6/"
SEASON = (/"DJF","MAM","JJA","SON" /)

; MODEL6 = (/"BCC-CSM2-MR","CAMS-CSM1-0","CanESM5","CESM2-FV2",\ ;"ACCESS-CM2","ACCESS-ESM1-5","BCC-ESM1",
;         "CESM2","CESM2-WACCM-FV2",\
;         "CESM2-WACCM","E3SM-1-0","FIO-ESM-2-0","GFDL-CM4",\;"E3SM-1-1","FGOALS-f3-L","FGOALS-g3","GFDL-ESM4",
;         "GISS-E2-1-G","INM-CM5-0","IPSL-CM6A-LR","MCM-UA-1-0","MIROC6",\;"GISS-E2-1-G-CC","GISS-E2-1-H",
;         "MPI-ESM1-2-HR","MPI-ESM1-2-LR","MRI-ESM2-0","NorCPM1","NorESM2-LM","SAM0-UNICON"/);"MPI-ESM-1-2-HAM","NESM3",
;
; MODEL6_LE = (/"IPSL-CM6A-LR","NorCPM1", "CanESM5", "GISS-E2-1-G","CESM2","INM-CM5-0",\;"GISS-E2-1-H",
;   "MIROC6","MPI-ESM1-2-LR","MPI-ESM1-2-HR","MRI-ESM2-0","E3SM-1-0" /) ;large ensemble model in CMIP6 "NESM3",
; nens6 = (/32,30,25,12,11, 10, 10,\;10,
;           10,7,5,5 /) ;ensemble number 5,

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

M5_YES = (/"ACCESS1-0","ACCESS1-3","CanESM2","CESM1-CAM5","CNRM-CM5","CSIRO-Mk3-6-0","GFDL-CM3",\;
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


i6le = new(dimsizes(MODEL6_LE), "integer")
do i = 0,dimsizes(MODEL6_LE)-1
  i6le(i) = ind(MODEL6.eq.MODEL6_LE(i))
end do

nm6 = dimsizes(MODEL6)
nens_all = 32

VAR = "va" ;"ts" ;"clt" ;"netsw" ;"netcssw","od550aer" ;"cloudeffect";"ts" ; "rsds" "va" ;"psl" ;
VARn = "va200" ;"ts" ;"clt" ;"netsw" ;"netcssw","od550aer" ;"cloudeffect";"ts" ; "rsds" "va" ;"psl" ;
EXP = "historical"
IND = "mmeeof2" ;"mmeeof2" ;"mmeeof1" ;"GMAOD" ;"PDI2" ;"PDI"; "AR1Di" ;"SLPAL" ;"pdv";"TNA"; "AR1varm"; "TNA";
AA = "mme";"mme" ; "s";

; note, the max lag should not be more than N/4
ccr1 = new((/nm6, 72,144 /), "float") ;cross correlation pattern

do im = 0,nm6-1

;from pdv_cmip6_hist.ncl
;cmip6_historical_CanESM2_r4i1p1_pdv_1850-2014.nc
locs = systemfunc("ls "+diri+"cmip6/pdv/cmip6_historical_"+MODEL6(im)+"_*_pdv_1850-2014.nc")
printVarSummary(locs)
print(locs)
nsa = dimsizes(locs)

  aa = new((/nens_all, 72,144 /), "float")

do ia = 0,nsa-1

 locs_str = str_split(locs(ia), "_"); "/")
 print("'" + locs_str + "'")
  ENSN  = locs_str(3)

  print(MODEL6(im)+" ens "+ENSN)

    file_name = diri3+EXP+"/"+VAR+"/"+MODEL6(im)+"_"+VAR+"_"+EXP+"_"+ENSN+".nc"
    file_name2 = diri+"cmip6/"+IND+"/cmip6_"+EXP+"_"+MODEL6(im)+"_"+ENSN+"_"+IND+"_1850-2014.nc"
    exists = isfilepresent(file_name)
    exists2 = isfilepresent(file_name2)
  if (AA.ne."mme") then
    if(.not.exists.or..not.exists2) then
      print(file_name)
      print(file_name2)
      print(MODEL6(im)+" ens "+ENSN+" file not exist")
      print("Either the file doesn't exist, or NCL does")
      print("not have OPeNDAP cabilities on this system.")
      continue
    else

    f   = addfile(file_name, "r")
    end if
  else
    if(.not.exists) then
      print(file_name)
      print(file_name2)
      print(MODEL6(im)+" ens "+ENSN+" file not exist")
      print("Either the file doesn't exist, or NCL does")
      print("not have OPeNDAP cabilities on this system.")
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
    xx  = f->$VAR$(ymstrts:ymlasts,{20000},:,:);:,:);
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
  ; ; from pdv_cmip6_hist.ncl
  ; f1   = addfile(diri+"cmip6/pdv/cmip6_"+EXP+"_"+MODEL6(im)+"_"+ENSN+"_pdv_1850-2014.nc", "r")
  ; pc  = f1->pc(0,(yrs-1850)*12:)

  ; ;;some index
  ; ;from cmip_index.ncl
  ; f1   = addfile(diri+"cmip6/"+IND+"/cmip6_"+EXP+"_"+MODEL6(im)+"_"+ENSN+"_"+IND+"_1850-2014.nc", "r")
  ; ; pc  = tofloat(f1->gmst((yrs-1850)*12:))
  ; pc  = tofloat(f1->index((yrs-1850)*12:))
  ; ; pc  = dtrend(pc, 0)

  ;global external forcing mode
  ; from mme_eof_cmip6.ncl
    f1   = addfile(diri+"cmip6/cmip6_historical_mme.eof_1850-2014.nc", "r")
    pc  = f1->pc(1,(yrs-1850)*12:)

  ; ; ;MME index
  ; ;from plot_cmip_index_xy.ncl
  ; f1 = addfile(diri+"cmip6_"+EXP+"_"+IND+"_mme.nc","r")
  ; pc = f1->cp6_a

  pc_annual = month_to_annual(pc, 1)
  ; pc_sea = month_to_seasonN(pc, SEASON)
  ; pc_sea2 = ndtooned(pc_sea)
  ; pc_sea2!0 = "time"
  delete([/xx /])

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

delete([/locs_str,pc,xa_sea2/]);,pc_sea2,xa_sea,pc_sea,xa
end do

;ensemble mean
ccr1(im,:,:) = dim_avg_n_Wrap(aa, 0)

delete([/locs/]);,x_Lead1

end do

ccr1!0 = "model"
printVarSummary(ccr1)
;--------output-------------
fon=diri+"cmip6_reg_mme"+IND+"_"+EXP+"_"+VARn+"_"+yrs+"-"+yrl+".nc";
; fon=diri+"cmip6_reg_"+IND+"_"+EXP+"_"+VARn+"_"+yrs+"-"+yrl+".nc";
system("rm -f "+fon)
fo=addfile(fon,"c")
fo->ccr1 = ccr1

exit

;---------read output---------------
f1   = addfile(diri+"cmip6_reg_"+IND+"_"+EXP+"_"+VARn+"_"+yrs+"-"+yrl+".nc", "r")
ccr1  = f1->ccr1

;;----------composite-----------------
;MME
com_ccr = dim_avg_n_Wrap(ccr1 , 0)
printVarSummary(com_ccr)

printMinMax(com_ccr, 0)
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
wks = gsn_open_wks("ps", dirip+"cmip6_reg");
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
res2@lbTitleString    = "K"                ; title string
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
    plot(0) = gsn_csm_contour_map_ce(wks, com_ccr, res2)


resk = True
;resk@txFontHeightF = 0.03
resk@gsnPanelLabelBar   = True                 ; add common colorbar
resk@gsnMaximize = True
resk@gsnPaperOrientation = "portrait"   ; force portrait
resk@lbBoxEndCapStyle = "TriangleBothEnds"
resk@lbOrientation = "Horizontal"
resk@lbBoxLinesOn = False
;resk@lbBoxMinorExtentF = 0.2
resk@lbLabelFontHeightF = 0.01  ;Default: 0.02
;resk@pmLabelBarWidthF = 0.1
;resk@pmLabelBarHeightF = 0.2
;resk@pmLabelBarParallelPosF = 0.3 ;default 0.5
;resk@pmLabelBarOrthogonalPosF = 0.005 ;default 0.02
resk@txString = VAR+" regressed onto "+IND+" "+yrs+"-"+yrl+": CMIP6"
gsn_panel(wks,plot,(/1,1/),resk)


end
