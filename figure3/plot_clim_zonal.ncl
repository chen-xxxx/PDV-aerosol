begin
diri = "/glade/work/chenxing/enso/";"/Users/xingchen/Documents/project/ENSO/data/" ;
dirip = "/glade/u/home/chenxing/enso/";"/Users/xingchen/Documents/project/ENSO/pic/" ;

setfileoption("nc","SuppressClose",False)

VAR = "rsds";"rsds";"ts";"clt" ;"od550aer" ;"cloudeffect";"ts" ;  "va" ;"psl" ;
VAR1 = "FSNS";"FSNS" ;"ts"; SWCF exactly the same as cloudeffect result; LWCF represent covective cloud effect the most, around the tropics
EXP = "historical"

yrs = 1920;(/1950,1990/)
yrl = 2014;(/1990,2014/)

wks = gsn_open_wks("png", "clim_cesm_zonal");dirip+
plot = new(10,graphic)                ; create graphic array
plot2 = new(10,graphic)                ; create graphic array

;---------read output---------------

;;;;;;;;;;;;;;;LENS;;;;;;;;;;;;;;;;;;;;
;from clim_lens5.ncl
;;;CMIP5 LENS;;;;;;;;;;;;;;
;CanESM2_r4i1p1_clim_PDI_historical_ts_1950-2014

; fils = systemfunc("ls "+diri+"lens5/CESM1-CAM5*_clim*"+VAR1+"_"+yrs(i)+"-"+yrl(i)+".nc")
fils = systemfunc("ls "+diri+"lens5/CESM1-CAM5*_clim_zonal_*"+VAR1+"_1920-2100.nc");2014.nc")
print(fils)
f   = addfiles(fils, "r")  ;multiple files
ListSetType (f, "join")
clm1  =  dim_avg_n_Wrap(f[:]->axz, 0) ;clim
; clm1 = clm1 - 273.15
; clm1@units = "C"
delete([/fils,f/])
printVarSummary(clm1)
;;;CESM2 with CMIP5 forcing;;;;;;;;;;;;;;
;cesm2_cmip5_forcing_001_clim_PDI_TS_1850-2014

; fils = systemfunc("ls "+diri+"lens5/cesm2_cmip5_forcing*_clim"+VAR1+"_"+yrs(i)+"-"+yrl(i)+".nc")
; fils = systemfunc("ls "+diri+"lens5/cesm2_cmip5_forcing*_clim_zonal_"+VAR1+"_1850-2014.nc")
fils = systemfunc("ls "+diri+"lens5/cesm2-cmip5_*_clim_zonal_"+VAR1+"_1920-2014.nc")
print(fils)
f   = addfiles(fils, "r")  ;multiple files
ListSetType (f, "join")
clm3  = dim_avg_n_Wrap(f[:]->axz, 0)
; clm3 = clm3 - 273.15
; clm3@units = "C"
delete([/fils,f/])
printVarSummary(clm3)


;;;;;;;;;;;;;;;CMIP6 LE;;;;;;;;;;;;;;;;;;;;
; fils = systemfunc("ls "+diri+"lens6/CESM2*_clim_historical_"+VAR+"_"+yrs(i)+"-"+yrl(i)+".nc")
; fils = systemfunc("ls "+diri+"lens6/CESM2_*_clim_zonal_historical_"+VAR+"_1850-2014.nc")
fils = systemfunc("ls "+diri+"lens6/CESM2-CAM6_*.00*_clim_zonal_historical_"+VAR1+"_1850-2014.nc")
print(fils)
f   = addfiles(fils, "r")  ;multiple files
ListSetType (f, "join")
; clm2_d  = dim_avg_n_Wrap(f[:]->axz, 0)
clm2  = dim_avg_n_Wrap(f[:]->axz, 0)
; fils2 = systemfunc("ls "+diri+"lens6/CESM2*_clim_zonal_historical_rsus_1850-2014.nc")
; f2   = addfiles(fils2, "r")  ;multiple files
; ListSetType (f2, "join")
; clm2_u  = dim_avg_n_Wrap(f2[:]->axz, 0)
; clm2 = clm2_d
; clm2 = clm2_d - clm2_u

; clm2 = clm2 - 273.15
; clm2@units = "C"
; clm2&time = ispan()
delete([/fils,f/])

printVarSummary(clm2)


;--------------------------------------
;  interpolate

LAT = clm2&lat

lat1 = clm1&lat
clm1_r = linint1_Wrap (lat1, clm1, True, LAT, 0)
lat3 = clm3&lat
clm3_r = linint1_Wrap (lat3, clm3, True, LAT, 0)

; ;-------difference---------------------------------

;;; Remove climatology during a SAME PERIOD!
clm1_r(:(2014-1920),:) = dim_rmvmean_n_Wrap(clm1_r(:(2014-1920),:),0)
clm2((1920-1850):,:) = dim_rmvmean_n_Wrap(clm2((1920-1850):,:),0)
clm3_r = dim_rmvmean_n_Wrap(clm3_r,0)

dclm1 = clm1_r(:(2014-1920),:)
dclm1 = clm2((1920-1850):,:) - clm1_r(:(2014-1920),:)

dclm2 = clm1_r(:(2014-1920),:)
dclm2 = clm2((1920-1850):,:) - clm3_r;((1920-1850):,:)

dclm3 = clm1_r(:(2014-1920),:)
dclm3 = clm3_r - clm1_r(:(2014-1920),:)

