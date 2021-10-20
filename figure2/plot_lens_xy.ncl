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

yr_calibrate = 1920
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
  delete([/locs,pc,f1,bb,locs_str/] )
end do
printVarSummary(pca_lens5)


;==========================CESM==========================

MODEL1 = (/"CESM1","CESM1","CESM1","CESM1","CESM2-CMIP5"/);
EXP1 =  (/ "xghg", "xaer" ,  "xbmb","xlulc",""/);
EXP1_name =  (/ "XGHG", "XAer" ,  "XBMB","XLULC","CESM2-CMIP5"/);
EXP1_ef_name =  (/ "GHG", "Aerosol" ,  "Biomass Burning","Landuse",""/);
lens2 = (/20,20,15,5,10 /) ;5,
nec = dimsizes(EXP1)
pca_cesm1 = new((/nec,ntime/), "float")
pc_cesm1 = new((/nec,max(lens2),ntime/), "float")
cesm_std = new((/nec,ntime/), "float")
nens2 = ispan(1, nec, 1)
Boot_cesm1 = new((/nec,2,ntime/), "float")

;;;;;;;cesm2_cmip5_forcing;;;;;;;;
;cesm2_cmip5_forcing_002_PDI_1850-2004.nc
locs = systemfunc("ls "+diri+"lens5/"+IND+"/cesm2-cmip5_historical*1920*2014*")
f1   = addfiles(locs, "r")  ;multiple files
ListSetType (f1, "join")        ; concatenate (=default)
pc  = f1[:]->index
pc = wgt_runave_n_Wrap( pc, wgt,  0, 1 )
yrs = 1920
yrl = 2014
pca_cesm1(nec-1,(yrs-yrs0)*12:(yrl-yrs0+1)*12-1) = dim_avg_n_Wrap(pc, 0)
cesm_std(nec-1,(yrs-yrs0)*12:(yrl-yrs0+1)*12-1) = dim_stddev_n_Wrap(pc, 0)
ndim = dimsizes(pc)
nens2(nec-1) = ndim(0)
; pca_cesm1(nec-1,:) = pca_cesm1(nec-1,:) - avg(pca_cesm1(nec-1,:(yr_calibrate-1850)*12)) ;consist the clm with other which started to yr_calibrate
; pc_cesm1(nec-1,:toint(lens2(im))-1,(yrs-yrs0)*12:(yrl-yrs0+1)*12-1) = pc

;Bootstrap test
; pc = pc - avg(pca_cesm1(nec-1,:(yr_calibrate2-1850)*12))
ndimt = dimsizes(pc)
Boot_cesm1(nec-1,:,(yrs-yrs0)*12:(yrl-yrs0+1)*12-1) = bootstrap_mme(ndtooned(pc),nBoot,ndimt(0),ndimt(1))
delete(ndimt)

delete([/locs,pc,f1/] )

;;;;;;;cesm1_le single forcing;;;;;;;;
do im = 0,nec-2

;cesm1_le_xghg_015_PDI_1920-2004
locs = systemfunc("ls "+diri+"lens5/"+IND+"/cesm1_le_"+EXP1(im)+"_*")
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

;==========================CESM2-SF==========================

MODEL2 = (/"CESM2","CESM2","CESM2","CESM2"/);"CESM1",
EXP2 =  (/ "GHG", "AAER" ,  "BMB","EE"/);"AAER","BMB","EE","GHG"
EXP2_name =  (/ "GHG", "AAER" ,  "BMB","EE"/);"xlulc",
EXP2_ef_name =  (/ "GHG", "Aerosol" ,  "Biomass Burning","EE"/);"xlulc",
lens2f = (/15,15,10,10 /) ;5,
nec2 = dimsizes(EXP2)
pca_cesm2sf = new((/nec2,ntime/), "float")
pc_cesm2sf = new((/nec2,max(lens2f),ntime/), "float")
cesm_std_cesm2sf = new((/nec2,ntime/), "float")
nens2sf = ispan(1, nec2, 1)
Boot_cesm2sf = new((/nec,2,ntime/), "float")

