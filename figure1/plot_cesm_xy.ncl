load "./model_bootstrap.ncl"
;derive from plot_pdv_cmip5_xy.ncl
begin

;don't filter pdv index twice!!!
;------------filter----------------------
fyr   = 8.
ihp   = 0                             ; low-pass filter: ihp = 0; high-pass ihp = 1; band-pass ihp = 2.
sigma = 1.0                           ; Lanczos sigma
nWgt  = toint(fyr*12*1+1); fyr)+1 ;                           ; odd only
fca   = 1./(fyr*12)
fcb   = -999.
wgt  = filwgts_lanczos (nWgt, ihp, fca, fcb, sigma )

diri = "/glade/work/chenxing/enso/";"/Users/xingchen/Documents/project/ENSO/data/" ;
dirip = "/glade/u/home/chenxing/enso/";"/Users/xingchen/Documents/project/ENSO/pic/" ;

neof = 1

yr_calibrate = 1900 ;1920
yr_calibrate2 = 1940 ;1920

nBoot = 10000 ; used for Bootstrap test

;============Observation==============================
;/obs/obs_index.ncl
f1   = addfile(diri+"obs_ERSST_PDI_1854-2019.nc","r");obs_PDI_1854-2019.nc", "r")
pc_obse  = f1->index
pc_obse = wgt_runave_n_Wrap( pc_obse, wgt,  0, 0 )   ;opt < 0 : utilize cyclic conditions

f1   = addfile(diri+"obs_ICOADS_PDI_1854-2019.nc","r");
pc_obsi  = f1->index
pc_obsi = wgt_runave_n_Wrap( pc_obsi, wgt,  0, 0 )

f1   = addfile(diri+"obs_HadISST_PDI_1870-2019.nc","r");
pc_obsh  = f1->index
pc_obsh = wgt_runave_n_Wrap( pc_obsh, wgt,  0, 0 )

printVarSummary(pc_obse)
delete(f1)


;============CMIP5 LENS==============================

MODEL = (/"CESM1-CAM5","CanESM2","CSIRO-Mk3-6-0",\;"EC-EARTH",
  "GFDL-ESM2M","MPI-ESM" /);"GFDL-CM3",

nens5 = (/ 40, 50, 30, 30,  100 /) ;20, ensemble number

EXP = "historical"
IND = "PDI"

nml5 = dimsizes(MODEL)

yrs0 = 1850
yrl0 = 2014;2004
ntime = (yrl0-yrs0+1)*12
; pc_all = new((/nml5,100,ntime/), "float")
pca_lens5 = new((/nml5,ntime/), "float")
pc_lens5 = new((/nml5,max(nens5),ntime/), "float")
com_std = new((/nml5,ntime/), "float")
Boot_lens5 = new((/nml5,2,ntime/), "float")
do im = 0,nml5-1

locs = systemfunc("ls "+diri+"lens5/"+IND+"/"+MODEL(im)+"_"+EXP+"*")
 locs_str = str_split(locs(im), "_")
 print("'" + locs_str + "'")


bb = str_split(locs_str(4), "-")

  yrl = 2014
  yrs= toint(bb(0))

print("yrs = "+yrs)

;---------read output---------------
;from lens5_index.ncl
  f1   = addfiles(locs, "r")  ;multiple files
  ListSetType (f1, "join")        ; concatenate (=default)

  pc  = f1[:]->index
  pc = wgt_runave_n_Wrap( pc, wgt,  0, 1 )

printVarSummary(pc)
;;----------composite ensemble-----------------

pca_lens5(im,(yrs-yrs0)*12:(yrl-yrs0+1)*12-1) = dim_avg_n_Wrap(pc, 0)
com_std(im,(yrs-yrs0)*12:(yrl-yrs0+1)*12-1) = dim_stddev_n_Wrap(pc, 0)
; pc_lens5(im,:nens5(im)-1,(yrs-yrs0)*12:(yrl-yrs0+1)*12-1) = pc
pca_lens5(im,:) = pca_lens5(im,:) - avg(pca_lens5(im,:(yrs+20-1850)*12)) ;consist the clm with other which started to yr_calibrate

