begin
diri = "/glade/work/chenxing/enso/"
dirip = "/glade/u/home/chenxing/enso/"

diri1 = "/glade/collections/cmip/cmip5/"
diri2 = "/glade/work/chenxing/CMIP5/historical/remap/tos/"
;from cdo_cmip_data.ncl
diri3 = "/glade/scratch/chenxing/cmip5/"
SEASON = (/"DJF(-1)","MAM(-1)","JJA(-1)","SON(-1)","DJF(0)" /)

NLAT =  70; 65; 5; 60;
SLAT =  -70;-5;-60;
WLON =  100;120;
ELON =  300;290;


IND  = "PDI" ;"nino34";
; LEV  = "200";"200" ;
VAR  = "TS" ;"pr" ; "zg300" ;"psl" "ts"
VAR2  = "ts" ;"pr" ; "zg300" ;"psl" "ts"
VARh  = "SSH" ;"ts" ;"pr" ; "zg300" ;"psl" "ts"
VARh2  = "zos" ;"ts" ;"pr" ; "zg300" ;"psl" "ts"
; units = "mm/day"
LR =  "reg" ;"reg";"reg_mme" ;"regLag" ;

wks = gsn_open_wks("png", dirip+"reg_cesm_obs");
plot = new(30,graphic)                ; create graphic array

;---------read output---------------
; from reg_pdi_lens5.ncl or reg_pdi_cesmle.ncl
;CESM1-CAM5_r6i1p1_reg_PDI_historical_ts_1920-2014.nc
fils = systemfunc("ls "+diri+"lens5/CESM1-CAM5_*_"+LR+"_"+IND+"_historical_"+VAR2+"_1920-2004.nc");
print(fils)
f1   = addfiles(fils, "r")
ListSetType (f1, "join")
t1 = dim_avg_n_Wrap(f1[:]->rc ,0)
if (VAR2.eq."zos") then
  t1 = t1*100.
  ;units from cm --> m
end if

; from reg_pdi_cesmle.ncl
fils = systemfunc("ls "+diri+"cesmle/CESM1-CAM5_historical_*_"+LR+"_"+IND+"_"+VARh2+"_1920-2014.nc");04.nc");
print(fils)
f1   = addfiles(fils, "r")
ListSetType (f1, "join")
h1 = dim_avg_n_Wrap(f1[:]->rc ,0)
if (VARh2.eq."zos") then
  h1 = h1*100.
  ;units from cm --> m
end if
delete([/fils,f1/])

; from reg_pdi_lens6.ncl
;CESM2_r4i1p1f1_reg_PDI_historical_va200_1991-2014.nc
; fils = systemfunc("ls "+diri+"lens5/CESM2_*_"+LR+"_"+IND+"_historical_"+VAR+"_1850-2014.nc");

; from reg_pdi_cesm2.ncl
fils = systemfunc("ls "+diri+"cesmle/CESM2-CAM6_*_"+LR+"_"+IND+"_"+VAR+"_1850-2014.nc");
f1   = addfiles(fils, "r")
ListSetType (f1, "join")
t2 = dim_avg_n_Wrap(f1[:]->rc ,0)
delete([/fils,f1/])

fils = systemfunc("ls "+diri+"cesmle/CESM2-CAM6_*_"+LR+"_"+IND+"_"+VARh+"_1850-2014.nc");
f1   = addfiles(fils, "r")
ListSetType (f1, "join")
h2 = dim_avg_n_Wrap(f1[:]->rc ,0)
delete([/fils,f1/])

; from reg_pdi_cesmle.ncl
;cesm2_cmip5_forcing_007_reg_PDI_ua850_1991-2014.nc
fils = systemfunc("ls "+diri+"cesmle/cesm2-cmip5_*_"+LR+"_"+IND+"_"+VAR+"_1920-2014.nc");04.nc");
f1   = addfiles(fils, "r")
ListSetType (f1, "join")
t0 = dim_avg_n_Wrap(f1[:]->rc ,0)

fils = systemfunc("ls "+diri+"cesmle/cesm2-cmip5_*_"+LR+"_"+IND+"_"+VARh+"_1920-2014.nc");04.nc");
f1   = addfiles(fils, "r")
ListSetType (f1, "join")
h0 = dim_avg_n_Wrap(f1[:]->rc ,0)
delete([/fils,f1/])
printVarSummary(h0)

; from reg_pdi_cesmle.ncl
; fils = systemfunc("ls "+diri+"cesmle/cesm1_le_xghg_*_"+LR+"_"+IND+"_"+VAR+"_1920-2014.nc");04.nc");
; f1   = addfiles(fils, "r")
; ListSetType (f1, "join")
; t_xghg = dim_avg_n_Wrap(f1[:]->rc ,0)
; delete([/fils,f1/])
;
; fils = systemfunc("ls "+diri+"cesmle/cesm1_le_xaer_*_"+LR+"_"+IND+"_"+VAR+"_1920-2014.nc");04.nc");
; f1   = addfiles(fils, "r")
; ListSetType (f1, "join")
; t_xaer = dim_avg_n_Wrap(f1[:]->rc ,0)
; delete([/fils,f1/])

;read obs PDV results
;from obs_reg.ncl
f0   = addfile(diri+"obs_reg_PDI_sst_1854-2019.nc", "r")
rco  = f0->rc(::-1,:)
printVarSummary(rco)

f0   = addfile(diri+"obs_reg_PDI_ssh_1958-2008.nc", "r")
ho  = f0->rc
; ho = ho*100.
; ho@units = "centimeter"
printVarSummary(ho)

