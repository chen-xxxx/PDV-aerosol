begin

NLAT =   90; 5; 60;
SLAT =  -90;-5;-60;
WLON =  0;120;
ELON =  360;290;


diri  = "/glade/work/chenxing/enso/";"/Users/xingchen/Documents/project/ENSO/data/" ;
dirip = "/glade/u/home/chenxing/enso/";"/Users/xingchen/Documents/project/ENSO/pic/" ;
neof = 2

;CMIP5 MODELS
MODEL_cmip5 = (/"ACCESS1-0","ACCESS1-3","bcc-csm1-1","BNU-ESM","CanESM2","CCSM4","CESM1-BGC",\;"bcc-csm1-1-m",
      "CESM1-CAM5","CESM1-FASTCHEM","CESM1-WACCM","CMCC-CESM","CMCC-CM","CMCC-CMS",\
      "CNRM-CM5","CSIRO-Mk3-6-0","FGOALS-g2","FGOALS-s2","FIO-ESM","GFDL-CM2p1",\;"CNRM-CM5-2""GFDL-CM3",
      "GFDL-ESM2G","GISS-E2-H-CC","HadCM3","HadGEM2-AO",\;"GFDL-ESM2M","GISS-E2-H","GISS-E2-R-CC","GISS-E2-R",
      "HadGEM2-CC","HadGEM2-ES","inmcm4","IPSL-CM5A-LR","IPSL-CM5A-MR","IPSL-CM5B-LR","MIROC5",\
      "MIROC-ESM-CHEM","MIROC-ESM","MPI-ESM-LR","MPI-ESM-MR","MPI-ESM-P","MRI-CGCM3",\;"MRI-ESM1",
      "NorESM1-ME","NorESM1-M"/)


; CMIP6 MODELS
MODEL_cmip6 = (/"BCC-CSM2-MR","CAMS-CSM1-0","CanESM5","CESM2-FV2",\ ;"ACCESS-CM2","ACCESS-ESM1-5","BCC-ESM1",
        "CESM2","CESM2-WACCM-FV2",\
        "CESM2-WACCM","E3SM-1-0","FIO-ESM-2-0","GFDL-CM4",\;"E3SM-1-1","FGOALS-f3-L","FGOALS-g3","GFDL-ESM4",
        "GISS-E2-1-G","INM-CM5-0","IPSL-CM6A-LR","MCM-UA-1-0","MIROC6",\;"GISS-E2-1-G-CC","GISS-E2-1-H",
        "MPI-ESM1-2-HR","MPI-ESM1-2-LR","MRI-ESM2-0","NorCPM1","NorESM2-LM","SAM0-UNICON"/);"MPI-ESM-1-2-HAM","NESM3",

; MODEL6 = (/"IPSL-CM6A-LR","NorCPM1", "CanESM5", "GISS-E2-1-G","CESM2","INM-CM5-0",\;"GISS-E2-1-H",
;   "MIROC6","MPI-ESM1-2-LR","MPI-ESM1-2-HR","MRI-ESM2-0","E3SM-1-0" /) ;large ensemble model in CMIP6 "NESM3",


; MODEL6_LE = (/"IPSL-CM6A-LR","NorCPM1", "CanESM5", "GISS-E2-1-G","CESM2","INM-CM5-0",\;"GISS-E2-1-H",
;   "MIROC6","MPI-ESM1-2-LR","MPI-ESM1-2-HR","MRI-ESM2-0","E3SM-1-0" /) ;large ensemble model in CMIP6 "NESM3",

; nens6 = (/32,30,25,12,11, 10, 10,\;10,
;           10,7,5,5 /) ;ensemble number 5,



; MODEL6_ESM = (/"CanESM5","CESM2","E3SM-1-0",\
;         "MPI-ESM1-2-HR","MPI-ESM1-2-LR","MRI-ESM2-0"/)

