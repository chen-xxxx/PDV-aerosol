begin

diri  = "/glade/work/chenxing/enso/";
dirip = "/glade/u/home/chenxing/enso/";

neof = 1


; MODEL6_ESM = (/"CanESM5","CESM2","E3SM-1-0",\
;         "MPI-ESM1-2-HR","MPI-ESM1-2-LR","MRI-ESM2-0"/)
; MODEL6_CM = (/"GISS-E2-1-G","INM-CM5-0","IPSL-CM6A-LR","MIROC6","NorCPM1" /)

; nens6_esm = (/25,11,5,7,10, 5/)
; nens6_cm = (/12,10,32,10,30/)

yrs5 = 1861
yrl5 = 2015
nyr5 = yrl5 - yrs5 +1
yrs6 = 1850
yrl6 = 2014
nyr6 = yrl6 - yrs6 +1

;;;;touch here;;;;;;;;;;;;
EXP5 = "historical";"historicalNat" ;"historicalGHG" ;
EXP6 = "historical";"hist-aer";"hist-Nat" ;"hist-GHG" ;

;don't filter pdv pc, it's already filtered, double filter will shortern data...

yrs0 = (/1861,1950/) ; 1950;1861;1920;
yrl = 2006; 2014;

wks = gsn_open_wks("png", dirip+"cmip_index_bar");
plot = new(10,graphic)                ; create graphic array

do iy = 0,0;1
  yrs = yrs0(iy)
  print(yrs+"-"+yrl)
; MME EOF 1 & 2
do i = 0,1
;--------read-------------
; f1 = addfile(diri+"cmip6_historical_PDI2_mme.nc" , "r" )
; refs = f1->cp6_a
f1 = addfile(diri+"cmip6/cmip6_historical_mme.eof_1850-2014.nc" , "r" )
refs = f1->pc(i,(yrs-yrs6)*12:)

; results of relationship remain similar as using cmip5 mme
f1 = addfile(diri+"cmip5/cmip5_historical_mme.eof_1861-2005.nc" , "r" )
refs5 = f1->pc(i,(yrs-yrs5)*12:)


; from plot_cmip_index_xy.ncl
;"EACSS" ;"EAS" ;"PDI" ; "NPCSS" ;"NPC" ;"NPS" ;"NPAOD" ;"PDI";"TPI" ;"NPI" ;"AMO" ;"pdo" ;"nh-sh" ;"GMAOD" ;"GMSW" ;
IND = "PDI"
f1 = addfile(diri+"cmip5_historical_PDI_mme.nc" , "r" )
e51 = f1->cp5_a2((yrs-yrs5)*12:)
e52 = f1->cp5_plus_a((yrs-yrs5)*12:)
e53 = f1->cp5_minus_a((yrs-yrs5)*12:)
; s51 = avg(f1->std_5)
; s52 = avg(f1->std_5_plus)
; s53 = avg(f1->std_5_minus)

f1 = addfile(diri+"cmip6_historical_PDI_mme.nc" , "r" )
e61 = f1->cp6_a2((yrs-yrs6)*12:)
s61 = avg(f1->std_6)

; from lens/plot_cesm_xy.ncl
fo = addfile(diri+"cesm_PDI_mme_1850-2014.nc" , "r" )
pca_cesm1 = dim_rmvmean_n_Wrap(fo->pca_cesm1((yrs-yrs6)*12:),0)
pca_cesm2 = pca_cesm1
pca_cesm2((1920-yrs)*12:) = dim_rmvmean_n_Wrap(fo->pca_cesm2((1920-yrs6)*12:),0)
pca_cesm1_cmip5 = pca_cesm1
pca_cesm1_cmip5((1920-yrs)*12:) = dim_rmvmean_n_Wrap(fo->pca_cesm1_cmip5((1920-yrs6)*12:),0)
s62 = avg(fo->std_cesm2)
s63 = avg(fo->std_cesm1_cmip5)

printVarSummary(e53)
printVarSummary(refs)
printVarSummary(pca_cesm2)
printVarSummary(e61)

;(:(2006-yrs)*12-1)
c51 = regCoef(refs(:(2006-yrs)*12-1) , e51(:(2006-yrs)*12-1)) ;regCoef ;regline_stats ;escorc
c52 = regCoef(refs(:(2006-yrs)*12-1) , e52(:(2006-yrs)*12-1))
c53 = regCoef(refs(:(2006-yrs)*12-1) , e53(:(2006-yrs)*12-1))
; c51 = regline_stats(refs5 , e51) ;regCoef ;regline_stats
; c52 = regline_stats(refs5 , e52)
; c53 = regline_stats(refs5 , e53)
c61 = regCoef(refs,  e61)
c62 = regCoef(refs,  pca_cesm2)
c63 = regCoef(refs,  pca_cesm1_cmip5)
print("External forcing EOF"+(i+1)+" correlation with PDI in CMIP6")
print(" CMIP5 MME is "+ c51)
print(" CMIP5 PLUS is "+ c52)
print(" CMIP5 MINUS is "+ c53)
print(" CMIP6 MME is "+ c61)
print(" cesm2 is "+ c62)
print(" cesm2 cmip5Forcing is "+ c63)

