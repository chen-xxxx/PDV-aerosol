; BE CAREFUL!!!! There is a weriod file in it!
; b.e21.BHISTcmip6.f09_g17.LE2-1231.005.cam.h0.TS.185912-186912.nc starts from 1859 not 1860!

begin

diri = "/glade/work/chenxing/enso/"
dirip = "/glade/u/home/chenxing/enso/"

diri_cesm2 = "/glade/campaign/cgd/cesm/CESM2-LE/"
;/glade/collections/cmip/CMIP6/CMIP/NCAR/CESM2/piControl/r1i1p1f1/Amon/ts/gn/latest/

MODEL_LOCS = "CESM2-LE"
MODEL = "CESM2-CAM6"

OCN = "True"
VAR = "TS" ;
EXPA = (/"cmip6", "smbb"/) ; the first 50 ens or the last 50 ens


NLAT =   45.
SLAT =  -30.
WLON =  110.
ELON =  290.;

neof = 3

yrs = 1850
yrl = 2014;2100
ymstrt = yrs*100+12
ymlast = yrl*100+12
if (MODEL.eq."CESM2-CAM6") then
  ymstrt = yrs*100+2
  ymlast = (yrl+1)*100+1
end if

nm = dimsizes(MODEL_LOCS)

do ix = 0,dimsizes(EXPA)-1
  EXP = EXPA(ix)
do im = 0,nm-1

    diri3 = diri_cesm2+"atm/proc/tseries/month_1/"+VAR+"/"

    ; b.e21.BHISTcmip6.f09_g17.LE2-1301.006.cam.h0.TS.192001-192912.nc
    ; b.e21.BHISTsmbb.f09_g17.LE2-1251.018.cam.h0.TS.198001-198912.nc
locs = systemfunc("ls "+diri3+"*"+EXP+"*185001*")
printVarSummary(locs)
print(locs)
nsa = dimsizes(locs)

ENSN  = new(nsa, "string")

istart = 0
do ie = istart,nsa-1

 locs_str = str_split(locs(ie), "."); "/")
 print("'" + locs_str + "'")

 ENSN(ie)  = locs_str(4)+"."+locs_str(5)

print(MODEL(im)+" ens "+ENSN(ie))

if (EXP.eq."smbb") then
if(ENSN(ie).eq."LE2-1191.010".or.ENSN(ie).eq."LE2-1251.017".or.\
  ENSN(ie).eq."LE2-1251.016".or.ENSN(ie).eq."LE2-1251.012".or.ENSN(ie).eq."LE2-1251.011") then
  print("missing ensembles!")
  continue
end if
end if

  fils = systemfunc("ls "+diri3+"*"+EXP+"*"+ENSN(ie)+"*001-*.nc");
  print(fils)
  f   = addfiles(fils, "r")  ;multiple files
  ListSetType (f, "cat")        ; concatenate (=default)

TIME2=f[:]->time
yyyymm2=cd_calendar(TIME2, -1)
printMinMax(yyyymm2, True)
ymstrts = ind(yyyymm2.eq.ymstrt)
ymlasts = ind(yyyymm2.eq.ymlast)
print(ymstrts+" <--start end--> "+ymlasts)

  xx  = f[:]->$VAR$(ymstrts:ymlasts,:,:)
printVarSummary(xx)

; ;climatology is 1975-2005
; xc = clmMonTLL(f[:]->$VAR$(ycstrts:yclasts,:,:))
; xa = calcMonAnomTLL(xx, xc)
xa = rmMonAnnCycTLL(xx)
; xa = dtrend_msg_n(xa&time, xa, True, False, 0)
; xa_annual = month_to_annual(xa,1)
; xa_annual!0 = "year"