do im = 0,nec2-1

; cesm2_sf_AAER_007_PDI_1850-2014.nc
locs2f = systemfunc("ls "+diri+"lens6/"+IND+"/cesm2_sf_"+EXP2(im)+"_*")
print(locs2f)
locs2f_str = str_split(locs2f(0), "_")
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

;----------------------------------

fo = addfile(diri+"ts_clim_zonal_difference_cesm_1920-2014.nc","r")
dclm1 = fo->dclm1
dclm2 = fo->dclm2
printVarSummary(dclm1)
printVarSummary(dclm2)

dc1 = dim_avg_n_Wrap(dclm1(:,{0:}),1)
dc2 = dim_avg_n_Wrap(dclm2(:,{0:}),1)
printVarSummary(dc1)
x_axis2 = ispan(1920,2014,1)

;------------detection and attribution--------------

x_axis = fspan(yrs0, yrl0+1, ntime)

yrsaa = 1920
yrlaa = 2010
do im = 0,nec-1
  rco = regline (pc_obse((yrsaa-1854+1)*12-1:(yrlaa-1854+1)*12-1) , pca_cesm1(im,(yrsaa-yrs0+1)*12-1:(yrlaa-yrs0+1)*12-1))
  rcm = regline (pca_lens5(0,(yrsaa-yrs0+1)*12-1:(yrlaa-yrs0+1)*12-1) , pca_cesm1(im,(yrsaa-yrs0+1)*12-1:(yrlaa-yrs0+1)*12-1))
  cro = escorc (pc_obse((yrsaa-1854+1)*12-1:(yrlaa-1854+1)*12-1) , pca_cesm1(im,(yrsaa-yrs0+1)*12-1:(yrlaa-yrs0+1)*12-1))
  crm = escorc (pca_lens5(0,(yrsaa-yrs0+1)*12-1:(yrlaa-yrs0+1)*12-1) , pca_cesm1(im,(yrsaa-yrs0+1)*12-1:(yrlaa-yrs0+1)*12-1))
  print("Regression| OBS:"+rco+" MME:"+rcm+" CESM1 "+EXP1_name(im))
  print("Correlation| OBS:"+cro+" MME:"+crm+" CESM1 "+EXP1_name(im))
end do

do im = 0,nec2-1
  rco = regline (pc_obse((yrsaa-1854+1)*12-1:(yrlaa-1854+1)*12-1) , pca_cesm2sf(im,(yrsaa-yrs0+1)*12-1:(yrlaa-yrs0+1)*12-1))
  rcm = regline (pca_cesm2((yrsaa-yrs0+1)*12-1:(yrlaa-yrs0+1)*12-1) , pca_cesm2sf(im,(yrsaa-yrs0+1)*12-1:(yrlaa-yrs0+1)*12-1))
  cro = escorc (pc_obse((yrsaa-1854+1)*12-1:(yrlaa-1854+1)*12-1) , pca_cesm2sf(im,(yrsaa-yrs0+1)*12-1:(yrlaa-yrs0+1)*12-1))
  crm = escorc (pca_cesm2((yrsaa-yrs0+1)*12-1:(yrlaa-yrs0+1)*12-1) , pca_cesm2sf(im,(yrsaa-yrs0+1)*12-1:(yrlaa-yrs0+1)*12-1))
  print("Regression| OBS:"+rco+" MME:"+rcm+" CESM2 "+EXP2_name(im))
  print("Correlation| OBS:"+cro+" MME:"+crm+" CESM2 "+EXP2_name(im))
end do

M = nec2
X  = new ( (/M+1,ntime/), "float" )
X(0,:) = 1.0                           ; constant term on rhs
X(1:,:) = pca_cesm2sf