; MODEL6_CM = (/"GISS-E2-1-G","INM-CM5-0","IPSL-CM6A-LR","MIROC6","NorCPM1" /)

yrs6 = 1850;1920;
yrl6 = 2014;
yrs5 = 1861;1920;
yrl5 = 2004;


;---------read output---------------
;from mme_eof_cmip.ncl
  f1   = addfile(diri+"cmip5/cmip5_historical_mme.eof_"+yrs5+"-2005.nc", "r")  ;multiple files
  f2   = addfile(diri+"cmip6/cmip6_historical_mme.eof_"+yrs6+"-2014.nc", "r")  ;multiple files

  rca5  = f1->rc
  pca5  = f1->pc
  pcvar5= f1->pcvar
  rca6  = f2->rc
  pca6  = f2->pc
  pcvar6= f2->pcvar
  printVarSummary(rca5)
  printVarSummary(pca5)
  printVarSummary(pcvar5)


  f1   = addfile(diri+"cmip5_historical_eof_global_od550aer_mme.nc", "r")  ;multiple files
  f2   = addfile(diri+"cmip6_historical_eof_global_od550aer_mme.nc", "r")  ;multiple files

  ado5  = dim_rmvmean_Wrap( f1->pc(0,(yrs5-1861)*12:))
  ado6  = dim_rmvmean_Wrap( f2->pc(0,(yrs6-1850)*12:))

;-------GMST----------------------------

  f1   = addfile(diri+"cmip5_historical_GMST_mme.nc", "r")
  gmst5  = dim_rmvmean_Wrap( f1->cp5_a((yrs5-1861)*12:))
  f1   = addfile(diri+"cmip6_historical_GMST_mme.nc", "r")
  gmst6  = dim_rmvmean_Wrap( f1->cp6_a((yrs6-1850)*12:))

printVarSummary(gmst5)

;-------ASRHD----------------------------

  f1   = addfile(diri+"cmip5_historical_ASRHD_mme.nc", "r")
  asrhd5  = dim_rmvmean_Wrap( f1->cp5_a((yrs5-1861)*12:))
  f1   = addfile(diri+"cmip6_historical_ASRHD_mme.nc", "r")
  asrhd6  = dim_rmvmean_Wrap( f1->cp6_a((yrs6-1850)*12:))

printVarSummary(asrhd5)

;--------------plot-------------------
wks = gsn_open_wks("png", dirip+"mme_eof");
plot = new(10,graphic)                ; create graphic array
plot2 = new(10,graphic)                ; create graphic array
gsn_define_colormap(wks, "NCV_blu_red"); "BlueDarkRed18");"BrownBlue12");"BlueGreen14");"BlueYellowRed");"sunshine_9lev")"BrownBlue12";
res2 = True
res2@gsnDraw = False        ;dont draw
res2@gsnFrame = False        ;dont advance frame
res2@gsnLeftString = ""
res2@gsnRightString = ""

res2@mpCenterLonF = 180.
res2@mpFillOn = False
res2@mpFillDrawOrder = "PostDraw"
res2@tmXBLabelFontHeightF = 0.02         ; change maj lat tm spacing
res2@tmYLLabelFontHeightF = res2@tmXBLabelFontHeightF
res2@gsnMajorLonSpacing = 50              ; change maj lon tm spacing
;  res2@mpMaxLatF                   = NLAT         ; choose subregion
;  res2@mpMinLatF                   = SLAT
;  res2@mpMaxLonF                   = ELON
;  res2@mpMinLonF                   = WLON
res2@gsnAddCyclic = True ;False
res2@cnFillOn = True;False ;
res2@cnLinesOn = False;True ;
res2@cnLineLabelsOn = False

res2@gsnLeftStringFontHeightF = 0.03
res2@gsnRightStringFontHeightF = 0.03