; xa_sea = xa_annual
delete([/fils,f,TIME2,yyyymm2/]);,lat,lon
;-------------------------------------
;cover land data; do this first!!
;mask 0=ocean (land reserved), 1=land, 2=lake, 3=small island, 4=ice shelf.

 lland = addfile("$NCARG_ROOT/lib/ncarg/data/cdf/landsea.nc","r")
 lsm0 = landsea_mask(lland->LSMASK,xa&lat,xa&lon)
 xa_sea = mask(xa,lsm0.eq.1, False)      ; mask out land points
 copy_VarMeta(xa, xa_sea)

delete(lsm0)

;-------------------------
; Calculating index
; Nino 1+2 (0-10S, 90W-80W), Nino 3 (5N-5S, 150W-90W),
; Nino 3.4/ONI (5N-5S, 170W-120W) and Nino 4 (5N-5S, 160E-150W)
; TNI is Nino 1+2 - Nino 4
;
; TNA: Tropical Northern Atlantic Index* Anomaly of the average of the monthly SST from 5.5N to 23.5N and 15W to 57.5W.
; Enfield, D.B., A.M. Mestas, D.A. Mayer, and L. Cid-Serrano, 1999: How ubiquitous is the dipole relationship in
; tropical Atlantic sea surface temperatures? JGR-O, 104, 7841-7848.AOML and PSL

; NPGO index: SLP index is over the Hawaiian region (158W–135W;13N–24N)
; PDO SLP index: SLP over Northeast Pacific (25–61N, 179–111W)

; Pacific dipole (tripole) SST index: a 30-50N, 130E-160W b 10S-10N,150E-100W. b-a
; Pacific dipole (tripole) SST index2 (adapted from Dong et al. 2014 GRL): a 30-45N, 145E-180W b 10S-6N,160W-110W. b-a

; NP cloud effect index: 30-50N, 120E-110W

; East Asian (EA) SW: 20-40N,110-125E
; East American (AM) SW: 30-45N,90-75W

; SW_HD net surface SW radiation between Southern and Northern Hemisphere (Southern-Northern)

  lat = xa_sea&lat
  rad    = 4.0*atan(1.0)/180.0
  clat   = cos(lat*rad)
  copy_VarCoords(xa_sea(0,:,0), clat)
  ; go = wgt_areaave_Wrap(x,clat, 1.0, 1)

  NLAT1 =  45.
  SLAT1 =  30.
  WLON1 =  145.
  ELON1 =  180.;

  NLAT2 =  6.
  SLAT2 =  -10.
  WLON2 =  360.-160.;
  ELON2 =  360.-110.;

  gmst1 = wgt_areaave_Wrap(xa_sea(:,{SLAT1:NLAT1},{WLON1:ELON1}),clat({SLAT1:NLAT1}), 1.0, 1)
  gmst2 = wgt_areaave_Wrap(xa_sea(:,{SLAT2:NLAT2},{WLON2:ELON2}),clat({SLAT2:NLAT2}), 1.0, 1)

  gmst = gmst1
  gmst = gmst2 - gmst1
  gmst@long_name = "PDI" ;


; ;------------filter----------------------
; fyr   = 8.
; ihp   = 0                             ; low-pass filter: ihp = 0; high-pass ihp = 1; band-pass ihp = 2.
; sigma = 1.0                           ; Lanczos sigma
; nWgt  = toint(fyr*12*2+1) ;fyr)+1 ;                           ; odd only
; fca   = 1./(fyr*12););
; fcb   = -999.
; wgt  = filwgts_lanczos (nWgt, ihp, fca, fcb, sigma )

; gmst = wgt_runave_n_Wrap( gmst, wgt,  -1, 0 )   ;opt < 0 : utilize cyclic conditions


; gmst = dtrend_msg_n(gmst&time, gmst, True, False, 0)


;--------output-------------
fon=diri+"cesmle/PDI/"+MODEL(im)+"_"+EXP+"_"+ENSN(ie)+"_PDI_"+yrs+"-"+yrl+".nc";
system("rm -f "+fon)
fo=addfile(fon,"c")
fo->index = gmst

delete([/xx, xa,xa_sea,clat,lat/])

end do
delete([/ENSN,locs,gmst1,gmst /]);gmst2,
end do
end do
end