rmulto = reg_multlin(pc_obse((yrsaa-1854+1)*12-1:(yrlaa-1854+1)*12-1) , X(:,(yrsaa-yrs0+1)*12-1:(yrlaa-yrs0+1)*12-1),False)
rmultm = reg_multlin(pca_cesm2((yrsaa-yrs0+1)*12-1:(yrlaa-yrs0+1)*12-1) , X(:,(yrsaa-yrs0+1)*12-1:(yrlaa-yrs0+1)*12-1),False)
print(rmulto)
print(rmultm)

; yregro1 = rco*x_axis + rco@yintercept

;--------------plot-------------------

wks = gsn_open_wks("png", dirip+"lens5_xy");"./pic/lens5_xy");
plot1 = new(nml5,graphic)                ; create graphic array
plot2 = new(10,graphic)                ; create graphic array
plot3 = new(5,graphic)                ; create graphic array
plot4 = new(5,graphic)                ; create graphic array
plot5 = new(5,graphic)                ; create graphic array
plots = new(5,graphic)                ; create graphic array

;*******************************************
; time series (principal component) plot
;*******************************************

  ; gsn_define_colormap(wks,"MPL_gist_rainbow")
  ; colors = (/"coral1","cyan1","darkolivegreen1","gold1","mediumpurple1","grey55" /) ;ispan(2, 125, 30)   ; indices into color table
  gsn_define_colormap(wks,"seaice_2")
  colors = ispan(2, 17, 2)   ; indices into color table
  colors1 = ispan(2, 60, 4)   ; indices into color table
  colors2 = ispan(70, 125, 5)   ; indices into color table


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
  res@tiXAxisString = "year"

  res@xyMonoLineColor = False
  res@xyMonoDashPattern = True

  res@trXMinF              = 1920;yrs0
  res@trXMaxF              = yrl0+1

  res@trYMinF               = -1.2
  res@trYMaxF               =  1.2

  res@xyLineThicknessF = 5.0

res2 = res
;MODEL
res@gsnLeftString = "PDV"; 15yr rolling trend"
res@gsnRightString = pca_lens5@units
  res@xyLineColors = "black"

do im = 0,nml5-1
  res@gsnLeftString = MODEL(im);+" ("+nens5(im)+")"
  plot1(im) = gsn_csm_xy (wks,x_axis,pca_lens5(im,:),res)
  ; each ensemble
  ; plota = gsn_csm_xy (wks,x_axis,pc_lens5(im,:,:),res2)
  ; overlay(plot1(im),plota)
end do

res2@xyLineColors = "red"
res@xyLineColors = "blue"

cesm1_le = pca_lens5(0,:)

res@gsnLeftString = "CESM1 & CESM2"
plot2(0) = gsn_csm_xy(wks,x_axis,pca_cesm2, res)
plota = gsn_csm_xy (wks,x_axis,cesm1_le,res2)
overlay(plot2(0),plota)

;Observation
res2@xyDashPattern = 2
res2@xyLineColors = "green"
pc_obs1 = pca_cesm2
pc_obs1 = pca_cesm2@_FillValue
printVarSummary(pc_obse)
printVarSummary(pca_cesm2)
printVarSummary(pc_obs1((1854-yrs0)*12:))
printVarSummary(pc_obse(:(yrl0-1854+1)*12-1))
pc_obs1((1854-yrs0)*12:) = pc_obse(:(yrl0-1854+1)*12-1)
plota = gsn_csm_xy (wks,x_axis,pc_obs1,res2)
overlay(plot2(0),plota)
delete(res2@xyDashPattern)

res@xyLineColors = "black"

res2@xyLineColors = "green"

dd = pca_cesm2
dd = pca_cesm1@_FillValue
dd = pca_cesm2 - cesm1_le
plota = gsn_csm_xy (wks,x_axis,dd,res2)
; overlay(plot2(0),plota)