;Bootstrap test
pc = pc - avg(pca_lens5(im,:(yrs+20-1850)*12))
ndimt = dimsizes(pc)
Boot_lens5(im,:,(yrs-yrs0)*12:(yrl-yrs0+1)*12-1) = bootstrap_mme(ndtooned(pc),nBoot,ndimt(0),ndimt(1))
delete(ndimt)

  delete([/locs,pc,f1,bb,locs_str/] )
end do
printVarSummary(pca_lens5)

printVarSummary(Boot_lens5)

;==========================CESM==========================

MODEL2 = (/"CESM1","CESM1","CESM1","CESM2-CMIP5"/);"CESM1",
EXP2 =  (/ "xghg", "xaer" ,  "xbmb",""/);"xlulc",
EXP2_name =  (/ "XGHG", "XAer" ,  "XBMB",""/);"xlulc",
EXP2_ef_name =  (/ "GHG", "Aerosol" ,  "Biomass Burning",""/);"xlulc",
lens2 = (/20,20,15,10 /) ;5,
nec = dimsizes(EXP2)
pca_cesm1 = new((/nec,ntime/), "float")
pc_cesm1 = new((/nec,max(lens2),ntime/), "float")
cesm_std = new((/nec,ntime/), "float")
nens2 = ispan(1, nec, 1)
Boot_cesm1 = new((/nec,2,ntime/), "float")

;;;;;;;cesm2_cmip5_forcing;;;;;;;;
;cesm2_cmip5_forcing_002_PDI_1850-2004.nc
locs = systemfunc("ls "+diri+"lens5/"+IND+"/cesm2-cmip5_historical_*1920-2014.nc")
f1   = addfiles(locs, "r")  ;multiple files
ListSetType (f1, "join")        ; concatenate (=default)
pc  = f1[:]->index
pc = wgt_runave_n_Wrap( pc, wgt,  0, 1 )
yrs = 1920
yrl = 2014
im = nec-1
pca_cesm1(im,(yrs-yrs0)*12:(yrl-yrs0+1)*12-1) = dim_avg_n_Wrap(pc, 0)
cesm_std(im,(yrs-yrs0)*12:(yrl-yrs0+1)*12-1) = dim_stddev_n_Wrap(pc, 0)
ndim = dimsizes(pc)
nens2(im) = ndim(0)
pca_cesm1(im,:) = pca_cesm1(im,:) - avg(pca_cesm1(im,:(yr_calibrate2-1850)*12)) ;consist the clm with other which started to yr_calibrate
; pc_cesm1(im,:toint(lens2(im))-1,(yrs-yrs0)*12:(yrl-yrs0+1)*12-1) = pc

;Bootstrap test
pc = pc - avg(pca_cesm1(im,:(yr_calibrate2-1850)*12))
ndimt = dimsizes(pc)
Boot_cesm1(im,:,(yrs-yrs0)*12:(yrl-yrs0+1)*12-1) = bootstrap_mme(ndtooned(pc),nBoot,ndimt(0),ndimt(1))
delete(ndimt)

delete([/locs,pc,f1/] )

;;;;;;;cesm1_le single forcing;;;;;;;;
do im = 0,nec-2

;cesm1_le_xghg_015_PDI_1920-2004
locs = systemfunc("ls "+diri+"lens5/"+IND+"/cesm1_le_"+EXP2(im)+"_*")
locs_str = str_split(locs(im), "_")
 print("'" + locs_str + "'")

bb = str_split(locs_str(5), "-")

  yrl = 2014
  yrs= toint(bb(0))

print("yrs = "+yrs)

;---------read output---------------
;from lens5_index.ncl
  f1   = addfiles(locs, "r")  ;multiple files
  ListSetType (f1, "join")        ; concatenate (=default)

  pc  = f1[:]->index
  pc = wgt_runave_n_Wrap( pc, wgt,  0, 1 )