cor = (/c51,c61,c52,c53,c62,c63/)
nc = toint((/nyr5,nyr6,nyr5,nyr5,nyr6,nyr6/)/8.)
; ;correlation Coefficient significant test
; rt     = rtest(cor, nc, 0)
;regression coefficient significant test
tval = (/c51@tval,c61@tval,c52@tval,c53@tval,c62@tval,c63@tval/)
df = (/c51@nptxy,c61@nptxy,c52@nptxy,c53@nptxy,c62@nptxy,c63@nptxy/)
print(tval)
b = tval
b = 0.5
;the tval that comes with regcoef may be not right
df = toint(1800/8.0)
tval = cor*sqrt(df)/sqrt(1-cor^2)
print(tval)
print(df)
rt = (1.-betainc( df/(df+tval^2), df/2.0, b))*100.  ; probability in %
sigl = where(rt.ge.95., 1, cor@_FillValue)

print(cor+" "+rt)
print(df)
;-----------output-----------------------------
asciiwrite ("~/enso/bar_cor_mme_"+(i+1)+"_"+yrs+".txt" , sprintf("%9.6f", cor));(/c51,c52,c53,c61,c62,c63/) ))
; asciiwrite ("~/enso/bar_reg_err_"+(i+1)+"_"+yrs+".txt" , sprintf("%9.6f", (/c51@RSE,c52@RSE,c53@RSE,c61@RSE,c62@RSE,c63@RSE/) ))
asciiwrite ("~/enso/bar_cor_err_"+(i+1)+"_"+yrs+".txt" , sprintf("%9.6f", rt));(/s51,s52,s53,s61,s62,s63/) ))


;--------------plot-------------------


;*******************************************
; time series (principal component) plot
;*******************************************

  gsn_define_colormap(wks,"seaice_2")
  colors = ispan(2, 17, 1)   ; indices into color table
  colors2 = ispan(2, 9, 1)   ; indices into color table
  colors1 = ispan(10, 18, 1)   ; indices into color table


; these four resources allow the user to stretch the plot size, and
; decide exactly where on the page to draw it.

  res = True
  res@gsnDraw = False        ;dont draw
  res@gsnFrame = False        ;dont advance frame
  res@gsnLeftString = ""
  res@gsnRightString = ""
  res@vpHeightF = 0.3
  res@vpWidthF  = 0.6

  res@tmXTOn    = False
  res@tmYROn    = False
  res@gsnXYBarChart            = True              ; Create bar plot
  ;res@gsnXYBarChartOutlineOnly = True


  res@gsnYRefLine           = 0.0             ; reference line
  ; res@gsnAboveYRefLineColor = "red"           ; above ref line fill red
  ; res@gsnBelowYRefLineColor = "blue"          ; below ref line fill blue
  ; res@gsnLeftStringFontHeightF  = 0.03
  ; res@gsnRightStringFontHeightF = 0.03

  x_axis = ispan(1, 6, 1)
  ;res@tmXBMode   = "Explicit"
  ;res@tmXBValues = x_axis;-1
  ;res@tmXBLabels = model
  ;res@tmXBLabelAngleF = 45.
  ;res@tmXBLabelFontHeightF = 0.02
  res@tiYAxisString = ""
  res@tiXAxisString = ""

  res@xyMonoLineColor = False
  res@xyMonoDashPattern = True

  res@trYMinF               = -1.0
  res@trYMaxF               =  1.0


;MODEL
res@xyLineThicknessF = 3.0
; res@gsnRightStringOrthogonalPosF = -0.2
; res@gsnRightStringParallelPosF = 0.1

res@gsnLeftString = yrs+"-"+yrl
res@gsnRightString = "EOF"+(i+1)
res@xyLineColor = "black"
plot(i*2+iy) = gsn_csm_xy (wks,x_axis, (/c51,c52,c53,c61,c62,c63 /) ,res) ;x_axis2, com_pc

;------------------------------------------------
resk = True
;resk@txFontHeightF = 0.03
resk@gsnPanelLabelBar   = False                 ; add common colorbar
resk@gsnMaximize = True
resk@gsnPaperOrientation = "portrait"   ; force portrait
resk@txString = ""

delete([/refs,e51,e52,e53,e61,pca_cesm2,pca_cesm1_cmip5,pca_cesm1,refs5 /])

end do
end do
gsn_panel(wks,plot,(/4,1/),resk)
end