do im = 0,nec-1
  ;;;;CESM1 single forcing
  res@gsnLeftString = MODEL1(im)+" "+EXP1_name(im);+" ("+nens2(im)+")"
  plot2(im+1) = gsn_csm_xy (wks,x_axis,pca_cesm1(im,:),res)

  ;Full forcing - removed exps
  dd = pca_cesm1@_FillValue
  dd = cesm1_le - pca_cesm1(im,:)
  plota = gsn_csm_xy (wks,x_axis,dd,res2)
  overlay(plot2(im+1),plota)

  ; each ensemble
  ; plota = gsn_csm_xy (wks,x_axis,pc_cesm1(im,:,:),res2)
  ; overlay(plot2(im),plota)
end do

color_sf0 = (/"red","blue","darkgreen","goldenrod2" /)
res@gsnLeftString = "CESM1-SF"
res@xyLineColors = color_sf0(0)
plots(0) = gsn_csm_xy (wks,x_axis,pca_cesm1(0,:),res)
do ia = 1,3
  res@xyLineColors = color_sf0(ia)
  plota = gsn_csm_xy (wks,x_axis,pca_cesm1(ia,:),res)
  overlay(plots(0),plota)
end do


res@xyLineColors = "black"
  do im = 0,nec2-1
  ;;;CESM2 single forcing
  res@gsnLeftString = MODEL2(im)+" "+EXP2_name(im);+" ("+nens2(im)+")"
  plot4(im) = gsn_csm_xy (wks,x_axis,pca_cesm2sf(im,:),res)
  ;
  ; dd = pca_cesm2@_FillValue
  ; dd = cesm1_le - pca_cesm2(im,:)
  ; plota = gsn_csm_xy (wks,x_axis,dd,res2)
  ; overlay(plot4(im+1),plota)

end do

res@gsnLeftString = "CESM2-SF"
res@xyLineColors = color_sf0(0)
plots(1) = gsn_csm_xy (wks,x_axis,pca_cesm2sf(0,:),res)
do ia = 1,3
res2@xyLineColors = color_sf0(ia)
plota = gsn_csm_xy (wks,x_axis,pca_cesm2sf(ia,:),res2)
overlay(plots(1),plota)
end do

; ; Confidence level
; res@xyLineThicknessF = 3.0
; res@xyDashPattern = 15
; res@gsnLeftString = ""
; res@gsnRightString = ""
;
; do ia = 0,3
;   res@xyLineColors = color_sf0(ia)
;   plota = gsn_csm_xy (wks,x_axis,Boot_cesm1(ia,0,:),res)
;   overlay(plots(0), plota)
;   plota = gsn_csm_xy (wks,x_axis,Boot_cesm1(ia,1,:),res)
;   overlay(plots(0), plota)
;
;   plota = gsn_csm_xy (wks,x_axis,Boot_cesm2sf(ia,0,:),res)
;   overlay(plots(1), plota)
;   plota = gsn_csm_xy (wks,x_axis,Boot_cesm2sf(ia,1,:),res)
;   overlay(plots(1), plota)
; end do

;==========================================================
; models in one plot
;==========================================================
delete(res@xyLineColors)

com_lens5 = dim_avg_n_Wrap(pca_lens5,0)

;MODEL
res@xyLineThicknessF = 5.0
  res@xyLineColors = colors
  res@gsnLeftString = "CMIP5 LENS";
  plot5(0) = gsn_csm_xy (wks,x_axis,pca_lens5 ,res) ;x_axis2, com_pc

delete(res@xyLineColors)

res@gsnLeftString = ""

;;;;;;;;;;;; CESM playground;;;;;;;;;;;;;;

res@trYMinF               = -1.2
res@trYMaxF               =  1.2

res@xyLineThicknessF = 5.0
;CESM2 LE (pca_cesm2)
res@xyLineColors = "grey55"
plot3(0) = gsn_csm_xy (wks,x_axis,pca_cesm2,res)
plotc = gsn_csm_xy (wks,x_axis,pca_cesm2,res)