printVarSummary(pc)
;;----------composite ensemble-----------------
printVarSummary(pca_cesm1(im,(yrs-yrs0)*12:))
pca_cesm1(im,(yrs-yrs0)*12:(yrl-yrs0+1)*12-1) = dim_avg_n_Wrap(pc, 0)
cesm_std(im,(yrs-yrs0)*12:(yrl-yrs0+1)*12-1) = dim_stddev_n_Wrap(pc, 0)
pca_cesm1(im,:) = pca_cesm1(im,:) - avg(pca_cesm1(im,:(yr_calibrate2-1850)*12)) ;consist the clm with other which started to yr_calibrate
; pc_cesm1(im,:toint(lens2(im))-1,(yrs-yrs0)*12:(yrl-yrs0+1)*12-1) = pc
ndim = dimsizes(pc)
nens2(im) = ndim(0)

;Bootstrap test
pc = pc - avg(pca_cesm1(im,:(yr_calibrate2-1850)*12))
ndimt = dimsizes(pc)
Boot_cesm1(im,:,(yrs-yrs0)*12:(yrl-yrs0+1)*12-1) = bootstrap_mme(ndtooned(pc),nBoot,ndimt(0),ndimt(1))
delete(ndimt)

  delete([/locs,pc,f1,bb,locs_str/] )
end do
printVarSummary(pca_cesm1)

; ;--------output-------------
; fon=diri+"cmip6_historical_pdv_mme.nc";
; system("rm -f "+fon)
; fo=addfile(fon,"c")
; fo->pca_lens5 = pca_lens5

;==========================CESM2-SF==========================

MODEL2 = (/"CESM2","CESM2","CESM2","CESM2"/);"CESM1",
EXP2 =  (/ "GHG", "AAER" ,  "BMB","EE"/);"AAER","BMB","EE","GHG"
EXP2_name =  (/ "GHG", "AAER" ,  "BMB","EE"/);"xlulc",
EXP2_ef_name =  (/ "GHG", "Aerosol" ,  "Biomass Burning","EE"/);"xlulc",
lens2 = (/15,15,10,10 /) ;5,
nec = dimsizes(EXP2)
pca_cesm2sf = new((/nec,ntime/), "float")
pc_cesm2sf = new((/nec,max(lens2),ntime/), "float")
cesm_std_cesm2sf = new((/nec,ntime/), "float")
nens2sf = ispan(1, nec, 1)
Boot_cesm2sf  = new((/nec,2,ntime/), "float")
do im = 0,nec-1

; cesm2_sf_AAER_007_PDI_1850-2014.nc
locs2f = systemfunc("ls "+diri+"lens6/"+IND+"/cesm2_sf_"+EXP2(im)+"_*")
locs2f_str = str_split(locs2f(im), "_")
 print("'" + locs2f_str + "'")

bb = str_split(locs2f_str(5), "-")

  yrl = 2014
  yrs= toint(bb(0))

print("yrs = "+yrs)

;---------read output---------------
;from cesm_le_index.ncl
  f1   = addfiles(locs2f, "r")  ;multiple files
  ListSetType (f1, "join")        ; concatenate (=default)

  pc  = f1[:]->index
  pc = wgt_runave_n_Wrap( pc, wgt,  0, 1 )

printVarSummary(pc)
;;----------composite ensemble-----------------
printVarSummary(pca_cesm2sf(im,(yrs-yrs0)*12:))
pca_cesm2sf(im,(yrs-yrs0)*12:(yrl-yrs0+1)*12-1) = dim_avg_n_Wrap(pc, 0)
cesm_std_cesm2sf(im,(yrs-yrs0)*12:(yrl-yrs0+1)*12-1) = dim_stddev_n_Wrap(pc, 0)
pca_cesm2sf(im,:) = pca_cesm2sf(im,:) - avg(pca_cesm2sf(im,:(yr_calibrate2-1850)*12)) ;consist the clm with other which started to yr_calibrate
; pc_cesm2sf(im,:toint(lens2(im))-1,(yrs-yrs0)*12:(yrl-yrs0+1)*12-1) = pc
ndim = dimsizes(pc)
nens2sf(im) = ndim(0)