res2@lbLabelBarOn = False;True ;
res2@lbOrientation = "vertical"
res2@lbTitleOn        =  True                ; turn on title
res2@lbLabelStride    = 2
res2@lbTitleString    = "K"                ; title string
res2@lbTitlePosition  = "Top"              ; title position
res2@lbTitleFontHeightF= .01                ; make title smaller
; res2@lbTitleDirection = "Across"
res2@lbTitleExtentF   = 0.01 ;Default: 0.15
res2@lbLabelFontHeightF = 0.01  ;Default: 0.02
res2@pmLabelBarWidthF = 0.05

res2@cnLevelSelectionMode  = "ManualLevels"
res2@cnMinLevelValF        = -0.50
res2@cnMaxLevelValF        =  0.50
res2@cnLevelSpacingF       =  res2@cnMaxLevelValF/10.

do i = 0,neof-1


res2@gsnLeftString = "CMIP5 MME (EOF"+(i+1)+")"
res2@gsnRightString = sprintf("%5.1f", pcvar5(i)) +"%"
plot(i*2) = gsn_csm_contour_map_ce(wks, rca5(i,:,:), res2)
res2@gsnLeftString = "CMIP6 MME (EOF"+(i+1)+")"
res2@gsnRightString = sprintf("%5.1f", pcvar6(i)) +"%"
plot(i*2+1) = gsn_csm_contour_map_ce(wks, rca6(i,:,:), res2)
end do

resk = True
;resk@txFontHeightF = 0.03
resk@gsnMaximize = True
resk@gsnPaperOrientation = "portrait"   ; force portrait
resk@lbBoxEndCapStyle = "TriangleBothEnds"
;resk@lbOrientation = "vertical"
resk@lbBoxLinesOn = False
;resk@lbBoxMinorExtentF = 0.2
resk@lbLabelFontHeightF = 0.01  ;Default: 0.02
;resk@pmLabelBarWidthF = 0.1
;resk@pmLabelBarHeightF = 0.2
;resk@pmLabelBarParallelPosF = 0.3 ;default 0.5
;resk@pmLabelBarOrthogonalPosF = 0.005 ;default 0.02
; resk@txString = MODEL(im)

; gsn_panel(wks,plot,(/2,1/),resk)

res2@lbLabelBarOn = False;

resk@gsnPanelLabelBar   = True                 ; add common colorbar
gsn_panel(wks,plot,(/2,2/),resk)

;*******************************************
; time series (principal component) plot
;*******************************************

; these four resources allow the user to stretch the plot size, and
; decide exactly where on the page to draw it.

  res = True
  res@gsnDraw = False        ;dont draw
  res@gsnFrame = False        ;dont advance frame
  res@gsnLeftString = ""
  res@gsnRightString = ""
  res@tiYAxisString = ""
  res@vpHeightF = 0.30        ; Changes the aspect ratio
  res@vpWidthF  = 0.6

  res@tmXTOn    = False

  ;res2@gsnScale  = True        ; force text scaling
  ;res@gsnXYBarChart            = True              ; Create bar plot
  ;res@gsnXYBarChartOutlineOnly = True


  res@gsnYRefLine           = 0.0             ; reference line
  ; res@gsnAboveYRefLineColor = "red"           ; above ref line fill red
  ; res@gsnBelowYRefLineColor = "blue"          ; below ref line fill blue
  res@gsnLeftStringFontHeightF  = 0.025
  res@gsnRightStringFontHeightF = 0.025
  res@gsnLeftStringOrthogonalPosF = -0.005

  res@trXMinF               = yrs6
  res@trXMaxF               = 2015

  res3 = res

  res@trYMinF               = -3.
  res@trYMaxF               =  3.

    ndim5  = dimsizes(pca5)
  x_axis5 = fspan(yrs5, yrl5+1, ndim5(1))
    ndim6  = dimsizes(pca6)
  x_axis6 = fspan(yrs6, yrl6+1, ndim6(1))
  ;res@tmXBMode   = "Explicit"
  ;res@tmXBValues = x_axis;-1
  ;res@tmXBLabels = model
  ;res@tmXBLabelAngleF = 45.
  ;res@tmXBLabelFontHeightF = 0.02