;CESM1 LENS (pca_lens5(0,:))
; res@xyLineThicknessF = 3.0
res@xyLineColors = "lightpink3"
plot3(3) = gsn_csm_xy (wks,x_axis,pca_lens5(0,:),res)
plotb = gsn_csm_xy (wks,x_axis,pca_lens5(0,:),res)
overlay(plot3(0), plotb)

;CESM1 single forcing (GHG:pca_cesm1(0,:); AER:pca_cesm1(1,:); LULC:pca_cesm1(2,:); BMB:pca_cesm1(3,:)  )
res@xyLineColors = "blue"
plot3(1) = gsn_csm_xy (wks,x_axis,pca_cesm1(1,:),res)

;CESM2 CMIP5 forcing (pca_cesm1(4,:))
res@xyLineColors = "gold1"
plota = gsn_csm_xy (wks,x_axis,pca_cesm1(nec-1,:),res)
overlay(plot3(0), plota)
plot3(2) = gsn_csm_xy (wks,x_axis,pca_cesm1(nec-1,:),res)
overlay(plot3(2),plotc)
plota = gsn_csm_xy (wks,x_axis,pca_cesm1(nec-1,:),res)
overlay(plot3(3),plota)

;all - xaer in cesm1
dces1 = pca_cesm1(1,:)
dces1 = pca_cesm1@_FillValue
dces1((1920-yrs0)*12:) = pca_lens5(0,(1920-yrs0)*12:) - pca_cesm1(1,(1920-yrs0)*12:)
;forcing in cmip6 - in cmip5 in cesm2
dces2 = pca_cesm2
dces2 = pca_cesm2@_FillValue
dces2((1850-yrs0)*12:(2015-yrs0)*12-1) = pca_cesm2((1850-yrs0)*12:(2015-yrs0)*12-1) - pca_cesm1(nec-1,(1850-yrs0)*12:(2015-yrs0)*12-1)
;cesm2 - cesm1 with same forcing in cmip5
dces3 = pca_cesm2
dces3 = pca_cesm2@_FillValue
dces3((1920-yrs0)*12:) = pca_cesm1(nec-1,(1920-yrs0)*12:) - pca_lens5(0,(1920-yrs0)*12:)

res@xyLineColors = "green"
plota = gsn_csm_xy (wks,x_axis,dces1,res)
overlay(plot3(1), plota)
plota = gsn_csm_xy (wks,x_axis,dces2,res)
overlay(plot3(2), plota)
plota = gsn_csm_xy (wks,x_axis,dces3,res)
overlay(plot3(3), plota)
res@xyLineColors = "lightpink3"
plotb = gsn_csm_xy (wks,x_axis,pca_lens5(0,:),res)
overlay(plot3(1), plotb)

res@xyDashPattern = 2
res@xyLineColors = "coral1"
plota = gsn_csm_xy (wks,x_axis2,dc2,res)
overlay(plot3(2), plota)
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

  res@gsnXYFillColors = "grey75"
  plota  = gsn_csm_xy (wks,(/x_axis/),mmz(0:1,:),res)  ; Create filled XY plot.
  overlay(plot1(im), plota)


  if (im.eq.0) then
    res@gsnXYFillColors = "lightpink3"
    plota  = gsn_csm_xy (wks,(/x_axis/),mmz(0:1,:),res)  ; Create filled XY plot.
    overlay(plot2(0), plota)
    res@gsnXYFillColors = "pink"
    plota  = gsn_csm_xy (wks,(/x_axis/),mmz(0:1,:),res)  ; Create filled XY plot.
    overlay(plot3(1), plota)
    plota  = gsn_csm_xy (wks,(/x_axis/),mmz(0:1,:),res)  ; Create filled XY plot.
    overlay(plot3(3), plota)
  end if

end do