;Bootstrap test
pc = pc - avg(pca_cesm2sf(im,:(yr_calibrate2-1850)*12))
ndimt = dimsizes(pc)
Boot_cesm2sf(im,:,(yrs-yrs0)*12:(yrl-yrs0+1)*12-1) = bootstrap_mme(ndtooned(pc),nBoot,ndimt(0),ndimt(1))
delete(ndimt)

  delete([/locs2f,pc,f1,bb,locs2f_str/] )
end do
printVarSummary(pca_cesm2sf)


;;;;;;;CESM2 from CMIP6;;;;;;;;
;; the one download from CMIP6:
; locs_cesm2 = systemfunc("ls "+diri+"cmip6/"+IND+"/cmip6_historical_CESM2_*_"+IND+"_1850-2014.nc")

;; the CESM2 LENS for 100 ensembles!!
locs_cesm2 = systemfunc("ls "+diri+"cesmle/"+IND+"/CESM2-CAM6_*_"+IND+"_1850-2014.nc")
; locs_cesm2 = systemfunc("ls "+diri+"cesmle/"+IND+"/CESM2-CAM6_cmip6*"+IND+"_1850-2014.nc")
; locs_cesm2 = systemfunc("ls "+diri+"cesmle/"+IND+"/CESM2-CAM6_smbb*"+IND+"_1850-2014.nc")
f1   = addfiles(locs_cesm2, "r")  ;multiple files
ListSetType (f1, "join")        ; concatenate (=default)

pc_cesm2  = f1[:]->index

pc_cesm2 = wgt_runave_n_Wrap( pc_cesm2, wgt,  0, 1 )   ;opt < 0 : utilize cyclic conditions
printVarSummary(pc_cesm2)
std_cesm2 = dim_stddev_n_Wrap(pc_cesm2,0)
pca_cesm2 = dim_avg_n_Wrap(pc_cesm2,0)
pca_cesm2 = pca_cesm2 - avg(pca_cesm2(:(yr_calibrate-1850)*12)) ;consist the clm with other which started to yr_calibrate

;Bootstrap test
pc_cesm2 = pc_cesm2 - avg(pca_cesm2(:(yr_calibrate-1850)*12))
ndimt = dimsizes(pc_cesm2)
Boot_cesm2 = bootstrap_mme(ndtooned(pc_cesm2),nBoot,ndimt(0),ndimt(1))
delete(ndimt)
printVarSummary(Boot_cesm2)

;----------------------------------

; fo = addfile(diri+"ts_clim_zonal_difference_cesm_1920-2014.nc","r")
fo = addfile(diri+"rsds_clim_zonal_difference_cesm_1920-2014.nc","r")
dclm1 = fo->dclm1
dclm2 = fo->dclm2
printVarSummary(dclm1)
printVarSummary(dclm2)

dc1 = dim_rmvmean(dim_avg_n_Wrap(dclm1(:,{0:}),1))
dc2 = dim_rmvmean(dim_avg_n_Wrap(dclm2(:,{0:}),1))
printVarSummary(dc1)
x_axis2 = ispan(1920,2014,1)

;--------output-------------
fon=diri+"cesm_"+IND+"_mme_1850-2014.nc";
system("rm -f "+fon)
fo=addfile(fon,"c")
fo->pca_cesm2 = pca_cesm2
fo->pca_cesm1_cmip5 = pca_cesm1(nec-1,:)
fo->pca_cesm1 = pca_lens5(0,:)
fo->std_cesm2 = std_cesm2
fo->std_cesm1_cmip5 = cesm_std(nec-1,:)
fo->std_cesm1 = com_std(0,:)

;--------------plot-------------------

