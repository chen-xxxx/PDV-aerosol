begin
diri = "/glade/work/chenxing/enso/"
dirip = "/glade/u/home/chenxing/enso/"

NLAT =  70; 65; 5; 60;
SLAT =  20;-70;-5;-60;
WLON =  100;120;
ELON =  300;290;

NLAT0 =  90
SLAT0 =  -90
WLON0 =  0;
ELON0 =  360;

;read obs IPO results
;from obs_ipo.ncl
f0   = addfile(diri+"obs_pdv_1880-2018.nc", "r") ;obs_pdv_1854-2019.nc
rco  = f0->rc(0,:,:)
pco  = f0->pc
pcvaro  = f0->pcvar
printVarSummary(rco)

  fref = systemfunc("ls "+diri+"cmip6/tos.pdv/cmip6_historical_ACCESS-CM2_r1i1p1f1_pdv_1850-2014.nc")
  print(fref)
  fr   = addfile(fref(0), "r")  ;multiple files
  rref = fr->rc;({SLAT:NLAT},{WLON:ELON})

;change resolution for obs to fit with model (to do pattern correlation)
    aa = rco;({SLAT:NLAT},{WLON:ELON})
   ; r_lon = 360./dimsizes(xam&lon)
    ; r_lat = 180./dimsizes(xam&lat)
    lat = aa&lat
    lon = aa&lon
    nlat = dimsizes(rref&lat) ;target dimension size
    nlon = dimsizes(rref&lon) ;target dimension size
    klon = fspan(WLON, ELON, nlon) ;target dimension
    klat = fspan(SLAT, NLAT, nlat) ;target dimension
    rco_r= linint2_Wrap(lon, lat, aa, True, klon, klat, 0)
    rco_r&LAT@units="degrees_north"
    rco_r&LON@units="degrees_east"
    printVarSummary(rco_r)
    delete([/lat,lon,klat,klon,aa/]);xa0


;cesm1 single forcing
diri1 = "/glade/scratch/chenxing/cesm1_le/"
;b.e11.B20TRLENS_RCP85.f09_g16.xghg.011.cam.h0.TS.192001-200512.nc

;cesm2 with CMIP5 forcing
; diri2 = "/glade/scratch/chenxing/cesm2_cmip5_forcing/"
diri2 = "/glade/campaign/cesm/development/cross-wg/CESM2_CMIP5/"
;b.e21.BHIST.f09_g17.cesm2_cmip5_forcing.002.cam.h0.TS.185001-200512.nc
;cesm2_cmip5_forcing.004.cloudeffect.200601-209912.nc

VAR  = "TS";"cloudeffect";(/"U","V"/) ;"Z3";(/"TS","PRECT" ,"PSL","FSNS","FSNSC"/);(/"FSNS","FSNSC"/);(/"LWCF","SWCF"/) ;"PSL" ;(/"PRECT"/) ;"TS" ;  "va" ;"CLDTOT"
VARn = "TS";"cloudeffect";(/"ua200","va200"/) ;"zg300";(/"ts","pr" ,"psl","FSNS","FSNSC"/);(/"FSNS","FSNSC"/);(/"LWCF","SWCF"/) ;"psl" ;(/"pr"/) ;"ts" ; "va850";"clt"
AA =  ""

yrs1 = (/1950,1991 /) ;1950;1950 ;1991;
yrl1 = (/1990,2014/) ;1990;1990 ;2014;

do iv = 0,dimsizes(VAR)-1
do i = 0,dimsizes(yrs1)-1

MODEL = "cesm2-cmip5" ;"cesm1_le";
EXP =  "" ;(/"xghg", "xaer" , "xlulc", "xbmb"/);

nm = dimsizes(EXP)

do im = 0,nm-1


if (MODEL.eq."cesm2-cmip5") then
  ; locs = systemfunc("ls "+diri2+"*"+MODEL+"*."+VAR(iv)+".*.nc")
  ; diri0 = diri2
  diri0 = diri2+"b.e21.BHIST.f09_g17.cesm2-cmip5.*/atm/proc/tseries/month_1/"
  locs = systemfunc("ls "+diri0+"*"+MODEL+"*."+VAR+".*.nc")
  else
  locs = systemfunc("ls "+diri1+"*"+EXP(im)+"*."+VAR(iv)+".*.nc")
  diri0 = diri1
end if
print(locs)
nsa = dimsizes(locs)

ENSN  = new(nsa, "string")

aa = new((/nsa, 72,144 /), "float")
rp1 = new(nsa, "float")

istart = 0
do ia = istart,nsa-1

 locs_str = str_split(locs(ia), ".")
 print("'" + locs_str + "'")


 if (MODEL.eq."cesm2-cmip5") then
   kk = str_split(locs_str(5), "/")
   ENSN(ia)  = kk(0)
else
ENSN(ia)  = locs_str(5) ;5 for all except 1 cloudeffect
end if

bb = str_split(locs_str(9), "-");9 for all except 3 for cloudeffect

  yrl0 = 2014
  ymlast= yrl0*100+12
if(ia.eq.0) then
  ymstrt= bb(0)
  yrs0 = toint(tofloat(bb(0))/100.)
end if

print(ymstrt+", "+yrs0)
print(MODEL+" ens "+ENSN(ia))

