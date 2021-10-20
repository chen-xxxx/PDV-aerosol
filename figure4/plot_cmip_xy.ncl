load "./model_bootstrap.ncl"
; load "/Users/xingchen/Documents/project/PDV/program/function_bootstrap_mme.ncl"
begin

diri = "/glade/work/chenxing/enso/";"/Users/xingchen/Documents/project/PDV/data/" ;
dirip = "/glade/u/home/chenxing/enso/";"/Users/xingchen/Documents/project/PDV/pic/" ;

;CMIP5 MODELS
; MODEL5 = (/"ACCESS1-0","ACCESS1-3","bcc-csm1-1-m","bcc-csm1-1","BNU-ESM","CanESM2","CCSM4","CESM1-BGC",\;
;       "CESM1-CAM5","CESM1-FASTCHEM","CESM1-WACCM","CMCC-CESM","CMCC-CM","CMCC-CMS",\
;       "CNRM-CM5","CNRM-CM5-2","CSIRO-Mk3-6-0","FGOALS-g2","FGOALS-s2","FIO-ESM","GFDL-CM2p1","GFDL-CM3",\;
;       "GFDL-ESM2G","GFDL-ESM2M","GISS-E2-H-CC","GISS-E2-H","GISS-E2-R-CC","GISS-E2-R","HadCM3","HadGEM2-AO",\;
;       "HadGEM2-CC","HadGEM2-ES","inmcm4","IPSL-CM5A-LR","IPSL-CM5A-MR","IPSL-CM5B-LR","MIROC5",\
;       "MIROC-ESM-CHEM","MIROC-ESM","MPI-ESM-LR","MPI-ESM-MR","MPI-ESM-P","MRI-CGCM3","MRI-ESM1",\;
;       "NorESM1-ME","NorESM1-M"/)

MODEL5 = (/"CNRM-CM5", "CSIRO-Mk3-6-0", "GFDL-CM2p1","HadCM3", "CCSM4","GISS-E2-H","GISS-E2-R", \;
             "IPSL-CM5A-LR", "CanESM2", "GFDL-CM3","MIROC5","CESM1-CAM5","HadGEM2-ES",\
             "ACCESS1-0","ACCESS1-3","bcc-csm1-1-m","bcc-csm1-1","CESM1-FASTCHEM","FGOALS-g2",\
             "FGOALS-s2","FIO-ESM","IPSL-CM5A-MR","MIROC-ESM","MPI-ESM-LR","MPI-ESM-MR","MRI-CGCM3","NorESM1-M"/);"GFDL-CM3",


; CMIP6 MODELS
; MODEL6 = (/"BCC-CSM2-MR","BCC-ESM1","CAMS-CSM1-0","CanESM5","CESM2-FV2",\ ;"ACCESS-CM2","ACCESS-ESM1-5",
;         "CESM2","CESM2-WACCM-FV2",\
;         "CESM2-WACCM","E3SM-1-0","FGOALS-g3","FIO-ESM-2-0","GFDL-CM4","GFDL-ESM4",\;"E3SM-1-1","FGOALS-f3-L",
;         "GISS-E2-1-G","GISS-E2-1-H","INM-CM5-0","IPSL-CM6A-LR","MCM-UA-1-0","MIROC6",\;"GISS-E2-1-G-CC",
;         "MPI-ESM1-2-HR","MPI-ESM1-2-LR","MRI-ESM2-0","NESM3","NorCPM1","NorESM2-LM","SAM0-UNICON"/);"MPI-ESM-1-2-HAM",

MODEL6 = (/"IPSL-CM6A-LR","NorCPM1", "CanESM5", "GISS-E2-1-G","CESM2","INM-CM5-0","GISS-E2-1-H",\;
  "MIROC6","MPI-ESM1-2-LR","MPI-ESM1-2-HR","MRI-ESM2-0","E3SM-1-0","NESM3",\
  "BCC-CSM2-MR","BCC-ESM1","CESM2-FV2","CESM2-WACCM-FV2","CESM2-WACCM","FGOALS-g3","FIO-ESM-2-0","NorESM2-LM" /) ;large ensemble model in CMIP6



