function bootstrap_mme(XX,nBoot,nens,tlength)
begin

; XX is the one-dimension pool
; nBoot is the times of sampling
; nens is the ensemble number
; --> get ensemble mean from random samples, then get the limits
; tlength is the length of the time series

;cleaning missing values
aa = ind(.not.ismissing(XX))
X2 = XX(aa)

ndim = dimsizes(X2)
                                             ; Test with small nBoot (eg: nBoot=10)
  xBt   = new ((/nBoot,tlength/), "float",XX@_FillValue)         ; array to hold nBoot results

  do ns=0,nBoot-1                              ; generate bootstrap results

    pc = new((/nens,tlength/),"float",XX@_FillValue)
    do ie = 0,nens-1
           ix = random_uniform(0, ndim(0)-1, tlength) ;
           jj = round(ix, 3) ; to integer
           pc(ie,:)= X2(jj)
     end do
     xBt(ns,:)= dim_avg_n_Wrap(pc,0)
end do
; printVarSummary(xBt)

HL =   new((/2, tlength/), "float",XX@_FillValue)
do is = 0,tlength-1

  xBoot = xBt(:,is);, ndtooned((/nBoot*nyra/))
                                               ; mean of all bootstrap samples at each grid point
;at =  ind(.not.ismissing(xBoot))
nis =  num(ismissing(xBoot))

  idx  = dim_pqsort_n(xBoot, 2, 0) ;(at) sort bootstrap means into ascending order at each grid point
  i025 = toint(0.025*(nBoot-nis));*nyra
  i975 = toint(0.975*(nBoot-nis));*nyra
  HL(0,is)   = xBoot(i025+nis-1)           ;  2.5% level; (nlat,mlon)
  HL(1,is)   = xBoot(i975+nis-1)           ; 97.5% level; (nlat,mlon)
end do

  ; units = XX@units
  HL@long_bame = "Bootstrap  2.5% Mean & Bootstrap 97.5% Mean"
  ; HL@units     = units

; printVarSummary(HL)


return HL

end