; res@tiXAxisString = "year"

res@xyLineThicknessF = 3.0
res@gsnRightString = ""
do i = 0,neof-1

  res@gsnLeftString = "PC"+(i+1)
  res@xyLineColor = "red"
  plot2(i) = gsn_csm_xy (wks,x_axis5,pca5(i,:),res) ;pca
  res@xyLineColor = "black"
  plota = gsn_csm_xy (wks,x_axis6,pca6(i,:),res) ;pca
  overlay(plot2(i), plota)

end do


;************************************************
; Attach text to plot using plot coordinates.
;************************************************
  txres               = True                     ; text mods desired
  txres@txFontHeightF = 0.015                     ; font smaller. default big
  txres@txFontColor   = "red"
  dum  = gsn_add_text(wks,plot2(0),"CMIP5",1870,2.5,txres)
  dum2 = gsn_add_text(wks,plot2(1),"CMIP5",1870,2.5,txres)
  txres@txFontColor   = "black"
  dum1 = gsn_add_text(wks,plot2(0),"CMIP6",1870,2.0,txres)
  dum3 = gsn_add_text(wks,plot2(1),"CMIP6",1870,2.0,txres)


resk@gsnPanelLabelBar   = False                 ; add common colorbar
gsn_panel(wks,plot2,(/2,1/),resk)


;-------------------------------------------------
;    extra lines adding GMST and AOD on PCs
;-------------------------------------------------

cor1 = escorc(gmst6, pca6(0,:))
cor2 = escorc(ado6, pca6(1,:))
print(cor1+" "+cor2)

delete(  res@gsnYRefLine )

  res3@trYMinF               = -0.8
  res3@trYMaxF               =  0.8

  res@xyLineColor = "black"
  res3@xyLineThicknessF = 3.0
  res3@xyLineColor = "blue"
  res@gsnLeftString = "PC1"
  plot2(0) = gsn_csm_xy2 (wks,x_axis6,pca6(0,:),gmst6,res,res3)
  res3@trYMinF               = -2.
  res3@trYMaxF               =  2.
  res@gsnLeftString = "PC2"
  plot2(1) = gsn_csm_xy2 (wks,x_axis6,pca6(1,:),asrhd6,res,res3);asrhd6;ado6,
  ; res3@xyLineColor = "lightblue"
  ; plota = gsn_csm_xy (wks,x_axis5,gmst5,res3) ;pca
  ; overlay(plot2(0), plota)
  res@gsnLeftString = ""

;add CMIP5 mme_eof PCs
do i = 0,neof-1
  res@xyLineColor = "red"
  plota = gsn_csm_xy (wks,x_axis5,pca5(i,:),res) ;pca
  overlay(plot2(i), plota)

end do

  txres@txFontColor   = "red"
  dum  = gsn_add_text(wks,plot2(0),"PC1(CMIP5)",1880,2.5,txres)
  dum2 = gsn_add_text(wks,plot2(1),"PC2(CMIP5)",1880,2.5,txres)
  txres@txFontColor   = "black"
  dum1 = gsn_add_text(wks,plot2(0),"PC1(CMIP6)",1880,2.0,txres)
  dum3 = gsn_add_text(wks,plot2(1),"PC2(CMIP6)",1880,2.0,txres)

  txres@txFontColor   = "blue"
  dum  = gsn_add_text(wks,plot2(0),"GMST R="+sprintf("%5.2f", cor1),1880,1.5,txres)
  dum2 = gsn_add_text(wks,plot2(1),"SWHD R="+sprintf("%5.2f", cor2),1880,1.5,txres)


gsn_panel(wks,plot2,(/2,1/),resk)

end