wks = gsn_open_wks("png", dirip+"cesm_xy");"./pic/lens5_xy");
plot2 = new(10,graphic)                ; create graphic array
plot3 = new(5,graphic)                ; create graphic array

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
  res@vpHeightF = 0.3
  res@vpWidthF  = 0.7

  res@tmXTOn    = False
  res@tmYROn    = False
  ;res@gsnXYBarChart            = True              ; Create bar plot
  ;res@gsnXYBarChartOutlineOnly = True


  res@gsnYRefLine           = 0.0             ; reference line
  ; res@gsnAboveYRefLineColor = "red"           ; above ref line fill red
  ; res@gsnBelowYRefLineColor = "blue"          ; below ref line fill blue
  ; res@gsnLeftStringFontHeightF  = 0.03
  ; res@gsnRightStringFontHeightF = 0.03

  x_axis = fspan(yrs0, yrl0+1, ntime)
  ;res@tmXBMode   = "Explicit"
  ;res@tmXBValues = x_axis;-1
  ;res@tmXBLabels = model
  ;res@tmXBLabelAngleF = 45.
  ;res@tmXBLabelFontHeightF = 0.02
  res@tiYAxisString = ""
  res@tiXAxisString = ""; "year"

  res@xyMonoLineColor = False
  res@xyMonoDashPattern = True

  res@trXMinF              = 1920;yrs0
  res@trXMaxF              = yrl0+1

  res@trYMinF               = -1.2
  res@trYMaxF               =  1.2

  res@xyLineThicknessF = 5.0

res2 = res


res2@xyLineColors = "blue"
res@xyLineColors =  "red"

cesm1_le = pca_lens5(0,:)
;remove mean is to force them in a same climatology level (ignore clim bias effect)
pca_cesm1(nec-1,(1920-yrs0)*12:) = dim_rmvmean_n_Wrap(pca_cesm1(nec-1,(1920-yrs0)*12:),0)
pca_cesm2((1920-yrs0)*12:) = dim_rmvmean_n_Wrap(pca_cesm2((1920-yrs0)*12:),0)
cesm1_le((1920-yrs0)*12:) = dim_rmvmean_n_Wrap(cesm1_le((1920-yrs0)*12:),0)

plot2(0) = gsn_csm_xy(wks,x_axis,pca_cesm2, res)
plota = gsn_csm_xy (wks,x_axis,cesm1_le,res2)
overlay(plot2(0),plota)

plotc = gsn_csm_xy(wks,x_axis,pca_cesm2, res)
plotd = gsn_csm_xy (wks,x_axis,cesm1_le,res2)

;Observation
res@xyLineThicknessF = 0.5
res2@xyLineColors = "grey65"
pc_obs1e = pca_cesm2
pc_obs1e = pca_cesm2@_FillValue
pc_obs1h = pc_obs1e
pc_obs1i = pc_obs1e
printVarSummary(pca_cesm2)
printVarSummary(pc_obs1e((1854-yrs0)*12:))
printVarSummary(pc_obse(:(yrl0-1854+1)*12-1))
pc_obs1e((1854-yrs0)*12:) = dim_rmvmean_n_Wrap(pc_obse(:(yrl0-1854+1)*12-1),0)
pc_obs1i((1854-yrs0)*12:) = dim_rmvmean_n_Wrap(pc_obsi(:(yrl0-1854+1)*12-1),0)
pc_obs1h((1870-yrs0)*12:) = dim_rmvmean_n_Wrap(pc_obsh(:(yrl0-1870+1)*12-1),0)
res2@xyDashPattern = 2
; plota = gsn_csm_xy (wks,x_axis,pc_obs1e,res2)
; overlay(plot2(0),plota)
; res2@xyDashPattern = 1
; plota = gsn_csm_xy (wks,x_axis,pc_obs1i,res2)
; overlay(plot2(0),plota)
; res2@xyDashPattern = 4
; plota = gsn_csm_xy (wks,x_axis,pc_obs1h,res2)
; overlay(plot2(0),plota)
delete(res2@xyDashPattern)
res@xyLineThicknessF = 5.0

overlay(plot2(0),plotc)
overlay(plot2(0),plotd)

;;;;;;;;;;;; CESM playground;;;;;;;;;;;;;;

;CESM2 LE (pca_cesm2)
res@xyLineColors = "red" ;"grey55"
plotc = gsn_csm_xy (wks,x_axis,pca_cesm2,res)