MODEL5_PLUS = (/"ACCESS1-0","ACCESS1-3","CanESM2","CESM1-CAM5","CNRM-CM5","CSIRO-Mk3-6-0","GFDL-CM3",\;
          "HadGEM2-ES","IPSL-CM5A-LR","IPSL-CM5A-MR","MIROC5","MIROC-ESM",\
          "MRI-CGCM3","NorESM1-M"/) ;explicitly have aerosol interaction included in CMIP5

MODEL5_MINUS = (/"bcc-csm1-1","CCSM4","CESM1-FASTCHEM","FGOALS-s2","FIO-ESM","GFDL-CM2p1","HadCM3",\;
          "MPI-ESM-LR","MPI-ESM-MR"  /) ;explicitly no aerosol interaction included in CMIP5 "GFDL-ESM2M",


i5y = new(dimsizes(MODEL5_PLUS), "integer")
do i = 0,dimsizes(MODEL5_PLUS)-1
  i5y(i) = ind(MODEL5.eq.MODEL5_PLUS(i))
end do
i5n = new(dimsizes(MODEL5_MINUS), "integer")
do i = 0,dimsizes(MODEL5_MINUS)-1
  i5n(i) = ind(MODEL5.eq.MODEL5_MINUS(i))
end do
print("say yes "+i5y)
print("say no "+i5n)

yrs5 = 1861
yrl5 = 2005
nyr5 = yrl5 - yrs5 +1
yrs6 = 1850
yrl6 = 2014
nyr6 = yrl6 - yrs6 +1

;;;;touch here;;;;;;;;;;;;
EXP5 = "historical";"historicalNat" ;"historicalGHG" ;
EXP6 = "historical";"hist-aer";"hist-Nat" ;"hist-GHG" ;

;don't filter pdv pc, it's already filtered, double filter will shortern data...
IND = "PDI" ;"EACSS" ;"EAS" ;"PDI2" ; "NPCSS" ;"NPC" ;"NPS" ;"NPAOD" ;"PDI2";"TPI" ;"NPI" ;"AMO" ;"pdo" ;"nh-sh" ;"GMAOD" ;"GMSW" ;
MODEL = MODEL5;MODEL6;
icmip = 5;6 ;

yrs = 1861;
yrl = 2004; 2014;


nmo5 = dimsizes(MODEL5)
nmo6 = dimsizes(MODEL6)

pc5_hist = new((/nmo5,10,(yrl5-yrs5+1)*12/), "float")

do im = 0,nmo5-1

;from cmip_index.ncl
;cmip5_historical_CanESM2_r4i1p1_pdv_1861-2004.nc
locs = systemfunc("ls "+diri+"cmip5/PDI/cmip5_historical_"+MODEL5(im)+"_*_PDI_"+yrs5+"-"+yrl5+".nc")
; printVarSummary(locs)
; print(locs)
nsa = dimsizes(locs)

; if(.not.ismissing(locs)) then
do ia = 0,nsa-1

  ; print("MODEL5 "+MODEL5(im))
  locs_str = str_split(locs(ia), "_"); "/")
  ; print("'" + locs_str + "'")
  ENSN  = locs_str(3)
  print(MODEL5(im)+" ens "+ENSN)
  delete(locs_str)

   file_name = diri+"cmip5/"+IND+"/cmip5_"+EXP5+"_"+MODEL5(im)+"_"+ENSN+"_"+IND+"_"+yrs5+"-"+yrl5+".nc"
   exists = isfilepresent(file_name)
   if(.not.exists) then
     ; print(MODEL5(im)+" ens "+ENSN+" file not exist")
     ; print("Either the file doesn't exist, or NCL does")
     ; print("not have OPeNDAP cabilities on this system.")
     continue
   else
    ; print(file_name)
   f   = addfile(file_name, "r")
   end if

  pc5_hist(im,ia,:)  = f->index;pc(0,:);gmst;