;--------output-------------
fon=diri+VAR+"_clim_zonal_difference_cesm_1920-2014.nc";
system("rm -f "+fon)
fo=addfile(fon,"c")
fo->dclm1 = dclm1
fo->dclm2 = dclm2
fo->dclm3 = dclm3


; ;-------t-test---------------------------------
; pra_std = dim_stddev_n_Wrap(rc, 0)

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
gsn_define_colormap(wks, "NCV_blu_red")


res2 = True
res2@gsnDraw = False        ;dont draw
res2@gsnFrame = False        ;dont advance frame
res2@gsnLeftString = ""
res2@gsnRightString = ""
res2@vpHeightF = 0.3
res2@vpWidthF  = 0.8

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
res2@cnInfoLabelOn = False

res2@gsnLeftStringFontHeightF = 0.02
res2@gsnRightStringFontHeightF = res2@gsnLeftStringFontHeightF
res2@lbLabelBarOn = True;
res2@lbOrientation = "Vertical"
res2@lbBoxLinesOn  = False
res2@lbTitleOn        =  True                ; turn on title
res2@lbLabelStride    = 2
res2@lbTitleString    = "W/m2"                ; title string
res2@lbTitlePosition  = "Top"              ; title position
res2@lbTitleFontHeightF= .015                ; make title smaller
res2@lbTitleDirection = "Across"
res2@lbTitleExtentF   = 0.01 ;Default: 0.15
res2@lbLabelFontHeightF = 0.015  ;Default: 0.02
; res2@pmLabelBarWidthF = 0.05
res2@lbBoxEndCapStyle = "TriangleBothEnds"

res2@tmXTOn = False
res2@tmYROn = False
res2@tmXBMode   = "Explicit"
res2@tmXBValues = ispan(0,93,10) ;clm1&year
res2@tmXBLabels = ispan(1920,2014,10)

res2@cnLevelSelectionMode  = "ManualLevels"
; res2@cnMinLevelValF        = -20.
; res2@cnMaxLevelValF        = 30.0
; res2@cnLevelSpacingF       = 5.0

res2@gsnLeftString = "CESM1"
; res2@gsnRightString = yrs(i)+"-"+yrl(i)
plot(0) = gsn_csm_time_lat(wks, clm1(lat|:,year|:), res2) ;gsn_csm_contour_map_ce

res2@gsnLeftString =  "CESM2 with CMIP5 forcing"
plot(1) = gsn_csm_time_lat(wks, clm3(lat|:,year|:), res2)

res2@gsnLeftString =  "CESM2"
plot(2) = gsn_csm_time_lat(wks, clm2(lat|:,year|:), res2)

res2@cnMinLevelValF        = -3.0
res2@cnMaxLevelValF        =  3.0
res2@cnLevelSpacingF       =  res2@cnMaxLevelValF/10.

; res2@tmYLLabelStride         = 1
; res2@tmYLMaxTicks = 15 ;Used with Automatic mode. Sets the maximum number of tick marks that will be chosen.
res2@tmYLMinorOn = False
res2@tmYLMode            = "Explicit"
res2@tmYLValues          = (/-80,-60,-40,-20,0,20,40,60,80/)
res2@tmYLLabels          = (/"80S","60S","40S","20S","0","20N","40N","60N","80N"/)
res2@tmYMajorGrid      = True
res2@tmYMajorGridLineDashPattern = 2
res2@tmYMajorGridLineColor = "grey55"
res2@tmXMajorGrid      = res2@tmYMajorGrid
res2@tmXMajorGridLineDashPattern = res2@tmYMajorGridLineDashPattern
res2@tmXMajorGridLineColor = res2@tmYMajorGridLineColor
res2@tmXBLabelFontHeightF = 0.015
res2@tmYLLabelFontHeightF = res2@tmXBLabelFontHeightF

res2@gsnRightString = "SW"
  res2@gsnLeftString = "CESM2 - CESM1"
  plot2(0) = gsn_csm_time_lat(wks, dclm1(lat|:,year|:), res2)

  res2@gsnLeftString =  "CESM2 - CESM2-CMIP5"
  plot2(1) = gsn_csm_time_lat(wks, dclm2(lat|:,year|:), res2)

  res2@gsnLeftString =  "CESM2-CMIP5 - CESM1"
  plot2(2) = gsn_csm_time_lat(wks, dclm3(lat|:,year|:), res2)

delete(res2)


resk = True
;resk@txFontHeightF = 0.03
resk@gsnPanelLabelBar   = False                 ; add common colorbar
resk@gsnMaximize = True
resk@gsnPaperOrientation = "portrait"   ; force portrait
resk@lbBoxEndCapStyle = "TriangleBothEnds"
resk@lbOrientation = "Vertical"
resk@lbBoxLinesOn = False
resk@lbTitleString    = "W/m2"                ; title string
resk@lbTitlePosition  = "Top"              ; title position
resk@lbLabelStride    = 2
resk@lbTitleDirection = "Across"
;resk@lbBoxMinorExtentF = 0.2
; resk@lbLabelFontHeightF = 0.01  ;Default: 0.02
resk@lbTitleExtentF   = 0.01 ;Default: 0.15
;resk@pmLabelBarWidthF = 0.1
;resk@pmLabelBarHeightF = 0.2
;resk@pmLabelBarParallelPosF = 0.3 ;default 0.5
;resk@pmLabelBarOrthogonalPosF = 0.005 ;default 0.02
resk@txString = VAR+" mean state"
gsn_panel(wks,plot,(/3,1/),resk)
gsn_panel(wks,plot2,(/3,1/),resk)

end