if (MODEL.eq."cesm2-cmip5") then
  locs_str = str_split(locs(ia), ".")
  kk = str_split(locs_str(5), "/")
  ENSN(ia)  = kk(0)
  diri0 = diri2+"b.e21.BHIST.f09_g17.cesm2-cmip5."+ENSN(ia)+"/atm/proc/tseries/month_1/"
  dirir = diri2+"b.e21.BRCP85.f09_g17.cesm2-cmip5."+ENSN(ia)+"/atm/proc/tseries/month_1/"
  fils = systemfunc("ls "+diri0+"*."+ENSN(ia)+"*."+VAR+".* "+dirir+"*."+ENSN(ia)+"*."+VAR+".*"); +locs(ie));+"/*.nc")
  yrs0 = 1920
  ymstrt = yrs0*100+2
  ymlast = (yrl0+1)*100+1
else
  ;b.e11.B20TRLENS_RCP85.f09_g16.xaer.014.cam.h0.TS.192001-200512.nc
  ;b.e11.B20TRLENS_RCP85.f09_g16.xaer.013.cam.h0.TS.200601-208012.nc
  fils = systemfunc("ls "+diri0+"*"+EXP(im)+"."+ENSN(ia)+"*."+VAR(iv)+".*"); +locs(ie));+"/*.nc")
end if
  f   = addfiles(fils, "r")  ;multiple files
  ListSetType (f, "cat")        ; concatenate (=default)


;only do historical part here first
TIME2=f[:]->time
yyyymm2=cd_calendar(TIME2, -1)
printMinMax(yyyymm2, True)
ymstrts = ind(yyyymm2.eq.ymstrt)
ymlasts = ind(yyyymm2.eq.ymlast)
print(ymstrts+" <--start end--> "+ymlasts)

  xx  = f[:]->$VAR(iv)$(ymstrts:ymlasts,:,:);(0:ymlasts+1,:,:) ;{850},:,:);
  ; xx  = f[:]->ce(0:ymlasts+1,:,:) ;{850},:,:);(ymstrts:ymlasts,:,:);
    if (MODEL.eq."cesm2-cmip5".and.VAR(iv).eq."PRECT") then
      xx = xx *1000
      xx@units = "kg m-2 s-1"
    end if
  delete([/f,TIME2,yyyymm2/]);,lat,lon

  ; xc = clmMonTLL(xx(a1:b1,:,:))
  xa = rmMonAnnCycTLL(xx)
  x_annual = month_to_annual(xx,1)
  xa_annual = month_to_annual(xa,1)

;
; ;---------interpolate---------------------
; ;change resolution for MODELS to the same 144*72
;     zz = xx
;    ; r_lon = 360./dimsizes(xam&lon)
;     ; r_lat = 180./dimsizes(xam&lat)
;     lat = zz&lat
;     lon = zz&lon
;     nlat = dimsizes(rref&lat) ;target dimension size
;     nlon = dimsizes(rref&lon) ;target dimension size
;     klon = fspan(WLON0, ELON0, nlon) ;target dimension
;     klat = fspan(SLAT0, NLAT0, nlat) ;target dimension
;     cc= linint2_Wrap(lon, lat, zz, True, klon, klat, 0)
;     cc&LAT@units="degrees_north"
;     cc&LON@units="degrees_east"
;     printVarSummary(cc)
;     delete([/lat,lon,klat,klon,zz/]);xa0
;     cc!1 = "lat"
;     cc!2 = "lon"
;
; copy_VarMeta(cc(0,:,:), xx(0,:,:))

a1 = yrs1(i)-yrs0
b1 = yrl1(i)-yrs0
print(a1+" "+b1)

xc = dim_avg_n_Wrap(x_annual(a1:b1,:,:),0)
; xc = clmMonTLL(x_annual(a1:b1,:,:))
xz = dim_avg_n_Wrap(x_annual,2)

xca = dim_avg_n_Wrap(xa_annual(a1:b1,:,:),0)
xza = dim_avg_n_Wrap(xa_annual,2)

;--------output-------------
if (MODEL.eq."cesm2-cmip5") then
  fon=diri+"lens5/"+MODEL+"_"+ENSN(ia)+"_clim_"+VARn(iv)+"_"+yrs1(i)+"-"+yrl1(i)+".nc";
  fon2=diri+"lens5/"+MODEL+"_"+ENSN(ia)+"_clim_zonal_"+VARn(iv)+"_"+yrs0+"-"+yrl0+".nc";
else
  fon=diri+"lens5/"+MODEL+"_"+EXP(im)+"_"+ENSN(ia)+"_clim_"+VARn(iv)+"_"+yrs1(i)+"-"+yrl1(i)+".nc";
  fon2=diri+"lens5/"+MODEL+"_"+EXP(im)+"_"+ENSN(ia)+"_clim_zonal_"+VARn(iv)+"_"+yrs0+"-"+yrl0+".nc";
end if
system("rm -f "+fon)
fo=addfile(fon,"c")
fo->clim  = xc
fo->aclim  = xca

system("rm -f "+fon2)
fo=addfile(fon2,"c")
fo->xz  = xz
fo->axz  = xza

delete([/locs_str,xc,xx/]);,pc_sea2,xa_sea2,
end do

delete([/locs/]);,x_Lead1

print("calculation is done for "+MODEL(0))
delete([/ENSN/])

end do

print("calculation is done")
end do
end do

end