; print(""+pc5_hist(im,ia,(1890-1861)*12))

end do
; end if
delete(locs)
end do
printVarSummary(pc5_hist)


;CMIP6
pc6_all = new((/nmo6,32,(yrl6-yrs6+1)*12/), "float")
do im = 0,nmo6-1

;from cmip_index.ncl
;cmip5_historical_CanESM2_r4i1p1_pdv_1861-2004.nc
locs = systemfunc("ls "+diri+"cmip6/PDI/cmip6_historical_"+MODEL6(im)+"_*_PDI_"+yrs6+"-"+yrl6+".nc")
printVarSummary(locs)
print(locs)
nsa = dimsizes(locs)

; if(.not.ismissing(locs)) then

do ia = 0,nsa-1

  print("MODEL6 "+MODEL6(im))
  locs_str = str_split(locs(ia), "_"); "/")
  print("'" + locs_str + "'")
  ENSN  = locs_str(3)
  print(MODEL6(im)+" ens "+ENSN)
  delete(locs_str)

   file_name = diri+"cmip6/"+IND+"/cmip6_"+EXP6+"_"+MODEL6(im)+"_"+ENSN+"_"+IND+"_"+yrs6+"-"+yrl6+".nc"
   exists = isfilepresent(file_name)
   if(.not.exists) then
     print(MODEL6(im)+" ens "+ENSN+" file not exist")
     print("Either the file doesn't exist, or NCL does")
     print("not have OPeNDAP cabilities on this system.")
     continue
   else
    print(file_name)
   f   = addfile(file_name, "r")
   end if

  pc6_all(im,ia,:)  = f->index;pc(0,:);gmst;

end do
; end if
delete(locs)

end do

printVarSummary(pc6_all)

;;--- rcp85 for cmip5 -----
;; append rcp85 (2006-2014) to historical for cmip5
pc5_rcp = new((/nmo5,10,(2014-2006+1)*12/), "float")

do im = 0,nmo5-1

;from cmip_index.ncl
exists = isfilepresent(diri+"cmip5/PDI/cmip5_rcp85_"+MODEL5(im)+"_r1i1p1_PDI_2006-2014.nc")
if(.not.exists) then
  continue
else
  locs = systemfunc("ls "+diri+"cmip5/PDI/cmip5_rcp85_"+MODEL5(im)+"_*_PDI_2006-2014.nc")

nsa = dimsizes(locs)

; if(.not.ismissing(locs)) then
do ia = 0,nsa-1

  ; print("MODEL5 "+MODEL5(im))
  locs_str = str_split(locs(ia), "_"); "/")
  ; print("'" + locs_str + "'")
  ENSN  = locs_str(3)
  print(MODEL5(im)+" ens "+ENSN)
  delete(locs_str)

   file_name = diri+"cmip5/"+IND+"/cmip5_rcp85_"+MODEL5(im)+"_"+ENSN+"_"+IND+"_2006-2014.nc"
   exists = isfilepresent(file_name)
   if(.not.exists) then
     ; print(MODEL5(im)+" ens "+ENSN+" file not exist")
     ; print("Either the file doesn't exist, or NCL does")
     ; print("not have OPeNDAP cabilities on this system.")
     continue
   else
    ; print(file_name)
   f   = addfile(file_name, "r")
   end if

  pc5_rcp(im,ia,:)  = f->index;pc(0,:);index;gmst;

; print(""+pc5_rcp(im,ia,(1890-1861)*12))

end do
end if
delete(locs)
end do
printVarSummary(pc5_rcp)

pc5_hist!0 = "model"
pc5_hist!1 = "ensemble"
pc5_rcp!0 = "model"
pc5_rcp!1 = "ensemble"
pc5_rcp = pc5_rcp + avg(pc5_hist(:,:,(2006-1861)*12-1)) - avg(pc5_rcp(:,:,0)) ;modify climatology
pp = array_append_record(pc5_hist(time|:,model|:,ensemble|:),pc5_rcp(time|:,model|:,ensemble|:),0)
printVarSummary(pp)
pc5_all = pp(model|:,ensemble|:,time|:)
printVarSummary(pc5_all)
delete(pp)