color_sf = (/"lightpink","lightblue","darkolivegreen1","peachpuff" /)

do im = 0,nec-1

  ; STD shading
  mmz(0,:) = pca_cesm1(im,:)+cesm_std(im,:)
  mmz(1,:) = pca_cesm1(im,:)-cesm_std(im,:)

  res@gsnXYFillColors = "grey75"
  plota  = gsn_csm_xy (wks,(/x_axis/),mmz(0:1,:),res)  ; Create filled XY plot.
  overlay(plot2(im+1), plota)

if (im.ne.nec-1) then
  res@gsnXYFillColors = color_sf(im)
  plota  = gsn_csm_xy (wks,(/x_axis/),mmz(0:1,:),res)  ; Create filled XY plot.
  overlay(plots(0), plota)
end if

  if (im.eq.1) then
    res@gsnXYFillColors = "lightblue"
    plota  = gsn_csm_xy (wks,(/x_axis/),mmz(0:1,:),res)  ; Create filled XY plot.
    overlay(plot3(1), plota)
  end if
  if (im.eq.nec-1) then
    res@gsnXYFillColors = "bisque"
    plota  = gsn_csm_xy (wks,(/x_axis/),mmz(0:1,:),res)  ; Create filled XY plot.
    overlay(plot3(2), plota)
    plota  = gsn_csm_xy (wks,(/x_axis/),mmz(0:1,:),res)  ; Create filled XY plot.
    overlay(plot3(3), plota)
  end if

end do

do im = 0,nec2-1

  ; STD shading
  mmz(0,:) = pca_cesm2sf(im,:)+cesm_std_cesm2sf(im,:)
  mmz(1,:) = pca_cesm2sf(im,:)-cesm_std_cesm2sf(im,:)

  res@gsnXYFillColors = "grey75"
  plota  = gsn_csm_xy (wks,(/x_axis/),mmz(0:1,:),res)  ; Create filled XY plot.
  overlay(plot4(im), plota)

  res@gsnXYFillColors = color_sf(im)
  plota  = gsn_csm_xy (wks,(/x_axis/),mmz(0:1,:),res)  ; Create filled XY plot.
  overlay(plots(1), plota)

end do

mmz(0,:) = pca_cesm2+std_cesm2
mmz(1,:) = pca_cesm2-std_cesm2

res@gsnXYFillColors = "grey75"
plota  = gsn_csm_xy (wks,(/x_axis/),mmz(0:1,:),res)  ; Create filled XY plot.
overlay(plot3(2), plota)
res@gsnXYFillColors = "lightblue"
plota  = gsn_csm_xy (wks,(/x_axis/),mmz(0:1,:),res)  ; Create filled XY plot.
overlay(plot2(0), plota)

;---------all lens5---------

com_std_lens5 = dim_avg_n_Wrap(com_std,0)

  mmz(0,:) = com_lens5-com_std_lens5
  mmz(1,:) = com_lens5+com_std_lens5

  plota  = gsn_csm_xy (wks,(/x_axis/),mmz(0:1,:),res)  ; Create filled XY plot.
  overlay(plot5(0), plota)



; ; ;;legend
; ;   gres = True
; ;   gres@YPosPercent = 95.    ; expressed as %, 0->100, sets position of top border of legend
; ;                             ;  when gres@Position is set to its default setting of "Top" (Default = 95.)
; ;   gres@XPosPercent = 5      ; expressed as %, 0->100, sets position of left border of legend(Default = 5.)

; ;   lineres = True
; ;   lineres@lgLineColors = (/"black","blue"/) ; line colors
; ;   lineres@lgLineThicknesses = 2.5                        ; line thicknesses
; ;   lineres@LineLengthPercent = 9.                         ; expressed as %, 0->100, length of line

; ;   textres = True
; ;   textres@lgLabels = (/"PDV","TPDV"/)  ; legend labels (required)

