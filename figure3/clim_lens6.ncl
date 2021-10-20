begin
diri = "/glade/work/chenxing/enso/"
dirip = "/glade/u/home/chenxing/enso/"


  yrs0 = 1850;1950;
  yrl0 = 2014
  ymstrt= yrs0*100+1
  ymlast= yrl0*100+12

diri1 = "/glade/collections/cmip/cmip6/"
diri2 = "/glade/work/chenxing/CMIP6/historical/remap/tos/"
;from cdo_cmip_data.ncl
diri3 = "/glade/scratch/chenxing/cmip6/"
diri_cesm2 = "/glade/campaign/cgd/cesm/CESM2-LE/"

; MODEL6 = (/"BCC-CSM2-MR","CAMS-CSM1-0","CanESM5","CESM2-FV2",\ ;"ACCESS-CM2","ACCESS-ESM1-5","BCC-ESM1",
;         "CESM2","CESM2-WACCM-FV2",\
;         "CESM2-WACCM","E3SM-1-0","FIO-ESM-2-0","GFDL-CM4",\;"E3SM-1-1","FGOALS-f3-L","FGOALS-g3","GFDL-ESM4",
;         "GISS-E2-1-G","INM-CM5-0","IPSL-CM6A-LR","MCM-UA-1-0","MIROC6",\;"GISS-E2-1-G-CC","GISS-E2-1-H",
;         "MPI-ESM1-2-HR","MPI-ESM1-2-LR","MRI-ESM2-0","NorCPM1","NorESM2-LM","SAM0-UNICON"/);"MPI-ESM-1-2-HAM","NESM3",

; MODEL6 = (/"IPSL-CM6A-LR","NorCPM1", "CanESM5", "GISS-E2-1-G","CESM2","INM-CM5-0",\;"GISS-E2-1-H",
  ; "MIROC6","MPI-ESM1-2-LR","MPI-ESM1-2-HR"/);,"MRI-ESM2-0","E3SM-1-0" /) ;large ensemble model in CMIP6 "NESM3",
; nens6 = (/32,30,25,12,11, 10,\;10,
; ;       10,10,7,5,5 /) ;ensemble number 5,

MODEL6 = "CESM2-CAM6" ;(/ "CESM2"/)

nm6 = dimsizes(MODEL6)
; nens_all = 32

VAR = "FSNS";(/"zg"/)  ;(/"ua","va"/) ;(/"ts","pr" ,"psl","rsds","rsdscs"/); "pr" ;"cloudeffect";(/"rsds","rsdscs"/) ;"psl" ; ;"ua" ;"od550aer"
VARn ="FSNS";(/"zg300"/);(/"ua200","va200"/) ;(/"ts","pr" ,"psl","rsds","rsdscs"/);"pr" ;"cloudeffect";(/"rsds","rsdscs"/) ;;"psl" ;  (/"ts","psl"/)
EXP = "historical"

yrs1 = (/1950,1991 /) ;1950;1950 ;1991;
yrl1 = (/1990,2014/) ;1990;1990 ;2014;

do iv = 0,dimsizes(VAR)-1
do i = 0,dimsizes(yrs1)-1


; note, the max lag should not be more than N/4
ccr1 = new((/nm6, 72,144 /), "float") ;cross correlation pattern

do im = 0,nm6-1

;from pdv_cmip6_hist.ncl
;or from cmip_index.ncl
;cmip6_historical_CanESM2_r4i1p1_pdv_1850-2014.nc
; locs = systemfunc("ls "+diri+"cmip6/pdv/cmip6_historical_"+MODEL6(im)+"_*_pdv_1850-2014.nc")
locs = systemfunc("ls "+diri+"cesmle/PDI/"+MODEL6(im)+"_*_PDI_1850-2014.nc")
printVarSummary(locs)
print(locs)
nsa = dimsizes(locs)

do ia = 0,nsa-1

 locs_str = str_split(locs(ia), "_"); "/")
 print("'" + locs_str + "'")
 if (MODEL6(im).eq."CESM2-CAM6") then
   ENSN  = locs_str(2)
   diric = diri_cesm2+"atm/proc/tseries/month_1/"+VAR+"/"
   fils = systemfunc("ls "+diric+"*"+ENSN+"*001-*.nc");
   print(fils)
   f   = addfiles(fils, "r")  ;multiple files
   ListSetType (f, "cat")        ; concatenate (=default)
   TIME2=f[:]->time
   yyyymm2=cd_calendar(TIME2, -1)
   printMinMax(yyyymm2, True)
   ymstrt = yrs0*100+2
   ymlast = (yrl0+1)*100+1
   ymstrts = ind(yyyymm2.eq.ymstrt)
   ymlasts = ind(yyyymm2.eq.ymlast)
   print(ymstrts+" <--start end--> "+ymlasts)

     xx  = f[:]->$VAR$(ymstrts:ymlasts,:,:)
else
  ENSN  = locs_str(3)

  print(MODEL6(im)+" ens "+ENSN)

    file_name = diri3+EXP+"/"+VAR(iv)+"/"+MODEL6(im)+"_"+VAR(iv)+"_"+EXP+"_"+ENSN+".nc"
    exists = isfilepresent(file_name)
    if(.not.exists) then
      print(MODEL6(im)+" ens "+ENSN+" file not exist")
      print("Either the file doesn't exist, or NCL does")
      print("not have OPeNDAP cabilities on this system.")
      continue
    else

    f   = addfile(file_name, "r")
    end if


  TIME2=f->time
  yyyymm2=cd_calendar(TIME2, -1)
  printMinMax(yyyymm2, True)
  ymstrts = ind(yyyymm2.eq.ymstrt)
  ymlasts = ind(yyyymm2.eq.ymlast)
  print(ymstrts+" <--start end--> "+ymlasts)

  xx  = f->$VAR(iv)$(ymstrts:ymlasts,:,:);{20000},:,:);
  ; xx  = f->ce(ymstrts:ymlasts,:,:)
end if
  printVarSummary(xx)

  delete([/f,TIME2,yyyymm2/]);,lat,lon

  xa = rmMonAnnCycTLL(xx)
  x_annual = month_to_annual(xx,1)
  xa_annual = month_to_annual(xa,1)

  a1 = yrs1(i)-yrs0
  b1 = yrl1(i)-yrs0
  print(a1+" "+b1)

  xc = dim_avg_n_Wrap(x_annual(a1:b1,:,:),0)
  ; xc = clmMonTLL(x_annual(a1:b1,:,:))
  xz = dim_avg_n_Wrap(x_annual,2)

  xca = dim_avg_n_Wrap(xa_annual(a1:b1,:,:),0)
  xza = dim_avg_n_Wrap(xa_annual,2)

;--------output-------------
fon=diri+"lens6/"+MODEL6(im)+"_"+ENSN+"_clim_"+EXP+"_"+VARn(iv)+"_"+yrs1(i)+"-"+yrl1(i)+".nc";
system("rm -f "+fon)
fo=addfile(fon,"c")
fo->clim  = xc
fo->aclim  = xca

fon=diri+"lens6/"+MODEL6(im)+"_"+ENSN+"_clim_zonal_"+EXP+"_"+VARn(iv)+"_"+yrs0+"-"+yrl0+".nc";
system("rm -f "+fon)
fo=addfile(fon,"c")
fo->xz  = xz
fo->axz  = xza

delete([/locs_str,xc,xx/]);,pc_sea2,xa_sea,pc_sea,xa
end do

delete([/locs/]);,x_Lead1

end do

end do
end do

end