;don't filter pdv index twice!!!
;------------filter----------------------
fyr   = 8.
ihp   = 0                             ; low-pass filter: ihp = 0; high-pass ihp = 1; band-pass ihp = 2.
sigma = 1.0                           ; Lanczos sigma
nWgt  = toint(fyr*12*1+1); fyr)+1 ;                           ; odd only
fca   = 1./(fyr*12)
fcb   = -999.
wgt  = filwgts_lanczos (nWgt, ihp, fca, fcb, sigma )
pc5_all = wgt_runave_n_Wrap( pc5_all, wgt,  0, 2 )   ;opt < 0 : utilize cyclic conditions
pc6_all = wgt_runave_n_Wrap( pc6_all, wgt,  0, 2 )   ;opt < 0 : utilize cyclic conditions


;----------composite-------------------
;MME
;ignore model bias
; ndimp = dimsizes(pc5_all)
; aa = reshape(pc5_all, (/ndimp(0)*ndimp(1),ndimp(2)/))
cp5_a = dim_avg_n_Wrap(pc5_all,(/0,1/)); aa, 0)
cp6_a = dim_avg_n_Wrap(pc6_all,(/0,1/)); aa, 0)

; ;each model mean
cp5 = dim_avg_n_Wrap(pc5_all,1)
cp6 = dim_avg_n_Wrap(pc6_all,1)

com_pc5 = dim_avg_n_Wrap(cp5,0)
com_pc6 = dim_avg_n_Wrap(cp6,0)

cp5_plus_a = dim_avg_n_Wrap(dim_avg_n_Wrap(pc5_all(i5y,:,:), 1),0) ;dim_avg_n_Wrap(pc5_all(i5y,:,:), (/0,1/)) ;PLUS group MME
cp5_minus_a = dim_avg_n_Wrap(dim_avg_n_Wrap(pc5_all(i5n,:,:), 1),0) ;dim_avg_n_Wrap(pc5_all(i5n,:,:), (/0,1/)) ;MINUS group MME

com_pc5 = com_pc5 + avg(com_pc5((2006-1861)*12-1)) - avg(com_pc5((2006-1861)*12)) ;modify climatology

; ;1. averaged STD across ensembles
cs_a = dim_stddev_n_Wrap(pc5_all, (/0,1/)) ;com_std, 0)


std_5 = dim_stddev_n_Wrap(pc5_all,(/1/))
std_6 = dim_stddev_n_Wrap(pc6_all,(/1/))
;--------output-------------
fon=diri+"cmip5_"+EXP5+"_"+IND+"_mme.nc";
system("rm -f "+fon)
fo=addfile(fon,"c")
fo->cp5_a = cp5_a
fo->cp5_a2 = com_pc5
fo->cp5_plus_a = cp5_plus_a
fo->cp5_minus_a = cp5_minus_a
fo->std_5 = std_5

fon=diri+"cmip6_"+EXP6+"_"+IND+"_mme.nc";
system("rm -f "+fon)
fo=addfile(fon,"c")
fo->cp6_a = cp6_a
fo->cp6_a2 = com_pc6
fo->std_6 = std_6


; ; ;-----------BootStrap---------------------

nBoot = 10000

; only test model (already ensemble averaged) mean
pc5_od0 = ndtooned(dim_avg_n_Wrap(pc5_all,1))
nmsp = ind(.not.ismissing(pc5_od0))
pc5_od = pc5_od0(nmsp)
ndim5 = dimsizes(pc5_all)
delete(nmsp)

pc6_od0 = ndtooned(dim_avg_n_Wrap(pc6_all,1))
nmsp = ind(.not.ismissing(pc6_od0))
pc6_od = pc6_od0(nmsp)
ndim6 = dimsizes(pc6_all)
delete(nmsp)

Boot_cmip5 = bootstrap_mme(pc5_od,nBoot,ndim5(0),ndim5(2))
Boot_cmip6 = bootstrap_mme(pc6_od,nBoot,ndim6(0),ndim6(2))
printVarSummary(Boot_cmip5)

