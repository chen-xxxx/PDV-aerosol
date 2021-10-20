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
VARh  = "SSH" ;"ts" ;"pr" ; "zg300" ;"psl" "ts"
VARpr  = "pr" ; "zg300" ;"psl" "ts"
VARf  = "FSNS"
VARf2  = "FSNSC"
VARpsl  = "psl"
VARv  = "va200"
; units = "mm/day"
LR =  "reg_mme" ;"reg";"reg_mme" ;"regLag" ;

wks = gsn_open_wks("png", dirip+"reg_cesm2");
plot = new(30,graphic)                ; create graphic array

;---------read output---------------

; from reg_pdi_cesm2.ncl
fils = systemfunc("ls "+diri+"cesmle/CESM2-CAM6_*.01*_"+LR+"_"+IND+"_"+VAR+"_1850-2014.nc");
f1   = addfiles(fils, "r")
ListSetType (f1, "join")
ts = dim_avg_n_Wrap(f1[:]->rc ,0)
delete([/fils,f1/])

fils = systemfunc("ls "+diri+"cesmle/CESM2-CAM6_*.01*_"+LR+"_"+IND+"_"+VARh+"_1850-2014.nc");
f1   = addfiles(fils, "r")
ListSetType (f1, "join")
ssh = dim_avg_n_Wrap(f1[:]->rc ,0)
delete([/fils,f1/])

fils = systemfunc("ls "+diri+"cesmle/CESM2-CAM6_*.01*_"+LR+"_"+IND+"_"+VARpr+"_1850-2014.nc");
f1   = addfiles(fils, "r")
ListSetType (f1, "join")
pr = dim_avg_n_Wrap(f1[:]->rc ,0)
pr = pr*1000*60*60*24 ;m/s-->1000*60*60*24mm/day
pr@units = "mm/day"
delete([/fils,f1/])

fils = systemfunc("ls "+diri+"cesmle/CESM2-CAM6_*.01*_"+LR+"_"+IND+"_"+VARf+"_1850-2014.nc");
f1   = addfiles(fils, "r")
ListSetType (f1, "join")
fsns = dim_avg_n_Wrap(f1[:]->rc ,0)
delete([/fils,f1/])

fils = systemfunc("ls "+diri+"cesmle/CESM2-CAM6_*.01*_"+LR+"_"+IND+"_"+VARf2+"_1850-2014.nc");
f1   = addfiles(fils, "r")
ListSetType (f1, "join")
fsnsc = dim_avg_n_Wrap(f1[:]->rc ,0)
delete([/fils,f1/])
clde = fsns
clde = fsns - fsnsc
printVarSummary(clde)

fils = systemfunc("ls "+diri+"cesmle/CESM2-CAM6_*.01*_"+LR+"_"+IND+"_"+VARpsl+"_1850-2014.nc");
f1   = addfiles(fils, "r")
ListSetType (f1, "join")
psl = dim_avg_n_Wrap(f1[:]->rc ,0)
delete([/fils,f1/])

fils = systemfunc("ls "+diri+"cesmle/CESM2-CAM6_*.01*_"+LR+"_"+IND+"_"+VARv+"_1850-2014.nc");
f1   = addfiles(fils, "r")
ListSetType (f1, "join")
v200 = dim_avg_n_Wrap(f1[:]->rc ,0)
delete([/fils,f1/])

; ; from reg_pdi_cesmle.ncl
; ;cesm2_cmip5_forcing_007_reg_PDI_ua850_1991-2014.nc
; fils = systemfunc("ls "+diri+"cesmle/cesm2-cmip5_*_"+LR+"_"+IND+"_"+VAR+"_1920-2014.nc");04.nc");
; f1   = addfiles(fils, "r")
; ListSetType (f1, "join")
; t0 = dim_avg_n_Wrap(f1[:]->rc ,0)
;
; fils = systemfunc("ls "+diri+"cesmle/cesm2-cmip5_*_"+LR+"_"+IND+"_"+VARh+"_1920-2014.nc");04.nc");
; f1   = addfiles(fils, "r")
; ListSetType (f1, "join")
; h0 = dim_avg_n_Wrap(f1[:]->rc ,0)
; delete([/fils,f1/])
; printVarSummary(h0)

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
res3 = res2

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
res2@lbLabelStride    = 4
res2@lbTitleString    = "K"                ; title string
res2@lbTitlePosition  = "Right"              ; title position
res2@lbTitleFontHeightF= .015                ; make title smaller
res2@lbTitleDirection = "Across"
; res2@lbTitleExtentF   = 0.01 ;Default: 0.15
; res2@lbLabelFontHeightF = 0.01  ;Default: 0.02
; res2@pmLabelBarWidthF = 0.05
res2@lbBoxEndCapStyle = "TriangleBothEnds"

; res2@cnLevelSelectionMode  = "ManualLevels"
; res2@cnMinLevelValF        = -0.4
; res2@cnMaxLevelValF        =  0.4
; res2@cnLevelSpacingF       =  res2@cnMaxLevelValF/10.