;   ; plot(2) = simple_legend(wks,plot(2),gres,lineres,textres)
;   ; plot(3) = simple_legend(wks,plot(3),gres,lineres,textres)

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

  lgres@lgMonoDashIndex = True
  lgres@lgDashIndexes = 0;(/0,0,0,0,0,0,0,0/)
  lgres@lgLineColors       = (/"gold1","pink","grey75"/)
  labels1 = (/"CESM2(CMIP5forcing)  ","CESM1","CESM2" /)
  nitems1 = dimsizes(labels1)                 ; number of legend items

  lbid1 = gsn_create_legend(wks,nitems1,labels1,lgres)

  lgres@lgLineColors       = (/"green","blue" ,"lightpink3"/)
  labels2 = (/"Diff(Aerosol)","CESM1(XAerosol)  ","CESM1 " /)
  nitems2 = dimsizes(labels2)                 ; number of legend items
  lbid2 = gsn_create_legend(wks,nitems2,labels2,lgres)


  lgres@lgLineColors       = (/"green","gold1" ,"pink"/)
  labels4 = (/"Diff(CESM2/1physics)","CESM2(CMIP5forcing)","CESM1" /)
  nitems4 = dimsizes(labels4)                 ; number of legend items
  lbid4 = gsn_create_legend(wks,nitems4,labels4,lgres)

  delete(lgres@lgLineColors)
  delete(lgres@lgDashIndexes)
  lgres@lgMonoDashIndex = False
  lgres@lgDashIndexes = (/2,0,0/)
  lgres@lgLineColors       = (/"green","blue" ,"red"/);"green",
  labels6 = (/"ERSST ","CESM2(11)            ","CESM1(40)             " /) ;"Diff(CESM2/1)",
  nitems6 = dimsizes(labels6)                 ; number of legend items
  lbid6 = gsn_create_legend(wks,nitems6,labels6,lgres)

  delete(lgres@lgLineColors)

  delete(lgres@lgDashIndexes)

  lgres@lgDashIndexes = (/2,0,0,0/)
  lgres@lgLineColors       = (/"coral1","green","gold1" ,"grey75"/)
  labels3 = (/"NH TS Diff(CMIP6/5forcing)","Diff(CMIP6/5forcing)","CESM2(CMIP5forcing|7)","CESM2(11)" /)
  nitems3 = dimsizes(labels3)                 ; number of legend items
  lbid3 = gsn_create_legend(wks,nitems3,labels3,lgres)
  delete(lgres@lgLineColors)

  lgres@vpWidthF           = 0.2           ; width of legend (NDC)
  lgres@lgLabelFontHeightF = .06            ; legend label font thickness
  lgres@lgDashIndexes = (/0,0,0,0/)
  lgres@lgLineColors       = color_sf0(::-1)
  labelssf1 = (/"XLULC(5) R="+sprintf("%3.2f", escorc(pca_cesm1(3,:),cesm1_le)),\
  "XBMB(15) R="+sprintf("%3.2f", escorc(pca_cesm1(2,:),cesm1_le)),"XAER(20) R="+\
  sprintf("%3.2f", escorc(pca_cesm1(1,:),cesm1_le)),"XGHG(20) R="+sprintf("%3.2f", escorc(pca_cesm1(0,:),cesm1_le)) /)

  nitemssf1 = dimsizes(labelssf1)                 ; number of legend items
  lbid_sf1 = gsn_create_legend(wks,nitemssf1,labelssf1,lgres)

  labelssf2 = (/"EE(10) R="+sprintf("%3.2f", escorc(pca_cesm2sf(3,:),pca_cesm2)),\
  "BMB(10) R="+sprintf("%3.2f", escorc(pca_cesm2sf(2,:),pca_cesm2)),\
  "AER(15) R="+sprintf("%3.2f", escorc(pca_cesm2sf(1,:),pca_cesm2)),\
  "GHG(15) R="+sprintf("%3.2f", escorc(pca_cesm2sf(0,:),pca_cesm2)) /)
  nitemssf2 = dimsizes(labelssf2)                 ; number of legend items
  lbid_sf2 = gsn_create_legend(wks,nitemssf2,labelssf2,lgres)

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

  annoid1 = gsn_add_annotation(plot3(0),lbid1,amres)  ; add legend to plot
  annoid2 = gsn_add_annotation(plot3(1),lbid2,amres)  ; add legend to plot
  annoid3 = gsn_add_annotation(plot3(2),lbid3,amres)  ; add legend to plot
  annoid4 = gsn_add_annotation(plot3(3),lbid4,amres)  ; add legend to plot
  annoid6 = gsn_add_annotation(plot2(0),lbid6,amres)  ; add legend to plot
  annoid7 = gsn_add_annotation(plots(0),lbid_sf1,amres)  ; add legend to plot
  annoid8 = gsn_add_annotation(plots(1),lbid_sf2,amres)  ; add legend to plot

  lgres@lgLineColors       = (/"green","black"/)
  do im = 0,nec-1
    labels = (/EXP1_ef_name(im)+" effects",EXP1_name(im)+"         " /)
    nitemsa = dimsizes(labels)                 ; number of legend items
    label = unique_string("label")
    plot2@$label$ = gsn_create_legend(wks,nitemsa,labels,lgres)
    annot = unique_string("annot")
  plot2@$annot$ = gsn_add_annotation(plot2(im+1),plot2@$label$,amres)  ; add legend to plot
  end do

  delete(lgres@lgLineColors)

  lgres@vpWidthF           = 0.20           ; width of legend (NDC)
  lgres@vpHeightF          = 0.30           ; height of legend (NDC)
  lgres@lgLineColors       = colors;(::-1)
  labels5 = MODEL+"("+nens5+")"
  nitems5 = dimsizes(labels5)                 ; number of legend items

  lbid5 = gsn_create_legend(wks,nitems5,labels5,lgres)

  delete(lgres@lgLineColors)

  amres@amParallelPosF   =  0.5              ; Move legend to right
  amres@amOrthogonalPosF =  0.5              ; Move legend down.
  annoid5 = gsn_add_annotation(plot5(0),lbid5,amres)  ; add legend to plot