; ; function_bootstrap_mme.ncl

; N = 1000
; nBoot =   10000


; nem5y = num(.not.ismissing(ndtooned(pc5_all(i5y,:,500))))
; nem5n = num(.not.ismissing(ndtooned(pc5_all(i5n,:,500))))
; nem5 = num(.not.ismissing(ndtooned(pc5_all(:,:,500))))
; print(nem5y)

; boo5 = bootstrap_mme(pc5_all,wgt,N,nBoot,nem5)
; ; zz = dim_avg_n_Wrap(boo5, 1)
; ; bh5 = cp5_a
; ; bh5 = where(cp5_a.ge.zz(0).or.cp5_a.ne.zz(1), cp5_a, cp5_a@_FillValue)

; boo5y = bootstrap_mme(pc5_all,wgt,N,nBoot,nem5y)
; ; zz = dim_avg_n_Wrap(boo5y, 1)
; ; bh5y = cp5_plus_a
; ; bh5y = where(cp5_plus_a.ge.zz(0).or.cp5_plus_a.ne.zz(1), cp5_plus_a, cp5_plus_a@_FillValue)

; boo5n = bootstrap_mme(pc5_all,wgt,N,nBoot,nem5n)
; ; zz = dim_avg_n_Wrap(boo5n, 1)
; ; bh5n = cp5_minus_a
; ; bh5n = where(cp5_minus_a.ge.zz(0).or.cp5_minus_a.ne.zz(1), cp5_minus_a, cp5_minus_a@_FillValue)

; nem6 = num(.not.ismissing(ndtooned(pc6_all(:,:,500))))
; boo6 = bootstrap_mme(pc6_all,wgt,N,nBoot,nem6)
; ; zz = dim_avg_n_Wrap(boo6, 1)
; ; print(nem6)
; ; bh6 = cp6_a
; ; bh6 = where(cp6_a.ge.zz(0).or.cp6_a.ne.zz(1), cp6_a, cp6_a@_FillValue)



;--------------plot-------------------

wks = gsn_open_wks("png", dirip+"cmip_xy");
wks2 = gsn_open_wks("png", dirip+"test");
plot1 = new(10,graphic)                ; create graphic array
plot2 = new(10,graphic)                ; create graphic array
plot3 = new(10,graphic)                ; create graphic array
plot4 = new(10,graphic)                ; create graphic array


;*******************************************
; time series (principal component) plot
;*******************************************

  gsn_define_colormap(wks,"seaice_2")
  colors = ispan(2, 17, 1)   ; indices into color table
  colors2 = ispan(2, 17, 2)   ; indices into color table
  colors1 = ispan(10, 18, 1)   ; indices into color table


; these four resources allow the user to stretch the plot size, and
; decide exactly where on the page to draw it.

  res = True
  res@gsnDraw = False        ;dont draw
  res@gsnFrame = False        ;dont advance frame
  res@gsnLeftString = ""
  res@gsnRightString = ""
  res@vpHeightF = 0.3
  res@vpWidthF  = 0.8

  res@tmXTOn    = False
  res@tmYROn    = False
  ;res@gsnXYBarChart            = True              ; Create bar plot
  ;res@gsnXYBarChartOutlineOnly = True


  res@gsnYRefLine           = 0.0             ; reference line
  ; res@gsnAboveYRefLineColor = "red"           ; above ref line fill red
  ; res@gsnBelowYRefLineColor = "blue"          ; below ref line fill blue
  ; res@gsnLeftStringFontHeightF  = 0.03
  ; res@gsnRightStringFontHeightF = 0.03

  ndim5  = dimsizes(pc5_all)
  x_axis5 = fspan(yrs5, yrl6, ndim5(2))
  ndim6  = dimsizes(pc6_all)
  x_axis6 = fspan(yrs6, yrl6, ndim6(2))
  x_axis1 = ispan(yrs, yrl, 1)
  ;res@tmXBMode   = "Explicit"
  ;res@tmXBValues = x_axis;-1
  ;res@tmXBLabels = model
  ;res@tmXBLabelAngleF = 45.
  ;res@tmXBLabelFontHeightF = 0.02
  res@tiYAxisString = ""
  res@tiXAxisString = "year"

  res@xyMonoLineColor = False
  res@xyMonoDashPattern = True

  res@trXMinF               = 1850
  res@trXMaxF               = 2015

  res@trYMinF               = -1.0
  res@trYMaxF               =  1.0