;CESM2 CMIP5 forcing (pca_cesm1(4,:))
res@tiXAxisString = "year"
res@xyLineColors = "gold1"
plot3(2) = gsn_csm_xy (wks,x_axis,pca_cesm1(nec-1,:),res)
; overlay(plot3(2),plotc)

;forcing in cmip6 - in cmip5 in cesm2
dces2 = pca_cesm2
dces2 = pca_cesm2@_FillValue
; dces2((1850-yrs0)*12:(2015-yrs0)*12-1) = pca_cesm2((1850-yrs0)*12:(2015-yrs0)*12-1) - pca_cesm1(nec-1,(1850-yrs0)*12:(2015-yrs0)*12-1)
dces2 = cesm1_le - pca_cesm1(nec-1,:)

res@xyLineColors = "green"
; plota = gsn_csm_xy (wks,x_axis,dces2,res)
; overlay(plot3(2), plota)

; NH TS difference index
res@xyDashPattern = 2
res@xyLineColors = "coral1"
; plota = gsn_csm_xy (wks,x_axis2,dc2,res)
; overlay(plot3(2), plota)

klk = month_to_annual(dces2,1)
print(escorc(klk(1920-1850:),dc2)+" correlation!!") ;-0.14 for HDSW with cmip diff
print(escorc(pca_cesm1(nec-1,:),cesm1_le)+" correlation with CESM1")
print(escorc(pca_cesm1(nec-1,:),pca_cesm2)+" correlation with CESM2")

res@xyLineThicknessF = 3.0
res@xyDashPattern = 15
res@xyLineColors = "grey55"

plota = gsn_csm_xy (wks,x_axis,Boot_cesm1(nec-1,0,:),res)
overlay(plot3(2), plota)
plota = gsn_csm_xy (wks,x_axis,Boot_cesm1(nec-1,1,:),res)
overlay(plot3(2), plota)

res@xyLineColors = "red" ;"lightpink"
plota = gsn_csm_xy (wks,x_axis,Boot_cesm2(0,:),res)
overlay(plot2(0), plota)
plota = gsn_csm_xy (wks,x_axis,Boot_cesm2(1,:),res)
overlay(plot2(0), plota)


res@xyLineColors = "blue" ;"lightcyan"
plota = gsn_csm_xy (wks,x_axis,Boot_cesm1(0,0,:),res)
overlay(plot2(0), plota)
plota = gsn_csm_xy (wks,x_axis,Boot_cesm1(0,1,:),res)
overlay(plot2(0), plota)
;---------shading of STD---------

  delete(res@xyDashPattern)
  delete(res@xyLineColors)
  res@xyLineColor     = -1                           ; We don't want the line, so make it trax_axisparent.
  mmz = pca_lens5(0:1,:)
  res@gsnXYFillOpacities = 0.3
  res@xyCurveDrawOrder = "PreDraw"

do im = 0,nml5-1

  ; STD shading
  mmz(0,:) = pca_lens5(im,:)+com_std(im,:)
  mmz(1,:) = pca_lens5(im,:)-com_std(im,:)


  if (im.eq.0) then
    res@gsnXYFillColors = "lightblue";"lightpink3"
    plota  = gsn_csm_xy (wks,(/x_axis/),mmz(0:1,:),res)  ; Create filled XY plot.
    overlay(plot2(0), plota)
  end if

end do

do im = 0,nec-1

  ; STD shading
  mmz(0,:) = pca_cesm1(im,:)+cesm_std(im,:)
  mmz(1,:) = pca_cesm1(im,:)-cesm_std(im,:)

  if (im.eq.nec-1) then
    res@gsnXYFillColors = "bisque"
    plota  = gsn_csm_xy (wks,(/x_axis/),mmz(0:1,:),res)  ; Create filled XY plot.
    overlay(plot3(2), plota)
  end if

end do


mmz(0,:) = pca_cesm2+std_cesm2
mmz(1,:) = pca_cesm2-std_cesm2