; ;************************************************
; ; Attach text to plot using plot coordinates.
; ;************************************************
;   txres               = True                     ; text mods desired
;   txres@txFontHeightF = 0.02                     ; font smaller. default big
;
;   txres@txFontColor  = "darkgreen"
;   dum1 = gsn_add_text(wks,plot3(2),"Difference(CMIP6/5forcing)",1970,-0.8,txres)
;   txres@txFontColor  = "darkgoldenrod3"
;   dum2 = gsn_add_text(wks,plot3(2),"CESM2(CMIP5forcing| 7)",1970,-0.6,txres)
;   txres@txFontColor  = "grey25"
;   dum3 = gsn_add_text(wks,plot3(2),"CESM2(11)",1970,-0.4,txres)

;------------------------------------------------
resk = True
;resk@txFontHeightF = 0.03
resk@gsnPanelLabelBar   = False                 ; add common colorbar
resk@gsnMaximize = True
resk@gsnPaperOrientation = "portrait"   ; force portrait
; resk@txString = IND
resk@gsnPanelCenter = False

gsn_panel(wks,plot1,(/3,2/),resk)
gsn_panel(wks,plot2,(/3,2/),resk)
gsn_panel(wks,plot2(1:4),(/2,2/),resk)
gsn_panel(wks,plot3,(/4,1/),resk)
gsn_panel(wks,plot4,(/2,2/),resk)
gsn_panel(wks,plot5,(/1,1/),resk)
gsn_panel(wks,(/plot2(0),plot3(2)/),(/2,1/),resk)
gsn_panel(wks,plots,(/2,1/),resk)


end