;---------interpolate---------------------
;change resolution for SODA

    lat = ho&lat
    lon = ho&lon
    ; nlat0 = dimsizes(ho&lat) ;target dimension size
    ; nlon0 = dimsizes(ho&lon) ;target dimension size
    ; klon0 = fspan(0, 360, nlon0) ;target dimension
    ; klat0 = fspan(-90, 90, nlat0) ;target dimension

    ; nlat = dimsizes(rco&lat) ;target dimension size
    ; nlon = dimsizes(rco&lon) ;target dimension size
    ; klon = fspan(0, 360, nlon) ;target dimension
    ; klat = fspan(-90, 90, nlat) ;target dimension
    ho_r= linint2_Wrap(lon, lat, ho, True, rco&lon, rco&lat, 0);klon,klat,0);
    ; delete([/lat,lon,klat,klon/]);xa0
    ; ho_r!0 = "lat"
    ; ho_r!1 = "lon"

    copy_VarMeta(rco, ho_r)
    printVarSummary(ho_r)

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
gsn_define_colormap(wks, "NCV_blu_red")
; gsn_define_colormap(wks, "MPL_BrBG")


res2 = True
res2@gsnDraw = False        ;dont draw
res2@gsnFrame = False        ;dont advance frame
res2@gsnLeftString = ""
res2@gsnRightString = ""
res2@vpWidthF  = 0.6

vcres = res2
resc  = res2

res2@mpCenterLonF = 180.
res2@mpFillOn = False
res2@mpFillDrawOrder = "PostDraw"
 res2@mpMaxLatF                   = NLAT         ; choose subregion
 res2@mpMinLatF                   = SLAT
 res2@mpMaxLonF                   = ELON
 res2@mpMinLonF                   = WLON
res2@gsnAddCyclic = True ;False
res2@cnFillOn = True;False ;
res2@cnLinesOn = False;True ;
res2@cnLineLabelsOn = False
res2@tmXBLabelFontHeightF = 0.018         ; change maj lat tm spacing
res2@tmYLLabelFontHeightF = res2@tmXBLabelFontHeightF
res2@gsnMajorLonSpacing = 50              ; change maj lon tm spacing

res2@gsnLeftStringFontHeightF = 0.02
res2@gsnRightStringFontHeightF = res2@gsnLeftStringFontHeightF
res2@lbOrientation = "Horizontal"
res2@lbBoxLinesOn  = False
res2@lbTitleOn        =  True                ; turn on title
res2@lbLabelStride    = 2
; res2@lbTitleString    = "K"                ; title string
res2@lbTitlePosition  = "Right"              ; title position
res2@lbTitleFontHeightF= .015                ; make title smaller
; res2@lbTitleDirection = "Across"
res2@lbTitleExtentF   = 0.01 ;Default: 0.15
res2@lbLabelFontHeightF = 0.01  ;Default: 0.02
; res2@pmLabelBarWidthF = 0.05

res2@lbLabelBarOn = False;
res2@cnLevelSelectionMode  = "ManualLevels"
res2@cnMinLevelValF        = -0.5;
res2@cnMaxLevelValF        =  0.5;
res2@cnLevelSpacingF       =  res2@cnMaxLevelValF/10.

res2@gsnLeftString = ""
res2@gsnRightString = "ERSST"
plot(0) = gsn_csm_contour_map_ce(wks, rco, res2)
    res2@gsnRightString = "CESM1"
    plot(1) = gsn_csm_contour_map_ce(wks, t1, res2)
    res2@gsnRightString = "CESM2 with CMIP5 forcing"
    plot(2) = gsn_csm_contour_map_ce(wks, t0, res2)
    res2@gsnRightString = "CESM2"
    plot(3) = gsn_csm_contour_map_ce(wks, t2, res2)

    resc@cnLineThicknessF = 1.5                      ; thicker lines
    ; resc@cnLineLabelsOn   = False                    ; no line labels
    resc@cnLevelSpacingF = 1.0
    resc@cnLineLabelBackgroundColor = "Transparent"
    resc@cnSmoothingOn = True
    ; resc@cnSmoothingTensionF = 5

    plota = gsn_csm_contour(wks, ho_r, resc)
    plota = ColorNegDashZeroPosContour(plota,"red","magenta","blue")
    overlay(plot(0),plota)
    plota = gsn_csm_contour(wks, h1, resc)
    plota = ColorNegDashZeroPosContour(plota,"red","magenta","blue")
    overlay(plot(1),plota)
    plota = gsn_csm_contour(wks, h0, resc)
    plota = ColorNegDashZeroPosContour(plota,"red","magenta","blue")
    overlay(plot(2),plota)
    plota = gsn_csm_contour(wks, h2, resc)
    plota = ColorNegDashZeroPosContour(plota,"red","magenta","blue")
    overlay(plot(3),plota)


resk = True
;resk@txFontHeightF = 0.03
resk@gsnPanelLabelBar   = True                 ; add common colorbar
resk@gsnMaximize = True
resk@gsnPaperOrientation = "portrait"   ; force portrait
resk@lbBoxEndCapStyle = "TriangleBothEnds"
resk@lbOrientation = "Horizontal"
resk@lbBoxLinesOn = False
resk@lbTitleString    = "K"                ; title string
resk@lbTitlePosition  = "Right"              ; title position
resk@lbTitleDirection = "Across"
resk@lbTitleFontHeightF= .015                ; make title smaller
;resk@lbBoxMinorExtentF = 0.2
resk@lbLabelFontHeightF = 0.01  ;Default: 0.02
;resk@pmLabelBarWidthF = 0.1
;resk@pmLabelBarHeightF = 0.2
;resk@pmLabelBarParallelPosF = 0.3 ;default 0.5
;resk@pmLabelBarOrthogonalPosF = 0.005 ;default 0.02
; resk@txString = " regression onto "+IND
gsn_panel(wks,plot,(/2,2/),resk)


end