res@gsnXYFillColors = "lightblue";"grey75"
plota  = gsn_csm_xy (wks,(/x_axis/),mmz(0:1,:),res)  ; Create filled XY plot.
; overlay(plot3(2), plota)
res@gsnXYFillColors = "lightpink3";"lightblue"
plota  = gsn_csm_xy (wks,(/x_axis/),mmz(0:1,:),res)  ; Create filled XY plot.
overlay(plot2(0), plota)

;---------------------------------
; Set up resources for a customized legend.
;
  lgres                    = True
  lgres@lgLineThicknessF   = 3.0
  lgres@lgItemType         = "Lines"        ; show lines only (default)
  lgres@lgLabelFontHeightF = .1            ; legend label font thickness
  lgres@vpWidthF           = 0.30           ; width of legend (NDC)
  lgres@vpHeightF          = 0.10           ; height of legend (NDC)
  ; lgres@lgPerimThicknessF  = 2.0            ; thicken the box perimeter
  lgres@lgPerimOn          = False
 ; lgres@lgPerimFill = 0
 ; lgres@lgPerimFillColor = 0
  lgres@lgPerimFill            = "SolidFill"      ; Fill legend box w/white
  lgres@lgPerimFillColor       = "white"          ; so it masks XY curves

  lgres@lgMonoDashIndex = False
  lgres@lgDashIndexes = (/0,0/)
  lgres@lgLineColors       = (/"red" ,"blue"/);"green","grey65","grey65","grey65",
  labels6 = (/" CESM2("+dimsizes(locs_cesm2)+")             "," CESM1(40)            " /) ;"Diff(CESM2/1)"," HadISST "," ICOADS "," ERSST ",
  nitems6 = dimsizes(labels6)                 ; number of legend items
  lbid6 = gsn_create_legend(wks,nitems6,labels6,lgres)

  delete(lgres@lgLineColors)

  delete(lgres@lgDashIndexes)
  lgres@vpHeightF          = 0.10           ; height of legend (NDC)

  lgres@lgDashIndexes = (/0,0,0/) ;2,
  lgres@lgLineColors       = (/"gold1"/);"green","coral1", ,"blue"/)
  labels3 = (/" CESM2-CMIP5(10)"/);" Diff(CMIP6/5forcing)"," NH TS Diff(CMIP6/5forcing)",,"CESM2(11)" /)
  nitems3 = dimsizes(labels3)                 ; number of legend items
  lbid3 = gsn_create_legend(wks,nitems3,labels3,lgres)
  delete(lgres@lgLineColors)


; Use gsn_add_annotation to attach this legend to our existing plot.
; This way, if we resize the plot, the legend will stay with the
; plot and be resized automatically.
;
  amres                  = True

  amres@amJust           = "BottomLeft"    ; Use bottom right corner of box
                                            ; for determining its location.
  amres@amParallelPosF   =  -0.44              ; Move legend to right
  amres@amOrthogonalPosF =   0.5              ; Move legend down.

  annoid3 = gsn_add_annotation(plot3(2),lbid3,amres)  ; add legend to plot
  annoid6 = gsn_add_annotation(plot2(0),lbid6,amres)  ; add legend to plot

;------------------------------------------------
resk = True
;resk@txFontHeightF = 0.03
resk@gsnPanelLabelBar   = False                 ; add common colorbar
resk@gsnMaximize = True
resk@gsnPaperOrientation = "portrait"   ; force portrait
; resk@txString = IND


gsn_panel(wks,(/plot2(0),plot3(2)/),(/2,1/),resk)

;==============================================
;  attach plots
;=============================================
delete(res2)
res1 = True
res2 = True
res2@gsnAttachPlotsXAxis = True
res1@gsnAttachPlotsXAxis = True
;res2@gsnMaximize = True
res1@gsnPaperOrientation = "portrait"   ; force portrait
res2@gsnAttachBorderOn = True ;False ;
res1@gsnAttachBorderOn = False

newplot4 = gsn_attach_plots(plot2(0),(/plot3(2)/),res1,res2)
draw(plot2(0))
frame(wks)

end