;MODEL
res@xyLineThicknessF = 5.0
res@gsnRightString = pc5_all@units
  res@xyLineColors = "black"

  ;---------------
  ; MME
  ;---------------

  res@trYMinF               = -0.6
  res@trYMaxF               =  0.6

  res@gsnLeftString = ""
  res@xyLineColors = "blue"
  plot4(0) = gsn_csm_xy (wks,x_axis5, com_pc5 ,res)
  res@xyLineColors = "red"
  plota = gsn_csm_xy (wks,x_axis6, com_pc6 ,res)
  overlay(plot4(0),plota)

  res@xyLineThicknessF = 3.0
  res@xyDashPattern = 15
  res@xyLineColors = "blue"

  plota = gsn_csm_xy (wks,x_axis5,Boot_cmip5(0,:),res)
  overlay(plot4(0), plota)
  plota = gsn_csm_xy (wks,x_axis5,Boot_cmip5(1,:),res)
  overlay(plot4(0), plota)

  res@xyLineColors = "red"

  plota = gsn_csm_xy (wks,x_axis6,Boot_cmip6(0,:),res)
  overlay(plot4(0), plota)
  plota = gsn_csm_xy (wks,x_axis6,Boot_cmip6(1,:),res)
  overlay(plot4(0), plota)

;---------shading of STD---------

  ; delete(res@xyDashPattern)
  delete(res@xyLineColors)
  res@xyLineColor     = -1                           ; We don't want the line, so make it trax_axisparent.
  res@gsnXYFillOpacities = 0.3
  res@xyCurveDrawOrder = "PreDraw"
  mmz = cp6(0:1,:)

res@gsnLeftString = ""

;---------shading of STD---------

; com_std6 = dim_avg_n_Wrap(std_6,0)
com_std6 = dim_stddev_n_Wrap(cp6,0)

  mmz(0,:) = com_pc6-com_std6
  mmz(1,:) = com_pc6+com_std6

  res@gsnXYFillColors = "pink"
  plota  = gsn_csm_xy (wks,(/x_axis6/),mmz(0:1,:),res)  ; Create filled XY plot.
  overlay(plot4(0), plota)

  delete(mmz)
  mmz = cp5(0:1,:)
  ; com_std5 = dim_avg_n_Wrap(std_5,0)
  com_std5 = dim_stddev_n_Wrap(cp5,0)

    mmz(0,:) = com_pc5-com_std5
    mmz(1,:) = com_pc5+com_std5

    res@gsnXYFillColors = "lightblue"
    plota  = gsn_csm_xy (wks,(/x_axis5/),mmz(0:1,:),res)  ; Create filled XY plot.
    overlay(plot4(0), plota)


;************************************************
; Attach text to plot using plot coordinates.
;************************************************
  txres               = True                     ; text mods desired
  txres@txFontHeightF = 0.02                     ; font smaller. default big

  txres@txFontColor  = "blue"
  dum1 = gsn_add_text(wks,plot4(0),"CMIP5",1870,0.3,txres)
  txres@txFontColor  = "red"
  dum2 = gsn_add_text(wks,plot4(0),"CMIP6",1870,0.2,txres)

;------------------------------------------------
resk = True
;resk@txFontHeightF = 0.03
resk@gsnPanelLabelBar   = False                 ; add common colorbar
resk@gsnMaximize = True
resk@gsnPaperOrientation = "portrait"   ; force portrait

resk@txString = ""
gsn_panel(wks,plot4,(/1,1/),resk)

end