res3@cnFillOn  = False
res3@cnInfoLabelOn            = False
;res3@cnLinesOn = True
;res3@cnLineLabelsOn = True ;
res3@cnLevelFlags = "LineAndLabel" ;control over whether a line and/or a line label is to appear at each contour level
res3@cnLineLabelBackgroundColor = -1
res3@cnLineLabelInterval = 1
res3@cnLineLabelPlacementMode = "constant"
res3@cnLineThicknessF = 2.0
res3@cnLineLabelFontHeightF = 0.01
; res3@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
; res3@cnLevels = (/-6.,-4.,-2.,2.,4.,6.,8.,10./)


res2@gsnLeftString = ""

res2@lbLabelBarOn = True;
res2@gsnLeftStringFontHeightF = 0.02
res2@gsnRightStringFontHeightF = res2@gsnLeftStringFontHeightF

; res2@lbLabelBarOn = False;
res2@cnLevelSelectionMode  = "ManualLevels"
res2@cnMinLevelValF        = -0.5;
res2@cnMaxLevelValF        =  0.5;
res2@cnLevelSpacingF       =  res2@cnMaxLevelValF/10.

res2@gsnRightString = "CESM2"
    ; res2@gsnRightString = "CESM2 with CMIP5 forcing"
    ; plot(0) = gsn_csm_contour_map_ce(wks, t0, res2)
    res2@gsnLeftString = "TS & SSH"
    res2@lbTitleString    = "K"                ; title string
    plot(2) = gsn_csm_contour_map_ce(wks, ts, res2)

    res2@cnMinLevelValF        = -2.0;
    res2@cnMaxLevelValF        =  2.0;
    res2@cnLevelSpacingF       =  res2@cnMaxLevelValF/10.
    res2@gsnLeftString = "SSH"
    res2@lbTitleString    = "cm"                ; title string
    ; plot(1) = gsn_csm_contour_map_ce(wks, ssh, res2)

    res2@cnMinLevelValF        = -0.5;
    res2@cnMaxLevelValF        =  0.5;
    res2@cnLevelSpacingF       =  res2@cnMaxLevelValF/10.
    res2@gsnLeftString = "Pr"
    res2@lbTitleString    = "mm/day"                ; title string
    ; plot(2) = gsn_csm_contour_map_ce(wks, pr, res2)

    res2@cnMinLevelValF        = -2.0;
    res2@cnMaxLevelValF        =  2.0;
    res2@cnLevelSpacingF       =  res2@cnMaxLevelValF/10.
    res2@gsnLeftString = "clear-sky"
    res2@lbTitleString    = "Wm-2"                ; title string
    plot(0) = gsn_csm_contour_map_ce(wks, fsnsc, res2)
    res2@gsnLeftString = "cloud effect & Pr"
    res2@lbTitleString    = "Wm-2"                ; title string
    plot(1) = gsn_csm_contour_map_ce(wks, clde, res2)

    res2@cnMinLevelValF        = -30.0;
    res2@cnMaxLevelValF        =  30.0;
    res2@cnLevelSpacingF       =  res2@cnMaxLevelValF/10.
    res2@gsnLeftString = "PSL & V200"
    res2@lbTitleString    = "Pa"                ; title string
    plot(3) = gsn_csm_contour_map_ce(wks, psl, res2)

    res2@cnMinLevelValF        = -0.5;
    res2@cnMaxLevelValF        =  0.5;
    res2@cnLevelSpacingF       =  res2@cnMaxLevelValF/10.
    res2@gsnLeftString = "V200"
    res2@lbTitleString    = "m/s"                ; title string
    ; plot(4) = gsn_csm_contour_map_ce(wks, v200, res2)

    ;contour
    res3@cnLevelSpacingF = 0.1
    plotc = gsn_csm_contour(wks, pr, res3)
    plotc = ColorNegDashZeroPosContour(plotc,"brown",-1,"green")
    overlay(plot(1),plotc)

    res3@cnLevelSpacingF = 0.3
    plotc = gsn_csm_contour(wks, ssh, res3)
    plotc = ColorNegDashZeroPosContour(plotc,"brown",-1,"green")
    overlay(plot(2),plotc)

    res3@cnLevelSpacingF = 0.1
    plotc = gsn_csm_contour(wks, v200, res3)
    plotc = ColorNegDashZeroPosContour(plotc,"brown",-1,"green")
    overlay(plot(3),plotc)

    ; vcres@vcGlyphStyle            = "Fillarrow"    ; turn on curly vectors
    vcres@vcMinFracLengthF        = 0.2
    vcres@vcMinDistanceF          = 0.018
    vcres@vcRefMagnitudeF         = 0.2;1.0             ; define vector ref mag
    vcres@vcRefLengthF            = 0.04             ; define length of vec ref

    vcres@vcRefAnnoOn             = True
    vcres@vcRefAnnoPerimOn          = False          ;参考矢量的边框
    vcres@vcRefAnnoString2          = "m/s"            ;not draw the word"reference vector"
    vcres@vcRefAnnoOrthogonalPosF = -.45            ; move ref vector up

    vcres@lbLabelBarOn = False
    vcres@vcFillArrowFillColor = "black"

    ; vector= gsn_csm_vector(wks,com_u5,com_v5,vcres)
    ; overlay(plot(0),vector)


resk = True
;resk@txFontHeightF = 0.03
; resk@gsnPanelLabelBar   = True                 ; add common colorbar
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
resk@txString = " "
gsn_panel(wks,plot,(/2,2/),resk)



end
