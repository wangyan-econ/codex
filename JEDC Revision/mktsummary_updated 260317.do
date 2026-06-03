////////////////////////////////////////////////////////////////////////////////////////////////////////
gen mkt = 1 if Treatment == 1|Treatment ==3
replace mkt = 0 if Treatment == 2|Treatment ==4
gen urncomposition = 1 if Treatment == 1|Treatment ==2
replace urncomposition = 0 if Treatment == 3|Treatment ==4
//////////////////////////////////////////////////////////////////////////////////////////////
merge m:m Session using "C:\Users\yan006\Dropbox\Project with WANG YAN 2019\1ST PROJECT\DO and DTA Files\211028 summary\questionnaire.dta", keepusing(avgage avggender avgmajorecon avgriskaversion Grp2avgage Grp2avggender Grp2avgmajorecon Grp2avgriskaversion)
drop _merge
gen age = avgage
gen gender = avggender
gen majorecon = avgmajorecon
gen riskaversion = avgriskaversion
drop avgage avggender avgmajorecon avgriskaversion
gen Grp2age = Grp2avgage
gen Grp2gender = Grp2avggender
gen Grp2majorecon = Grp2avgmajorecon
gen Grp2riskaversion = Grp2avgriskaversion
drop Grp2avgage Grp2avggender Grp2avgmajorecon Grp2avgriskaversion
//////////////////////////////////////////////////////////////////////////////////////////////
//#Table XIV. Period-average summary statistics of balls acquired
merge 1:m Session Period using "C:\Users\yan006\Dropbox\Project with WANG YAN 2019\1ST PROJECT\DO and DTA Files\211028 summary\subjects.dta", keepusing(informed uninformed)
keep in 1/480
drop _merge

use mktsummary.dta, replace
tabstat SumNumAcq, by(Treatment) stat(mean sd min max n)
ranksum SumNumAcq if urncomposition == 0, by(mkt)
ranksum SumNumAcq if urncomposition == 1, by(mkt)

tabstat NumSubInformed, by(Treatment) stat(mean sd min max n)
ranksum NumSubInformed if urncomposition == 0, by(mkt)
ranksum NumSubInformed if urncomposition == 1, by(mkt)

gen informedratio = informed/12
tabstat informedratio, by(Treatment) stat(mean sd min max n)
ranksum informedratio if urncomposition == 0, by(mkt)
ranksum informedratio if urncomposition == 1, by(mkt)
//////////////////////////////////////////////////////////////////////////////////////////////
//#Table I. OLS of SumNumAcq
use mktsummary.dta, replace

reg SumNumAcq mkt Period if urncomposition == 0, vce(cluster Session)
outreg2 using reg.xls,replace
reg SumNumAcq mkt Grp2age Grp2gender Grp2majorecon Grp2riskaversion Period if urncomposition == 0, vce(cluster Session)
outreg2 using reg.xls,append
reg SumNumAcq mkt Period if urncomposition == 1, vce(cluster Session)
outreg2 using reg.xls,append
reg SumNumAcq mkt Grp2age Grp2gender Grp2majorecon Grp2riskaversion Period if urncomposition == 1, vce(cluster Session)
outreg2 using reg.xls,append
//////////////////////////////////////////////////////////////////////////////////////////////
///JEDC RR
//#Table I. OLS of SumNumAcq (with Dark × Period interaction)
///by Period 5/10/15/20
use mktsummary.dta, replace
* Low precision
reg SumNumAcq i.mkt##c.Period if urncomposition == 0, vce(cluster Session)
outreg2 using reg.xls, replace

reg SumNumAcq i.mkt##c.Period Grp2age Grp2gender Grp2majorecon Grp2riskaversion ///
    if urncomposition == 0, vce(cluster Session)
margins mkt, at(Period=(5 10 15 20))
marginsplot, ///
    title("Number of Signals Acquired in a Market by Period (Low Precision)", size(medium)) ///
    subtitle("Predicted values with 95% confidence intervals", size(small)) ///
    xtitle("Period", size(medsmall)) ///
    ytitle("Predicted Number of Signals Acquired in a Market", size(medsmall)) ///
    legend(order(1 "Lit only" 2 "Dark") pos(6) ring(1) cols(2) size(medsmall))
outreg2 using reg.xls, append
* High precision
reg SumNumAcq i.mkt##c.Period if urncomposition == 1, vce(cluster Session)
outreg2 using reg.xls, append

reg SumNumAcq i.mkt##c.Period Grp2age Grp2gender Grp2majorecon Grp2riskaversion ///
    if urncomposition == 1, vce(cluster Session)
margins mkt, at(Period=(5 10 15 20))
marginsplot, ///
    title("Number of Signals Acquired in a Market by Period (High Precision)", size(medium)) ///
    subtitle("Predicted values with 95% confidence intervals", size(small)) ///
    xtitle("Period", size(medsmall)) ///
    ytitle("Predicted Number of Signals Acquired in a Market", size(medsmall)) ///
    legend(order(1 "Lit only" 2 "Dark") pos(6) ring(1) cols(2) size(medsmall))
outreg2 using reg.xls, append
///////////////////////////////////////////////////////////////////////////////////////////////////////////
gen block = 1 if Period < 11
replace block = 2 if Period > 10

label define blocklab 1 "Period 1-10" 2 "Period 11-20", replace
label values block blocklab
//#Table I. OLS of SumNumAcq (with Dark × Period interaction)
///by Period 10/20
use mktsummary.dta, replace
* Low precision
reg SumNumAcq i.mkt##c.Period if urncomposition == 0, vce(cluster Session)
outreg2 using reg.xls, replace

reg SumNumAcq i.mkt##c.Period Grp2age Grp2gender Grp2majorecon Grp2riskaversion ///
    if urncomposition == 0, vce(cluster Session)
margins mkt, at(Period=(10 20))
marginsplot, ///
    xscale(range(8 22)) ///
    xlabel(10 20) ///
    title("Number of Signals Acquired in a Market by Period (Low Precision)", size(medium)) ///
    subtitle("Predicted values with 95% confidence intervals", size(small)) ///
    xtitle("Period", size(medsmall)) ///
    ytitle("Predicted Number of Signals Acquired in a Market", size(medsmall)) ///
    legend(order(1 "Lit only" 2 "Dark") pos(6) ring(1) cols(2) size(medsmall))
outreg2 using reg.xls, append
* High precision
reg SumNumAcq i.mkt##c.Period if urncomposition == 1, vce(cluster Session)
outreg2 using reg.xls, append

reg SumNumAcq i.mkt##c.Period Grp2age Grp2gender Grp2majorecon Grp2riskaversion ///
    if urncomposition == 1, vce(cluster Session)
margins mkt, at(Period=(10 20))
marginsplot, ///
    xscale(range(8 22)) ///
    xlabel(10 20) ///
    title("Number of Signals Acquired in a Market by Period (High Precision)", size(medium)) ///
    subtitle("Predicted values with 95% confidence intervals", size(small)) ///
    xtitle("Period", size(medsmall)) ///
    ytitle("Predicted Number of Signals Acquired in a Market", size(medsmall)) ///
    legend(order(1 "Lit only" 2 "Dark") pos(6) ring(1) cols(2) size(medsmall))
outreg2 using reg.xls, append
///////////////////////////////////////////////////////////////////////////////////////////////////////////
////by 4 intervals
* Low precision
label define intervallab 1 "P1-5" 2 "P6-10" 3 "P11-15" 4 "P16-20", replace
label values interval intervallab

reg SumNumAcq i.mkt##i.interval if urncomposition == 0, vce(cluster Session)
outreg2 using reg.xls, replace

reg SumNumAcq i.mkt##i.interval Grp2age Grp2gender Grp2majorecon Grp2riskaversion ///
    if urncomposition == 0, vce(cluster Session)
margins mkt#interval
marginsplot, xdimension(interval) ///
    title("Number of Signals Acquired in a Market by Period (Low Precision)", size(medium)) ///
    subtitle("Predicted values with 95% confidence intervals", size(small)) ///
    xtitle("Period", size(medsmall)) ///
    ytitle("Predicted Number of Signals Acquired in a Market", size(medsmall)) ///
    legend(order(1 "Lit only" 2 "Dark") pos(6) ring(1) cols(2) size(medsmall))
outreg2 using reg.xls, append
* High precision
reg SumNumAcq i.mkt##i.interval if urncomposition == 1, vce(cluster Session)
outreg2 using reg.xls, append

reg SumNumAcq i.mkt##i.interval Grp2age Grp2gender Grp2majorecon Grp2riskaversion ///
    if urncomposition == 1, vce(cluster Session)
margins mkt#interval
marginsplot, xdimension(interval) ///
    title("Number of Signals Acquired in a Market by Period (High Precision)", size(medium)) ///
    subtitle("Predicted values with 95% confidence intervals", size(small)) ///
    xtitle("Period", size(medsmall)) ///
    ytitle("Predicted Number of Signals Acquired in a Market", size(medsmall)) ///
    legend(order(1 "Lit only" 2 "Dark") pos(6) ring(1) cols(2) size(medsmall))
outreg2 using reg.xls, append
//////////////////////////////////////////////////////////////////////////////////////////////
////by 2 intervals
gen block = 1 if Period < 11
replace block = 2 if Period > 10

label define blocklab 1 "Period 1-10" 2 "Period 11-20", replace
label values block blocklab

* Low precision
reg SumNumAcq i.mkt##i.block if urncomposition == 0, vce(cluster Session)
outreg2 using reg.xls, replace

reg SumNumAcq i.mkt##i.block Grp2age Grp2gender Grp2majorecon Grp2riskaversion ///
    if urncomposition == 0, vce(cluster Session)
margins mkt#block
marginsplot, xdimension(block) ///
    xscale(range(0.75 2.25)) ///
    title("Number of Signals Acquired in a Market by Period (Low Precision)", size(medium)) ///
    subtitle("Predicted values with 95% confidence intervals", size(small)) ///
    xtitle("Period", size(medsmall)) ///
    ytitle("Predicted Number of Signals Acquired in a Market", size(medsmall)) ///
    legend(order(1 "Lit only" 2 "Dark") pos(6) ring(1) cols(2) size(medsmall))
outreg2 using reg.xls, append
* High precision
reg SumNumAcq i.mkt##i.block if urncomposition == 1, vce(cluster Session)
outreg2 using reg.xls, append

reg SumNumAcq i.mkt##i.block Grp2age Grp2gender Grp2majorecon Grp2riskaversion ///
    if urncomposition == 1, vce(cluster Session)
margins mkt#block
marginsplot, xdimension(block) ///
    xscale(range(0.75 2.25)) ///
    title("Number of Signals Acquired in a Market by Period (High Precision)", size(medium)) ///
    subtitle("Predicted values with 95% confidence intervals", size(small)) ///
    xtitle("Period", size(medsmall)) ///
    ytitle("Predicted Number of Signals Acquired in a Market", size(medsmall)) ///
    legend(order(1 "Lit only" 2 "Dark") pos(6) ring(1) cols(2) size(medsmall))
outreg2 using reg.xls, append
//////////////////////////////////////////////////////////////////////////////////////////////
////by 2 intervals
* Low precision
reg LADLIT i.mkt##i.block if urncomposition == 0, vce(cluster Session)
outreg2 using reg.xls, replace
reg LADLIT i.mkt##i.block Grp2age Grp2gender Grp2majorecon Grp2riskaversion if urncomposition == 0, vce(cluster Session)
margins mkt#block
marginsplot, xdimension(block) ///
    xscale(range(0.75 2.25)) ///
    title("Number of Signals Acquired in a Market by Period (Low Precision)", size(medium)) ///
    subtitle("Predicted values with 95% confidence intervals", size(small)) ///
    xtitle("Period", size(medsmall)) ///
    ytitle("Predicted Number of Signals Acquired in a Market", size(medsmall)) ///
    legend(order(1 "Lit only" 2 "Dark") pos(6) ring(1) cols(2) size(medsmall))
outreg2 using reg.xls, append
* High precision
reg LADLIT i.mkt##i.block if urncomposition == 1, vce(cluster Session)
outreg2 using reg.xls, append
reg LADLIT i.mkt##i.block Grp2age Grp2gender Grp2majorecon Grp2riskaversion if urncomposition == 1, vce(cluster Session)
margins mkt#block
marginsplot, xdimension(block) ///
    xscale(range(0.75 2.25)) ///
    title("Number of Signals Acquired in a Market by Period (High Precision)", size(medium)) ///
    subtitle("Predicted values with 95% confidence intervals", size(small)) ///
    xtitle("Period", size(medsmall)) ///
    ytitle("Predicted Number of Signals Acquired in a Market", size(medsmall)) ///
    legend(order(1 "Lit only" 2 "Dark") pos(6) ring(1) cols(2) size(medsmall))
outreg2 using reg.xls, append
//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
////by 2 intervals
* Low precision

//////////////////////////////////////////////////////////////////////////////////////////////

//#Table VII/VIII JEDC RR
use mktsummary.dta, replace

reg SumNumAcq urncomposition i.urncomposition##c.Period Period if mkt == 0, vce(cluster Session)

outreg2 using reg.xls,replace
reg SumNumAcq urncomposition i.urncomposition##c.Period Grp2age Grp2gender Grp2majorecon Grp2riskaversion Period if mkt == 0, vce(cluster Session)

outreg2 using reg.xls,append
reg SumNumAcq urncomposition i.urncomposition##c.Period Period if mkt == 1, vce(cluster Session)

outreg2 using reg.xls,append
reg SumNumAcq urncomposition i.urncomposition##c.Period Grp2age Grp2gender Grp2majorecon Grp2riskaversion Period if mkt == 1, vce(cluster Session)

outreg2 using reg.xls,append
////////////////////////////////////////////////////////////////////////////////////
merge 1:m Session Period using "/Users/yan/Library/CloudStorage/Dropbox/Project with WANG YAN 2019/1ST PROJECT/DO and DTA Files/211028 summary/subjects_updated 260317.dta", keepusing(infolitsubmission infodarksubmission infototsubmission infolittrade infodarktrade infotottrade uninfolitsubmission uninfodarksubmission uninfototsubmission uninfolittrade uninfodarktrade uninfotottrade)
keep in 1/480
drop _merge
////////////////////////////////////////////////////////////////////////////////////
gen interval = 1 if Period < 6
replace interval = 2 if Period > 5 & Period < 11
replace interval = 3 if Period > 10 & Period < 16
replace interval = 4 if Period > 15
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
use mktsummary.dta, replace
collapse (mean) meanladlit= LADLIT (sd) sdladlit=LADLIT (count) n1 = LADLIT (mean) meanladdark= LADDARK (sd) sdladdark=LADDARK (count) n2 = LADDARK (mean) meansumacq= SumNumAcq (sd) sdsumacq=SumNumAcq (count) n3 = SumNumAcq (mean) meaninfolitsub= infolitsubmission (sd) sdinfolitsub=infolitsubmission (count) n4 = infolitsubmission (mean) meanuninfolitsub= uninfolitsubmission (sd) sduninfolitsub=uninfolitsubmission (count) n5 = uninfolitsubmission (mean) meaninfolittrade= infolittrade (sd) sdinfolittrade=infolittrade (count) n6 = infolittrade (mean) meanuninfolittrade= uninfolittrade (sd) sduninfolittrade=uninfolittrade (count) n7 = uninfolittrade (mean) meaninfodarksub= infodarksubmission (sd) sdinfodarksub=infodarksubmission (count) n8 = infodarksubmission (mean) meanuninfodarksub= uninfodarksubmission (sd) sduninfodarksub=uninfodarksubmission (count) n9 = uninfodarksubmission (mean) meaninfodarktrade= infodarktrade (sd) sdinfodarktrade=infodarktrade (count) n10 = infodarktrade (mean) meanuninfodarktrade= uninfodarktrade (sd) sduninfodarktrade=uninfodarktrade (count) n11 = uninfodarktrade, by(urncomposition mkt interval)
gen highladlit = meanladlit + invttail(n1-1,0.025)*(sdladlit/sqrt(n1))
gen lowladlit = meanladlit - invttail(n1-1,0.025)*(sdladlit/sqrt(n1))
gen highladdark = meanladdark + invttail(n2-1,0.025)*(sdladdark/sqrt(n2))
gen lowladdark = meanladdark - invttail(n2-1,0.025)*(sdladdark/sqrt(n2))
gen highsumacq = meansumacq + invttail(n3-1,0.025)*(sdsumacq/sqrt(n3))
gen lowsumacq = meansumacq - invttail(n3-1,0.025)*(sdsumacq/sqrt(n3))
gen highinfolitsub = meaninfolitsub + invttail(n4-1,0.025)*(sdinfolitsub/sqrt(n4))
gen lowinfolitsub = meaninfolitsub - invttail(n4-1,0.025)*(sdinfolitsub/sqrt(n4))
gen highuninfolitsub = meanuninfolitsub + invttail(n5-1,0.025)*(sduninfolitsub/sqrt(n5))
gen lowuninfolitsub = meanuninfolitsub - invttail(n5-1,0.025)*(sduninfolitsub/sqrt(n5))
gen highinfolittrade = meaninfolittrade + invttail(n6-1,0.025)*(sdinfolittrade/sqrt(n6))
gen lowinfolittrade  = meaninfolittrade - invttail(n6-1,0.025)*(sdinfolittrade/sqrt(n6))
gen highuninfolittrade  = meanuninfolittrade + invttail(n7-1,0.025)*(sduninfolittrade/sqrt(n7))
gen lowuninfolittrade = meanuninfolittrade - invttail(n7-1,0.025)*(sduninfolittrade/sqrt(n7))
gen highinfodarksub = meaninfodarksub + invttail(n8-1,0.025)*(sdinfodarksub/sqrt(n8))
gen lowinfodarksub = meaninfodarksub - invttail(n8-1,0.025)*(sdinfodarksub/sqrt(n8))
gen highuninfodarksub = meanuninfodarksub + invttail(n9-1,0.025)*(sduninfodarksub/sqrt(n9))
gen lowuninfodarksub = meanuninfodarksub - invttail(n9-1,0.025)*(sduninfodarksub/sqrt(n9))
gen highinfodarktrade = meaninfodarktrade + invttail(n10-1,0.025)*(sdinfodarktrade/sqrt(n10))
gen lowinfodarktrade  = meaninfodarktrade - invttail(n10-1,0.025)*(sdinfodarktrade/sqrt(n10))
gen highuninfodarktrade  = meanuninfodarktrade + invttail(n11-1,0.025)*(sduninfodarktrade/sqrt(n11))
gen lowuninfodarktrade = meanuninfodarktrade - invttail(n11-1,0.025)*(sduninfodarktrade/sqrt(n11))

label define INT 1 "Period 1-5" 2 "Period 6-10" 3 "Period 11-15" 4 "Period 16-20"
label values interval INT
format meanladlit meanladlit %9.3g

twoway (bar meanladlit interval if interval == 1, barwidth(.5)) (bar meanladlit interval if interval == 2, barwidth(.5))(bar meanladlit interval if interval == 3, barwidth(.5))(bar meanladlit interval if interval == 4, barwidth(.5))(rcap highladlit lowladlit interval, color(black)) if urncomposition ==0 & mkt == 0, legend(off)title({stSerif: Low precision & Lit only}) ytitle({stSerif:LAD}) yscale(range(0 5)) graphregion(color(white)) name(a,replace) xlabel( 1 `"{fontface "stSerif": Period 1-5}"' 2 `"{fontface "stSerif": Period 6-10}"' 3 `"{fontface "stSerif": Period 11-15}"' 4 `"{fontface "stSerif": Period 16-20}"', noticks) xtitle({stSerif: Period})ylabel(0 `"{fontface "stSerif": 0}"' 1 `"{fontface "stSerif": 1}"' 2 `"{fontface "stSerif": 2}"' 3 `"{fontface "stSerif": 3}"' 4 `"{fontface "stSerif": 4}"'5`"{fontface "stSerif": 5}"', angle(0) valuelabel)

twoway (bar meanladlit interval if interval == 1, barwidth(.5)) (bar meanladlit interval if interval == 2, barwidth(.5))(bar meanladlit interval if interval == 3, barwidth(.5))(bar meanladlit interval if interval == 4, barwidth(.5))(rcap highladlit lowladlit interval, color(black)) if urncomposition ==1 & mkt == 0, legend(off)title({stSerif: High precision & Lit only}) ytitle({stSerif:LAD}) yscale(range(0 5)) graphregion(color(white)) name(b,replace) xlabel( 1 `"{fontface "stSerif": Period 1-5}"' 2 `"{fontface "stSerif": Period 6-10}"' 3 `"{fontface "stSerif": Period 11-15}"' 4 `"{fontface "stSerif": Period 16-20}"', noticks) xtitle({stSerif: Period})ylabel(0 `"{fontface "stSerif": 0}"' 1 `"{fontface "stSerif": 1}"' 2 `"{fontface "stSerif": 2}"' 3 `"{fontface "stSerif": 3}"' 4 `"{fontface "stSerif": 4}"'5`"{fontface "stSerif": 5}"', angle(0) valuelabel)

twoway (bar meanladlit interval if interval == 1, barwidth(.5)) (bar meanladlit interval if interval == 2, barwidth(.5))(bar meanladlit interval if interval == 3, barwidth(.5))(bar meanladlit interval if interval == 4, barwidth(.5))(rcap highladlit lowladlit interval, color(black)) if urncomposition ==0 & mkt == 1, legend(off)title({stSerif: Low precision & Lit and Dark}) ytitle({stSerif:LAD}) yscale(range(0 5)) graphregion(color(white)) name(c,replace) xlabel(1 `"{fontface "stSerif": Period 1-5}"' 2 `"{fontface "stSerif": Period 6-10}"' 3 `"{fontface "stSerif": Period 11-15}"' 4 `"{fontface "stSerif": Period 16-20}"', noticks) xtitle({stSerif: Period})ylabel(0 `"{fontface "stSerif": 0}"' 1 `"{fontface "stSerif": 1}"' 2 `"{fontface "stSerif": 2}"' 3 `"{fontface "stSerif": 3}"' 4 `"{fontface "stSerif": 4}"'5`"{fontface "stSerif": 5}"', angle(0) valuelabel)

twoway (bar meanladlit interval if interval == 1, barwidth(.5)) (bar meanladlit interval if interval == 2, barwidth(.5))(bar meanladlit interval if interval == 3, barwidth(.5))(bar meanladlit interval if interval == 4, barwidth(.5))(rcap highladlit lowladlit interval, color(black)) if urncomposition ==1 & mkt == 1, legend(off)title({stSerif: High precision & Lit and Dark}) ytitle({stSerif:LAD}) yscale(range(0 5)) graphregion(color(white)) name(d,replace) xlabel(1 `"{fontface "stSerif": Period 1-5}"' 2 `"{fontface "stSerif": Period 6-10}"' 3 `"{fontface "stSerif": Period 11-15}"' 4 `"{fontface "stSerif": Period 16-20}"', noticks) xtitle({stSerif: Period})ylabel(0 `"{fontface "stSerif": 0}"' 1 `"{fontface "stSerif": 1}"' 2 `"{fontface "stSerif": 2}"' 3 `"{fontface "stSerif": 3}"' 4 `"{fontface "stSerif": 4}"'5`"{fontface "stSerif": 5}"', angle(0) valuelabel)

grc1leg a b c d, title({stSerif:LAD in Lit Market}) legendfrom(a) graphregion(color(white))
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .title.draw_view.setstyle, style(no)
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
twoway (bar meanladdark interval if interval == 1, barwidth(.5)) (bar meanladdark interval if interval == 2, barwidth(.5))(bar meanladdark interval if interval == 3, barwidth(.5))(bar meanladdark interval if interval == 4, barwidth(.5))(rcap highladdark lowladdark interval, color(black)) if urncomposition ==0 & mkt == 1, legend(off)title({stSerif: Low precision & Lit and Dark}) ytitle({stSerif:LAD}) yscale(range(0 5)) graphregion(color(white)) name(a,replace) xlabel( 1 `"{fontface "stSerif": Period 1-5}"' 2 `"{fontface "stSerif": Period 6-10}"' 3 `"{fontface "stSerif": Period 11-15}"' 4 `"{fontface "stSerif": Period 16-20}"', noticks) xtitle({stSerif: Period})ylabel(0 `"{fontface "stSerif": 0}"' 1 `"{fontface "stSerif": 1}"' 2 `"{fontface "stSerif": 2}"' 3 `"{fontface "stSerif": 3}"' 4 `"{fontface "stSerif": 4}"'5`"{fontface "stSerif": 5}"', angle(0) valuelabel)

twoway (bar meanladdark interval if interval == 1, barwidth(.5)) (bar meanladdark interval if interval == 2, barwidth(.5))(bar meanladdark interval if interval == 3, barwidth(.5))(bar meanladdark interval if interval == 4, barwidth(.5))(rcap highladdark lowladdark interval, color(black)) if urncomposition ==1 & mkt == 1, legend(off)title({stSerif: High precision & Lit and Dark}) ytitle({stSerif:LAD}) yscale(range(0 5)) graphregion(color(white)) name(b,replace) xlabel(1 `"{fontface "stSerif": Period 1-5}"' 2 `"{fontface "stSerif": Period 6-10}"' 3 `"{fontface "stSerif": Period 11-15}"' 4 `"{fontface "stSerif": Period 16-20}"', noticks) xtitle({stSerif: Period})ylabel(0 `"{fontface "stSerif": 0}"' 1 `"{fontface "stSerif": 1}"' 2 `"{fontface "stSerif": 2}"' 3 `"{fontface "stSerif": 3}"' 4 `"{fontface "stSerif": 4}"'5`"{fontface "stSerif": 5}"', angle(0) valuelabel)

grc1leg a b, title({stSerif:LAD in Dark Market}) legendfrom(a) graphregion(color(white))
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .title.draw_view.setstyle, style(no)
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
twoway (bar meanladlit interval if interval == 1, barwidth(.5)) (bar meanladlit interval if interval == 2, barwidth(.5))(bar meanladlit interval if interval == 3, barwidth(.5))(bar meanladlit interval if interval == 4, barwidth(.5))(rcap highladlit lowladlit interval, color(black)) if urncomposition ==0 & mkt == 0, legend(off)title({stSerif: Lit only}) ytitle({stSerif:LAD in Lit Market}) yscale(range(0 5)) graphregion(color(white)) name(a,replace) xlabel( 1 `"{fontface "stSerif": Period 1-5}"' 2 `"{fontface "stSerif": Period 6-10}"' 3 `"{fontface "stSerif": Period 11-15}"' 4 `"{fontface "stSerif": Period 16-20}"', noticks) xtitle({stSerif: Period})ylabel(0 `"{fontface "stSerif": 0}"' 1 `"{fontface "stSerif": 1}"' 2 `"{fontface "stSerif": 2}"' 3 `"{fontface "stSerif": 3}"' 4 `"{fontface "stSerif": 4}"'5`"{fontface "stSerif": 5}"', angle(0) valuelabel)

twoway (bar meanladlit interval if interval == 1, barwidth(.5)) (bar meanladlit interval if interval == 2, barwidth(.5))(bar meanladlit interval if interval == 3, barwidth(.5))(bar meanladlit interval if interval == 4, barwidth(.5))(rcap highladlit lowladlit interval, color(black)) if urncomposition ==0 & mkt == 1, legend(off)title({stSerif: Lit and Dark}) ytitle({stSerif:LAD in Lit Market}) yscale(range(0 5)) graphregion(color(white)) name(b,replace) xlabel( 1 `"{fontface "stSerif": Period 1-5}"' 2 `"{fontface "stSerif": Period 6-10}"' 3 `"{fontface "stSerif": Period 11-15}"' 4 `"{fontface "stSerif": Period 16-20}"', noticks) xtitle({stSerif: Period})ylabel(0 `"{fontface "stSerif": 0}"' 1 `"{fontface "stSerif": 1}"' 2 `"{fontface "stSerif": 2}"' 3 `"{fontface "stSerif": 3}"' 4 `"{fontface "stSerif": 4}"'5`"{fontface "stSerif": 5}"', angle(0) valuelabel)

twoway (bar meanladdark interval if interval == 1, barwidth(.5)) (bar meanladdark interval if interval == 2, barwidth(.5))(bar meanladdark interval if interval == 3, barwidth(.5))(bar meanladdark interval if interval == 4, barwidth(.5))(rcap highladdark lowladdark interval, color(black)) if urncomposition ==0 & mkt == 1, legend(off)title({stSerif: Lit and Dark}) ytitle({stSerif:LAD in Dark Market}) yscale(range(0 5)) graphregion(color(white)) name(c,replace) xlabel( 1 `"{fontface "stSerif": Period 1-5}"' 2 `"{fontface "stSerif": Period 6-10}"' 3 `"{fontface "stSerif": Period 11-15}"' 4 `"{fontface "stSerif": Period 16-20}"', noticks) xtitle({stSerif: Period})ylabel(0 `"{fontface "stSerif": 0}"' 1 `"{fontface "stSerif": 1}"' 2 `"{fontface "stSerif": 2}"' 3 `"{fontface "stSerif": 3}"' 4 `"{fontface "stSerif": 4}"'5`"{fontface "stSerif": 5}"', angle(0) valuelabel)

grc1leg b c a, title({stSerif:LAD (Low precision)}) legendfrom(a) graphregion(color(white))
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .title.draw_view.setstyle, style(no)
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
twoway (bar meanladlit interval if interval == 1, barwidth(.5)) (bar meanladlit interval if interval == 2, barwidth(.5))(bar meanladlit interval if interval == 3, barwidth(.5))(bar meanladlit interval if interval == 4, barwidth(.5))(rcap highladlit lowladlit interval, color(black)) if urncomposition ==1 & mkt == 0, legend(off)title({stSerif: Lit only}) ytitle({stSerif:LAD in Lit Market}) yscale(range(0 5)) graphregion(color(white)) name(a,replace) xlabel(1 `"{fontface "stSerif": Period 1-5}"' 2 `"{fontface "stSerif": Period 6-10}"' 3 `"{fontface "stSerif": Period 11-15}"' 4 `"{fontface "stSerif": Period 16-20}"', noticks) xtitle({stSerif: Period})ylabel(0 `"{fontface "stSerif": 0}"' 1 `"{fontface "stSerif": 1}"' 2 `"{fontface "stSerif": 2}"' 3 `"{fontface "stSerif": 3}"' 4 `"{fontface "stSerif": 4}"'5`"{fontface "stSerif": 5}"', angle(0) valuelabel)

twoway (bar meanladlit interval if interval == 1, barwidth(.5)) (bar meanladlit interval if interval == 2, barwidth(.5))(bar meanladlit interval if interval == 3, barwidth(.5))(bar meanladlit interval if interval == 4, barwidth(.5))(rcap highladlit lowladlit interval, color(black)) if urncomposition ==1 & mkt == 1, legend(off)title({stSerif: Lit and Dark}) ytitle({stSerif:LAD in Lit Market}) yscale(range(0 5)) graphregion(color(white)) name(b,replace) xlabel( 1 `"{fontface "stSerif": Period 1-5}"' 2 `"{fontface "stSerif": Period 6-10}"' 3 `"{fontface "stSerif": Period 11-15}"' 4 `"{fontface "stSerif": Period 16-20}"', noticks) xtitle({stSerif: Period})ylabel(0 `"{fontface "stSerif": 0}"' 1 `"{fontface "stSerif": 1}"' 2 `"{fontface "stSerif": 2}"' 3 `"{fontface "stSerif": 3}"' 4 `"{fontface "stSerif": 4}"'5`"{fontface "stSerif": 5}"', angle(0) valuelabel)

twoway (bar meanladdark interval if interval == 1, barwidth(.5)) (bar meanladdark interval if interval == 2, barwidth(.5))(bar meanladdark interval if interval == 3, barwidth(.5))(bar meanladdark interval if interval == 4, barwidth(.5))(rcap highladdark lowladdark interval, color(black)) if urncomposition ==1 & mkt == 1, legend(off)title({stSerif: Lit and Dark}) ytitle({stSerif:LAD in Dark Market}) yscale(range(0 5)) graphregion(color(white)) name(c,replace) xlabel(1 `"{fontface "stSerif": Period 1-5}"' 2 `"{fontface "stSerif": Period 6-10}"' 3 `"{fontface "stSerif": Period 11-15}"' 4 `"{fontface "stSerif": Period 16-20}"', noticks) xtitle({stSerif: Period})ylabel(0 `"{fontface "stSerif": 0}"' 1 `"{fontface "stSerif": 1}"' 2 `"{fontface "stSerif": 2}"' 3 `"{fontface "stSerif": 3}"' 4 `"{fontface "stSerif": 4}"'5`"{fontface "stSerif": 5}"', angle(0) valuelabel)

grc1leg b c a, title({stSerif:LAD (High precision)}) legendfrom(a) graphregion(color(white))
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .title.draw_view.setstyle, style(no)
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
twoway (bar meansumacq interval if interval == 1, barwidth(.5)) (bar meansumacq interval if interval == 2, barwidth(.5))(bar meansumacq interval if interval == 3, barwidth(.5))(bar meansumacq interval if interval == 4, barwidth(.5))(rcap highsumacq lowsumacq interval, color(black)) if urncomposition ==0 & mkt == 0, legend(off)title({stSerif: Low precision & Lit only}) ytitle({stSerif:Sum of signals acquired}) yscale(range(20 50)) graphregion(color(white)) name(a,replace) xlabel(1 `"{fontface "stSerif": Period 1-5}"' 2 `"{fontface "stSerif": Period 6-10}"' 3 `"{fontface "stSerif": Period 11-15}"' 4 `"{fontface "stSerif": Period 16-20}"', noticks) xtitle({stSerif: Period})ylabel(20 `"{fontface "stSerif": 20}"' 30 `"{fontface "stSerif": 30}"' 40 `"{fontface "stSerif": 40}"' 50 `"{fontface "stSerif": 50}"', angle(0) valuelabel)

twoway (bar meansumacq interval if interval == 1, barwidth(.5)) (bar meansumacq interval if interval == 2, barwidth(.5))(bar meansumacq interval if interval == 3, barwidth(.5))(bar meansumacq interval if interval == 4, barwidth(.5))(rcap highsumacq lowsumacq interval, color(black)) if urncomposition ==1 & mkt == 0, legend(off)title({stSerif: High precision & Lit only}) ytitle({stSerif:Sum of signals acquired}) yscale(range(20 50)) graphregion(color(white)) name(b,replace) xlabel( 1 `"{fontface "stSerif": Period 1-5}"' 2 `"{fontface "stSerif": Period 6-10}"' 3 `"{fontface "stSerif": Period 11-15}"' 4 `"{fontface "stSerif": Period 16-20}"', noticks) xtitle({stSerif: Period})ylabel(20 `"{fontface "stSerif": 20}"' 30 `"{fontface "stSerif": 30}"' 40 `"{fontface "stSerif": 40}"' 50 `"{fontface "stSerif": 50}"',  angle(0) valuelabel)

twoway (bar meansumacq interval if interval == 1, barwidth(.5)) (bar meansumacq interval if interval == 2, barwidth(.5))(bar meansumacq interval if interval == 3, barwidth(.5))(bar meansumacq interval if interval == 4, barwidth(.5))(rcap highsumacq lowsumacq interval, color(black)) if urncomposition ==0 & mkt == 1, legend(off)title({stSerif: Low precision & Lit and Dark}) ytitle({stSerif:Sum of signals acquired}) yscale(range(20 50)) graphregion(color(white)) name(c,replace) xlabel( 1 `"{fontface "stSerif": Period 1-5}"' 2 `"{fontface "stSerif": Period 6-10}"' 3 `"{fontface "stSerif": Period 11-15}"' 4 `"{fontface "stSerif": Period 16-20}"', noticks) xtitle({stSerif: Period})ylabel(20 `"{fontface "stSerif": 20}"' 30 `"{fontface "stSerif": 30}"' 40 `"{fontface "stSerif": 40}"' 50 `"{fontface "stSerif": 50}"',  angle(0) valuelabel)

twoway (bar meansumacq interval if interval == 1, barwidth(.5)) (bar meansumacq interval if interval == 2, barwidth(.5))(bar meansumacq interval if interval == 3, barwidth(.5))(bar meansumacq interval if interval == 4, barwidth(.5))(rcap highsumacq lowsumacq interval, color(black)) if urncomposition ==1 & mkt == 1, legend(off)title({stSerif: High precision & Lit and Dark}) ytitle({stSerif:Sum of signals acquired}) yscale(range(20 50)) graphregion(color(white)) name(d,replace) xlabel(1 `"{fontface "stSerif": Period 1-5}"' 2 `"{fontface "stSerif": Period 6-10}"' 3 `"{fontface "stSerif": Period 11-15}"' 4 `"{fontface "stSerif": Period 16-20}"', noticks) xtitle({stSerif: Period})ylabel(20 `"{fontface "stSerif": 20}"' 30 `"{fontface "stSerif": 30}"' 40 `"{fontface "stSerif": 40}"' 50 `"{fontface "stSerif": 50}"', angle(0) valuelabel)

grc1leg a b c d, title({stSerif:Sum of Signals Acquired}) legendfrom(a) graphregion(color(white))
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .title.draw_view.setstyle, style(no)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
twoway (bar meaninfolitsub interval if interval == 1, barwidth(.5)) (bar meaninfolitsub interval if interval == 2, barwidth(.5))(bar meaninfolitsub interval if interval == 3, barwidth(.5))(bar meaninfolitsub interval if interval == 4, barwidth(.5))(rcap highinfolitsub lowinfolitsub interval, color(black)) if urncomposition ==0 & mkt == 0, legend(off)title({stSerif: Informed in Lit (Lit Only)}) ytitle({stSerif:Submission volume}) yscale(range(300 700)) graphregion(color(white)) name(a,replace) xlabel( 1 `"{fontface "stSerif": P 1-5}"' 2 `"{fontface "stSerif": P 6-10}"' 3 `"{fontface "stSerif": P 11-15}"' 4 `"{fontface "stSerif": P 16-20}"', noticks) xtitle({stSerif: Period})ylabel(300 `"{fontface "stSerif": 300}"' 400 `"{fontface "stSerif": 400}"' 500 `"{fontface "stSerif": 500}"' 600 `"{fontface "stSerif": 600}"' 700 `"{fontface "stSerif": 700}"', angle(0) valuelabel)

twoway (bar meaninfolitsub interval if interval == 1, barwidth(.5)) (bar meaninfolitsub interval if interval == 2, barwidth(.5))(bar meaninfolitsub interval if interval == 3, barwidth(.5))(bar meaninfolitsub interval if interval == 4, barwidth(.5))(rcap highinfolitsub lowinfolitsub interval, color(black)) if urncomposition ==0 & mkt == 1, legend(off)title({stSerif: Informed in Lit (Lit & Dark)}) ytitle({stSerif:Submission volume}) yscale(range(300 700)) graphregion(color(white)) name(b,replace) xlabel(  1 `"{fontface "stSerif": P 1-5}"' 2 `"{fontface "stSerif": P 6-10}"' 3 `"{fontface "stSerif": P 11-15}"' 4 `"{fontface "stSerif": P 16-20}"', noticks) xtitle({stSerif: Period})ylabel(300 `"{fontface "stSerif": 300}"' 400 `"{fontface "stSerif": 400}"' 500 `"{fontface "stSerif": 500}"' 600 `"{fontface "stSerif": 600}"' 700 `"{fontface "stSerif": 700}"', angle(0) valuelabel)

twoway (bar meanuninfolitsub interval if interval == 1, barwidth(.5)) (bar meanuninfolitsub interval if interval == 2, barwidth(.5))(bar meanuninfolitsub interval if interval == 3, barwidth(.5))(bar meanuninfolitsub interval if interval == 4, barwidth(.5))(rcap highuninfolitsub lowuninfolitsub interval, color(black)) if urncomposition ==0 & mkt == 0, legend(off)title({stSerif: Uninformed in Lit (Lit Only)}) ytitle({stSerif:Submission volume}) yscale(range(300 700)) graphregion(color(white)) name(c,replace) xlabel( 1 `"{fontface "stSerif": P 1-5}"' 2 `"{fontface "stSerif": P 6-10}"' 3 `"{fontface "stSerif": P 11-15}"' 4 `"{fontface "stSerif": P 16-20}"', noticks) xtitle({stSerif: Period})ylabel(300 `"{fontface "stSerif": 300}"' 400 `"{fontface "stSerif": 400}"' 500 `"{fontface "stSerif": 500}"' 600 `"{fontface "stSerif": 600}"' 700 `"{fontface "stSerif": 700}"', angle(0) valuelabel)

twoway (bar meanuninfolitsub interval if interval == 1, barwidth(.5)) (bar meanuninfolitsub interval if interval == 2, barwidth(.5))(bar meanuninfolitsub interval if interval == 3, barwidth(.5))(bar meanuninfolitsub interval if interval == 4, barwidth(.5))(rcap highuninfolitsub lowuninfolitsub interval, color(black)) if urncomposition ==0 & mkt == 1, legend(off)title({stSerif: Uninformed in Lit (Lit & Dark)}) ytitle({stSerif:Submission volume}) yscale(range(300 700)) graphregion(color(white)) name(d,replace) xlabel( 1 `"{fontface "stSerif": P 1-5}"' 2 `"{fontface "stSerif": P 6-10}"' 3 `"{fontface "stSerif": P 11-15}"' 4 `"{fontface "stSerif": P 16-20}"', noticks) xtitle({stSerif: Period})ylabel(300 `"{fontface "stSerif": 300}"' 400 `"{fontface "stSerif": 400}"' 500 `"{fontface "stSerif": 500}"' 600 `"{fontface "stSerif": 600}"' 700 `"{fontface "stSerif": 700}"', angle(0) valuelabel)

grc1leg a c b d, title({stSerif: Submission Volume (Low Precision)}) legendfrom(a) graphregion(color(white))
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .title.draw_view.setstyle, style(no)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
twoway (bar meaninfodarksub interval if interval == 1, barwidth(.5)) (bar meaninfodarksub interval if interval == 2, barwidth(.5))(bar meaninfodarksub interval if interval == 3, barwidth(.5))(bar meaninfodarksub interval if interval == 4, barwidth(.5))(rcap highinfodarksub lowinfodarksub interval, color(black)) if urncomposition ==0 & mkt == 1, legend(off)title({stSerif: Informed in Dark (Lit & Dark)}) ytitle({stSerif:Submission volume}) yscale(range(50 200)) graphregion(color(white)) name(a,replace) xlabel( 1 `"{fontface "stSerif": P 1-5}"' 2 `"{fontface "stSerif": P 6-10}"' 3 `"{fontface "stSerif": P 11-15}"' 4 `"{fontface "stSerif": P 16-20}"', noticks) xtitle({stSerif: Period})ylabel(50 `"{fontface "stSerif": 50}"' 100 `"{fontface "stSerif": 100}"' 150 `"{fontface "stSerif": 150}"' 200 `"{fontface "stSerif": 200}"', angle(0) valuelabel)
twoway (bar meanuninfodarksub interval if interval == 1, barwidth(.5)) (bar meanuninfodarksub interval if interval == 2, barwidth(.5))(bar meanuninfodarksub interval if interval == 3, barwidth(.5))(bar meanuninfodarksub interval if interval == 4, barwidth(.5))(rcap highuninfodarksub lowuninfodarksub interval, color(black)) if urncomposition ==0 & mkt == 1, legend(off)title({stSerif: Uninformed in Dark (Lit & Dark)}) ytitle({stSerif:Submission volume}) yscale(range(50 200)) graphregion(color(white)) name(b,replace) xlabel( 1 `"{fontface "stSerif": P 1-5}"' 2 `"{fontface "stSerif": P 6-10}"' 3 `"{fontface "stSerif": P 11-15}"' 4 `"{fontface "stSerif": P 16-20}"', noticks) xtitle({stSerif: Period})ylabel(50 `"{fontface "stSerif": 50}"' 100 `"{fontface "stSerif": 100}"' 150 `"{fontface "stSerif": 150}"' 200 `"{fontface "stSerif": 200}"', angle(0) valuelabel)

grc1leg a b, title({stSerif: Submission Volume (Low Precision)}) legendfrom(a) graphregion(color(white))
gr_edit .legend.draw_view.setstyle, style(no)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
twoway (bar meaninfolitsub interval if interval == 1, barwidth(.5)) (bar meaninfolitsub interval if interval == 2, barwidth(.5))(bar meaninfolitsub interval if interval == 3, barwidth(.5))(bar meaninfolitsub interval if interval == 4, barwidth(.5))(rcap highinfolitsub lowinfolitsub interval, color(black)) if urncomposition ==1 & mkt == 0, legend(off)title({stSerif: Informed in Lit (Lit Only)}) ytitle({stSerif:Submission volume}) yscale(range(300 1100)) graphregion(color(white)) name(a,replace) xlabel( 1 `"{fontface "stSerif": P 1-5}"' 2 `"{fontface "stSerif": P 6-10}"' 3 `"{fontface "stSerif": P 11-15}"' 4 `"{fontface "stSerif": P 16-20}"', noticks) xtitle({stSerif: Period})ylabel(300 `"{fontface "stSerif": 300}"' 500 `"{fontface "stSerif": 500}"' 700 `"{fontface "stSerif": 700}"' 900 `"{fontface "stSerif": 900}"' 1100 `"{fontface "stSerif": 1100}"', angle(0) valuelabel)

twoway (bar meaninfolitsub interval if interval == 1, barwidth(.5)) (bar meaninfolitsub interval if interval == 2, barwidth(.5))(bar meaninfolitsub interval if interval == 3, barwidth(.5))(bar meaninfolitsub interval if interval == 4, barwidth(.5))(rcap highinfolitsub lowinfolitsub interval, color(black)) if urncomposition ==1 & mkt == 1, legend(off)title({stSerif: Informed in Lit (Lit & Dark)}) ytitle({stSerif:Submission volume}) yscale(range(300 600)) graphregion(color(white)) name(b,replace) xlabel(  1 `"{fontface "stSerif": P 1-5}"' 2 `"{fontface "stSerif": P 6-10}"' 3 `"{fontface "stSerif": P 11-15}"' 4 `"{fontface "stSerif": P 16-20}"', noticks) xtitle({stSerif: Period})ylabel(300 `"{fontface "stSerif": 300}"' 400 `"{fontface "stSerif": 400}"' 500 `"{fontface "stSerif": 500}"' 600 `"{fontface "stSerif": 600}"', angle(0) valuelabel)

twoway (bar meanuninfolitsub interval if interval == 1, barwidth(.5)) (bar meanuninfolitsub interval if interval == 2, barwidth(.5))(bar meanuninfolitsub interval if interval == 3, barwidth(.5))(bar meanuninfolitsub interval if interval == 4, barwidth(.5))(rcap highuninfolitsub lowuninfolitsub interval, color(black)) if urncomposition ==1 & mkt == 0, legend(off)title({stSerif: Uninformed in Lit (Lit Only)}) ytitle({stSerif:Submission volume}) yscale(range(300 1100)) graphregion(color(white)) name(c,replace) xlabel( 1 `"{fontface "stSerif": P 1-5}"' 2 `"{fontface "stSerif": P 6-10}"' 3 `"{fontface "stSerif": P 11-15}"' 4 `"{fontface "stSerif": P 16-20}"', noticks) xtitle({stSerif: Period})ylabel(300 `"{fontface "stSerif": 300}"' 500 `"{fontface "stSerif": 500}"' 700 `"{fontface "stSerif": 700}"' 900 `"{fontface "stSerif": 900}"' 1100 `"{fontface "stSerif": 1100}"', angle(0) valuelabel)

twoway (bar meanuninfolitsub interval if interval == 1, barwidth(.5)) (bar meanuninfolitsub interval if interval == 2, barwidth(.5))(bar meanuninfolitsub interval if interval == 3, barwidth(.5))(bar meanuninfolitsub interval if interval == 4, barwidth(.5))(rcap highuninfolitsub lowuninfolitsub interval, color(black)) if urncomposition ==1 & mkt == 1, legend(off)title({stSerif: Uninformed in Lit (Lit & Dark)}) ytitle({stSerif:Submission volume}) yscale(range(300 600)) graphregion(color(white)) name(d,replace) xlabel( 1 `"{fontface "stSerif": P 1-5}"' 2 `"{fontface "stSerif": P 6-10}"' 3 `"{fontface "stSerif": P 11-15}"' 4 `"{fontface "stSerif": P 16-20}"', noticks) xtitle({stSerif: Period})ylabel(300 `"{fontface "stSerif": 300}"' 400 `"{fontface "stSerif": 400}"' 500 `"{fontface "stSerif": 500}"' 600 `"{fontface "stSerif": 600}"', angle(0) valuelabel)

grc1leg a c b d, title({stSerif: Submission Volume (High Precision)}) legendfrom(a) graphregion(color(white))
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .title.draw_view.setstyle, style(no)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
twoway (bar meaninfodarksub interval if interval == 1, barwidth(.5)) (bar meaninfodarksub interval if interval == 2, barwidth(.5))(bar meaninfodarksub interval if interval == 3, barwidth(.5))(bar meaninfodarksub interval if interval == 4, barwidth(.5))(rcap highinfodarksub lowinfodarksub interval, color(black)) if urncomposition ==1 & mkt == 1, legend(off)title({stSerif: Informed in Dark (Lit & Dark)}) ytitle({stSerif:Submission volume}) yscale(range(50 250)) graphregion(color(white)) name(a,replace) xlabel( 1 `"{fontface "stSerif": P 1-5}"' 2 `"{fontface "stSerif": P 6-10}"' 3 `"{fontface "stSerif": P 11-15}"' 4 `"{fontface "stSerif": P 16-20}"', noticks) xtitle({stSerif: Period})ylabel(50 `"{fontface "stSerif": 50}"' 100 `"{fontface "stSerif": 100}"' 150 `"{fontface "stSerif": 150}"' 200 `"{fontface "stSerif": 200}"' 250 `"{fontface "stSerif": 250}"', angle(0) valuelabel)
twoway (bar meanuninfodarksub interval if interval == 1, barwidth(.5)) (bar meanuninfodarksub interval if interval == 2, barwidth(.5))(bar meanuninfodarksub interval if interval == 3, barwidth(.5))(bar meanuninfodarksub interval if interval == 4, barwidth(.5))(rcap highuninfodarksub lowuninfodarksub interval, color(black)) if urncomposition ==1 & mkt == 1, legend(off)title({stSerif: Uninformed in Dark (Lit & Dark)}) ytitle({stSerif:Submission volume}) yscale(range(50 250)) graphregion(color(white)) name(b,replace) xlabel( 1 `"{fontface "stSerif": P 1-5}"' 2 `"{fontface "stSerif": P 6-10}"' 3 `"{fontface "stSerif": P 11-15}"' 4 `"{fontface "stSerif": P 16-20}"', noticks) xtitle({stSerif: Period})ylabel(50 `"{fontface "stSerif": 50}"' 100 `"{fontface "stSerif": 100}"' 150 `"{fontface "stSerif": 150}"' 200 `"{fontface "stSerif": 200}"' 250 `"{fontface "stSerif": 250}"', angle(0) valuelabel)

grc1leg a b, title({stSerif: Submission Volume (High Precision)}) legendfrom(a) graphregion(color(white))
gr_edit .legend.draw_view.setstyle, style(no)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
use mktsummary.dta, replace
collapse (mean) meanratiolit= infotouninforatiolit (sd) sdratiolit=infotouninforatiolit (count) n1 = infotouninforatiolit (mean) meanratiodark = infotouninforatiodark (sd) sdratiodark=infotouninforatiodark (count) n2 = infotouninforatiodark, by(urncomposition mkt interval)
gen highratiolit = meanratiolit + invttail(n1-1,0.025)*(sdratiolit/sqrt(n1))
gen lowratiolit = meanratiolit - invttail(n1-1,0.025)*(sdratiolit/sqrt(n1))
gen highratiodark = meanratiodark + invttail(n2-1,0.025)*(sdratiodark/sqrt(n2))
gen lowratiodark = meanratiodark - invttail(n2-1,0.025)*(sdratiodark/sqrt(n2))

label define INT 1 "Period 1-5" 2 "Period 6-10" 3 "Period 11-15" 4 "Period 16-20"
label values interval INT
format meanratiolit meanratiodark %9.3g

twoway (bar meanratiolit interval if interval == 1, barwidth(.5)) (bar meanratiolit interval if interval == 2, barwidth(.5))(bar meanratiolit interval if interval == 3, barwidth(.5))(bar meanratiolit interval if interval == 4, barwidth(.5))(rcap highratiolit lowratiolit interval, color(black)) if urncomposition ==0 & mkt == 0, legend(off)title({stSerif: Low precision & Lit only}) ytitle({stSerif:info-to-uninfo}) yscale(range(0 4)) graphregion(color(white)) name(a,replace) xlabel( 1 `"{fontface "stSerif": Period 1-5}"' 2 `"{fontface "stSerif": Period 6-10}"' 3 `"{fontface "stSerif": Period 11-15}"' 4 `"{fontface "stSerif": Period 16-20}"', noticks) xtitle({stSerif: Period})ylabel(0 `"{fontface "stSerif": 0}"' 1 `"{fontface "stSerif": 1}"' 2 `"{fontface "stSerif": 2}"' 3 `"{fontface "stSerif": 3}"' 4 `"{fontface "stSerif": 4}"', angle(0) valuelabel)

twoway (bar meanratiolit interval if interval == 1, barwidth(.5)) (bar meanratiolit interval if interval == 2, barwidth(.5))(bar meanratiolit interval if interval == 3, barwidth(.5))(bar meanratiolit interval if interval == 4, barwidth(.5))(rcap highratiolit lowratiolit interval, color(black)) if urncomposition ==0 & mkt == 1, legend(off)title({stSerif: Low precision & Lit and Dark}) ytitle({stSerif:info-to-uninfo}) yscale(range(0 4)) graphregion(color(white)) name(b,replace) xlabel( 1 `"{fontface "stSerif": Period 1-5}"' 2 `"{fontface "stSerif": Period 6-10}"' 3 `"{fontface "stSerif": Period 11-15}"' 4 `"{fontface "stSerif": Period 16-20}"', noticks) xtitle({stSerif: Period})ylabel(0 `"{fontface "stSerif": 0}"' 1 `"{fontface "stSerif": 1}"' 2 `"{fontface "stSerif": 2}"' 3 `"{fontface "stSerif": 3}"' 4 `"{fontface "stSerif": 4}"', angle(0) valuelabel)

twoway (bar meanratiolit interval if interval == 1, barwidth(.5)) (bar meanratiolit interval if interval == 2, barwidth(.5))(bar meanratiolit interval if interval == 3, barwidth(.5))(bar meanratiolit interval if interval == 4, barwidth(.5))(rcap highratiolit lowratiolit interval, color(black)) if urncomposition ==1 & mkt == 0, legend(off)title({stSerif: High precision & Lit only}) ytitle({stSerif:info-to-uninfo}) yscale(range(0 4)) graphregion(color(white)) name(c,replace) xlabel( 1 `"{fontface "stSerif": Period 1-5}"' 2 `"{fontface "stSerif": Period 6-10}"' 3 `"{fontface "stSerif": Period 11-15}"' 4 `"{fontface "stSerif": Period 16-20}"', noticks) xtitle({stSerif: Period})ylabel(0 `"{fontface "stSerif": 0}"' 1 `"{fontface "stSerif": 1}"' 2 `"{fontface "stSerif": 2}"' 3 `"{fontface "stSerif": 3}"' 4 `"{fontface "stSerif": 4}"', angle(0) valuelabel)

twoway (bar meanratiolit interval if interval == 1, barwidth(.5)) (bar meanratiolit interval if interval == 2, barwidth(.5))(bar meanratiolit interval if interval == 3, barwidth(.5))(bar meanratiolit interval if interval == 4, barwidth(.5))(rcap highratiolit lowratiolit interval, color(black)) if urncomposition ==1 & mkt == 1, legend(off)title({stSerif: High precision & Lit and Dark}) ytitle({stSerif:info-to-uninfo}) yscale(range(0 4)) graphregion(color(white)) name(d,replace) xlabel( 1 `"{fontface "stSerif": Period 1-5}"' 2 `"{fontface "stSerif": Period 6-10}"' 3 `"{fontface "stSerif": Period 11-15}"' 4 `"{fontface "stSerif": Period 16-20}"', noticks) xtitle({stSerif: Period})ylabel(0 `"{fontface "stSerif": 0}"' 1 `"{fontface "stSerif": 1}"' 2 `"{fontface "stSerif": 2}"' 3 `"{fontface "stSerif": 3}"' 4 `"{fontface "stSerif": 4}"', angle(0) valuelabel)

grc1leg a c b d, title({stSerif: Informed-to-Uninformed Submission Ratio (Lit)}) legendfrom(a) graphregion(color(white))
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .title.draw_view.setstyle, style(no)

twoway (bar meanratiodark interval if interval == 1, barwidth(.5)) (bar meanratiodark interval if interval == 2, barwidth(.5))(bar meanratiodark interval if interval == 3, barwidth(.5))(bar meanratiodark interval if interval == 4, barwidth(.5))(rcap highratiodark lowratiodark interval, color(black)) if urncomposition ==0 & mkt == 1, legend(off)title({stSerif: Low precision & Lit and Dark}) ytitle({stSerif:info-to-uninfo}) yscale(range(0 7)) graphregion(color(white)) name(a,replace) xlabel( 1 `"{fontface "stSerif": Period 1-5}"' 2 `"{fontface "stSerif": Period 6-10}"' 3 `"{fontface "stSerif": Period 11-15}"' 4 `"{fontface "stSerif": Period 16-20}"', noticks) xtitle({stSerif: Period})ylabel(0 `"{fontface "stSerif": 0}"' 1 `"{fontface "stSerif": 1}"' 2 `"{fontface "stSerif": 2}"' 3 `"{fontface "stSerif": 3}"' 4 `"{fontface "stSerif": 4}"' 5 `"{fontface "stSerif": 5}"' 6 `"{fontface "stSerif": 6}"' 7 `"{fontface "stSerif": 7}"', angle(0) valuelabel)

twoway (bar meanratiodark interval if interval == 1, barwidth(.5)) (bar meanratiodark interval if interval == 2, barwidth(.5))(bar meanratiodark interval if interval == 3, barwidth(.5))(bar meanratiodark interval if interval == 4, barwidth(.5))(rcap highratiodark lowratiodark interval, color(black)) if urncomposition ==1 & mkt == 1, legend(off)title({stSerif: High precision & Lit and Dark}) ytitle({stSerif:info-to-uninfo}) yscale(range(0 7)) graphregion(color(white)) name(b,replace) xlabel( 1 `"{fontface "stSerif": Period 1-5}"' 2 `"{fontface "stSerif": Period 6-10}"' 3 `"{fontface "stSerif": Period 11-15}"' 4 `"{fontface "stSerif": Period 16-20}"', noticks) xtitle({stSerif: Period})ylabel(0 `"{fontface "stSerif": 0}"' 1 `"{fontface "stSerif": 1}"' 2 `"{fontface "stSerif": 2}"' 3 `"{fontface "stSerif": 3}"' 4 `"{fontface "stSerif": 4}"' 5 `"{fontface "stSerif": 5}"' 6 `"{fontface "stSerif": 6}"' 7 `"{fontface "stSerif": 7}"', angle(0) valuelabel)

grc1leg a b, title({stSerif: Informed-to-Uninformed Submission Ratio (Dark)}) legendfrom(a) graphregion(color(white))
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .title.draw_view.setstyle, style(no)


twoway (bar meanratiolit interval if interval == 1, barwidth(.5)) (bar meanratiolit interval if interval == 2, barwidth(.5))(bar meanratiolit interval if interval == 3, barwidth(.5))(bar meanratiolit interval if interval == 4, barwidth(.5))(rcap highratiolit lowratiolit interval, color(black)) if urncomposition ==0 & mkt == 0, legend(off)title({stSerif: Ratio in Lit (Lit only)}) ytitle({stSerif:info-to-uninfo}) yscale(range(0 7)) graphregion(color(white)) name(a,replace) xlabel( 1 `"{fontface "stSerif": P 1-5}"' 2 `"{fontface "stSerif": P 6-10}"' 3 `"{fontface "stSerif": P 11-15}"' 4 `"{fontface "stSerif": P 16-20}"', noticks) xtitle({stSerif: Period})ylabel(0 `"{fontface "stSerif": 0}"' 1 `"{fontface "stSerif": 1}"' 2 `"{fontface "stSerif": 2}"' 3 `"{fontface "stSerif": 3}"' 4 `"{fontface "stSerif": 4}"' 5 `"{fontface "stSerif": 5}"' 6 `"{fontface "stSerif": 6}"' 7 `"{fontface "stSerif": 7}"', angle(0) valuelabel)

twoway (bar meanratiolit interval if interval == 1, barwidth(.5)) (bar meanratiolit interval if interval == 2, barwidth(.5))(bar meanratiolit interval if interval == 3, barwidth(.5))(bar meanratiolit interval if interval == 4, barwidth(.5))(rcap highratiolit lowratiolit interval, color(black)) if urncomposition ==0 & mkt == 1, legend(off)title({stSerif: Ratio in Lit (Lit and Dark)}) ytitle({stSerif:info-to-uninfo}) yscale(range(0 7)) graphregion(color(white)) name(b,replace) xlabel( 1 `"{fontface "stSerif": P 1-5}"' 2 `"{fontface "stSerif": P 6-10}"' 3 `"{fontface "stSerif": P 11-15}"' 4 `"{fontface "stSerif": P 16-20}"', noticks) xtitle({stSerif: Period})ylabel(0 `"{fontface "stSerif": 0}"' 1 `"{fontface "stSerif": 1}"' 2 `"{fontface "stSerif": 2}"' 3 `"{fontface "stSerif": 3}"' 4 `"{fontface "stSerif": 4}"' 5 `"{fontface "stSerif": 5}"' 6 `"{fontface "stSerif": 6}"' 7 `"{fontface "stSerif": 7}"', angle(0) valuelabel)

twoway (bar meanratiodark interval if interval == 1, barwidth(.5)) (bar meanratiodark interval if interval == 2, barwidth(.5))(bar meanratiodark interval if interval == 3, barwidth(.5))(bar meanratiodark interval if interval == 4, barwidth(.5))(rcap highratiodark lowratiodark interval, color(black)) if urncomposition ==0 & mkt == 1, legend(off)title({stSerif: Ratio in Dark (Lit and Dark)}) ytitle({stSerif:info-to-uninfo}) yscale(range(0 7)) graphregion(color(white)) name(c,replace) xlabel( 1 `"{fontface "stSerif": P 1-5}"' 2 `"{fontface "stSerif": P 6-10}"' 3 `"{fontface "stSerif": P 11-15}"' 4 `"{fontface "stSerif": P 16-20}"', noticks) xtitle({stSerif: Period})ylabel(0 `"{fontface "stSerif": 0}"' 1 `"{fontface "stSerif": 1}"' 2 `"{fontface "stSerif": 2}"' 3 `"{fontface "stSerif": 3}"' 4 `"{fontface "stSerif": 4}"' 5 `"{fontface "stSerif": 5}"' 6 `"{fontface "stSerif": 6}"' 7 `"{fontface "stSerif": 7}"', angle(0) valuelabel)


grc1leg a b c, title({stSerif: Informed-to-Uninformed Submission Ratio (Low precision)}) legendfrom(a) graphregion(color(white)) cols(3) xcommon ycommon imargin(0 0 0 0)
gr_edit .legend.draw_view.setstyle, style(no)

twoway (bar meanratiolit interval if interval == 1, barwidth(.5)) (bar meanratiolit interval if interval == 2, barwidth(.5))(bar meanratiolit interval if interval == 3, barwidth(.5))(bar meanratiolit interval if interval == 4, barwidth(.5))(rcap highratiolit lowratiolit interval, color(black)) if urncomposition ==1 & mkt == 0, legend(off)title({stSerif: Ratio in Lit (Lit only)}) ytitle({stSerif:info-to-uninfo}) yscale(range(0 4)) graphregion(color(white)) name(a,replace) xlabel(  1 `"{fontface "stSerif": P 1-5}"' 2 `"{fontface "stSerif": P 6-10}"' 3 `"{fontface "stSerif": P 11-15}"' 4 `"{fontface "stSerif": P 16-20}"', noticks) xtitle({stSerif: Period})ylabel(0 `"{fontface "stSerif": 0}"' 1 `"{fontface "stSerif": 1}"' 2 `"{fontface "stSerif": 2}"' 3 `"{fontface "stSerif": 3}"' 4 `"{fontface "stSerif": 4}"', angle(0) valuelabel)

twoway (bar meanratiolit interval if interval == 1, barwidth(.5)) (bar meanratiolit interval if interval == 2, barwidth(.5))(bar meanratiolit interval if interval == 3, barwidth(.5))(bar meanratiolit interval if interval == 4, barwidth(.5))(rcap highratiolit lowratiolit interval, color(black)) if urncomposition ==1 & mkt == 1, legend(off)title({stSerif: Ratio in Lit (Lit and Dark)}) ytitle({stSerif:info-to-uninfo}) yscale(range(0 4)) graphregion(color(white)) name(b,replace) xlabel( 1 `"{fontface "stSerif": P 1-5}"' 2 `"{fontface "stSerif": P 6-10}"' 3 `"{fontface "stSerif": P 11-15}"' 4 `"{fontface "stSerif": P 16-20}"', noticks) xtitle({stSerif: Period})ylabel(0 `"{fontface "stSerif": 0}"' 1 `"{fontface "stSerif": 1}"' 2 `"{fontface "stSerif": 2}"' 3 `"{fontface "stSerif": 3}"' 4 `"{fontface "stSerif": 4}"', angle(0) valuelabel)

twoway (bar meanratiodark interval if interval == 1, barwidth(.5)) (bar meanratiodark interval if interval == 2, barwidth(.5))(bar meanratiodark interval if interval == 3, barwidth(.5))(bar meanratiodark interval if interval == 4, barwidth(.5))(rcap highratiodark lowratiodark interval, color(black)) if urncomposition ==1 & mkt == 1, legend(off)title({stSerif: Ratio in Dark (Lit and Dark)}) ytitle({stSerif:info-to-uninfo}) yscale(range(0 4)) graphregion(color(white)) name(c,replace) xlabel( 1 `"{fontface "stSerif": P 1-5}"' 2 `"{fontface "stSerif": P 6-10}"' 3 `"{fontface "stSerif": P 11-15}"' 4 `"{fontface "stSerif": P 16-20}"', noticks) xtitle({stSerif: Period})ylabel(0 `"{fontface "stSerif": 0}"' 1 `"{fontface "stSerif": 1}"' 2 `"{fontface "stSerif": 2}"' 3 `"{fontface "stSerif": 3}"' 4 `"{fontface "stSerif": 4}"', angle(0) valuelabel)


grc1leg a b c, title({stSerif: Informed-to-Uninformed Submission Ratio (High precision)})legendfrom(a) graphregion(color(white)) cols(3) xcommon ycommon imargin(0 0 0 0)
gr_edit .legend.draw_view.setstyle, style(no)


twoway (bar meanratiolit interval if interval == 1, barwidth(.5)) (bar meanratiolit interval if interval == 2, barwidth(.5))(bar meanratiolit interval if interval == 3, barwidth(.5))(bar meanratiolit interval if interval == 4, barwidth(.5))(rcap highratiolit lowratiolit interval, color(black)) if urncomposition ==0 & mkt == 1, legend(off)title({stSerif: Low precision (Lit)}) ytitle({stSerif:info-to-uninfo}) yscale(range(0 7)) graphregion(color(white)) name(a,replace) xlabel( 1 `"{fontface "stSerif": Period 1-5}"' 2 `"{fontface "stSerif": Period 6-10}"' 3 `"{fontface "stSerif": Period 11-15}"' 4 `"{fontface "stSerif": Period 16-20}"', noticks) xtitle({stSerif: Period})ylabel(0 `"{fontface "stSerif": 0}"' 1 `"{fontface "stSerif": 1}"' 2 `"{fontface "stSerif": 2}"' 3 `"{fontface "stSerif": 3}"' 4 `"{fontface "stSerif": 4}"' 5 `"{fontface "stSerif": 5}"' 6 `"{fontface "stSerif": 6}"' 7 `"{fontface "stSerif": 7}"', angle(0) valuelabel)

twoway (bar meanratiolit interval if interval == 1, barwidth(.5)) (bar meanratiolit interval if interval == 2, barwidth(.5))(bar meanratiolit interval if interval == 3, barwidth(.5))(bar meanratiolit interval if interval == 4, barwidth(.5))(rcap highratiolit lowratiolit interval, color(black)) if urncomposition ==1 & mkt == 1, legend(off)title({stSerif: High precision (Lit)}) ytitle({stSerif:info-to-uninfo}) yscale(range(0 7)) graphregion(color(white)) name(b,replace) xlabel( 1 `"{fontface "stSerif": Period 1-5}"' 2 `"{fontface "stSerif": Period 6-10}"' 3 `"{fontface "stSerif": Period 11-15}"' 4 `"{fontface "stSerif": Period 16-20}"', noticks) xtitle({stSerif: Period})ylabel(0 `"{fontface "stSerif": 0}"' 1 `"{fontface "stSerif": 1}"' 2 `"{fontface "stSerif": 2}"' 3 `"{fontface "stSerif": 3}"' 4 `"{fontface "stSerif": 4}"' 5 `"{fontface "stSerif": 5}"' 6 `"{fontface "stSerif": 6}"' 7 `"{fontface "stSerif": 7}"', angle(0) valuelabel)

twoway (bar meanratiodark interval if interval == 1, barwidth(.5)) (bar meanratiodark interval if interval == 2, barwidth(.5))(bar meanratiodark interval if interval == 3, barwidth(.5))(bar meanratiodark interval if interval == 4, barwidth(.5))(rcap highratiodark lowratiodark interval, color(black)) if urncomposition ==0 & mkt == 1, legend(off)title({stSerif: Low precision (Dark)}) ytitle({stSerif:info-to-uninfo}) yscale(range(0 7)) graphregion(color(white)) name(c,replace) xlabel( 1 `"{fontface "stSerif": Period 1-5}"' 2 `"{fontface "stSerif": Period 6-10}"' 3 `"{fontface "stSerif": Period 11-15}"' 4 `"{fontface "stSerif": Period 16-20}"', noticks) xtitle({stSerif: Period})ylabel(0 `"{fontface "stSerif": 0}"' 1 `"{fontface "stSerif": 1}"' 2 `"{fontface "stSerif": 2}"' 3 `"{fontface "stSerif": 3}"' 4 `"{fontface "stSerif": 4}"' 5 `"{fontface "stSerif": 5}"' 6 `"{fontface "stSerif": 6}"' 7 `"{fontface "stSerif": 7}"', angle(0) valuelabel)

twoway (bar meanratiodark interval if interval == 1, barwidth(.5)) (bar meanratiodark interval if interval == 2, barwidth(.5))(bar meanratiodark interval if interval == 3, barwidth(.5))(bar meanratiodark interval if interval == 4, barwidth(.5))(rcap highratiodark lowratiodark interval, color(black)) if urncomposition ==1 & mkt == 1, legend(off)title({stSerif: High precision (Dark)}) ytitle({stSerif:info-to-uninfo}) yscale(range(0 7)) graphregion(color(white)) name(d,replace) xlabel( 1 `"{fontface "stSerif": Period 1-5}"' 2 `"{fontface "stSerif": Period 6-10}"' 3 `"{fontface "stSerif": Period 11-15}"' 4 `"{fontface "stSerif": Period 16-20}"', noticks) xtitle({stSerif: Period})ylabel(0 `"{fontface "stSerif": 0}"' 1 `"{fontface "stSerif": 1}"' 2 `"{fontface "stSerif": 2}"' 3 `"{fontface "stSerif": 3}"' 4 `"{fontface "stSerif": 4}"' 5 `"{fontface "stSerif": 5}"' 6 `"{fontface "stSerif": 6}"' 7 `"{fontface "stSerif": 7}"', angle(0) valuelabel)

grc1leg a c b d, title({stSerif: Informed-to-Uninformed Submission Ratio (Lit & Dark)})legendfrom(a)
gr_edit .legend.draw_view.setstyle, style(no)


use mktsummary.dta, replace
collapse (mean) meanNumSubInformed= NumSubInformed (sd) sdNumSubInformed=NumSubInformed (count) n1 = NumSubInformed, by(urncomposition mkt interval)
gen highNumSubInformed = meanNumSubInformed + invttail(n1-1,0.025)*(sdNumSubInformed/sqrt(n1))
gen lowNumSubInformed = meanNumSubInformed - invttail(n1-1,0.025)*(sdNumSubInformed/sqrt(n1))


label define INT 1 "Period 1-5" 2 "Period 6-10" 3 "Period 11-15" 4 "Period 16-20"
label values interval INT
format meanratiolit meanratiodark %9.3g

twoway (bar meanNumSubInformed interval if interval == 1, barwidth(.5)) (bar meanNumSubInformed interval if interval == 2, barwidth(.5))(bar meanNumSubInformed interval if interval == 3, barwidth(.5))(bar meanNumSubInformed interval if interval == 4, barwidth(.5))(rcap highNumSubInformed lowNumSubInformed interval, color(black)) if urncomposition ==0 & mkt == 0, legend(off)title({stSerif: Low precision & Lit only}) ytitle({stSerif:No. of informed}) yscale(range(4 8)) graphregion(color(white)) name(a,replace) xlabel(1 `"{fontface "stSerif": Period 1-5}"' 2 `"{fontface "stSerif": Period 6-10}"' 3 `"{fontface "stSerif": Period 11-15}"' 4 `"{fontface "stSerif": Period 16-20}"', noticks) xtitle({stSerif: Period})ylabel(4 `"{fontface "stSerif": 4}"' 5 `"{fontface "stSerif": 5}"' 6 `"{fontface "stSerif": 6}"' 7 `"{fontface "stSerif": 7}"' 8 `"{fontface "stSerif": 8}"', angle(0) valuelabel)

twoway (bar meanNumSubInformed interval if interval == 1, barwidth(.5)) (bar meanNumSubInformed interval if interval == 2, barwidth(.5))(bar meanNumSubInformed interval if interval == 3, barwidth(.5))(bar meanNumSubInformed interval if interval == 4, barwidth(.5))(rcap highNumSubInformed lowNumSubInformed interval, color(black)) if urncomposition ==1 & mkt == 0, legend(off)title({stSerif: High precision & Lit only}) ytitle({stSerif:No. of informed}) yscale(range(4 8)) graphregion(color(white)) name(b,replace) xlabel( 1 `"{fontface "stSerif": Period 1-5}"' 2 `"{fontface "stSerif": Period 6-10}"' 3 `"{fontface "stSerif": Period 11-15}"' 4 `"{fontface "stSerif": Period 16-20}"', noticks) xtitle({stSerif: Period})ylabel(4 `"{fontface "stSerif": 4}"' 5 `"{fontface "stSerif": 5}"' 6 `"{fontface "stSerif": 6}"' 7 `"{fontface "stSerif": 7}"' 8 `"{fontface "stSerif": 8}"',  angle(0) valuelabel)

twoway (bar meanNumSubInformed interval if interval == 1, barwidth(.5)) (bar meanNumSubInformed interval if interval == 2, barwidth(.5))(bar meanNumSubInformed interval if interval == 3, barwidth(.5))(bar meanNumSubInformed interval if interval == 4, barwidth(.5))(rcap highNumSubInformed lowNumSubInformed interval, color(black)) if urncomposition ==0 & mkt == 1, legend(off)title({stSerif: Low precision & Lit and Dark}) ytitle({stSerif:No. of informed}) yscale(range(4 8)) graphregion(color(white)) name(c,replace) xlabel( 1 `"{fontface "stSerif": Period 1-5}"' 2 `"{fontface "stSerif": Period 6-10}"' 3 `"{fontface "stSerif": Period 11-15}"' 4 `"{fontface "stSerif": Period 16-20}"', noticks) xtitle({stSerif: Period})ylabel(4 `"{fontface "stSerif": 4}"' 5 `"{fontface "stSerif": 5}"' 6 `"{fontface "stSerif": 6}"' 7 `"{fontface "stSerif": 7}"' 8 `"{fontface "stSerif": 8}"',  angle(0) valuelabel)

twoway (bar meanNumSubInformed interval if interval == 1, barwidth(.5)) (bar meanNumSubInformed interval if interval == 2, barwidth(.5))(bar meanNumSubInformed interval if interval == 3, barwidth(.5))(bar meanNumSubInformed interval if interval == 4, barwidth(.5))(rcap highNumSubInformed lowNumSubInformed interval, color(black)) if urncomposition ==1 & mkt == 1, legend(off)title({stSerif: High precision & Lit and Dark}) ytitle({stSerif:No. of informed}) yscale(range(4 8)) graphregion(color(white)) name(d,replace) xlabel(1 `"{fontface "stSerif": Period 1-5}"' 2 `"{fontface "stSerif": Period 6-10}"' 3 `"{fontface "stSerif": Period 11-15}"' 4 `"{fontface "stSerif": Period 16-20}"', noticks) xtitle({stSerif: Period})ylabel(4 `"{fontface "stSerif": 4}"' 5 `"{fontface "stSerif": 5}"' 6 `"{fontface "stSerif": 6}"' 7 `"{fontface "stSerif": 7}"' 8 `"{fontface "stSerif": 8}"', angle(0) valuelabel)

grc1leg a b c d, title({stSerif:No. of Informed}) legendfrom(a) graphregion(color(white))
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .title.draw_view.setstyle, style(no)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///coefficients of constants check
use mktsummary.dta, replace

reg SumNumAcq mkt Grp2gender Grp2majorecon Grp2riskaversion Period if urncomposition == 0, vce(cluster Session)
outreg2 using reg.xls,replace
reg SumNumAcq mkt Grp2age Grp2majorecon Grp2riskaversion Period if urncomposition == 0, vce(cluster Session)
outreg2 using reg.xls,append
reg SumNumAcq mkt Grp2age Grp2gender Grp2riskaversion Period if urncomposition == 0, vce(cluster Session)
outreg2 using reg.xls,append
reg SumNumAcq mkt Grp2age Grp2gender Grp2majorecon Period if urncomposition == 0, vce(cluster Session)
outreg2 using reg.xls,append

reg SumNumAcq mkt Grp2gender Grp2majorecon Grp2riskaversion Period if urncomposition == 1, vce(cluster Session)
outreg2 using reg.xls,replace
reg SumNumAcq mkt Grp2age Grp2majorecon Grp2riskaversion Period if urncomposition == 1, vce(cluster Session)
outreg2 using reg.xls,append
reg SumNumAcq mkt Grp2age Grp2gender Grp2riskaversion Period if urncomposition == 1, vce(cluster Session)
outreg2 using reg.xls,append
reg SumNumAcq mkt Grp2age Grp2gender Grp2majorecon Period if urncomposition == 1, vce(cluster Session)
outreg2 using reg.xls,append

///////////////////////////////////////////////////////////////////////////////////////////////////////////

reg SumNumAcq urncomposition Grp2gender Grp2majorecon Grp2riskaversion Period if mkt == 0, vce(cluster Session)
outreg2 using reg.xls,replace
reg SumNumAcq urncomposition Grp2age Grp2majorecon Grp2riskaversion Period if mkt == 0, vce(cluster Session)
outreg2 using reg.xls,append
reg SumNumAcq urncomposition Grp2age Grp2gender Grp2riskaversion Period if mkt == 0, vce(cluster Session)
outreg2 using reg.xls,append
reg SumNumAcq urncomposition Grp2age Grp2gender Grp2majorecon Period if mkt == 0, vce(cluster Session)
outreg2 using reg.xls,append

reg SumNumAcq urncomposition Grp2gender Grp2majorecon Grp2riskaversion Period if mkt == 1, vce(cluster Session)
outreg2 using reg.xls,replace
reg SumNumAcq urncomposition Grp2age Grp2majorecon Grp2riskaversion Period if mkt == 1, vce(cluster Session)
outreg2 using reg.xls,append
reg SumNumAcq urncomposition Grp2age Grp2gender Grp2riskaversion Period if mkt == 1, vce(cluster Session)
outreg2 using reg.xls,append
reg SumNumAcq urncomposition Grp2age Grp2gender Grp2majorecon Period if mkt == 1, vce(cluster Session)
outreg2 using reg.xls,append
///////////////////////////////////////////////////////////////////////////////////////////////////////////
//#Figure 1
use mktsummary.dta, replace
collapse (mean) meanladlit= LADLIT (sd) sdladlit=LADLIT (count) n1 = LADLIT, by(urncomposition B)
gen highladlit = meanladlit + invttail(n1-1,0.025)*(sdladlit/sqrt(n1))
gen lowladlit = meanladlit - invttail(n1-1,0.025)*(sdladlit/sqrt(n1))
label define BB 0 "Single lit" 1 "dark 0-20%" 2 "dark 20%-40%" 3 "dark >=40%"
label values B BB
format meanladlit %9.3g

twoway (bar meanladlit B if B == 0, barwidth(.5)) (bar meanladlit B if B == 1, barwidth(.5))(bar meanladlit B if B == 2, barwidth(.5))(bar meanladlit B if B == 3, barwidth(.5))(rcap highladlit lowladlit B, color(black)) if urncomposition ==0, legend(off)title({stSerif: Low precision}) ytitle({stSerif:LAD}) yscale(range(0 5)) graphregion(color(white)) name(a,replace) xlabel( 0 `"{fontface "stSerif": Lit Only}"' 1 `"{fontface "stSerif": Modest}"' 2 `"{fontface "stSerif": High}"' 3 `"{fontface "stSerif": Very High}"', noticks) xtitle({stSerif: proportion of dark trading})ylabel(0 `"{fontface "stSerif": 0}"' 1 `"{fontface "stSerif": 1}"' 2 `"{fontface "stSerif": 2}"' 3 `"{fontface "stSerif": 3}"' 4 `"{fontface "stSerif": 4}"'5`"{fontface "stSerif": 5}"', angle(0) valuelabel)

twoway (bar meanladlit B if B == 0, barwidth(.5)) (bar meanladlit B if B == 1, barwidth(.5))(bar meanladlit B if B == 2, barwidth(.5))(bar meanladlit B if B == 3, barwidth(.5))(rcap highladlit lowladlit B, color(black)) if urncomposition ==1, legend(off)title({stSerif: High precision}) ytitle({stSerif:LAD}) yscale(range(0 5)) graphregion(color(white)) name(b,replace) xlabel( 0 `"{fontface "stSerif": Lit Only}"' 1 `"{fontface "stSerif": Modest}"' 2 `"{fontface "stSerif": High}"' 3 `"{fontface "stSerif": Very High}"', noticks) xtitle({stSerif: proportion of dark trading})ylabel(0 `"{fontface "stSerif": 0}"' 1 `"{fontface "stSerif": 1}"' 2 `"{fontface "stSerif": 2}"' 3 `"{fontface "stSerif": 3}"' 4 `"{fontface "stSerif": 4}"'5`"{fontface "stSerif": 5}"', angle(0) valuelabel)

grc1leg a b, title({stSerif:Linear Absolute Deviation in Lit Market}) legendfrom(a) graphregion(color(white))
gr_edit .title.draw_view.setstyle, style(no)
gr_edit .legend.draw_view.setstyle, style(no)

/////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////
//# Figure 2-1
use mktsummary.dta, replace
gen a1 = AvgLitTradePrice/10
twoway scatter AvgLitTradePrice BFI if Treatment == 4|| lpoly AvgLitTradePrice BFI if Treatment == 4, lcolor(green) lwidth(thick) lpattern(dash) kernel(epanechnikov) bwidth(0.2) || lfit AvgLitTradePrice a1, lcolor(gs5) lpattern (shortdash) ///
||, yscale(range(0 10)) xscale(range(0 1)) xlabel(0 `"{fontface "stSerif": 0}"' 0.2 `"{fontface "stSerif": 0.2}"' 0.4 `"{fontface "stSerif": 0.4}"' 0.6 `"{fontface "stSerif": 0.6}"' 0.8 `"{fontface "stSerif": 0.8}"' 1 `"{fontface "stSerif": 1}"', angle(0) labsize(small) valuelabel) ylabel(0 `"{fontface "stSerif": 0}"' 2 `"{fontface "stSerif": 2}"' 4 `"{fontface "stSerif": 4}"' 6 `"{fontface "stSerif": 6}"' 8 `"{fontface "stSerif": 8}"' 10 `"{fontface "stSerif": 10}"', angle(0) valuelabel) ///
ytitle({stSerif:Price}) xtitle({stSerif:Bayesian posterior}) legend(order(2 "{stSerif:E(mean price|Bayesian posterior)}") ) xsize(6) ysize(6) graphregion(color(white)) title({stSerif: {it:Lit Only-Low}},size(medium)) name(a,replace)

twoway scatter AvgLitTradePrice BFI if Treatment == 3|| lpoly AvgLitTradePrice BFI if Treatment == 3, lcolor(green) lwidth(thick) lpattern(dash) kernel(epanechnikov) bwidth(0.2) || lfit AvgLitTradePrice a1, lcolor(gs5) lpattern (shortdash) ///
||, yscale(range(0 10)) xscale(range(0 1)) xlabel(0 `"{fontface "stSerif": 0}"' 0.2 `"{fontface "stSerif": 0.2}"' 0.4 `"{fontface "stSerif": 0.4}"' 0.6 `"{fontface "stSerif": 0.6}"' 0.8 `"{fontface "stSerif": 0.8}"' 1 `"{fontface "stSerif": 1}"', angle(0) labsize(small) valuelabel) ylabel(0 `"{fontface "stSerif": 0}"' 2 `"{fontface "stSerif": 2}"' 4 `"{fontface "stSerif": 4}"' 6 `"{fontface "stSerif": 6}"' 8 `"{fontface "stSerif": 8}"' 10 `"{fontface "stSerif": 10}"', angle(0) valuelabel) ///
ytitle({stSerif:Price}) xtitle({stSerif:Bayesian posterior}) legend(order(2 "{stSerif:E(mean price|Bayesian posterior)}") ) xsize(6) ysize(6) graphregion(color(white)) title({stSerif: {it:Dark-Low}},size(medium)) name(b,replace)

twoway scatter AvgLitTradePrice BFI if Treatment == 2|| lpoly AvgLitTradePrice BFI if Treatment == 2, lcolor(green) lwidth(thick) lpattern(dash) kernel(epanechnikov) bwidth(0.2) || lfit AvgLitTradePrice a1, lcolor(gs5) lpattern (shortdash) ///
||, yscale(range(0 10)) xscale(range(0 1)) xlabel(0 `"{fontface "stSerif": 0}"' 0.2 `"{fontface "stSerif": 0.2}"' 0.4 `"{fontface "stSerif": 0.4}"' 0.6 `"{fontface "stSerif": 0.6}"' 0.8 `"{fontface "stSerif": 0.8}"' 1 `"{fontface "stSerif": 1}"', angle(0) labsize(small) valuelabel) ylabel(0 `"{fontface "stSerif": 0}"' 2 `"{fontface "stSerif": 2}"' 4 `"{fontface "stSerif": 4}"' 6 `"{fontface "stSerif": 6}"' 8 `"{fontface "stSerif": 8}"' 10 `"{fontface "stSerif": 10}"', angle(0) valuelabel) ///
ytitle({stSerif:Price}) xtitle({stSerif:Bayesian posterior}) legend(order(2 "{stSerif:E(mean price|Bayesian posterior)}") ) xsize(6) ysize(6)  graphregion(color(white)) title({stSerif: {it:Lit Only-High}},size(medium))name(c,replace)

twoway scatter AvgLitTradePrice BFI if Treatment == 1|| lpoly AvgLitTradePrice BFI if Treatment == 1, lcolor(green) lwidth(thick) lpattern(dash) kernel(epanechnikov) bwidth(0.2) || lfit AvgLitTradePrice a1, lcolor(gs5) lpattern (shortdash) ///
||, yscale(range(0 10)) xscale(range(0 1)) xlabel(0 `"{fontface "stSerif": 0}"' 0.2 `"{fontface "stSerif": 0.2}"' 0.4 `"{fontface "stSerif": 0.4}"' 0.6 `"{fontface "stSerif": 0.6}"' 0.8 `"{fontface "stSerif": 0.8}"' 1 `"{fontface "stSerif": 1}"', angle(0) labsize(small) valuelabel) ylabel(0 `"{fontface "stSerif": 0}"' 2 `"{fontface "stSerif": 2}"' 4 `"{fontface "stSerif": 4}"' 6 `"{fontface "stSerif": 6}"' 8 `"{fontface "stSerif": 8}"' 10 `"{fontface "stSerif": 10}"', angle(0) valuelabel) ///
ytitle({stSerif:Price}) xtitle({stSerif:Bayesian posterior}) legend(order(2 "{stSerif:E(mean price|Bayesian posterior)}") ) xsize(6) ysize(6)  graphregion(color(white)) title({stSerif: {it:Dark-High}},size(medium)) name(d,replace)

grc1leg a b c d, title({stSerif:Overall}) legendfrom(a) graphregion(color(white)margin(l=22 r=22))
gr_edit .title.draw_view.setstyle, style(no)
gr_edit .legend.draw_view.setstyle, style(no)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//# Figure 2-2
use mktsummary.dta, replace
twoway scatter AvgLitTradePrice BFI if Treatment == 4|| lpoly AvgLitTradePrice BFI if Treatment == 4, lcolor(green) lwidth(thick) lpattern(dash) kernel(epanechnikov) bwidth(0.2) || lfit AvgLitTradePrice a1, lcolor(gs5) lpattern (shortdash) ///
||, yscale(range(0 10)) xscale(range(0 1)) xlabel(0 `"{fontface "stSerif": 0}"' 0.2 `"{fontface "stSerif": 0.2}"' 0.4 `"{fontface "stSerif": 0.4}"' 0.6 `"{fontface "stSerif": 0.6}"' 0.8 `"{fontface "stSerif": 0.8}"' 1 `"{fontface "stSerif": 1}"', angle(0) labsize(small) valuelabel) ylabel(0 `"{fontface "stSerif": 0}"' 2 `"{fontface "stSerif": 2}"' 4 `"{fontface "stSerif": 4}"' 6 `"{fontface "stSerif": 6}"' 8 `"{fontface "stSerif": 8}"' 10 `"{fontface "stSerif": 10}"', angle(0) valuelabel) ///
ytitle({stSerif:Price}) xtitle({stSerif:Bayesian posterior}) legend(order(2 "{stSerif:E(mean price|Bayesian posterior)}") ) xsize(6) ysize(6)  graphregion(color(white)) title({stSerif: {it:Lit Only}},size(medium)) name(a,replace)

twoway scatter AvgLitTradePrice BFI if Treatment == 3 & B == 1|| lpoly AvgLitTradePrice BFI if Treatment == 3 & B == 1, lcolor(green) lwidth(thick) lpattern(dash) kernel(epanechnikov) bwidth(0.2) || lfit AvgLitTradePrice a1, lcolor(gs5) lpattern (shortdash) ///
||, yscale(range(0 10)) xscale(range(0 1)) xlabel(0 `"{fontface "stSerif": 0}"' 0.2 `"{fontface "stSerif": 0.2}"' 0.4 `"{fontface "stSerif": 0.4}"' 0.6 `"{fontface "stSerif": 0.6}"' 0.8 `"{fontface "stSerif": 0.8}"' 1 `"{fontface "stSerif": 1}"', angle(0) labsize(small) valuelabel) ylabel(0 `"{fontface "stSerif": 0}"' 2 `"{fontface "stSerif": 2}"' 4 `"{fontface "stSerif": 4}"' 6 `"{fontface "stSerif": 6}"' 8 `"{fontface "stSerif": 8}"' 10 `"{fontface "stSerif": 10}"', angle(0) valuelabel) ///
ytitle({stSerif:Price}) xtitle({stSerif:Bayesian posterior}) legend(order(2 "{stSerif:E(mean price|Bayesian posterior)}") ) xsize(6) ysize(6) graphregion(color(white)) title({stSerif: {it: Modest}},size(medium)) name(b1,replace)

twoway scatter AvgLitTradePrice BFI if Treatment == 3 & B == 2|| lpoly AvgLitTradePrice BFI if Treatment == 3 & B == 2, lcolor(green) lwidth(thick) lpattern(dash) kernel(epanechnikov) bwidth(0.2) || lfit AvgLitTradePrice a1, lcolor(gs5) lpattern (shortdash) ///
||, yscale(range(0 10)) xscale(range(0 1)) xlabel(0 `"{fontface "stSerif": 0}"' 0.2 `"{fontface "stSerif": 0.2}"' 0.4 `"{fontface "stSerif": 0.4}"' 0.6 `"{fontface "stSerif": 0.6}"' 0.8 `"{fontface "stSerif": 0.8}"' 1 `"{fontface "stSerif": 1}"', angle(0) labsize(small) valuelabel) ylabel(0 `"{fontface "stSerif": 0}"' 2 `"{fontface "stSerif": 2}"' 4 `"{fontface "stSerif": 4}"' 6 `"{fontface "stSerif": 6}"' 8 `"{fontface "stSerif": 8}"' 10 `"{fontface "stSerif": 10}"', angle(0) valuelabel) ///
ytitle({stSerif:Price}) xtitle({stSerif:Bayesian posterior}) legend(order(2 "{stSerif:E(mean price|Bayesian posterior)}") ) xsize(6) ysize(6) graphregion(color(white)) title({stSerif: {it:High}},size(medium)) name(b2,replace)

twoway scatter AvgLitTradePrice BFI if Treatment == 3 & B == 3|| lpoly AvgLitTradePrice BFI if Treatment == 3 & B == 3, lcolor(green) lwidth(thick) lpattern(dash) kernel(epanechnikov) bwidth(0.2) || lfit AvgLitTradePrice a1, lcolor(gs5) lpattern (shortdash) ///
||, yscale(range(0 10)) xscale(range(0 1)) xlabel(0 `"{fontface "stSerif": 0}"' 0.2 `"{fontface "stSerif": 0.2}"' 0.4 `"{fontface "stSerif": 0.4}"' 0.6 `"{fontface "stSerif": 0.6}"' 0.8 `"{fontface "stSerif": 0.8}"' 1 `"{fontface "stSerif": 1}"', angle(0) labsize(small) valuelabel) ylabel(0 `"{fontface "stSerif": 0}"' 2 `"{fontface "stSerif": 2}"' 4 `"{fontface "stSerif": 4}"' 6 `"{fontface "stSerif": 6}"' 8 `"{fontface "stSerif": 8}"' 10 `"{fontface "stSerif": 10}"', angle(0) valuelabel) ///
ytitle({stSerif:Price}) xtitle({stSerif:Bayesian posterior}) legend(order(2 "{stSerif:E(mean price|Bayesian posterior)}") ) xsize(6) ysize(6) graphregion(color(white)) title({stSerif: {it:Very High}},size(medium)) name(b3,replace)

grc1leg a b1 b2 b3, title({stSerif: Low precision},size(medium)) legendfrom(a) graphregion(color(white)margin(l=22 r=22))
gr_edit .title.draw_view.setstyle, style(no)
gr_edit .legend.draw_view.setstyle, style(no)
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//# Figure 2-3
use mktsummary.dta, replace
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
twoway scatter AvgLitTradePrice BFI if Treatment == 2|| lpoly AvgLitTradePrice BFI if Treatment == 2, lcolor(green) lwidth(thick) lpattern(dash) kernel(epanechnikov) bwidth(0.2) || lfit AvgLitTradePrice a1, lcolor(gs5) lpattern (shortdash) ///
||, yscale(range(0 10)) xscale(range(0 1)) xlabel(0 `"{fontface "stSerif": 0}"' 0.2 `"{fontface "stSerif": 0.2}"' 0.4 `"{fontface "stSerif": 0.4}"' 0.6 `"{fontface "stSerif": 0.6}"' 0.8 `"{fontface "stSerif": 0.8}"' 1 `"{fontface "stSerif": 1}"', angle(0) labsize(small) valuelabel) ylabel(0 `"{fontface "stSerif": 0}"' 2 `"{fontface "stSerif": 2}"' 4 `"{fontface "stSerif": 4}"' 6 `"{fontface "stSerif": 6}"' 8 `"{fontface "stSerif": 8}"' 10 `"{fontface "stSerif": 10}"', angle(0) valuelabel) ///
ytitle({stSerif:Price}) xtitle({stSerif:Bayesian posterior}) legend(order(2 "{stSerif:E(mean price|Bayesian posterior)}") )  xsize(6) ysize(6) graphregion(color(white)) title({stSerif: {it:Lit Only}},size(medium)) name(a,replace)

twoway scatter AvgLitTradePrice BFI if Treatment == 1 & B == 1|| lpoly AvgLitTradePrice BFI if Treatment == 1 & B == 1, lcolor(green) lwidth(thick) lpattern(dash) kernel(epanechnikov) bwidth(0.2) || lfit AvgLitTradePrice a1, lcolor(gs5) lpattern (shortdash) ///
||, yscale(range(0 10)) xscale(range(0 1)) xlabel(0 `"{fontface "stSerif": 0}"' 0.2 `"{fontface "stSerif": 0.2}"' 0.4 `"{fontface "stSerif": 0.4}"' 0.6 `"{fontface "stSerif": 0.6}"' 0.8 `"{fontface "stSerif": 0.8}"' 1 `"{fontface "stSerif": 1}"', angle(0) labsize(small) valuelabel) ylabel(0 `"{fontface "stSerif": 0}"' 2 `"{fontface "stSerif": 2}"' 4 `"{fontface "stSerif": 4}"' 6 `"{fontface "stSerif": 6}"' 8 `"{fontface "stSerif": 8}"' 10 `"{fontface "stSerif": 10}"', angle(0) valuelabel) ///
ytitle({stSerif:Price}) xtitle({stSerif:Bayesian posterior}) legend(order(2 "{stSerif:E(mean price|Bayesian posterior)}") )  xsize(6) ysize(6) graphregion(color(white)) title({stSerif: {it: Modest}},size(medium)) name(b1,replace)

twoway scatter AvgLitTradePrice BFI if Treatment == 1 & B == 2|| lpoly AvgLitTradePrice BFI if Treatment == 1 & B == 2, lcolor(green) lwidth(thick) lpattern(dash) kernel(epanechnikov) bwidth(0.2) || lfit AvgLitTradePrice a1, lcolor(gs5) lpattern (shortdash) ///
||, yscale(range(0 10)) xscale(range(0 1)) xlabel(0 `"{fontface "stSerif": 0}"' 0.2 `"{fontface "stSerif": 0.2}"' 0.4 `"{fontface "stSerif": 0.4}"' 0.6 `"{fontface "stSerif": 0.6}"' 0.8 `"{fontface "stSerif": 0.8}"' 1 `"{fontface "stSerif": 1}"', angle(0) labsize(small) valuelabel) ylabel(0 `"{fontface "stSerif": 0}"' 2 `"{fontface "stSerif": 2}"' 4 `"{fontface "stSerif": 4}"' 6 `"{fontface "stSerif": 6}"' 8 `"{fontface "stSerif": 8}"' 10 `"{fontface "stSerif": 10}"', angle(0) valuelabel) ///
ytitle({stSerif:Price}) xtitle({stSerif:Bayesian posterior}) legend(order(2 "{stSerif:E(mean price|Bayesian posterior)}") ) xsize(6) ysize(6) graphregion(color(white)) title({stSerif: {it:High}},size(medium)) name(b2,replace)

twoway scatter AvgLitTradePrice BFI if Treatment == 1 & B == 3|| lpoly AvgLitTradePrice BFI if Treatment == 1 & B == 3, lcolor(green) lwidth(thick) lpattern(dash) kernel(epanechnikov) bwidth(0.2) || lfit AvgLitTradePrice a1, lcolor(gs5) lpattern (shortdash) ///
||, yscale(range(0 10)) xscale(range(0 1)) xlabel(0 `"{fontface "stSerif": 0}"' 0.2 `"{fontface "stSerif": 0.2}"' 0.4 `"{fontface "stSerif": 0.4}"' 0.6 `"{fontface "stSerif": 0.6}"' 0.8 `"{fontface "stSerif": 0.8}"' 1 `"{fontface "stSerif": 1}"', angle(0) labsize(small) valuelabel) ylabel(0 `"{fontface "stSerif": 0}"' 2 `"{fontface "stSerif": 2}"' 4 `"{fontface "stSerif": 4}"' 6 `"{fontface "stSerif": 6}"' 8 `"{fontface "stSerif": 8}"' 10 `"{fontface "stSerif": 10}"', angle(0) valuelabel) ///
ytitle({stSerif:Price}) xtitle({stSerif:Bayesian posterior}) legend(order(2 "{stSerif:E(mean price|Bayesian posterior)}") ) xsize(6) ysize(6) graphregion(color(white)) title({stSerif: {it:Very High}},size(medium)) name(b3,replace)

grc1leg a b1 b2 b3, title({stSerif: High precision},size(medium)) legendfrom(a) graphregion(color(white)margin(l=22 r=22))
gr_edit .title.draw_view.setstyle, style(no)
gr_edit .legend.draw_view.setstyle, style(no)

/////////////////////////////////////////////////////////////////////////////////////////////////////
//#Table II
use mktsummary.dta, replace
gen LADLIT = abs(AvgLitTradePrice - 10*BFI)
replace LADLIT = . if TotLitTrade == 0
gen LAPELIT = abs(AvgLitTradePrice - 10*urn)
replace LAPELIT = . if TotLitTrade == 0

gen LADDARK = abs(AvgDarkTradePrice - 10*BFI)
replace LADDARK = . if TotDarkTrade == 0

gen darktraderatio = TotDarkTrade/TotTrade
gen B = 1 if darktraderatio < 0.2 & mkt == 1
replace B = 2 if darktraderatio < 0.4 & darktraderatio >= 0.2
replace B = 3 if darktraderatio >= 0.4
replace B = 0 if mkt == 0

gen B1 = 1 if B == 1
replace B1 = 0 if B != 1
gen B2 = 1 if B == 2
replace B2 = 0 if B != 2
gen B3 = 1 if B == 3
replace B3 = 0 if B != 3
/////////////////////////////////////////////////////////////////////////////////////////////////////
//64
reg LADLIT mkt Period if urncomposition == 0, vce(cluster Session)
outreg2 using reg.xls, replace
reg LADLIT mkt TotLitTradeNum age gender majorecon riskaversion Period if urncomposition == 0, vce(cluster Session)
outreg2 using reg.xls, append
reg LADLIT B1 B2 B3 Period if urncomposition == 0, vce(cluster Session)
outreg2 using reg.xls, append
reg LADLIT B1 B2 B3 TotLitTradeNum age gender majorecon riskaversion Period if urncomposition == 0, vce(cluster Session)
outreg2 using reg.xls, append
////73 
reg LADLIT mkt Period if urncomposition == 1, vce(cluster Session)
outreg2 using reg.xls, append
reg LADLIT mkt TotLitTradeNum age gender majorecon riskaversion Period if urncomposition == 1, vce(cluster Session)
outreg2 using reg.xls, append
reg LADLIT B1 B2 B3 Period if urncomposition == 1, vce(cluster Session)
outreg2 using reg.xls, append
reg LADLIT B1 B2 B3 TotLitTradeNum age gender majorecon riskaversion Period if urncomposition == 1, vce(cluster Session)
outreg2 using reg.xls, append
/////////////////////////////////////////////////////////////////////////////////////////////////////
///test 0213
gen B1urncomposition = B1 * urncomposition
gen B2urncomposition = B2 * urncomposition
gen B3urncomposition = B3 * urncomposition

reg LAPELIT B1 B2 B3 urncomposition B1urncomposition B2urncomposition B3urncomposition Period, vce(cluster Session)
outreg2 using reg.xls,replace
lincom B1 + B1urncomposition
lincom B2 + B2urncomposition
lincom B3 + B3urncomposition
reg LAPELIT B1 B2 B3 urncomposition B1urncomposition B2urncomposition B3urncomposition TotLitTradeNum bfiaccuracy age gender majorecon riskaversion Period, vce(cluster Session)
outreg2 using reg.xls,replace
lincom B1 + B1urncomposition
lincom B2 + B2urncomposition
lincom B3 + B3urncomposition

reg LADLIT mkt Period if B3 == 1 | mkt == 0, vce(cluster Session)
outreg2 using reg.xls,replace
reg LADLIT mkt age gender majorecon riskaversion Period if B3 == 1 | mkt == 0, vce(cluster Session)
outreg2 using reg.xls,append
////////////////////////////////////////////////////////////////////////////////////////////////////////////
//use SumNumAcq
//64
reg LADLIT mkt Period if urncomposition == 0, vce(cluster Session)
outreg2 using reg.xls, replace
reg LADLIT mkt SumNumAcq age gender majorecon riskaversion Period if urncomposition == 0, vce(cluster Session)
outreg2 using reg.xls, append
reg LADLIT B1 B2 B3 Period if urncomposition == 0, vce(cluster Session)
outreg2 using reg.xls, append
reg LADLIT B1 B2 B3 SumNumAcq age gender majorecon riskaversion Period if urncomposition == 0, vce(cluster Session)
outreg2 using reg.xls, append
////73 
reg LADLIT mkt Period if urncomposition == 1, vce(cluster Session)
outreg2 using reg.xls, append
reg LADLIT mkt SumNumAcq age gender majorecon riskaversion Period if urncomposition == 1, vce(cluster Session)
outreg2 using reg.xls, append
reg LADLIT B1 B2 B3 Period if urncomposition == 1, vce(cluster Session)
outreg2 using reg.xls, append
reg LADLIT B1 B2 B3 SumNumAcq age gender majorecon riskaversion Period if urncomposition == 1, vce(cluster Session)
outreg2 using reg.xls, append
//#Figure 3
use mktsummary.dta, replace
collapse (mean) meanlapelit= LAPELIT (sd) sdlapelit=LAPELIT (count) n2 = LAPELIT, by(urncomposition B)

gen highlapelit = meanlapelit + invttail(n2-1,0.025)*(sdlapelit/sqrt(n2))
gen lowlapelit = meanlapelit - invttail(n2-1,0.025)*(sdlapelit/sqrt(n2))
label define BB 0 "Single lit" 1 "dark 0-20%" 2 "dark 20%-40%" 3 "dark >=40%"
label values B BB
format meanlapelit %9.3g

twoway (bar meanlapelit B if B == 0, barwidth(.5)) (bar meanlapelit B if B == 1, barwidth(.5))(bar meanlapelit B if B == 2, barwidth(.5))(bar meanlapelit B if B == 3, barwidth(.5))(rcap highlapelit lowlapelit B, color(black)) if urncomposition ==0, legend(off)title({stSerif: Low precision}) ytitle({stSerif:LAPE}) yscale(range(0 5)) graphregion(color(white)) name(a,replace) xlabel( 0 `"{fontface "stSerif": Single lit}"' 1 `"{fontface "stSerif": [0, 20%)}"' 2 `"{fontface "stSerif": [20%, 40%)}"' 3 `"{fontface "stSerif": [40%, 100%]}"', noticks) xtitle({stSerif: proportion of dark trading})ylabel(0 `"{fontface "stSerif": 0}"' 1 `"{fontface "stSerif": 1}"' 2 `"{fontface "stSerif": 2}"' 3 `"{fontface "stSerif": 3}"' 4 `"{fontface "stSerif": 4}"'5`"{fontface "stSerif": 5}"', angle(0) valuelabel)

twoway (bar meanlapelit B if B == 0, barwidth(.5)) (bar meanlapelit B if B == 1, barwidth(.5))(bar meanlapelit B if B == 2, barwidth(.5))(bar meanlapelit B if B == 3, barwidth(.5))(rcap highlapelit lowlapelit B, color(black)) if urncomposition ==1, legend(off)title({stSerif: High precision}) ytitle({stSerif:LAPE}) yscale(range(0 5)) graphregion(color(white)) name(b,replace) xlabel( 0 `"{fontface "stSerif": Single lit}"' 1 `"{fontface "stSerif": [0, 20%)}"' 2 `"{fontface "stSerif": [20%, 40%)}"' 3 `"{fontface "stSerif": [40%, 100%]}"', noticks) xtitle({stSerif: proportion of dark trading})ylabel(0 `"{fontface "stSerif": 0}"' 1 `"{fontface "stSerif": 1}"' 2 `"{fontface "stSerif": 2}"' 3 `"{fontface "stSerif": 3}"' 4 `"{fontface "stSerif": 4}"'5`"{fontface "stSerif": 5}"', angle(0) valuelabel)

grc1leg a b, title({stSerif: Linear Absolute Prediction Error in Lit Market},size(medium)) legendfrom(a) graphregion(color(white))
gr_edit .title.draw_view.setstyle, style(no)
gr_edit .legend.draw_view.setstyle, style(no)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//#Figure 4-1
use mktsummary.dta, replace

twoway scatter urn AvgLitTradePrice if Treatment == 4 || lowess urn AvgLitTradePrice if Treatment == 4 & inrange(urn,0,1), color(blue) bwidth(0.5) jitter(5) ||lfit a1 AvgLitTradePrice, lcolor(red) lpattern (shortdash)  xscale(range(0 10)) yscale(range(0 1))  ylabel(0 `"{fontface "stSerif": 0}"' 0.2 `"{fontface "stSerif": 0.2}"' 0.4 `"{fontface "stSerif": 0.4}"' 0.6 `"{fontface "stSerif": 0.6}"' 0.8 `"{fontface "stSerif": 0.8}"' 1 `"{fontface "stSerif": 1}"', angle(0) labsize(vsmall) valuelabel) xlabel(0 `"{fontface "stSerif": 0}"' 1 `"{fontface "stSerif": 1}"' 2 `"{fontface "stSerif": 2}"' 3 `"{fontface "stSerif": 3}"' 4 `"{fontface "stSerif": 4}"' 5 `"{fontface "stSerif": 5}"' 6 `"{fontface "stSerif": 6}"' 7 `"{fontface "stSerif": 7}"' 8 `"{fontface "stSerif": 8}"' 9 `"{fontface "stSerif": 9}"' 10 `"{fontface "stSerif": 10}"', angle(0) valuelabel) xtitle({stSerif:mean price}) ytitle({stSerif:E(Outcome|mean price)}) legend(off) title({stSerif: Low precision single lit market }) name(a,replace)

twoway scatter urn AvgLitTradePrice if Treatment == 3 || lowess urn AvgLitTradePrice if Treatment == 3, color(blue) bwidth(0.5) jitter(5) ||lfit a1 AvgLitTradePrice, lcolor(red) lpattern (shortdash)  xscale(range(0 10)) yscale(range(0 1))  ylabel(0 `"{fontface "stSerif": 0}"' 0.2 `"{fontface "stSerif": 0.2}"' 0.4 `"{fontface "stSerif": 0.4}"' 0.6 `"{fontface "stSerif": 0.6}"' 0.8 `"{fontface "stSerif": 0.8}"' 1 `"{fontface "stSerif": 1}"', angle(0) labsize(vsmall) valuelabel) xlabel(0 `"{fontface "stSerif": 0}"' 1 `"{fontface "stSerif": 1}"' 2 `"{fontface "stSerif": 2}"' 3 `"{fontface "stSerif": 3}"' 4 `"{fontface "stSerif": 4}"' 5 `"{fontface "stSerif": 5}"' 6 `"{fontface "stSerif": 6}"' 7 `"{fontface "stSerif": 7}"' 8 `"{fontface "stSerif": 8}"' 9 `"{fontface "stSerif": 9}"' 10 `"{fontface "stSerif": 10}"', angle(0) valuelabel) xtitle({stSerif:mean price}) ytitle({stSerif:E(Outcome|mean price)}) legend(off) title({stSerif: Low precision lit & dark }) name(b,replace)

twoway scatter urn AvgLitTradePrice if Treatment == 2 || lowess urn AvgLitTradePrice if Treatment == 2, color(blue) bwidth(0.5) jitter(5)  ||lfit a1 AvgLitTradePrice, lcolor(red) lpattern (shortdash)  xscale(range(0 10)) yscale(range(0 1))  ylabel(0 `"{fontface "stSerif": 0}"' 0.2 `"{fontface "stSerif": 0.2}"' 0.4 `"{fontface "stSerif": 0.4}"' 0.6 `"{fontface "stSerif": 0.6}"' 0.8 `"{fontface "stSerif": 0.8}"' 1 `"{fontface "stSerif": 1}"', angle(0) labsize(vsmall) valuelabel) xlabel(0 `"{fontface "stSerif": 0}"' 1 `"{fontface "stSerif": 1}"' 2 `"{fontface "stSerif": 2}"' 3 `"{fontface "stSerif": 3}"' 4 `"{fontface "stSerif": 4}"' 5 `"{fontface "stSerif": 5}"' 6 `"{fontface "stSerif": 6}"' 7 `"{fontface "stSerif": 7}"' 8 `"{fontface "stSerif": 8}"' 9 `"{fontface "stSerif": 9}"' 10 `"{fontface "stSerif": 10}"', angle(0) valuelabel) xtitle({stSerif:mean price}) ytitle({stSerif:E(Outcome|mean price)}) legend(off) title({stSerif: High precision single lit market  }) name(c,replace)

twoway scatter urn AvgLitTradePrice if Treatment == 1 || lowess urn AvgLitTradePrice if Treatment == 1, color(blue) bwidth(0.5) jitter(5)  ||lfit a1 AvgLitTradePrice, lcolor(red) lpattern (shortdash)  xscale(range(0 10)) yscale(range(0 1))  ylabel(0 `"{fontface "stSerif": 0}"' 0.2 `"{fontface "stSerif": 0.2}"' 0.4 `"{fontface "stSerif": 0.4}"' 0.6 `"{fontface "stSerif": 0.6}"' 0.8 `"{fontface "stSerif": 0.8}"' 1 `"{fontface "stSerif": 1}"', angle(0) labsize(vsmall) valuelabel) xlabel(0 `"{fontface "stSerif": 0}"' 1 `"{fontface "stSerif": 1}"' 2 `"{fontface "stSerif": 2}"' 3 `"{fontface "stSerif": 3}"' 4 `"{fontface "stSerif": 4}"' 5 `"{fontface "stSerif": 5}"' 6 `"{fontface "stSerif": 6}"' 7 `"{fontface "stSerif": 7}"' 8 `"{fontface "stSerif": 8}"' 9 `"{fontface "stSerif": 9}"' 10 `"{fontface "stSerif": 10}"', angle(0) valuelabel) xtitle({stSerif:mean price}) ytitle({stSerif:E(Outcome|mean price)}) legend(off) title({stSerif: High precision lit & dark }) name(d,replace)

grc1leg a b c d, title({stSerif: Overall},size(medium)) legendfrom(a) graphregion(color(white))
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .title.draw_view.setstyle, style(no)
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
//#Figure 4-2
use mktsummary.dta, replace

twoway scatter urn AvgLitTradePrice if Treatment == 4 || lowess urn AvgLitTradePrice if Treatment == 4 & inrange(urn,0,1), color(blue) bwidth(0.5) jitter(5) ||lfit a1 AvgLitTradePrice, lcolor(red) lpattern (shortdash)  xscale(range(0 10)) yscale(range(0 1))  ylabel(0 `"{fontface "stSerif": 0}"' 0.2 `"{fontface "stSerif": 0.2}"' 0.4 `"{fontface "stSerif": 0.4}"' 0.6 `"{fontface "stSerif": 0.6}"' 0.8 `"{fontface "stSerif": 0.8}"' 1 `"{fontface "stSerif": 1}"', angle(0) labsize(vsmall) valuelabel) xlabel(0 `"{fontface "stSerif": 0}"' 1 `"{fontface "stSerif": 1}"' 2 `"{fontface "stSerif": 2}"' 3 `"{fontface "stSerif": 3}"' 4 `"{fontface "stSerif": 4}"' 5 `"{fontface "stSerif": 5}"' 6 `"{fontface "stSerif": 6}"' 7 `"{fontface "stSerif": 7}"' 8 `"{fontface "stSerif": 8}"' 9 `"{fontface "stSerif": 9}"' 10 `"{fontface "stSerif": 10}"', angle(0) valuelabel) xtitle({stSerif:mean price}) ytitle({stSerif:E(Outcome|mean price)}) legend(off) title({stSerif: Single lit market }) name(a,replace)

twoway scatter urn AvgLitTradePrice if Treatment == 3 & B == 1|| lowess urn AvgLitTradePrice if Treatment == 3 & B == 1 & inrange(urn,0,1), color(blue) bwidth(0.5) jitter(5) ||lfit a1 AvgLitTradePrice, lcolor(red) lpattern (shortdash)  xscale(range(0 10)) yscale(range(0 1))  ylabel(0 `"{fontface "stSerif": 0}"' 0.2 `"{fontface "stSerif": 0.2}"' 0.4 `"{fontface "stSerif": 0.4}"' 0.6 `"{fontface "stSerif": 0.6}"' 0.8 `"{fontface "stSerif": 0.8}"' 1 `"{fontface "stSerif": 1}"', angle(0) labsize(vsmall) valuelabel) xlabel(0 `"{fontface "stSerif": 0}"' 1 `"{fontface "stSerif": 1}"' 2 `"{fontface "stSerif": 2}"' 3 `"{fontface "stSerif": 3}"' 4 `"{fontface "stSerif": 4}"' 5 `"{fontface "stSerif": 5}"' 6 `"{fontface "stSerif": 6}"' 7 `"{fontface "stSerif": 7}"' 8 `"{fontface "stSerif": 8}"' 9 `"{fontface "stSerif": 9}"' 10 `"{fontface "stSerif": 10}"', angle(0) valuelabel) xtitle({stSerif:mean price}) ytitle({stSerif:E(Outcome|mean price)}) legend(off) title({stSerif: Dark < 20% }) name(b1,replace)

twoway scatter urn AvgLitTradePrice if Treatment == 3 & B == 2 || lowess urn AvgLitTradePrice if Treatment == 3 & B == 2, color(blue) jitter(5) bwidth(0.5) ||lfit a1 AvgLitTradePrice, lcolor(red) lpattern (shortdash)  xscale(range(0 10)) yscale(range(0 1))  ylabel(0 `"{fontface "stSerif": 0}"' 0.2 `"{fontface "stSerif": 0.2}"' 0.4 `"{fontface "stSerif": 0.4}"' 0.6 `"{fontface "stSerif": 0.6}"' 0.8 `"{fontface "stSerif": 0.8}"' 1 `"{fontface "stSerif": 1}"', angle(0) labsize(vsmall) valuelabel) xlabel(0 `"{fontface "stSerif": 0}"' 1 `"{fontface "stSerif": 1}"' 2 `"{fontface "stSerif": 2}"' 3 `"{fontface "stSerif": 3}"' 4 `"{fontface "stSerif": 4}"' 5 `"{fontface "stSerif": 5}"' 6 `"{fontface "stSerif": 6}"' 7 `"{fontface "stSerif": 7}"' 8 `"{fontface "stSerif": 8}"' 9 `"{fontface "stSerif": 9}"' 10 `"{fontface "stSerif": 10}"', angle(0) valuelabel) xtitle({stSerif:mean price}) ytitle({stSerif:E(Outcome|mean price)}) legend(off) title({stSerif: 20% <= Dark < 40% }) name(b2,replace)

twoway scatter urn AvgLitTradePrice if Treatment == 3 & B == 3 || lowess urn AvgLitTradePrice if Treatment == 3 & B == 3, color(blue) bwidth(0.5) jitter(5) ||lfit a1 AvgLitTradePrice, lcolor(red) lpattern (shortdash)  xscale(range(0 10)) yscale(range(0 1))  ylabel(0 `"{fontface "stSerif": 0}"' 0.2 `"{fontface "stSerif": 0.2}"' 0.4 `"{fontface "stSerif": 0.4}"' 0.6 `"{fontface "stSerif": 0.6}"' 0.8 `"{fontface "stSerif": 0.8}"' 1 `"{fontface "stSerif": 1}"', angle(0) labsize(vsmall) valuelabel) xlabel(0 `"{fontface "stSerif": 0}"' 1 `"{fontface "stSerif": 1}"' 2 `"{fontface "stSerif": 2}"' 3 `"{fontface "stSerif": 3}"' 4 `"{fontface "stSerif": 4}"' 5 `"{fontface "stSerif": 5}"' 6 `"{fontface "stSerif": 6}"' 7 `"{fontface "stSerif": 7}"' 8 `"{fontface "stSerif": 8}"' 9 `"{fontface "stSerif": 9}"' 10 `"{fontface "stSerif": 10}"', angle(0) valuelabel) xtitle({stSerif:mean price}) ytitle({stSerif:E(Outcome|mean price)}) legend(off) title({stSerif: Dark >= 40% })  name(b3,replace)

grc1leg a b1 b2 b3, title({stSerif: Low precision},size(medium)) legendfrom(a) graphregion(color(white))
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .title.draw_view.setstyle, style(no)

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
//#Figure 4-3
use mktsummary.dta, replace

twoway scatter urn AvgLitTradePrice if Treatment == 2 || lowess urn AvgLitTradePrice if Treatment == 2, color(blue) bwidth(0.5) jitter(5)  ||lfit a1 AvgLitTradePrice, lcolor(red) lpattern (shortdash)  xscale(range(0 10)) yscale(range(0 1))  ylabel(0 `"{fontface "stSerif": 0}"' 0.2 `"{fontface "stSerif": 0.2}"' 0.4 `"{fontface "stSerif": 0.4}"' 0.6 `"{fontface "stSerif": 0.6}"' 0.8 `"{fontface "stSerif": 0.8}"' 1 `"{fontface "stSerif": 1}"', angle(0) labsize(vsmall) valuelabel) xlabel(0 `"{fontface "stSerif": 0}"' 1 `"{fontface "stSerif": 1}"' 2 `"{fontface "stSerif": 2}"' 3 `"{fontface "stSerif": 3}"' 4 `"{fontface "stSerif": 4}"' 5 `"{fontface "stSerif": 5}"' 6 `"{fontface "stSerif": 6}"' 7 `"{fontface "stSerif": 7}"' 8 `"{fontface "stSerif": 8}"' 9 `"{fontface "stSerif": 9}"' 10 `"{fontface "stSerif": 10}"', angle(0) valuelabel) xtitle({stSerif:mean price}) ytitle({stSerif:E(Outcome|mean price)}) legend(off) title({stSerif: Single lit market}) name(c,replace)

twoway scatter urn AvgLitTradePrice if Treatment == 1 & B == 1|| lowess urn AvgLitTradePrice if Treatment == 1 & B == 1, color(blue) jitter(5) bwidth(0.5)||lfit a1 AvgLitTradePrice, lcolor(red) lpattern (shortdash)  xscale(range(0 10)) yscale(range(0 1))  ylabel(0 `"{fontface "stSerif": 0}"' 0.2 `"{fontface "stSerif": 0.2}"' 0.4 `"{fontface "stSerif": 0.4}"' 0.6 `"{fontface "stSerif": 0.6}"' 0.8 `"{fontface "stSerif": 0.8}"' 1 `"{fontface "stSerif": 1}"', angle(0) labsize(vsmall) valuelabel) xlabel(0 `"{fontface "stSerif": 0}"' 1 `"{fontface "stSerif": 1}"' 2 `"{fontface "stSerif": 2}"' 3 `"{fontface "stSerif": 3}"' 4 `"{fontface "stSerif": 4}"' 5 `"{fontface "stSerif": 5}"' 6 `"{fontface "stSerif": 6}"' 7 `"{fontface "stSerif": 7}"' 8 `"{fontface "stSerif": 8}"' 9 `"{fontface "stSerif": 9}"' 10 `"{fontface "stSerif": 10}"', angle(0) valuelabel) xtitle({stSerif:mean price}) ytitle({stSerif:E(Outcome|mean price)}) legend(off) title({stSerif: Dark < 20% }) name(d1,replace)

twoway scatter urn AvgLitTradePrice if Treatment == 1 & B == 2 || lowess urn AvgLitTradePrice if Treatment == 1 & B == 2, color(blue) jitter(5) bwidth(0.5) ||lfit a1 AvgLitTradePrice, lcolor(red) lpattern (shortdash)  xscale(range(0 10)) yscale(range(0 1))  ylabel(0 `"{fontface "stSerif": 0}"' 0.2 `"{fontface "stSerif": 0.2}"' 0.4 `"{fontface "stSerif": 0.4}"' 0.6 `"{fontface "stSerif": 0.6}"' 0.8 `"{fontface "stSerif": 0.8}"' 1 `"{fontface "stSerif": 1}"', angle(0) labsize(vsmall) valuelabel) xlabel(0 `"{fontface "stSerif": 0}"' 1 `"{fontface "stSerif": 1}"' 2 `"{fontface "stSerif": 2}"' 3 `"{fontface "stSerif": 3}"' 4 `"{fontface "stSerif": 4}"' 5 `"{fontface "stSerif": 5}"' 6 `"{fontface "stSerif": 6}"' 7 `"{fontface "stSerif": 7}"' 8 `"{fontface "stSerif": 8}"' 9 `"{fontface "stSerif": 9}"' 10 `"{fontface "stSerif": 10}"', angle(0) valuelabel) xtitle({stSerif:mean price}) ytitle({stSerif:E(Outcome|mean price)}) legend(off) title({stSerif: 20% <= Dark < 40% }) name(d2,replace)

twoway scatter urn AvgLitTradePrice if Treatment == 1 & B == 3 || lowess urn AvgLitTradePrice if Treatment == 1 & B == 3, color(blue) jitter(5) bwidth(0.5)||lfit a1 AvgLitTradePrice, lcolor(red) lpattern (shortdash)  xscale(range(0 10)) yscale(range(0 1))  ylabel(0 `"{fontface "stSerif": 0}"' 0.2 `"{fontface "stSerif": 0.2}"' 0.4 `"{fontface "stSerif": 0.4}"' 0.6 `"{fontface "stSerif": 0.6}"' 0.8 `"{fontface "stSerif": 0.8}"' 1 `"{fontface "stSerif": 1}"', angle(0) labsize(vsmall) valuelabel) xlabel(0 `"{fontface "stSerif": 0}"' 1 `"{fontface "stSerif": 1}"' 2 `"{fontface "stSerif": 2}"' 3 `"{fontface "stSerif": 3}"' 4 `"{fontface "stSerif": 4}"' 5 `"{fontface "stSerif": 5}"' 6 `"{fontface "stSerif": 6}"' 7 `"{fontface "stSerif": 7}"' 8 `"{fontface "stSerif": 8}"' 9 `"{fontface "stSerif": 9}"' 10 `"{fontface "stSerif": 10}"', angle(0) valuelabel) xtitle({stSerif:mean price}) ytitle({stSerif:E(Outcome|mean price)}) legend(off) title({stSerif: Dark >= 40% })  name(d3,replace)

grc1leg c d1 d2 d3, title({stSerif: High precision},size(medium)) legendfrom(c) graphregion(color(white))
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .title.draw_view.setstyle, style(no)

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
//#Table III
use mktsummary.dta, replace
gen bfiaccuracy = 1 if (BFI > 0.5 & urn == 1)|(BFI < 0.5 & urn == 0)
replace bfiaccuracy = 0 if bfiaccuracy ==.
//64
reg LAPELIT mkt Period if urncomposition == 0, vce(cluster Session)
outreg2 using reg.xls, replace
reg LAPELIT mkt TotLitTradeNum bfiaccuracy age gender majorecon riskaversion Period if urncomposition == 0, vce(cluster Session)
outreg2 using reg.xls, append
reg LAPELIT B1 B2 B3 Period if urncomposition == 0, vce(cluster Session)
outreg2 using reg.xls, append
reg LAPELIT B1 B2 B3 TotLitTradeNum bfiaccuracy age gender majorecon riskaversion Period if urncomposition == 0, vce(cluster Session)
outreg2 using reg.xls, append
////73 
reg LAPELIT mkt Period if urncomposition == 1, vce(cluster Session)
outreg2 using reg.xls, append
reg LAPELIT mkt TotLitTradeNum bfiaccuracy age gender majorecon riskaversion Period if urncomposition == 1, vce(cluster Session)
outreg2 using reg.xls, append
reg LAPELIT B1 B2 B3 Period if urncomposition == 1, vce(cluster Session)
outreg2 using reg.xls, append
reg LAPELIT B1 B2 B3 TotLitTradeNum bfiaccuracy age gender majorecon riskaversion Period if urncomposition == 1, vce(cluster Session)
outreg2 using reg.xls, append
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
//drop bfiaccuracy
//64
reg LAPELIT mkt Period if urncomposition == 0, vce(cluster Session)
outreg2 using reg.xls, replace
reg LAPELIT mkt TotLitTradeNum SumNumAcq age gender majorecon riskaversion Period if urncomposition == 0, vce(cluster Session)
outreg2 using reg.xls, append
reg LAPELIT B1 B2 B3 Period if urncomposition == 0, vce(cluster Session)
outreg2 using reg.xls, append
reg LAPELIT B1 B2 B3 TotLitTradeNum SumNumAcq age gender majorecon riskaversion Period if urncomposition == 0, vce(cluster Session)
outreg2 using reg.xls, append
////73 
reg LAPELIT mkt Period if urncomposition == 1, vce(cluster Session)
outreg2 using reg.xls, append
reg LAPELIT mkt TotLitTradeNum SumNumAcq age gender majorecon riskaversion Period if urncomposition == 1, vce(cluster Session)
outreg2 using reg.xls, append
reg LAPELIT B1 B2 B3 Period if urncomposition == 1, vce(cluster Session)
outreg2 using reg.xls, append
reg LAPELIT B1 B2 B3 TotLitTradeNum SumNumAcq age gender majorecon riskaversion Period if urncomposition == 1, vce(cluster Session)
outreg2 using reg.xls, append
//use SumNumAcq
//64
reg LAPELIT mkt Period if urncomposition == 0, vce(cluster Session)
outreg2 using reg.xls, replace
reg LAPELIT mkt SumNumAcq age gender majorecon riskaversion Period if urncomposition == 0, vce(cluster Session)
outreg2 using reg.xls, append
reg LAPELIT B1 B2 B3 Period if urncomposition == 0, vce(cluster Session)
outreg2 using reg.xls, append
reg LAPELIT B1 B2 B3 SumNumAcq age gender majorecon riskaversion Period if urncomposition == 0, vce(cluster Session)
outreg2 using reg.xls, append
////73 
reg LAPELIT mkt Period if urncomposition == 1, vce(cluster Session)
outreg2 using reg.xls, append
reg LAPELIT mkt SumNumAcq age gender majorecon riskaversion Period if urncomposition == 1, vce(cluster Session)
outreg2 using reg.xls, append
reg LAPELIT B1 B2 B3 Period if urncomposition == 1, vce(cluster Session)
outreg2 using reg.xls, append
reg LAPELIT B1 B2 B3 SumNumAcq age gender majorecon riskaversion Period if urncomposition == 1, vce(cluster Session)
outreg2 using reg.xls, append
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
//#Table IV
use mktsummary.dta, replace

gen correctprice = 1 if (AvgLitTradePrice > 5 & urn == 1)|(AvgLitTradePrice <= 5 & urn == 0)
replace correctprice = 0 if correctprice == .

logit correctprice mkt age gender majorecon riskaversion Period if urncomposition == 0, or nolog  vce(cluster Session)
outreg2 using reg.xls, replace
logit correctprice B1 B2 B3 age gender majorecon riskaversion Period if urncomposition == 0, or nolog vce(cluster Session)
outreg2 using reg.xls, append
logit correctprice mkt age gender majorecon riskaversion Period if urncomposition == 1, or nolog  vce(cluster Session)
outreg2 using reg.xls, append
logit correctprice B1 B2 B3 age gender majorecon riskaversion Period if urncomposition == 1, or nolog vce(cluster Session)
outreg2 using reg.xls, append
estat clas
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////
//#Table V
use mktsummary.dta, replace
merge 1:m Session Period using "C:\Users\yan006\Dropbox\Project with WANG YAN 2019\1ST PROJECT\DO and DTA Files\211028 summary\transaction.dta", keepusing(vola)
keep in 1/480
drop _merge
//64
reg vola mkt SumNumAcq  age gender majorecon riskaversion Period if urncomposition == 0, vce(cluster Session)
outreg2 using reg.xls, replace

reg vola B1 B2 B3 SumNumAcq age gender majorecon riskaversion Period if urncomposition == 0, vce(cluster Session)
outreg2 using reg.xls, append
//73
reg vola mkt SumNumAcq  age gender majorecon riskaversion Period if urncomposition == 1, vce(cluster Session)
outreg2 using reg.xls, append

reg vola B1 B2 B3 SumNumAcq  age gender majorecon riskaversion Period if urncomposition == 1, vce(cluster Session)
outreg2 using reg.xls, append
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//use TotLitTradeNum
//64
reg vola mkt TotLitTradeNum  age gender majorecon riskaversion Period if urncomposition == 0, vce(cluster Session)
outreg2 using reg.xls, replace

reg vola B1 B2 B3 TotLitTradeNum age gender majorecon riskaversion Period if urncomposition == 0, vce(cluster Session)
outreg2 using reg.xls, append
//73
reg vola mkt TotLitTradeNum age gender majorecon riskaversion Period if urncomposition == 1, vce(cluster Session)
outreg2 using reg.xls, append

reg vola B1 B2 B3 TotLitTradeNum age gender majorecon riskaversion Period if urncomposition == 1, vce(cluster Session)
outreg2 using reg.xls, append
//////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////
//#Table VI
use mktsummary.dta, replace
merge 1:m Session Period using "C:\Users\yan006\Dropbox\Project with WANG YAN 2019\1ST PROJECT\DO and DTA Files\211028 summary\contractsandcontractdark.dta", keepusing(Depth)
keep in 1/480
drop _merge

//64
reg TotTrade mkt SumNumAcq gender majorecon riskaversion Period if urncomposition == 0, vce(cluster Session)
outreg2 using reg.xls, replace
reg TotTrade mkt SumNumAcq age majorecon riskaversion Period if urncomposition == 0, vce(cluster Session)
outreg2 using reg.xls, append
reg TotTrade mkt SumNumAcq age gender riskaversion Period if urncomposition == 0, vce(cluster Session)
outreg2 using reg.xls, append
reg TotTrade mkt SumNumAcq age gender majorecon Period if urncomposition == 0, vce(cluster Session)
outreg2 using reg.xls, append


//73
reg TotTrade mkt SumNumAcq gender majorecon riskaversion Period if urncomposition == 1, vce(cluster Session)
outreg2 using reg.xls, replace
reg TotTrade mkt SumNumAcq age majorecon riskaversion Period if urncomposition == 1, vce(cluster Session)
outreg2 using reg.xls, append
reg TotTrade mkt SumNumAcq age gender riskaversion Period if urncomposition == 1, vce(cluster Session)
outreg2 using reg.xls, append
reg TotTrade mkt SumNumAcq age gender majorecon Period if urncomposition == 1, vce(cluster Session)
outreg2 using reg.xls, append







reg TotTrade B1 B2 B3 SumNumAcq  age gender majorecon riskaversion Period if urncomposition == 0, vce(cluster Session)
outreg2 using reg.xls, append
reg TotLitTrade mkt SumNumAcq  age gender majorecon riskaversion Period if urncomposition == 0, vce(cluster Session)
outreg2 using reg.xls, append
reg TotLitTrade B1 B2 B3 SumNumAcq  age gender majorecon riskaversion Period if urncomposition == 0, vce(cluster Session)
outreg2 using reg.xls, append
reg Depth mkt SumNumAcq  age gender majorecon riskaversion Period if urncomposition == 0, vce(cluster Session)
outreg2 using reg.xls, append
reg Depth B1 B2 B3 SumNumAcq  age gender majorecon riskaversion Period if urncomposition == 0, vce(cluster Session)
outreg2 using reg.xls, append
///weighted spread
reg Quotedspreadwt mkt SumNumAcq  age gender majorecon riskaversion Period if urncomposition == 0, vce(cluster Session)
outreg2 using reg.xls, append
reg Quotedspreadwt B1 B2 B3 SumNumAcq  age gender majorecon riskaversion Period if urncomposition == 0, vce(cluster Session)
outreg2 using reg.xls, append
reg Effspreadwt mkt SumNumAcq  age gender majorecon riskaversion Period if urncomposition == 0, vce(cluster Session)
outreg2 using reg.xls, append
reg Effspreadwt B1 B2 B3 SumNumAcq  age gender majorecon riskaversion Period if urncomposition == 0, vce(cluster Session)
outreg2 using reg.xls, append
///no weighted spread
reg Quotedspread mkt SumNumAcq  age gender majorecon riskaversion Period if urncomposition == 0, vce(cluster Session)
outreg2 using reg.xls, replace
reg Quotedspread B1 B2 B3 SumNumAcq  age gender majorecon riskaversion Period if urncomposition == 0, vce(cluster Session)
outreg2 using reg.xls, append
reg Effspread mkt SumNumAcq  age gender majorecon riskaversion Period if urncomposition == 0, vce(cluster Session)
outreg2 using reg.xls, append
reg Effspread B1 B2 B3 SumNumAcq  age gender majorecon riskaversion Period if urncomposition == 0, vce(cluster Session)
outreg2 using reg.xls, append


//73
reg TotTrade mkt SumNumAcq  age gender majorecon riskaversion Period if urncomposition == 1, vce(cluster Session)
outreg2 using reg.xls, replace
reg TotTrade B1 B2 B3 SumNumAcq  age gender majorecon riskaversion Period if urncomposition ==1, vce(cluster Session)
outreg2 using reg.xls, append
reg TotLitTrade mkt SumNumAcq  age gender majorecon riskaversion Period if urncomposition == 1, vce(cluster Session)
outreg2 using reg.xls, append
reg TotLitTrade B1 B2 B3 SumNumAcq  age gender majorecon riskaversion Period if urncomposition == 1, vce(cluster Session)
outreg2 using reg.xls, append
reg Depth mkt SumNumAcq  age gender majorecon riskaversion Period if urncomposition == 1, vce(cluster Session)
outreg2 using reg.xls, append
reg Depth B1 B2 B3 SumNumAcq  age gender majorecon riskaversion Period if urncomposition == 1, vce(cluster Session)
outreg2 using reg.xls, append
///weighted spread
reg Quotedspreadwt mkt SumNumAcq  age gender majorecon riskaversion Period if urncomposition == 1, vce(cluster Session)
outreg2 using reg.xls, append
reg Quotedspreadwt B1 B2 B3 SumNumAcq  age gender majorecon riskaversion Period if urncomposition == 1, vce(cluster Session)
outreg2 using reg.xls, append
reg Effspreadwt mkt SumNumAcq  age gender majorecon riskaversion Period if urncomposition == 1, vce(cluster Session)
outreg2 using reg.xls, append
reg Effspreadwt B1 B2 B3 SumNumAcq  age gender majorecon riskaversion Period if urncomposition == 1, vce(cluster Session)
outreg2 using reg.xls, append
///no weighted spread
reg Quotedspread mkt SumNumAcq  age gender majorecon riskaversion Period if urncomposition == 1, vce(cluster Session)
outreg2 using reg.xls, replace
reg Quotedspread B1 B2 B3 SumNumAcq  age gender majorecon riskaversion Period if urncomposition == 1, vce(cluster Session)
outreg2 using reg.xls, append
reg Effspread mkt SumNumAcq  age gender majorecon riskaversion Period if urncomposition == 1, vce(cluster Session)
outreg2 using reg.xls, append
reg Effspread B1 B2 B3 SumNumAcq  age gender majorecon riskaversion Period if urncomposition == 1, vce(cluster Session)
outreg2 using reg.xls, append
///////////////////////////////////////////////////////////////////////////////////////////
merge 1:m Session Period using "C:\Users\yan006\Dropbox\Project with WANG YAN 2019\1ST PROJECT\DO and DTA Files\211028 summary\contractsandcontractdark.dta", keepusing(Quotedspreadwt Quotedspread)
keep in 1/480
drop _merge
merge 1:m Session Period using "C:\Users\yan006\Dropbox\Project with WANG YAN 2019\1ST PROJECT\DO and DTA Files\211028 summary\transaction.dta", keepusing(Effspreadwt Effspread)
keep in 1/480
drop _merge

/////////////////////////////////////////////////////////////////////////////////////////////////////
//#Table VII
use mktsummary.dta, replace
merge 1:m Session Period using "C:\Users\yan006\Dropbox\Project with WANG YAN 2019\1ST PROJECT\DO and DTA Files\211028 summary\contractsandcontractdark.dta", keepusing(litFR Totdarksubmission Totlitsubmission Totsubmission)
keep in 1/480
drop _merge
gen darkFR = TotDarkTrade/Totdarksubmission

reg litFR mkt SumNumAcq  age gender majorecon riskaversion Period if urncomposition == 0, vce(cluster Session)
outreg2 using reg.xls, replace

reg litFR B1 B2 B3 SumNumAcq age gender majorecon riskaversion Period if urncomposition == 0, vce(cluster Session)
outreg2 using reg.xls, append

reg litFR mkt SumNumAcq  age gender majorecon riskaversion Period if urncomposition == 1, vce(cluster Session)
outreg2 using reg.xls, append

reg litFR B1 B2 B3 SumNumAcq  age gender majorecon riskaversion Period if urncomposition == 1, vce(cluster Session)
outreg2 using reg.xls, append

reg darkFR darktraderatio SumNumAcq age gender majorecon riskaversion Period if urncomposition == 0, vce(cluster Session)
outreg2 using reg.xls, append

reg darkFR darktraderatio SumNumAcq age gender majorecon riskaversion Period if urncomposition == 1, vce(cluster Session)
outreg2 using reg.xls, append
/////////////////////////////////////////////////////////////////////////////////////////////////////
//#Table VIII
use mktsummary.dta, replace
merge 1:m Session Period using "C:\Users\yan006\Dropbox\Project with WANG YAN 2019\1ST PROJECT\DO and DTA Files\211028 summary\transactionandtransactiondark.dta", keepusing(avglitwaittime avgdarkwaittime)
keep in 1/480
drop _merge

reg avglitwaittime mkt SumNumAcq  age gender majorecon riskaversion Period if urncomposition == 0, vce(cluster Session)
outreg2 using reg.xls, replace

reg avglitwaittime B1 B2 B3 SumNumAcq age gender majorecon riskaversion Period if urncomposition == 0, vce(cluster Session)
outreg2 using reg.xls, append

reg avglitwaittime mkt SumNumAcq  age gender majorecon riskaversion Period if urncomposition == 1, vce(cluster Session)
outreg2 using reg.xls, append

reg avglitwaittime B1 B2 B3 SumNumAcq  age gender majorecon riskaversion Period if urncomposition == 1, vce(cluster Session)
outreg2 using reg.xls, append

reg avgdarkwaittime darktraderatio SumNumAcq age gender majorecon riskaversion Period if urncomposition == 0, vce(cluster Session)
outreg2 using reg.xls, append

reg avgdarkwaittime darktraderatio SumNumAcq age gender majorecon riskaversion Period if urncomposition == 1, vce(cluster Session)
outreg2 using reg.xls, append
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//#Figure 6 info-to-uninfo ratio
use mktsummary.dta, replace
merge 1:m Session Period using "C:\Users\yan006\Dropbox\Project with WANG YAN 2019\1ST PROJECT\DO and DTA Files\211028 summary\contractsandcontractdark.dta", keepusing(infolitsubmission infodarksubmission infototsubmission uninfolitsubmission uninfodarksubmission uninfototsubmission)
keep in 1/480
drop _merge
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
label define BB 0 `"{fontface "stSerif": Single lit}"' 1 `"{fontface "stSerif": [0, 20%)}"' 2 `"{fontface "stSerif": [20%, 40%)}"' 3 `"{fontface "stSerif":[40%, 100%]}"'
label values B BB

graph bar infolitsubmission uninfolitsubmission if urncomposition == 0, over(B, label(angle(45))) nofill stack percentage title({stSerif: Lit market}) ytitle({stSerif:ratio})  blabel(bar, format(%4.2f) position(center) size(small) color(white)) legend(label(1 `"{fontface "stSerif": Informed}"') label(2 `"{fontface "stSerif": Uninformed}"')) bar(4, bfcolor(gs3)) yscale(range(0 100)) graphregion(color(white)) name(a2,replace) ylabel(0 `"{fontface "stSerif": 0}"'10`"{fontface "stSerif": 10%}"' 20`"{fontface "stSerif": 20%}"' 30`"{fontface "stSerif": 30%}"'40`"{fontface "stSerif": 40%}"'50`"{fontface "stSerif": 50%}"'60`"{fontface "stSerif": 60%}"'70`"{fontface "stSerif": 70%}"'80`"{fontface "stSerif": 80%}"'90`"{fontface "stSerif": 90%}"'100 `"{fontface "stSerif": 100%}"', angle(0) valuelabel)

graph bar infodarksubmission uninfodarksubmission if urncomposition == 0 & mkt == 1, over(B, label(angle(45))) outergap(100) nofill stack percentage title({stSerif: Dark pool}) ytitle({stSerif:ratio})  blabel(bar, format(%4.2f) position(center) size(small) color(white)) legend(label(1 `"{fontface "stSerif": Informed}"') label(2 `"{fontface "stSerif": Uninformed}"')) bar(4, bfcolor(gs3)) yscale(range(0 100)) graphregion(color(white)) name(b2,replace) ylabel(0 `"{fontface "stSerif": 0}"'10`"{fontface "stSerif": 10%}"' 20`"{fontface "stSerif": 20%}"' 30`"{fontface "stSerif": 30%}"'40`"{fontface "stSerif": 40%}"'50`"{fontface "stSerif": 50%}"'60`"{fontface "stSerif": 60%}"'70`"{fontface "stSerif": 70%}"'80`"{fontface "stSerif": 80%}"'90`"{fontface "stSerif": 90%}"'100 `"{fontface "stSerif": 100%}"', angle(0) valuelabel)

grc1leg a2 b2, title({stSerif:Low precision}) legendfrom(a2) graphregion(color(white)) name (c)
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .title.draw_view.setstyle, style(no)

graph bar infolitsubmission uninfolitsubmission if urncomposition == 1, over(B, label(angle(45))) nofill stack percentage title({stSerif: Lit market}) ytitle({stSerif:ratio}) blabel(bar, format(%4.2f) position(center) size(small) color(white)) legend(label(1 `"{fontface "stSerif": Informed}"') label(2 `"{fontface "stSerif": Uninformed}"')) bar(4, bfcolor(gs3)) yscale(range(0 100)) graphregion(color(white)) name(a1,replace) ylabel(0 `"{fontface "stSerif": 0}"'10`"{fontface "stSerif": 10%}"' 20`"{fontface "stSerif": 20%}"' 30`"{fontface "stSerif": 30%}"'40`"{fontface "stSerif": 40%}"'50`"{fontface "stSerif": 50%}"'60`"{fontface "stSerif": 60%}"'70`"{fontface "stSerif": 70%}"'80`"{fontface "stSerif": 80%}"'90`"{fontface "stSerif": 90%}"'100 `"{fontface "stSerif": 100%}"', angle(0) valuelabel) 

graph bar infodarksubmission uninfodarksubmission if urncomposition == 1 & mkt == 1, over(B, label(angle(45))) outergap(100) nofill stack percentage title({stSerif: Dark pool}) ytitle({stSerif:ratio})  blabel(bar, format(%4.2f) position(center) size(small) color(white)) legend(label(1 `"{fontface "stSerif": Informed}"') label(2 `"{fontface "stSerif": Uninformed}"')) bar(4, bfcolor(gs3)) yscale(range(0 100)) graphregion(color(white)) name(b1,replace) ylabel(0 `"{fontface "stSerif": 0}"'10`"{fontface "stSerif": 10%}"' 20`"{fontface "stSerif": 20%}"' 30`"{fontface "stSerif": 30%}"'40`"{fontface "stSerif": 40%}"'50`"{fontface "stSerif": 50%}"'60`"{fontface "stSerif": 60%}"'70`"{fontface "stSerif": 70%}"'80`"{fontface "stSerif": 80%}"'90`"{fontface "stSerif": 90%}"'100 `"{fontface "stSerif": 100%}"', angle(0) valuelabel)


grc1leg a1 b1, title({stSerif:High precision}) legendfrom(a1) graphregion(color(white)) name (d)
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .title.draw_view.setstyle, style(no)

grc1leg c d, rows(1) title({stSerif:Informed-to-Uninformed ratio}) legendfrom(c) graphregion(color(white))
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .title.draw_view.setstyle, style(no)

gen infotouninforatiolit = infolitsubmission/uninfolitsubmission
gen infotouninforatiodark = infodarksubmission/uninfodarksubmission

tabstat infotouninforatiolit if urncomposition == 1, by(B)
tabstat infotouninforatiolit if urncomposition == 0, by(B)
ranksum infotouninforatiolit if urncomposition == 1, by(mkt)
ranksum infotouninforatiolit if urncomposition == 0, by(mkt)
signrank infotouninforatiolit = infotouninforatiodark if urncomposition == 1 & mkt == 1
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//#Figure 11 info-to-uninfo ratio
use mktsummary.dta, replace
merge 1:m Session Period using "C:\Users\yan006\Dropbox\Project with WANG YAN 2019\1ST PROJECT\DO and DTA Files\211028 summary\contractsandcontractdark.dta", keepusing(moderatelitsubmission moderatedarksubmission  moderatetotsubmission stronglitsubmission  strongdarksubmission strongtotsubmission )
keep in 1/480
drop _merge
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//#Figure 11-1 
graph pie infolitsubmission uninfolitsubmission if Treatment == 4, legend(order(1 `"{stSerif: Informed}"'  2 `"{stSerif: Uninformed}"') col(2)) legend(region(lwidth(none)) size(vsmall)) plabel(_all percent, format(%4.1f) color(white)) title({stSerif: Single lit_Low precision},size(small)) name(a1, replace)

graph pie infolitsubmission uninfolitsubmission if Treatment == 3, legend(order(1 `"{stSerif: Informed}"'  2 `"{stSerif: Uninformed}"') col(2)) legend(region(lwidth(none)) size(vsmall)) plabel(_all percent, format(%4.1f) color(white)) title({stSerif: Lit (Lit & dark)_Low precision},size(small)) name(a2, replace)

graph pie infodarksubmission uninfodarksubmission if Treatment == 3, legend(order(1 `"{stSerif: Informed}"'  2 `"{stSerif: Uninformed}"') col(2)) legend(region(lwidth(none)) size(vsmall)) plabel(_all percent, format(%4.1f) color(white)) title({stSerif: Dark (Lit & dark)_Low precision},size(small)) name(a3, replace)

graph pie infolitsubmission uninfolitsubmission if Treatment == 2, legend(order(1 `"{stSerif: Informed}"'  2 `"{stSerif: Uninformed}"') col(2)) legend(region(lwidth(none)) size(vsmall)) plabel(_all percent, format(%4.1f) color(white)) title({stSerif: Single lit_High precision},size(small)) name(a4, replace)

graph pie infolitsubmission uninfolitsubmission if Treatment == 1, legend(order(1 `"{stSerif: Informed}"'  2 `"{stSerif: Uninformed}"') col(2)) legend(region(lwidth(none)) size(vsmall)) plabel(_all percent, format(%4.1f) color(white)) title({stSerif: Lit (Lit & dark)_High precision},size(small)) name(a5, replace)

graph pie infodarksubmission uninfodarksubmission if Treatment == 1, legend(order(1 `"{stSerif: Informed}"'  2 `"{stSerif: Uninformed}"') col(2)) legend(region(lwidth(none)) size(vsmall)) plabel(_all percent, format(%4.1f) color(white)) title({stSerif: Dark (Lit & dark)_High precision},size(small)) name(a6, replace)

grc1leg a1 a2 a3 a4 a5 a6, title({stSerif:Order submission composition}) legendfrom(a1) graphregion(color(white))
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//#Figure 11-2 
graph pie infolitsubmission uninfolitsubmission if Treatment == 3 & B == 1, legend(order(1 `"{stSerif: Informed}"'  2 `"{stSerif: Uninformed}"') col(2)) legend(region(lwidth(none)) size(vsmall)) plabel(_all percent, format(%4.1f) color(white)) title({stSerif: Lit (Dark < 20%)_Low precision}, size(small)) name(b1, replace)

graph pie infolitsubmission uninfolitsubmission if Treatment == 3 & B == 2, legend(order(1 `"{stSerif: Informed}"'  2 `"{stSerif: Uninformed}"') col(2)) legend(region(lwidth(none)) size(vsmall)) plabel(_all percent, format(%4.1f) color(white)) title({stSerif: Lit (20% <= Dark < 40%)_Low precision},size(small)) name(b2, replace)

graph pie infolitsubmission uninfolitsubmission if Treatment == 3 & B == 3, legend(order(1 `"{stSerif: Informed}"'  2 `"{stSerif: Uninformed}"') col(2)) legend(region(lwidth(none)) size(vsmall)) plabel(_all percent, format(%4.1f) color(white)) title({stSerif: Lit (Dark >= 40%)_Low precision},size(small)) name(b3, replace)

graph pie infodarksubmission uninfodarksubmission if Treatment == 3 & B == 1, legend(order(1 `"{stSerif: Informed}"'  2 `"{stSerif: Uninformed}"') col(2)) legend(region(lwidth(none)) size(vsmall)) plabel(_all percent, format(%4.1f) color(white)) title({stSerif: Dark (Dark < 20%)_Low precision},size(small)) name(b4, replace)

graph pie infodarksubmission uninfodarksubmission if Treatment == 3 & B == 2, legend(order(1 `"{stSerif: Informed}"'  2 `"{stSerif: Uninformed}"') col(2)) legend(region(lwidth(none)) size(vsmall)) plabel(_all percent, format(%4.1f) color(white)) title({stSerif: Dark (20% <= Dark < 40%)_Low precision},size(small)) name(b5, replace)

graph pie infodarksubmission uninfodarksubmission if Treatment == 3 & B == 3, legend(order(1 `"{stSerif: Informed}"'  2 `"{stSerif: Uninformed}"') col(2)) legend(region(lwidth(none)) size(vsmall)) plabel(_all percent, format(%4.1f) color(white)) title({stSerif: Dark (Dark >= 40%)_Low precision}, size(small)) name(b6, replace)

grc1leg b1 b2 b3 b4 b5 b6, title({stSerif:Order submission composition_Low precision (Lit & Dark)}) legendfrom(b1) graphregion(color(white))
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//#Figure 11-3
graph pie infolitsubmission uninfolitsubmission if Treatment == 1 & B == 1, legend(order(1 `"{stSerif: Informed}"'  2 `"{stSerif: Uninformed}"') col(2)) legend(region(lwidth(none)) size(vsmall)) plabel(_all percent, format(%4.1f) color(white)) title({stSerif: Lit (Dark < 20%)_High precision}, size(small)) name(c1, replace)

graph pie infolitsubmission uninfolitsubmission if Treatment == 1 & B == 2, legend(order(1 `"{stSerif: Informed}"'  2 `"{stSerif: Uninformed}"') col(2)) legend(region(lwidth(none)) size(vsmall)) plabel(_all percent, format(%4.1f) color(white)) title({stSerif: Lit (20% <= Dark < 40%)_High precision},size(small)) name(c2, replace)

graph pie infolitsubmission uninfolitsubmission if Treatment == 1 & B == 3, legend(order(1 `"{stSerif: Informed}"'  2 `"{stSerif: Uninformed}"') col(2)) legend(region(lwidth(none)) size(vsmall)) plabel(_all percent, format(%4.1f) color(white)) title({stSerif: Lit (Dark >= 40%)_High precision},size(small)) name(c3, replace)

graph pie infodarksubmission uninfodarksubmission if Treatment == 1 & B == 1, legend(order(1 `"{stSerif: Informed}"'  2 `"{stSerif: Uninformed}"') col(2)) legend(region(lwidth(none)) size(vsmall)) plabel(_all percent, format(%4.1f) color(white)) title({stSerif: Dark (Dark < 20%)_High precision},size(small)) name(c4, replace)

graph pie infodarksubmission uninfodarksubmission if Treatment == 1 & B == 2, legend(order(1 `"{stSerif: Informed}"'  2 `"{stSerif: Uninformed}"') col(2)) legend(region(lwidth(none)) size(vsmall)) plabel(_all percent, format(%4.1f) color(white)) title({stSerif: Dark (20% <= Dark < 40%)_High precision},size(small)) name(c5, replace)

graph pie infodarksubmission uninfodarksubmission if Treatment == 1 & B == 3, legend(order(1 `"{stSerif: Informed}"'  2 `"{stSerif: Uninformed}"') col(2)) legend(region(lwidth(none)) size(vsmall)) plabel(_all percent, format(%4.1f) color(white)) title({stSerif: Dark (Dark >= 40%)_High precision}, size(small)) name(c6, replace)

grc1leg c1 c2 c3 c4 c5 c6, title({stSerif:Order submission composition_High precision (Lit & Dark)}) legendfrom(c1) graphregion(color(white))
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//#Figure 11-4 
graph pie moderatelitsubmission stronglitsubmission uninfolitsubmission if Treatment == 4, legend(order(1 `"{stSerif: Moderately informed}"'  2 `"{stSerif: Strongly informed}"'  3 `"{stSerif: Uninformed}"') col(2)) legend(region(lwidth(none)) size(vsmall)) plabel(_all percent, format(%4.1f) color(white)) title({stSerif: Single lit_Low precision},size(small)) name(a1, replace)

graph pie moderatelitsubmission stronglitsubmission uninfolitsubmission if Treatment == 3, legend(order(1 `"{stSerif: Moderately informed}"'  2 `"{stSerif: Strongly informed}"'  3 `"{stSerif: Uninformed}"') col(2)) legend(region(lwidth(none)) size(vsmall)) plabel(_all percent, format(%4.1f) color(white)) title({stSerif: Lit (Lit & dark)_Low precision},size(small)) name(a2, replace)

graph pie moderatedarksubmission strongdarksubmission uninfodarksubmission if Treatment == 3, legend(order(1 `"{stSerif: Moderately informed}"'  2 `"{stSerif: Strongly informed}"'  3 `"{stSerif: Uninformed}"') col(2)) legend(region(lwidth(none)) size(vsmall)) plabel(_all percent, format(%4.1f) color(white)) title({stSerif: Dark (Lit & dark)_Low precision},size(small)) name(a3, replace)

graph pie moderatelitsubmission stronglitsubmission uninfolitsubmission if Treatment == 2, legend(order(1 `"{stSerif: Moderately informed}"'  2 `"{stSerif: Strongly informed}"'  3 `"{stSerif: Uninformed}"') col(2)) legend(region(lwidth(none)) size(vsmall)) plabel(_all percent, format(%4.1f) color(white)) title({stSerif: Single lit_High precision},size(small)) name(a4, replace)

graph pie moderatelitsubmission stronglitsubmission uninfolitsubmission if Treatment == 1, legend(order(1 `"{stSerif: Moderately informed}"'  2 `"{stSerif: Strongly informed}"'  3 `"{stSerif: Uninformed}"') col(2)) legend(region(lwidth(none)) size(vsmall)) plabel(_all percent, format(%4.1f) color(white)) title({stSerif: Lit (Lit & dark)_High precision},size(small)) name(a5, replace)

graph pie moderatedarksubmission strongdarksubmission uninfodarksubmission if Treatment == 1, legend(order(1 `"{stSerif: Moderately informed}"'  2 `"{stSerif: Strongly informed}"'  3 `"{stSerif: Uninformed}"') col(2)) legend(region(lwidth(none)) size(vsmall)) plabel(_all percent, format(%4.1f) color(white)) title({stSerif: Dark (Lit & dark)_High precision},size(small)) name(a6, replace)

grc1leg a1 a2 a3 a4 a5 a6, title({stSerif:Order submission composition}) legendfrom(a1) graphregion(color(white))
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//#Figure 11-5
graph pie moderatelitsubmission stronglitsubmission uninfolitsubmission if Treatment == 3 & B == 1, legend(order(1 `"{stSerif: Moderately informed}"'  2 `"{stSerif: Strongly informed}"'  3 `"{stSerif: Uninformed}"') col(2)) legend(region(lwidth(none)) size(vsmall)) plabel(_all percent, format(%4.1f) color(white)) title({stSerif: Lit (Dark < 20%)_Low precision}, size(small)) name(b1, replace)

graph pie moderatelitsubmission stronglitsubmission uninfolitsubmission if Treatment == 3 & B == 2, legend(order(1 `"{stSerif: Moderately informed}"'  2 `"{stSerif: Strongly informed}"'  3 `"{stSerif: Uninformed}"') col(2)) legend(region(lwidth(none)) size(vsmall)) plabel(_all percent, format(%4.1f) color(white)) title({stSerif: Lit (20% <= Dark < 40%)_Low precision},size(small)) name(b2, replace)

graph pie moderatelitsubmission stronglitsubmission uninfolitsubmission if Treatment == 3 & B == 3, legend(order(1 `"{stSerif: Moderately informed}"'  2 `"{stSerif: Strongly informed}"'  3 `"{stSerif: Uninformed}"') col(2)) legend(region(lwidth(none)) size(vsmall)) plabel(_all percent, format(%4.1f) color(white)) title({stSerif: Lit (Dark >= 40%)_Low precision},size(small)) name(b3, replace)

graph pie moderatedarksubmission strongdarksubmission uninfodarksubmission if Treatment == 3 & B == 1, legend(order(1 `"{stSerif: Moderately informed}"'  2 `"{stSerif: Strongly informed}"'  3 `"{stSerif: Uninformed}"') col(2)) legend(region(lwidth(none)) size(vsmall)) plabel(_all percent, format(%4.1f) color(white)) title({stSerif: Dark (Dark < 20%)_Low precision},size(small)) name(b4, replace)

graph pie moderatedarksubmission strongdarksubmission uninfodarksubmission if Treatment == 3 & B == 2, legend(order(1 `"{stSerif: Moderately informed}"'  2 `"{stSerif: Strongly informed}"'  3 `"{stSerif: Uninformed}"') col(2)) legend(region(lwidth(none)) size(vsmall)) plabel(_all percent, format(%4.1f) color(white)) title({stSerif: Dark (20% <= Dark < 40%)_Low precision},size(small)) name(b5, replace)

graph pie moderatedarksubmission strongdarksubmission uninfodarksubmission if Treatment == 3 & B == 3, legend(order(1 `"{stSerif: Moderately informed}"'  2 `"{stSerif: Strongly informed}"'  3 `"{stSerif: Uninformed}"') col(2)) legend(region(lwidth(none)) size(vsmall)) plabel(_all percent, format(%4.1f) color(white)) title({stSerif: Dark (Dark >= 40%)_Low precision}, size(small)) name(b6, replace)

grc1leg b1 b2 b3 b4 b5 b6, title({stSerif:Order submission composition_Low precision (Lit & Dark)}) legendfrom(b1) graphregion(color(white))
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//#Figure 11-6
graph pie moderatelitsubmission stronglitsubmission uninfolitsubmission if Treatment == 1 & B == 1, legend(order(1 `"{stSerif: Moderately informed}"'  2 `"{stSerif: Strongly informed}"'  3 `"{stSerif: Uninformed}"') col(2)) legend(region(lwidth(none)) size(vsmall)) plabel(_all percent, format(%4.1f) color(white)) title({stSerif: Lit (Dark < 20%)_High precision}, size(small)) name(c1, replace)

graph pie moderatelitsubmission stronglitsubmission uninfolitsubmission if Treatment == 1 & B == 2, legend(order(1 `"{stSerif: Moderately informed}"'  2 `"{stSerif: Strongly informed}"'  3 `"{stSerif: Uninformed}"') col(2)) legend(region(lwidth(none)) size(vsmall)) plabel(_all percent, format(%4.1f) color(white)) title({stSerif: Lit (20% <= Dark < 40%)_High precision},size(small)) name(c2, replace)

graph pie moderatelitsubmission stronglitsubmission uninfolitsubmission if Treatment == 1 & B == 3, legend(order(1 `"{stSerif: Moderately informed}"'  2 `"{stSerif: Strongly informed}"'  3 `"{stSerif: Uninformed}"') col(2)) legend(region(lwidth(none)) size(vsmall)) plabel(_all percent, format(%4.1f) color(white)) title({stSerif: Lit (Dark >= 40%)_High precision},size(small)) name(c3, replace)

graph pie moderatedarksubmission strongdarksubmission uninfodarksubmission if Treatment == 1 & B == 1, legend(order(1 `"{stSerif: Moderately informed}"'  2 `"{stSerif: Strongly informed}"'  3 `"{stSerif: Uninformed}"') col(2)) legend(region(lwidth(none)) size(vsmall)) plabel(_all percent, format(%4.1f) color(white)) title({stSerif: Dark (Dark < 20%)_High precision},size(small)) name(c4, replace)

graph pie moderatedarksubmission strongdarksubmission uninfodarksubmission if Treatment == 1 & B == 2, legend(order(1 `"{stSerif: Moderately informed}"'  2 `"{stSerif: Strongly informed}"'  3 `"{stSerif: Uninformed}"') col(2)) legend(region(lwidth(none)) size(vsmall)) plabel(_all percent, format(%4.1f) color(white)) title({stSerif: Dark (20% <= Dark < 40%)_High precision},size(small)) name(c5, replace)

graph pie moderatedarksubmission strongdarksubmission uninfodarksubmission if Treatment == 1 & B == 3, legend(order(1 `"{stSerif: Moderately informed}"'  2 `"{stSerif: Strongly informed}"'  3 `"{stSerif: Uninformed}"') col(2)) legend(region(lwidth(none)) size(vsmall)) plabel(_all percent, format(%4.1f) color(white)) title({stSerif: Dark (Dark >= 40%)_High precision}, size(small)) name(c6, replace)

grc1leg c1 c2 c3 c4 c5 c6, title({stSerif:Order submission composition_High precision (Lit & Dark)}) legendfrom(c1) graphregion(color(white))
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//#Table XI submission/execution, orders and order size/////////////////////
//////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
use mktsummary.dta, replace

merge 1:m Session Period using "C:\Users\yan006\Dropbox\Project with WANG YAN 2019\1ST PROJECT\DO and DTA Files\211028 summary\contractsandcontractdark.dta", keepusing(Totdarksubmission Totlitsubmission Totsubmission)
keep in 1/480
drop _merge

merge 1:m Session Period using "C:\Users\yan006\Dropbox\Project with WANG YAN 2019\1ST PROJECT\DO and DTA Files\211028 summary\contractsandcontractdark.dta", keepusing(Totdarksubmissionnum Totlitsubmissionnum Totsubmissionnum Totdarksubmissionsize Totlitsubmissionsize Totsubmissionsize)
keep in 1/480
drop _merge

merge 1:m Session Period using "C:\Users\yan006\Dropbox\Project with WANG YAN 2019\1ST PROJECT\DO and DTA Files\211028 summary\transactionandtransactiondark.dta", keepusing(Totdarktradesize Totlittradesize Tottradesize)
keep in 1/480
drop _merge

drop Totdarksubmission Totlitsubmission Totsubmission
merge 1:m Session Period using "C:\Users\yan006\Dropbox\Project with WANG YAN 2019\1ST PROJECT\DO and DTA Files\211028 summary\contractsandcontractdarkwithinitialvolume.dta", keepusing(Totdarksubmission Totlitsubmission Totsubmission Totdarksubmissionnum Totlitsubmissionnum Totsubmissionnum Totdarksubmissionsize Totlitsubmissionsize Totsubmissionsize)
keep in 1/480
drop _merge
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
tabstat Totlitsubmission if urncomposition == 0, by(mkt) stat(mean sd min max n)
tabstat Totlitsubmission if urncomposition == 1, by(mkt) stat(mean sd min max n)

tabstat Totdarksubmission if urncomposition == 0, by(mkt) stat(mean sd min max n)
tabstat Totdarksubmission if urncomposition == 1, by(mkt) stat(mean sd min max n)

tabstat Totsubmission if urncomposition == 0, by(mkt) stat(mean sd min max n)
tabstat Totsubmission if urncomposition == 1, by(mkt) stat(mean sd min max n)

ranksum Totlitsubmission if urncomposition == 0, by(mkt)
ranksum Totlitsubmission if urncomposition == 1, by(mkt) 

ranksum Totsubmission if urncomposition == 0, by(mkt)
ranksum Totsubmission if urncomposition == 1, by(mkt)

//////////////////////////////////////////////////////////
tabstat TotLitTrade if urncomposition == 0, by(mkt) stat(mean sd min max n)
tabstat TotLitTrade if urncomposition == 1, by(mkt) stat(mean sd min max n)

tabstat TotDarkTrade if urncomposition == 0, by(mkt) stat(mean sd min max n)
tabstat TotDarkTrade if urncomposition == 1, by(mkt) stat(mean sd min max n)

tabstat TotTrade if urncomposition == 0, by(mkt) stat(mean sd min max n)
tabstat TotTrade if urncomposition == 1, by(mkt) stat(mean sd min max n)

ranksum TotLitTrade if urncomposition == 0, by(mkt)
ranksum TotLitTrade if urncomposition == 1, by(mkt) 

ranksum TotTrade if urncomposition == 0, by(mkt)
ranksum TotTrade if urncomposition == 1, by(mkt)
////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
tabstat Totlitsubmissionnum if urncomposition == 0, by(mkt) stat(mean sd min max n)
tabstat Totlitsubmissionnum if urncomposition == 1, by(mkt) stat(mean sd min max n)

tabstat Totdarksubmissionnum if urncomposition == 0, by(mkt) stat(mean sd min max n)
tabstat Totdarksubmissionnum if urncomposition == 1, by(mkt) stat(mean sd min max n)

tabstat Totsubmissionnum if urncomposition == 0, by(mkt) stat(mean sd min max n)
tabstat Totsubmissionnum if urncomposition == 1, by(mkt) stat(mean sd min max n)

ranksum Totlitsubmissionnum if urncomposition == 0, by(mkt)
ranksum Totlitsubmissionnum if urncomposition == 1, by(mkt) 

ranksum Totsubmissionnum if urncomposition == 0, by(mkt)
ranksum Totsubmissionnum if urncomposition == 1, by(mkt)
//////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
tabstat TotLitTradeNum if urncomposition == 0, by(mkt) stat(mean sd min max n)
tabstat TotLitTradeNum if urncomposition == 1, by(mkt) stat(mean sd min max n)

tabstat TotDarkTradeNum if urncomposition == 0, by(mkt) stat(mean sd min max n)
tabstat TotDarkTradeNum if urncomposition == 1, by(mkt) stat(mean sd min max n)

tabstat TotTradeNum if urncomposition == 0, by(mkt) stat(mean sd min max n)
tabstat TotTradeNum if urncomposition == 1, by(mkt) stat(mean sd min max n)

ranksum TotLitTradeNum if urncomposition == 0, by(mkt)
ranksum TotLitTradeNum if urncomposition == 1, by(mkt) 

ranksum TotTradeNum if urncomposition == 0, by(mkt)
ranksum TotTradeNum if urncomposition == 1, by(mkt)
//////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
tabstat Totlitsubmissionsize if urncomposition == 0, by(mkt) stat(mean sd min max n)
tabstat Totlitsubmissionsize if urncomposition == 1, by(mkt) stat(mean sd min max n)

tabstat Totdarksubmissionsize if urncomposition == 0, by(mkt) stat(mean sd min max n)
tabstat Totdarksubmissionsize if urncomposition == 1, by(mkt) stat(mean sd min max n)

tabstat Totsubmissionsize if urncomposition == 0, by(mkt) stat(mean sd min max n)
tabstat Totsubmissionsize if urncomposition == 1, by(mkt) stat(mean sd min max n)

ranksum Totlitsubmissionsize if urncomposition == 0, by(mkt)
ranksum Totlitsubmissionsize if urncomposition == 1, by(mkt) 

ranksum Totsubmissionsize if urncomposition == 0, by(mkt)
ranksum Totsubmissionsize if urncomposition == 1, by(mkt)
//////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
tabstat Totlittradesize if urncomposition == 0, by(mkt) stat(mean sd min max n)
tabstat Totlittradesize if urncomposition == 1, by(mkt) stat(mean sd min max n)

tabstat Totdarktradesize if urncomposition == 0, by(mkt) stat(mean sd min max n)
tabstat Totdarktradesize if urncomposition == 1, by(mkt) stat(mean sd min max n)

tabstat Tottradesize if urncomposition == 0, by(mkt) stat(mean sd min max n)
tabstat Tottradesize if urncomposition == 1, by(mkt) stat(mean sd min max n)

ranksum Totlittradesize if urncomposition == 0, by(mkt)
ranksum Totlittradesize if urncomposition == 1, by(mkt) 

ranksum Tottradesize if urncomposition == 0, by(mkt)
ranksum Tottradesize if urncomposition == 1, by(mkt)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//#Figure 8 order size 
use mktsummary.dta, replace

collapse (mean) meantransactionsize = Tottradesize (sd) sdtransactionsize=Tottradesize (count) n1 = Tottradesize (mean) meanlittransactionsize= Totlittradesize (sd) sdlittransactionsize=Totlittradesize (count) n2 = Totlittradesize (mean) meanoffersize= Totsubmissionsize (sd) sdoffersize=Totsubmissionsize (count) n3 = Totsubmissionsize (mean) meanlitoffersize= Totlitsubmissionsize (sd) sdlitoffersize=Totlitsubmissionsize (count) n4 = Totlitsubmissionsize, by(urncomposition mkt)

gen hightransactionsize = meantransactionsize + invttail(n1-1,0.025)*(sdtransactionsize/sqrt(n1))
gen lowtransactionsize = meantransactionsize - invttail(n1-1,0.025)*(sdtransactionsize/sqrt(n1))
gen highlittransactionsize = meanlittransactionsize + invttail(n2-1,0.025)*(sdlittransactionsize/sqrt(n2))
gen lowlittransactionsize = meanlittransactionsize - invttail(n2-1,0.025)*(sdlittransactionsize/sqrt(n2))
gen highoffersize = meanoffersize + invttail(n3-1,0.025)*(sdoffersize/sqrt(n3))
gen lowoffersize = meanoffersize - invttail(n3-1,0.025)*(sdoffersize/sqrt(n3))
gen highlitoffersize = meanlitoffersize + invttail(n4-1,0.025)*(sdlitoffersize/sqrt(n4))
gen lowlitoffersize = meanlitoffersize - invttail(n4-1,0.025)*(sdlitoffersize/sqrt(n4))

gen mkturncomposition = 0

twoway (bar meanoffersize mkt if mkt == 0, barwidth(.4)) (bar meanoffersize mkt if mkt == 1, barwidth(.4)) (rcap highoffersize lowoffersize mkt, color(black)) if urncomposition ==0, legend(off) title({stSerif:Low precision (overall)},size(small)) ytitle({stSerif: submitted order size},size(small)) yscale(range(9 18)) graphregion(color(white)) name(a,replace) xlabel( 0 `"{fontface "stSerif": Single lit}"' 1 `"{fontface "stSerif": Lit & dark}"' , noticks) xtitle({stSerif: Market})ylabel( 9 `"{fontface "stSerif": 9}"' 12 `"{fontface "stSerif": 12}"'15`"{fontface "stSerif": 15}"'18`"{fontface "stSerif": 18}"', angle(0) valuelabel)

twoway (bar meanoffersize mkt if mkt == 0, barwidth(.4)) (bar meanoffersize mkt if mkt == 1, barwidth(.4)) (rcap highoffersize lowoffersize mkt, color(black)) if urncomposition ==1, legend(off) title({stSerif: High precision (overall)},size(small)) ytitle({stSerif: submitted order size},size(small)) yscale(range(9 18)) graphregion(color(white)) name(b,replace) xlabel( 0 `"{fontface "stSerif": Single lit}"' 1 `"{fontface "stSerif": Lit & dark}"' , noticks) xtitle({stSerif: Market})ylabel( 9 `"{fontface "stSerif": 9}"' 12 `"{fontface "stSerif": 12}"'15`"{fontface "stSerif": 15}"'18`"{fontface "stSerif": 18}"', angle(0) valuelabel)

twoway (bar meanlitoffersize mkt if mkt == 0, barwidth(.4)) (bar meanlitoffersize mkt if mkt == 1, barwidth(.4)) (rcap highlitoffersize lowlitoffersize mkt, color(black)) if urncomposition ==0, legend(off) title({stSerif: Low precision (lit market)},size(small)) ytitle({stSerif: submitted order size},size(small)) yscale(range(9 18)) graphregion(color(white)) name(c,replace) xlabel( 0 `"{fontface "stSerif": Single lit}"' 1 `"{fontface "stSerif": Lit & dark}"' , noticks) xtitle({stSerif: Market})ylabel( 9 `"{fontface "stSerif": 9}"' 12 `"{fontface "stSerif": 12}"'15`"{fontface "stSerif": 15}"'18`"{fontface "stSerif": 18}"', angle(0) valuelabel)

twoway (bar meanlitoffersize mkt if mkt == 0, barwidth(.4)) (bar meanlitoffersize mkt if mkt == 1, barwidth(.4)) (rcap highlitoffersize lowlitoffersize mkt, color(black)) if urncomposition ==1, legend(off) title({stSerif: High precision (lit market)},size(small)) ytitle({stSerif: submitted order size},size(small)) yscale(range(9 18)) graphregion(color(white)) name(d,replace) xlabel( 0 `"{fontface "stSerif": Single lit}"' 1 `"{fontface "stSerif": Lit & dark}"' , noticks) xtitle({stSerif: Market})ylabel( 9 `"{fontface "stSerif": 9}"' 12 `"{fontface "stSerif": 12}"'15`"{fontface "stSerif": 15}"'18`"{fontface "stSerif": 18}"', angle(0) valuelabel)

grc1leg a b c d, rows(1) title({stSerif: Submitted order size},size(medium)) legendfrom(a) graphregion(color(white))
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .title.draw_view.setstyle, style(no)


twoway (bar meantransactionsize mkt if mkt == 0, barwidth(.4)) (bar meantransactionsize mkt if mkt == 1, barwidth(.4))(rcap hightransactionsize lowtransactionsize mkt, color(black)) if urncomposition ==0, legend(off) title({stSerif: Low precision (overall)},size(small)) xtitle({stSerif: Market}) ytitle({stSerif: transacted order size},size(small)) yscale(range(6 12)) graphregion(color(white)) name(a,replace) xlabel( 0 `"{fontface "stSerif": Single lit}"' 1 `"{fontface "stSerif": Lit & dark}"' , noticks) ylabel( 6 `"{fontface "stSerif": 6}"' 8 `"{fontface "stSerif": 8}"' 10 `"{fontface "stSerif": 10}"' 12 `"{fontface "stSerif": 12}"', angle(0) valuelabel)

twoway (bar meantransactionsize mkt if mkt == 0, barwidth(.4)) (bar meantransactionsize mkt if mkt == 1, barwidth(.4)) (rcap hightransactionsize lowtransactionsize mkt, color(black)) if urncomposition ==1, legend(off) title({stSerif: High precision (overall)},size(small)) ytitle({stSerif: transacted order size},size(small)) yscale(range(6 12)) graphregion(color(white)) name(b,replace) xlabel( 0 `"{fontface "stSerif": Single lit}"' 1 `"{fontface "stSerif": Lit & dark}"' , noticks) xtitle({stSerif: Market})ylabel( 6 `"{fontface "stSerif": 6}"' 8 `"{fontface "stSerif": 8}"' 10 `"{fontface "stSerif": 10}"' 12 `"{fontface "stSerif": 12}"', angle(0) valuelabel)


twoway (bar meanlittransactionsize mkt if mkt == 0, barwidth(.4)) (bar meanlittransactionsize mkt if mkt == 1, barwidth(.4))(rcap highlittransactionsize lowlittransactionsize mkt, color(black)) if urncomposition ==0, legend(off) title({stSerif:Low precision (lit market)},size(small)) ytitle({stSerif: transacted order size},size(small)) yscale(range(6 12)) graphregion(color(white)) name(c,replace) xlabel( 0 `"{fontface "stSerif": Single lit}"' 1 `"{fontface "stSerif": Lit & dark}"' , noticks) xtitle({stSerif: Market})ylabel( 6 `"{fontface "stSerif": 6}"' 8 `"{fontface "stSerif": 8}"' 10 `"{fontface "stSerif": 10}"' 12 `"{fontface "stSerif": 12}"', angle(0) valuelabel)

twoway (bar meanlittransactionsize mkt if mkt == 0, barwidth(.4)) (bar meanlittransactionsize mkt if mkt == 1, barwidth(.4)) (rcap highlittransactionsize lowlittransactionsize mkt, color(black)) if urncomposition ==1, legend(off) title({stSerif: High precision (lit market)},size(small)) ytitle({stSerif: transacted order size},size(small)) yscale(range(6 12)) graphregion(color(white)) name(d,replace) xlabel( 0 `"{fontface "stSerif": Single lit}"' 1 `"{fontface "stSerif": Lit & dark}"', noticks) xtitle({stSerif: Market})ylabel( 6 `"{fontface "stSerif": 6}"' 8 `"{fontface "stSerif": 8}"' 10 `"{fontface "stSerif": 10}"' 12 `"{fontface "stSerif": 12}"', angle(0) valuelabel)

grc1leg a b c d,  rows(1) title({stSerif: Transacted order size},size(medium)) legendfrom(a) graphregion(color(white))

gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .title.draw_view.setstyle, style(no)

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
use mktsummary.dta, replace

collapse (mean) meantransactionsize = Tottradesize (sd) sdtransactionsize=Tottradesize (count) n1 = Tottradesize (mean) meanlittransactionsize= Totlittradesize (sd) sdlittransactionsize=Totlittradesize (count) n2 = Totlittradesize (mean) meanoffersize= Totsubmissionsize (sd) sdoffersize=Totsubmissionsize (count) n3 = Totsubmissionsize (mean) meanlitoffersize= Totlitsubmissionsize (sd) sdlitoffersize=Totlitsubmissionsize (count) n4 = Totlitsubmissionsize, by(urncomposition mkt)

gen hightransactionsize = meantransactionsize + invttail(n1-1,0.025)*(sdtransactionsize/sqrt(n1))
gen lowtransactionsize = meantransactionsize - invttail(n1-1,0.025)*(sdtransactionsize/sqrt(n1))
gen highlittransactionsize = meanlittransactionsize + invttail(n2-1,0.025)*(sdlittransactionsize/sqrt(n2))
gen lowlittransactionsize = meanlittransactionsize - invttail(n2-1,0.025)*(sdlittransactionsize/sqrt(n2))
gen highoffersize = meanoffersize + invttail(n3-1,0.025)*(sdoffersize/sqrt(n3))
gen lowoffersize = meanoffersize - invttail(n3-1,0.025)*(sdoffersize/sqrt(n3))
gen highlitoffersize = meanlitoffersize + invttail(n4-1,0.025)*(sdlitoffersize/sqrt(n4))
gen lowlitoffersize = meanlitoffersize - invttail(n4-1,0.025)*(sdlitoffersize/sqrt(n4))

gen mkturncomposition = 0
replace mkturncomposition = urncomposition - 0.2 if mkt == 0
replace mkturncomposition = urncomposition + 0.2 if mkt == 1

gen singlelitoffersize = meanoffersize if mkt == 0
gen litdarkoffersize = meanoffersize if mkt == 1
gen singlelitlitoffersize = meanlitoffersize if mkt == 0
gen litdarklitoffersize = meanlitoffersize if mkt == 1

gen singlelittransactionsize = meantransactionsize if mkt == 0
gen litdarktransactionsize = meantransactionsize if mkt == 1
gen singlelitlittransactionsize = meanlittransactionsize if mkt == 0
gen litdarklittransactionsize = meanlittransactionsize if mkt == 1

twoway (bar singlelitoffersize mkturncomposition, barwidth(.4)) (bar litdarkoffersize mkturncomposition, barwidth(.4)) (rcap highoffersize lowoffersize mkturncomposition, color(black)), title({stSerif:Overall market},size(medium)) ytitle({stSerif: submitted order size},size(medium)) yscale(range(9 18)) graphregion(color(white)) name(a,replace) xlabel( 0 `"{fontface "stSerif": Low precision}"' 1 `"{fontface "stSerif": High precicsion}"' , noticks) xtitle("") legend(order(1 2) label(1 `"{fontface "stSerif": Single lit}"') label(2 `"{fontface "stSerif": Lit & dark}"')) ylabel( 9 `"{fontface "stSerif": 9}"' 12 `"{fontface "stSerif": 12}"'15`"{fontface "stSerif": 15}"'18`"{fontface "stSerif": 18}"', angle(0) valuelabel)

twoway (bar singlelitlitoffersize mkturncomposition, barwidth(.4)) (bar litdarklitoffersize mkturncomposition, barwidth(.4)) (rcap highlitoffersize lowlitoffersize mkturncomposition, color(black)), title({stSerif:Lit market},size(medium)) ytitle({stSerif: submitted order size},size(medium)) yscale(range(9 18)) graphregion(color(white)) name(b,replace) xlabel( 0 `"{fontface "stSerif": Low precision}"' 1 `"{fontface "stSerif": High precicsion}"' , noticks) xtitle("") legend(order(1 2) label(1 `"{fontface "stSerif": Single lit}"') label(2 `"{fontface "stSerif": Lit & dark}"')) ylabel( 9 `"{fontface "stSerif": 9}"' 12 `"{fontface "stSerif": 12}"'15`"{fontface "stSerif": 15}"'18`"{fontface "stSerif": 18}"', angle(0) valuelabel)

grc1leg a b, rows(1) title({stSerif: Submitted order size},size(medium)) legendfrom(a) graphregion(color(white))
gr_edit .title.draw_view.setstyle, style(no)
gr_edit .legend.draw_view.setstyle, style(no)

twoway (bar singlelittransactionsize mkturncomposition, barwidth(.4)) (bar litdarktransactionsize mkturncomposition, barwidth(.4)) (rcap hightransactionsize lowtransactionsize mkturncomposition, color(black)), title({stSerif:Overall market},size(medium)) ytitle({stSerif: transacted order size},size(medium)) yscale(range(6 12)) graphregion(color(white)) name(c,replace) xlabel( 0 `"{fontface "stSerif": Low precision}"' 1 `"{fontface "stSerif": High precicsion}"' , noticks) xtitle("") legend(order(1 2) label(1 `"{fontface "stSerif": Single lit}"') label(2 `"{fontface "stSerif": Lit & dark}"')) ylabel( 6 `"{fontface "stSerif": 6}"' 8 `"{fontface "stSerif": 8}"' 10 `"{fontface "stSerif": 10}"' 12 `"{fontface "stSerif": 12}"', angle(0) valuelabel)

twoway (bar singlelitlittransactionsize mkturncomposition, barwidth(.4)) (bar litdarklittransactionsize mkturncomposition, barwidth(.4)) (rcap highlittransactionsize lowlittransactionsize mkturncomposition, color(black)), title({stSerif:Lit market},size(medium)) ytitle({stSerif: transacted order size},size(medium)) yscale(range(6 12)) graphregion(color(white)) name(d,replace) xlabel( 0 `"{fontface "stSerif": Low precision}"' 1 `"{fontface "stSerif": High precicsion}"' , noticks) xtitle("") legend(order(1 2) label(1 `"{fontface "stSerif": Single lit}"') label(2 `"{fontface "stSerif": Lit & dark}"')) ylabel( 6 `"{fontface "stSerif": 6}"' 8 `"{fontface "stSerif": 8}"' 10 `"{fontface "stSerif": 10}"' 12 `"{fontface "stSerif": 12}"', angle(0) valuelabel)

grc1leg c d, rows(1) title({stSerif: Transacted order size},size(medium)) legendfrom(c) graphregion(color(white))
gr_edit .title.draw_view.setstyle, style(no)
gr_edit .legend.draw_view.setstyle, style(no)
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//#Table XIV 
gen darksubmissionratio = Totdarksubmission/Totsubmission
gen netdarksubmission = Totdarksubmission - Totlitsubmission if mkt == 1
reg darksubmissionratio SumNumAcq if Treatment ==3, vce(cluster Session)
outreg2 using reg.xls,replace

reg darksubmissionratio SumNumAcq age gender majorecon riskaversion Period if Treatment ==3, vce(cluster Session)
outreg2 using reg.xls,append

reg darksubmissionratio SumNumAcq if Treatment ==1, vce(cluster Session)
outreg2 using reg.xls,append

reg darksubmissionratio SumNumAcq age gender majorecon riskaversion Period if Treatment ==1, vce(cluster Session)
outreg2 using reg.xls,append

reg netdarksubmission SumNumAcq if Treatment ==3, vce(cluster Session)
outreg2 using reg.xls,replace

reg netdarksubmission SumNumAcq age gender majorecon riskaversion Period if Treatment ==3, vce(cluster Session)
outreg2 using reg.xls,append

reg netdarksubmission SumNumAcq if Treatment ==1, vce(cluster Session)
outreg2 using reg.xls,append

reg netdarksubmission SumNumAcq age gender majorecon riskaversion Period if Treatment ==1, vce(cluster Session)
outreg2 using reg.xls,append
//////
gen netdarktrade = TotDarkTrade- TotLitTrade if mkt == 1

reg darktraderatio SumNumAcq if Treatment ==3, vce(cluster Session)
outreg2 using reg.xls,replace

reg darktraderatio SumNumAcq age gender majorecon riskaversion Period if Treatment ==3, vce(cluster Session)
outreg2 using reg.xls,append

reg darktraderatio SumNumAcq if Treatment ==1, vce(cluster Session)
outreg2 using reg.xls,append

reg darktraderatio SumNumAcq age gender majorecon riskaversion Period if Treatment ==1, vce(cluster Session)
outreg2 using reg.xls,append

reg netdarktrade SumNumAcq if Treatment ==3, vce(cluster Session)
outreg2 using reg.xls,replace

reg netdarktrade SumNumAcq age gender majorecon riskaversion Period if Treatment ==3, vce(cluster Session)
outreg2 using reg.xls,append

reg netdarktrade SumNumAcq if Treatment ==1, vce(cluster Session)
outreg2 using reg.xls,append

reg netdarktrade SumNumAcq age gender majorecon riskaversion Period if Treatment ==1, vce(cluster Session)
outreg2 using reg.xls,append

/////////////////////////////////////////////////////////////////////////////////////////////////////
//#Table II-append
use mktsummary.dta, replace

hist darktraderatio if mkt == 1, normal
kdensity darktraderatio if mkt == 1,normal lpattern ("-")
qnorm darktraderatio  if mkt == 1
su darktraderatio if mkt == 1, detail
su darktraderatio if mkt == 1 & urncomposition == 0, detail
su darktraderatio if mkt == 1 & urncomposition == 1, detail

drop fq_dktraderatio
bysort Treatment: quantiles darktraderatio, gen(fq_dktraderatio) nq(3)
tabstat darktraderatio if urncomposition == 0 & mkt == 1, by(fq_dktraderatio) stat(mean sd min max n)
tabstat darktraderatio if urncomposition == 1 & mkt == 1, by(fq_dktraderatio) stat(mean sd min max n)

drop fq_dktraderatio
bysort Treatment: quantiles darktraderatio, gen(fq_dktraderatio) nq(4)
tabstat darktraderatio if urncomposition == 0 & mkt == 1, by(fq_dktraderatio) stat(mean sd min max n)
tabstat darktraderatio if urncomposition == 1 & mkt == 1, by(fq_dktraderatio) stat(mean sd min max n)

drop fq_dktraderatio
bysort Treatment: quantiles darktraderatio, gen(fq_dktraderatio) nq(5)
tabstat darktraderatio if urncomposition == 0 & mkt == 1, by(fq_dktraderatio) stat(mean sd min max n)
tabstat darktraderatio if urncomposition == 1 & mkt == 1, by(fq_dktraderatio) stat(mean sd min max n)


histogram darktraderatio if mkt == 1 & urncomposition == 0, fraction normal title({stSerif:Low precision}) xtitle({stSerif: Dark trading ratio}) ytitle({stSerif:Proportion}) xlabel( 0 `"{fontface "stSerif": 0}"' 0.2 `"{fontface "stSerif": 20%}"' 0.4 `"{fontface "stSerif": 40%}"' 0.6 `"{fontface "stSerif": 60%}"' 0.8 `"{fontface "stSerif": 80%}"' 1 `"{fontface "stSerif": 100%}"', noticks) ylabel( 0 `"{fontface "stSerif": 0}"' 0.05 `"{fontface "stSerif": 5%}"' 0.1 `"{fontface "stSerif": 10%}"' 0.15 `"{fontface "stSerif": 15%}"' 0.2`"{fontface "stSerif": 20%}"' 0.25 `"{fontface "stSerif": 25%}"', noticks)  name(a,replace)

histogram darktraderatio if mkt == 1 & urncomposition == 1, fraction normal title({stSerif:High precision}) xtitle({stSerif: Dark trading ratio}) ytitle({stSerif:Proportion}) xlabel( 0 `"{fontface "stSerif": 0}"' 0.2 `"{fontface "stSerif": 20%}"' 0.4 `"{fontface "stSerif": 40%}"' 0.6 `"{fontface "stSerif": 60%}"' 0.8 `"{fontface "stSerif": 80%}"' 1 `"{fontface "stSerif": 100%}"', noticks) ylabel( 0 `"{fontface "stSerif": 0}"' 0.05 `"{fontface "stSerif": 5%}"' 0.1 `"{fontface "stSerif": 10%}"' 0.15 `"{fontface "stSerif": 15%}"' 0.2`"{fontface "stSerif": 20%}"' 0.25 `"{fontface "stSerif": 25%}"', noticks) name(b,replace)

grc1leg a b, title({stSerif:Distribution of dark trading ratio}) legendfrom(a) graphregion(color(white))
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .title.draw_view.setstyle, style(no)

///////////////////////////////////////////////////////////////////////////////////////////////////////////
//#Figure 1 append
use mktsummary.dta, replace
/////4 bins
bysort Treatment: quantiles darktraderatio, gen(fq_dktraderatio) nq(4)

replace fq_dktraderatio = 0 if mkt == 0
label define Fq_dktraderatio 0 "Lit only" 1 "Dark q1" 2 "Dark q2" 3 "Dark q3" 4 "Dark q4"
label values fq_dktraderatio Fq_dktraderatio

collapse (mean) meanladlit= LADLIT (sd) sdladlit=LADLIT (count) n1 = LADLIT, by(urncomposition fq_dktraderatio)
gen highladlit = meanladlit + invttail(n1-1,0.025)*(sdladlit/sqrt(n1))
gen lowladlit = meanladlit - invttail(n1-1,0.025)*(sdladlit/sqrt(n1))
label define BBB 0 "Lit only" 1 "1st bin" 2 "2nd bin" 3 "3rd bin" 4"4th bin"
label values fq_dktraderatio BBB
format meanladlit %9.3g

twoway (bar meanladlit fq_dktraderatio if fq_dktraderatio == 0, barwidth(.5)) (bar meanladlit fq_dktraderatio if fq_dktraderatio == 1, barwidth(.5))(bar meanladlit fq_dktraderatio if fq_dktraderatio == 2, barwidth(.5))(bar meanladlit fq_dktraderatio if fq_dktraderatio == 3, barwidth(.5))(bar meanladlit fq_dktraderatio if fq_dktraderatio == 4, barwidth(.5))(rcap highladlit lowladlit fq_dktraderatio, color(black)) if urncomposition ==0, legend(off)title({stSerif: Low precision}) ytitle({stSerif:LAD}) yscale(range(0 5)) graphregion(color(white)) name(a,replace) xlabel( 0 `"{fontface "stSerif": Lit Only}"' 1 `"{fontface "stSerif": 1st bin}"' 2 `"{fontface "stSerif": 2nd bin}"' 3 `"{fontface "stSerif": 3rd bin}"' 4 `"{fontface "stSerif": 4th bin}"', noticks) xtitle({stSerif: proportion of dark trading})ylabel(0 `"{fontface "stSerif": 0}"' 1 `"{fontface "stSerif": 1}"' 2 `"{fontface "stSerif": 2}"' 3 `"{fontface "stSerif": 3}"' 4 `"{fontface "stSerif": 4}"'5`"{fontface "stSerif": 5}"', angle(0) valuelabel)

twoway (bar meanladlit fq_dktraderatio if fq_dktraderatio == 0, barwidth(.5)) (bar meanladlit fq_dktraderatio if fq_dktraderatio == 1, barwidth(.5))(bar meanladlit fq_dktraderatio if fq_dktraderatio == 2, barwidth(.5))(bar meanladlit fq_dktraderatio if fq_dktraderatio == 3, barwidth(.5))(bar meanladlit fq_dktraderatio if fq_dktraderatio == 4, barwidth(.5))(rcap highladlit lowladlit fq_dktraderatio, color(black)) if urncomposition ==1, legend(off)title({stSerif: High precision}) ytitle({stSerif:LAD}) yscale(range(0 5)) graphregion(color(white)) name(b,replace) xlabel( 0 `"{fontface "stSerif": Lit Only}"' 1 `"{fontface "stSerif": 1st bin}"' 2 `"{fontface "stSerif": 2nd bin}"' 3 `"{fontface "stSerif": 3rd bin}"' 4 `"{fontface "stSerif": 4th bin}"', noticks) xtitle({stSerif: proportion of dark trading})ylabel(0 `"{fontface "stSerif": 0}"' 1 `"{fontface "stSerif": 1}"' 2 `"{fontface "stSerif": 2}"' 3 `"{fontface "stSerif": 3}"' 4 `"{fontface "stSerif": 4}"'5`"{fontface "stSerif": 5}"', angle(0) valuelabel)

grc1leg a b, title({stSerif:Linear Absolute Deviation in Lit Market}) legendfrom(a) graphregion(color(white))
gr_edit .title.draw_view.setstyle, style(no)
gr_edit .legend.draw_view.setstyle, style(no)

/////3 bins
bysort Treatment: quantiles darktraderatio, gen(fq_dktraderatio) nq(3)

replace fq_dktraderatio = 0 if mkt == 0
label define Fq_dktraderatio 0 "Lit only" 1 "Dark q1" 2 "Dark q2" 3 "Dark q3"
label values fq_dktraderatio Fq_dktraderatio

collapse (mean) meanladlit= LADLIT (sd) sdladlit=LADLIT (count) n1 = LADLIT, by(urncomposition fq_dktraderatio)
gen highladlit = meanladlit + invttail(n1-1,0.025)*(sdladlit/sqrt(n1))
gen lowladlit = meanladlit - invttail(n1-1,0.025)*(sdladlit/sqrt(n1))
label define BBB 0 "Lit only" 1 "1st bin" 2 "2nd bin" 3 "3rd bin" 
label values fq_dktraderatio BBB
format meanladlit %9.3g

twoway (bar meanladlit fq_dktraderatio if fq_dktraderatio == 0, barwidth(.5)) (bar meanladlit fq_dktraderatio if fq_dktraderatio == 1, barwidth(.5))(bar meanladlit fq_dktraderatio if fq_dktraderatio == 2, barwidth(.5))(bar meanladlit fq_dktraderatio if fq_dktraderatio == 3, barwidth(.5))(rcap highladlit lowladlit fq_dktraderatio, color(black)) if urncomposition ==0, legend(off)title({stSerif: Low precision}) ytitle({stSerif:LAD}) yscale(range(0 5)) graphregion(color(white)) name(a,replace) xlabel( 0 `"{fontface "stSerif": Lit Only}"' 1 `"{fontface "stSerif": 1st bin}"' 2 `"{fontface "stSerif": 2nd bin}"' 3 `"{fontface "stSerif": 3rd bin}"', noticks) xtitle({stSerif: proportion of dark trading})ylabel(0 `"{fontface "stSerif": 0}"' 1 `"{fontface "stSerif": 1}"' 2 `"{fontface "stSerif": 2}"' 3 `"{fontface "stSerif": 3}"' 4 `"{fontface "stSerif": 4}"'5`"{fontface "stSerif": 5}"', angle(0) valuelabel)

twoway (bar meanladlit fq_dktraderatio if fq_dktraderatio == 0, barwidth(.5)) (bar meanladlit fq_dktraderatio if fq_dktraderatio == 1, barwidth(.5))(bar meanladlit fq_dktraderatio if fq_dktraderatio == 2, barwidth(.5))(bar meanladlit fq_dktraderatio if fq_dktraderatio == 3, barwidth(.5)) (rcap highladlit lowladlit fq_dktraderatio, color(black)) if urncomposition ==1, legend(off)title({stSerif: High precision}) ytitle({stSerif:LAD}) yscale(range(0 5)) graphregion(color(white)) name(b,replace) xlabel( 0 `"{fontface "stSerif": Lit Only}"' 1 `"{fontface "stSerif": 1st bin}"' 2 `"{fontface "stSerif": 2nd bin}"' 3 `"{fontface "stSerif": 3rd bin}"', noticks) xtitle({stSerif: proportion of dark trading})ylabel(0 `"{fontface "stSerif": 0}"' 1 `"{fontface "stSerif": 1}"' 2 `"{fontface "stSerif": 2}"' 3 `"{fontface "stSerif": 3}"' 4 `"{fontface "stSerif": 4}"'5`"{fontface "stSerif": 5}"', angle(0) valuelabel)

grc1leg a b, title({stSerif:Linear Absolute Deviation in Lit Market}) legendfrom(a) graphregion(color(white))
gr_edit .title.draw_view.setstyle, style(no)
gr_edit .legend.draw_view.setstyle, style(no)


/////5 bins
bysort Treatment: quantiles darktraderatio, gen(fq_dktraderatio) nq(3)
replace fq_dktraderatio = 0 if mkt == 0
label define Fq_dktraderatio 0 "Lit only" 1 "Dark q1" 2 "Dark q2" 3 "Dark q3" 4 "Dark q4" 5 "Dark q5"
label values fq_dktraderatio Fq_dktraderatio

collapse (mean) meanladlit= LADLIT (sd) sdladlit=LADLIT (count) n1 = LADLIT, by(urncomposition fq_dktraderatio)
gen highladlit = meanladlit + invttail(n1-1,0.025)*(sdladlit/sqrt(n1))
gen lowladlit = meanladlit - invttail(n1-1,0.025)*(sdladlit/sqrt(n1))
label define BBB 0 "Lit only" 1 "1st bin" 2 "2nd bin" 3 "3rd bin" 4 "4th bin" 5 "5th bin"
label values fq_dktraderatio BBB
format meanladlit %9.3g

twoway (bar meanladlit fq_dktraderatio if fq_dktraderatio == 0, barwidth(.5)) (bar meanladlit fq_dktraderatio if fq_dktraderatio == 1, barwidth(.5))(bar meanladlit fq_dktraderatio if fq_dktraderatio == 2, barwidth(.5))(bar meanladlit fq_dktraderatio if fq_dktraderatio == 3, barwidth(.5))(bar meanladlit fq_dktraderatio if fq_dktraderatio == 4, barwidth(.5))(bar meanladlit fq_dktraderatio if fq_dktraderatio == 5, barwidth(.5))(rcap highladlit lowladlit fq_dktraderatio, color(black)) if urncomposition ==0, legend(off)title({stSerif: Low precision}) ytitle({stSerif:LAD}) yscale(range(0 5)) graphregion(color(white)) name(a,replace) xlabel( 0 `"{fontface "stSerif": Lit Only}"' 1 `"{fontface "stSerif": 1st bin}"' 2 `"{fontface "stSerif": 2nd bin}"' 3 `"{fontface "stSerif": 3rd bin}"' 4 `"{fontface "stSerif": 4th bin}"' 5 `"{fontface "stSerif": 5th bin}"', noticks) xtitle({stSerif: proportion of dark trading})ylabel(0 `"{fontface "stSerif": 0}"' 1 `"{fontface "stSerif": 1}"' 2 `"{fontface "stSerif": 2}"' 3 `"{fontface "stSerif": 3}"' 4 `"{fontface "stSerif": 4}"'5`"{fontface "stSerif": 5}"', angle(0) valuelabel)

twoway (bar meanladlit fq_dktraderatio if fq_dktraderatio == 0, barwidth(.5)) (bar meanladlit fq_dktraderatio if fq_dktraderatio == 1, barwidth(.5))(bar meanladlit fq_dktraderatio if fq_dktraderatio == 2, barwidth(.5))(bar meanladlit fq_dktraderatio if fq_dktraderatio == 3, barwidth(.5))(bar meanladlit fq_dktraderatio if fq_dktraderatio == 4, barwidth(.5))(bar meanladlit fq_dktraderatio if fq_dktraderatio == 5, barwidth(.5))(rcap highladlit lowladlit fq_dktraderatio, color(black)) if urncomposition ==1, legend(off)title({stSerif: High precision}) ytitle({stSerif:LAD}) yscale(range(0 5)) graphregion(color(white)) name(b,replace) xlabel( 0 `"{fontface "stSerif": Lit Only}"' 1 `"{fontface "stSerif": 1st bin}"' 2 `"{fontface "stSerif": 2nd bin}"' 3 `"{fontface "stSerif": 3rd bin}"' 4 `"{fontface "stSerif": 4th bin}"' 5 `"{fontface "stSerif": 5th bin}"', noticks) xtitle({stSerif: proportion of dark trading})ylabel(0 `"{fontface "stSerif": 0}"' 1 `"{fontface "stSerif": 1}"' 2 `"{fontface "stSerif": 2}"' 3 `"{fontface "stSerif": 3}"' 4 `"{fontface "stSerif": 4}"'5`"{fontface "stSerif": 5}"', angle(0) valuelabel)

grc1leg a b, title({stSerif:Linear Absolute Deviation in Lit Market}) legendfrom(a) graphregion(color(white))
gr_edit .title.draw_view.setstyle, style(no)
gr_edit .legend.draw_view.setstyle, style(no)

//////////Mann-Whitney test, low and high precision treatments
tabstat SumNumAcq, by(Treatment) stat(mean sd min max n)
ranksum SumNumAcq if mkt == 0, by(urncomposition)
ranksum SumNumAcq if mkt == 1, by(urncomposition)

tabstat NumSubInformed, by(Treatment) stat(mean sd min max n)
ranksum NumSubInformed if mkt == 0, by(urncomposition)
ranksum NumSubInformed if mkt == 1, by(urncomposition)

tabstat informedratio, by(Treatment) stat(mean sd min max n)
ranksum informedratio if mkt == 0, by(urncomposition)
ranksum informedratio if mkt == 1, by(urncomposition)

//////////Mann-Whitney test, LAD LAPE VOLA 
tabstat LADLIT, by(Treatment) stat(mean sd min max n)
ranksum LADLIT if urncomposition == 0, by(mkt)
ranksum LADLIT if urncomposition == 1, by(mkt)

tabstat LAPELIT, by(Treatment) stat(mean sd min max n)
ranksum LAPELIT if urncomposition == 0, by(mkt)
ranksum LAPELIT if urncomposition == 1, by(mkt)

tabstat vola, by(Treatment) stat(mean sd min max n)
ranksum vola if urncomposition == 0, by(mkt)
ranksum vola if urncomposition == 1, by(mkt)

//////////Mann-Whitney test, LAD LAPE VOLA by bins modest/high/very high
/////low precision
tabstat LADLIT if urncomposition == 0, by(B) stat(mean sd min max n)
ranksum LADLIT if urncomposition == 0 & (B==0|B==1), by(B)
ranksum LADLIT if urncomposition == 0 & (B==0|B==2), by(B)
ranksum LADLIT if urncomposition == 0 & (B==0|B==3), by(B)

tabstat LAPELIT if urncomposition == 0, by(B) stat(mean sd min max n)
ranksum LAPELIT if urncomposition == 0 & (B==0|B==1), by(B)
ranksum LAPELIT if urncomposition == 0 & (B==0|B==2), by(B)
ranksum LAPELIT if urncomposition == 0 & (B==0|B==3), by(B)

tabstat vola if urncomposition == 0, by(B) stat(mean sd min max n)
ranksum vola if urncomposition == 0 & (B==0|B==1), by(B)
ranksum vola if urncomposition == 0 & (B==0|B==2), by(B)
ranksum vola if urncomposition == 0 & (B==0|B==3), by(B)
/////high precision
tabstat LADLIT if urncomposition == 1, by(B) stat(mean sd min max n)
ranksum LADLIT if urncomposition == 1 & (B==0|B==1), by(B)
ranksum LADLIT if urncomposition == 1 & (B==0|B==2), by(B)
ranksum LADLIT if urncomposition == 1 & (B==0|B==3), by(B)

tabstat LAPELIT if urncomposition == 1, by(B) stat(mean sd min max n)
ranksum LAPELIT if urncomposition == 1 & (B==0|B==1), by(B)
ranksum LAPELIT if urncomposition == 1 & (B==0|B==2), by(B)
ranksum LAPELIT if urncomposition == 1 & (B==0|B==3), by(B)

tabstat vola if urncomposition == 1, by(B) stat(mean sd min max n)
ranksum vola if urncomposition == 1 & (B==0|B==1), by(B)
ranksum vola if urncomposition == 1 & (B==0|B==2), by(B)
ranksum vola if urncomposition == 1 & (B==0|B==3), by(B)

//////////Mann-Whitney test, LAD LAPE VOLA by 3 bins quartile
/////low precision
drop fq_dktraderatio
bysort Treatment: quantiles darktraderatio, gen(fq_dktraderatio) nq(3)
replace fq_dktraderatio = 0 if mkt == 0

tabstat LADLIT if urncomposition == 0, by(fq_dktraderatio) stat(mean sd min max n)
ranksum LADLIT if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==1), by(fq_dktraderatio)
ranksum LADLIT if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==2), by(fq_dktraderatio)
ranksum LADLIT if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==3), by(fq_dktraderatio)

tabstat LAPELIT if urncomposition == 0, by(fq_dktraderatio) stat(mean sd min max n)
ranksum LAPELIT if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==1), by(fq_dktraderatio)
ranksum LAPELIT if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==2), by(fq_dktraderatio)
ranksum LAPELIT if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==3), by(fq_dktraderatio)

tabstat vola if urncomposition == 0, by(fq_dktraderatio) stat(mean sd min max n)
ranksum vola if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==1), by(fq_dktraderatio)
ranksum vola if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==2), by(fq_dktraderatio)
ranksum vola if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==3), by(fq_dktraderatio)

/////high precision
tabstat LADLIT if urncomposition == 1, by(fq_dktraderatio) stat(mean sd min max n)
ranksum LADLIT if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==1), by(fq_dktraderatio)
ranksum LADLIT if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==2), by(fq_dktraderatio)
ranksum LADLIT if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==3), by(fq_dktraderatio)

tabstat LAPELIT if urncomposition == 1, by(fq_dktraderatio) stat(mean sd min max n)
ranksum LAPELIT if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==1), by(fq_dktraderatio)
ranksum LAPELIT if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==2), by(fq_dktraderatio)
ranksum LAPELIT if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==3), by(fq_dktraderatio)

tabstat vola if urncomposition == 1, by(fq_dktraderatio) stat(mean sd min max n)
ranksum vola if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==1), by(fq_dktraderatio)
ranksum vola if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==2), by(fq_dktraderatio)
ranksum vola if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==3), by(fq_dktraderatio)

//////////Mann-Whitney test, LAD LAPE VOLA by 4 bins quartile
/////low precision
drop fq_dktraderatio
bysort Treatment: quantiles darktraderatio, gen(fq_dktraderatio) nq(4)
replace fq_dktraderatio = 0 if mkt == 0

tabstat LADLIT if urncomposition == 0, by(fq_dktraderatio) stat(mean sd min max n)
ranksum LADLIT if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==1), by(fq_dktraderatio)
ranksum LADLIT if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==2), by(fq_dktraderatio)
ranksum LADLIT if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==3), by(fq_dktraderatio)
ranksum LADLIT if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==4), by(fq_dktraderatio)

tabstat LAPELIT if urncomposition == 0, by(fq_dktraderatio) stat(mean sd min max n)
ranksum LAPELIT if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==1), by(fq_dktraderatio)
ranksum LAPELIT if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==2), by(fq_dktraderatio)
ranksum LAPELIT if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==3), by(fq_dktraderatio)
ranksum LAPELIT if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==4), by(fq_dktraderatio)

tabstat vola if urncomposition == 0, by(fq_dktraderatio) stat(mean sd min max n)
ranksum vola if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==1), by(fq_dktraderatio)
ranksum vola if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==2), by(fq_dktraderatio)
ranksum vola if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==3), by(fq_dktraderatio)
ranksum vola if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==4), by(fq_dktraderatio)

/////high precision
tabstat LADLIT if urncomposition == 1, by(fq_dktraderatio) stat(mean sd min max n)
ranksum LADLIT if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==1), by(fq_dktraderatio)
ranksum LADLIT if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==2), by(fq_dktraderatio)
ranksum LADLIT if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==3), by(fq_dktraderatio)
ranksum LADLIT if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==4), by(fq_dktraderatio)

tabstat LAPELIT if urncomposition == 1, by(fq_dktraderatio) stat(mean sd min max n)
ranksum LAPELIT if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==1), by(fq_dktraderatio)
ranksum LAPELIT if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==2), by(fq_dktraderatio)
ranksum LAPELIT if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==3), by(fq_dktraderatio)
ranksum LAPELIT if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==4), by(fq_dktraderatio)

tabstat vola if urncomposition == 1, by(fq_dktraderatio) stat(mean sd min max n)
ranksum vola if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==1), by(fq_dktraderatio)
ranksum vola if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==2), by(fq_dktraderatio)
ranksum vola if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==3), by(fq_dktraderatio)
ranksum vola if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==4), by(fq_dktraderatio)

//////////Mann-Whitney test, LAD LAPE VOLA by 5 bins quartile
/////low precision
drop fq_dktraderatio
bysort Treatment: quantiles darktraderatio, gen(fq_dktraderatio) nq(5)
replace fq_dktraderatio = 0 if mkt == 0

tabstat LADLIT if urncomposition == 0, by(fq_dktraderatio) stat(mean sd min max n)
ranksum LADLIT if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==1), by(fq_dktraderatio)
ranksum LADLIT if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==2), by(fq_dktraderatio)
ranksum LADLIT if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==3), by(fq_dktraderatio)
ranksum LADLIT if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==4), by(fq_dktraderatio)
ranksum LADLIT if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==5), by(fq_dktraderatio)

tabstat LAPELIT if urncomposition == 0, by(fq_dktraderatio) stat(mean sd min max n)
ranksum LAPELIT if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==1), by(fq_dktraderatio)
ranksum LAPELIT if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==2), by(fq_dktraderatio)
ranksum LAPELIT if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==3), by(fq_dktraderatio)
ranksum LAPELIT if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==4), by(fq_dktraderatio)
ranksum LAPELIT if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==5), by(fq_dktraderatio)

tabstat vola if urncomposition == 0, by(fq_dktraderatio) stat(mean sd min max n)
ranksum vola if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==1), by(fq_dktraderatio)
ranksum vola if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==2), by(fq_dktraderatio)
ranksum vola if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==3), by(fq_dktraderatio)
ranksum vola if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==4), by(fq_dktraderatio)
ranksum vola if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==5), by(fq_dktraderatio)
/////high precision
tabstat LADLIT if urncomposition == 1, by(fq_dktraderatio) stat(mean sd min max n)
ranksum LADLIT if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==1), by(fq_dktraderatio)
ranksum LADLIT if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==2), by(fq_dktraderatio)
ranksum LADLIT if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==3), by(fq_dktraderatio)
ranksum LADLIT if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==4), by(fq_dktraderatio)
ranksum LADLIT if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==5), by(fq_dktraderatio)


tabstat LAPELIT if urncomposition == 1, by(fq_dktraderatio) stat(mean sd min max n)
ranksum LAPELIT if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==1), by(fq_dktraderatio)
ranksum LAPELIT if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==2), by(fq_dktraderatio)
ranksum LAPELIT if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==3), by(fq_dktraderatio)
ranksum LAPELIT if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==4), by(fq_dktraderatio)
ranksum LAPELIT if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==5), by(fq_dktraderatio)

tabstat vola if urncomposition == 1, by(fq_dktraderatio) stat(mean sd min max n)
ranksum vola if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==1), by(fq_dktraderatio)
ranksum vola if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==2), by(fq_dktraderatio)
ranksum vola if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==3), by(fq_dktraderatio)
ranksum vola if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==4), by(fq_dktraderatio)
ranksum vola if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==5), by(fq_dktraderatio)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////Mann-Whitney test, Liquidity measures 
tabstat TotTrade, by(Treatment) stat(mean sd min max n)
ranksum TotTrade if urncomposition == 0, by(mkt)
ranksum TotTrade if urncomposition == 1, by(mkt)

tabstat TotLitTrade, by(Treatment) stat(mean sd min max n)
ranksum TotLitTrade if urncomposition == 0, by(mkt)
ranksum TotLitTrade if urncomposition == 1, by(mkt)

tabstat Depth, by(Treatment) stat(mean sd min max n)
ranksum Depth if urncomposition == 0, by(mkt)
ranksum Depth if urncomposition == 1, by(mkt)

tabstat Quotedspreadwt, by(Treatment) stat(mean sd min max n)
ranksum Quotedspreadwt if urncomposition == 0, by(mkt)
ranksum Quotedspreadwt if urncomposition == 1, by(mkt)

tabstat Effspreadwt, by(Treatment) stat(mean sd min max n)
ranksum Effspreadwt if urncomposition == 0, by(mkt)
ranksum Effspreadwt if urncomposition == 1, by(mkt)

//////////Mann-Whitney test, Liquidity measures by bins modest/high/very high
/////low precision
tabstat TotTrade if urncomposition == 0, by(B) stat(mean sd min max n)
ranksum TotTrade if urncomposition == 0 & (B==0|B==1), by(B)
ranksum TotTrade if urncomposition == 0 & (B==0|B==2), by(B)
ranksum TotTrade if urncomposition == 0 & (B==0|B==3), by(B)

tabstat TotLitTrade if urncomposition == 0, by(B) stat(mean sd min max n)
ranksum TotLitTrade if urncomposition == 0 & (B==0|B==1), by(B)
ranksum TotLitTrade if urncomposition == 0 & (B==0|B==2), by(B)
ranksum TotLitTrade if urncomposition == 0 & (B==0|B==3), by(B)

tabstat Depth if urncomposition == 0, by(B) stat(mean sd min max n)
ranksum Depth if urncomposition == 0 & (B==0|B==1), by(B)
ranksum Depth if urncomposition == 0 & (B==0|B==2), by(B)
ranksum Depth if urncomposition == 0 & (B==0|B==3), by(B)

tabstat Quotedspreadwt if urncomposition == 0, by(B) stat(mean sd min max n)
ranksum Quotedspreadwt if urncomposition == 0 & (B==0|B==1), by(B)
ranksum Quotedspreadwt if urncomposition == 0 & (B==0|B==2), by(B)
ranksum Quotedspreadwt if urncomposition == 0 & (B==0|B==3), by(B)

tabstat Effspreadwt if urncomposition == 0, by(B) stat(mean sd min max n)
ranksum Effspreadwt if urncomposition == 0 & (B==0|B==1), by(B)
ranksum Effspreadwt if urncomposition == 0 & (B==0|B==2), by(B)
ranksum Effspreadwt if urncomposition == 0 & (B==0|B==3), by(B)

/////high precision
tabstat TotTrade if urncomposition == 1, by(B) stat(mean sd min max n)
ranksum TotTrade if urncomposition == 1 & (B==0|B==1), by(B)
ranksum TotTrade if urncomposition == 1 & (B==0|B==2), by(B)
ranksum TotTrade if urncomposition == 1 & (B==0|B==3), by(B)

tabstat TotLitTrade if urncomposition == 1, by(B) stat(mean sd min max n)
ranksum TotLitTrade if urncomposition == 1 & (B==0|B==1), by(B)
ranksum TotLitTrade if urncomposition == 1 & (B==0|B==2), by(B)
ranksum TotLitTrade if urncomposition == 1 & (B==0|B==3), by(B)

tabstat Depth if urncomposition == 1, by(B) stat(mean sd min max n)
ranksum Depth if urncomposition == 1 & (B==0|B==1), by(B)
ranksum Depth if urncomposition == 1 & (B==0|B==2), by(B)
ranksum Depth if urncomposition == 1 & (B==0|B==3), by(B)

tabstat Quotedspreadwt if urncomposition == 1, by(B) stat(mean sd min max n)
ranksum Quotedspreadwt if urncomposition == 1 & (B==0|B==1), by(B)
ranksum Quotedspreadwt if urncomposition == 1 & (B==0|B==2), by(B)
ranksum Quotedspreadwt if urncomposition == 1 & (B==0|B==3), by(B)

tabstat Effspreadwt if urncomposition == 1, by(B) stat(mean sd min max n)
ranksum Effspreadwt if urncomposition == 1 & (B==0|B==1), by(B)
ranksum Effspreadwt if urncomposition == 1 & (B==0|B==2), by(B)
ranksum Effspreadwt if urncomposition == 1 & (B==0|B==3), by(B)

//////////Mann-Whitney test, Liquidity measures by 3 bins quartile
drop fq_dktraderatio
bysort Treatment: quantiles darktraderatio, gen(fq_dktraderatio) nq(3)
replace fq_dktraderatio = 0 if mkt == 0
/////low precision
tabstat TotTrade if urncomposition == 0, by(fq_dktraderatio) stat(mean sd min max n)
ranksum TotTrade if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==1), by(fq_dktraderatio)
ranksum TotTrade if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==2), by(fq_dktraderatio)
ranksum TotTrade if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==3), by(fq_dktraderatio)

tabstat TotLitTrade if urncomposition == 0, by(fq_dktraderatio) stat(mean sd min max n)
ranksum TotLitTrade if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==1), by(fq_dktraderatio)
ranksum TotLitTrade if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==2), by(fq_dktraderatio)
ranksum TotLitTrade if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==3), by(fq_dktraderatio)

tabstat Depth if urncomposition == 0, by(fq_dktraderatio) stat(mean sd min max n)
ranksum Depth if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==1), by(fq_dktraderatio)
ranksum Depth if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==2), by(fq_dktraderatio)
ranksum Depth if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==3), by(fq_dktraderatio)

tabstat Quotedspreadwt if urncomposition == 0, by(fq_dktraderatio) stat(mean sd min max n)
ranksum Quotedspreadwt if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==1), by(fq_dktraderatio)
ranksum Quotedspreadwt if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==2), by(fq_dktraderatio)
ranksum Quotedspreadwt if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==3), by(fq_dktraderatio)

tabstat Effspreadwt if urncomposition == 0, by(fq_dktraderatio) stat(mean sd min max n)
ranksum Effspreadwt if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==1), by(fq_dktraderatio)
ranksum Effspreadwt if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==2), by(fq_dktraderatio)
ranksum Effspreadwt if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==3), by(fq_dktraderatio)

/////high precision
tabstat TotTrade if urncomposition == 1, by(fq_dktraderatio) stat(mean sd min max n)
ranksum TotTrade if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==1), by(fq_dktraderatio)
ranksum TotTrade if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==2), by(fq_dktraderatio)
ranksum TotTrade if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==3), by(fq_dktraderatio)

tabstat TotLitTrade if urncomposition == 1, by(fq_dktraderatio) stat(mean sd min max n)
ranksum TotLitTrade if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==1), by(fq_dktraderatio)
ranksum TotLitTrade if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==2), by(fq_dktraderatio)
ranksum TotLitTrade if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==3), by(fq_dktraderatio)

tabstat Depth if urncomposition == 1, by(fq_dktraderatio) stat(mean sd min max n)
ranksum Depth if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==1), by(fq_dktraderatio)
ranksum Depth if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==2), by(fq_dktraderatio)
ranksum Depth if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==3), by(fq_dktraderatio)

tabstat Quotedspreadwt if urncomposition == 1, by(fq_dktraderatio) stat(mean sd min max n)
ranksum Quotedspreadwt if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==1), by(fq_dktraderatio)
ranksum Quotedspreadwt if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==2), by(fq_dktraderatio)
ranksum Quotedspreadwt if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==3), by(fq_dktraderatio)

tabstat Effspreadwt if urncomposition == 1, by(fq_dktraderatio) stat(mean sd min max n)
ranksum Effspreadwt if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==1), by(fq_dktraderatio)
ranksum Effspreadwt if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==2), by(fq_dktraderatio)
ranksum Effspreadwt if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==3), by(fq_dktraderatio)

//////////Mann-Whitney test, Liquidity measures by 4 bins quartile
drop fq_dktraderatio
bysort Treatment: quantiles darktraderatio, gen(fq_dktraderatio) nq(4)
replace fq_dktraderatio = 0 if mkt == 0
/////low precision
tabstat TotTrade if urncomposition == 0, by(fq_dktraderatio) stat(mean sd min max n)
ranksum TotTrade if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==1), by(fq_dktraderatio)
ranksum TotTrade if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==2), by(fq_dktraderatio)
ranksum TotTrade if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==3), by(fq_dktraderatio)
ranksum TotTrade if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==4), by(fq_dktraderatio)

tabstat TotLitTrade if urncomposition == 0, by(fq_dktraderatio) stat(mean sd min max n)
ranksum TotLitTrade if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==1), by(fq_dktraderatio)
ranksum TotLitTrade if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==2), by(fq_dktraderatio)
ranksum TotLitTrade if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==3), by(fq_dktraderatio)
ranksum TotLitTrade if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==4), by(fq_dktraderatio)

tabstat Depth if urncomposition == 0, by(fq_dktraderatio) stat(mean sd min max n)
ranksum Depth if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==1), by(fq_dktraderatio)
ranksum Depth if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==2), by(fq_dktraderatio)
ranksum Depth if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==3), by(fq_dktraderatio)
ranksum Depth if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==4), by(fq_dktraderatio)

tabstat Quotedspreadwt if urncomposition == 0, by(fq_dktraderatio) stat(mean sd min max n)
ranksum Quotedspreadwt if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==1), by(fq_dktraderatio)
ranksum Quotedspreadwt if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==2), by(fq_dktraderatio)
ranksum Quotedspreadwt if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==3), by(fq_dktraderatio)
ranksum Quotedspreadwt if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==4), by(fq_dktraderatio)

tabstat Effspreadwt if urncomposition == 0, by(fq_dktraderatio) stat(mean sd min max n)
ranksum Effspreadwt if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==1), by(fq_dktraderatio)
ranksum Effspreadwt if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==2), by(fq_dktraderatio)
ranksum Effspreadwt if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==3), by(fq_dktraderatio)
ranksum Effspreadwt if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==4), by(fq_dktraderatio)

/////high precision
tabstat TotTrade if urncomposition == 1, by(fq_dktraderatio) stat(mean sd min max n)
ranksum TotTrade if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==1), by(fq_dktraderatio)
ranksum TotTrade if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==2), by(fq_dktraderatio)
ranksum TotTrade if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==3), by(fq_dktraderatio)
ranksum TotTrade if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==4), by(fq_dktraderatio)

tabstat TotLitTrade if urncomposition == 1, by(fq_dktraderatio) stat(mean sd min max n)
ranksum TotLitTrade if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==1), by(fq_dktraderatio)
ranksum TotLitTrade if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==2), by(fq_dktraderatio)
ranksum TotLitTrade if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==3), by(fq_dktraderatio)
ranksum TotLitTrade if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==4), by(fq_dktraderatio)

tabstat Depth if urncomposition == 1, by(fq_dktraderatio) stat(mean sd min max n)
ranksum Depth if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==1), by(fq_dktraderatio)
ranksum Depth if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==2), by(fq_dktraderatio)
ranksum Depth if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==3), by(fq_dktraderatio)
ranksum Depth if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==4), by(fq_dktraderatio)

tabstat Quotedspreadwt if urncomposition == 1, by(fq_dktraderatio) stat(mean sd min max n)
ranksum Quotedspreadwt if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==1), by(fq_dktraderatio)
ranksum Quotedspreadwt if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==2), by(fq_dktraderatio)
ranksum Quotedspreadwt if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==3), by(fq_dktraderatio)
ranksum Quotedspreadwt if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==4), by(fq_dktraderatio)

tabstat Effspreadwt if urncomposition == 1, by(fq_dktraderatio) stat(mean sd min max n)
ranksum Effspreadwt if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==1), by(fq_dktraderatio)
ranksum Effspreadwt if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==2), by(fq_dktraderatio)
ranksum Effspreadwt if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==3), by(fq_dktraderatio)
ranksum Effspreadwt if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==4), by(fq_dktraderatio)

//////////Mann-Whitney test, Liquidity measures by 4 bins quartile
drop fq_dktraderatio
bysort Treatment: quantiles darktraderatio, gen(fq_dktraderatio) nq(5)
replace fq_dktraderatio = 0 if mkt == 0
/////low precision
tabstat TotTrade if urncomposition == 0, by(fq_dktraderatio) stat(mean sd min max n)
ranksum TotTrade if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==1), by(fq_dktraderatio)
ranksum TotTrade if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==2), by(fq_dktraderatio)
ranksum TotTrade if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==3), by(fq_dktraderatio)
ranksum TotTrade if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==4), by(fq_dktraderatio)
ranksum TotTrade if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==5), by(fq_dktraderatio)

tabstat TotLitTrade if urncomposition == 0, by(fq_dktraderatio) stat(mean sd min max n)
ranksum TotLitTrade if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==1), by(fq_dktraderatio)
ranksum TotLitTrade if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==2), by(fq_dktraderatio)
ranksum TotLitTrade if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==3), by(fq_dktraderatio)
ranksum TotLitTrade if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==4), by(fq_dktraderatio)
ranksum TotLitTrade if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==5), by(fq_dktraderatio)

tabstat Depth if urncomposition == 0, by(fq_dktraderatio) stat(mean sd min max n)
ranksum Depth if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==1), by(fq_dktraderatio)
ranksum Depth if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==2), by(fq_dktraderatio)
ranksum Depth if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==3), by(fq_dktraderatio)
ranksum Depth if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==4), by(fq_dktraderatio)
ranksum Depth if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==5), by(fq_dktraderatio)

tabstat Quotedspreadwt if urncomposition == 0, by(fq_dktraderatio) stat(mean sd min max n)
ranksum Quotedspreadwt if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==1), by(fq_dktraderatio)
ranksum Quotedspreadwt if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==2), by(fq_dktraderatio)
ranksum Quotedspreadwt if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==3), by(fq_dktraderatio)
ranksum Quotedspreadwt if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==4), by(fq_dktraderatio)
ranksum Quotedspreadwt if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==5), by(fq_dktraderatio)

tabstat Effspreadwt if urncomposition == 0, by(fq_dktraderatio) stat(mean sd min max n)
ranksum Effspreadwt if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==1), by(fq_dktraderatio)
ranksum Effspreadwt if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==2), by(fq_dktraderatio)
ranksum Effspreadwt if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==3), by(fq_dktraderatio)
ranksum Effspreadwt if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==4), by(fq_dktraderatio)
ranksum Effspreadwt if urncomposition == 0 & (fq_dktraderatio==0|fq_dktraderatio==5), by(fq_dktraderatio)

/////high precision
tabstat TotTrade if urncomposition == 1, by(fq_dktraderatio) stat(mean sd min max n)
ranksum TotTrade if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==1), by(fq_dktraderatio)
ranksum TotTrade if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==2), by(fq_dktraderatio)
ranksum TotTrade if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==3), by(fq_dktraderatio)
ranksum TotTrade if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==4), by(fq_dktraderatio)
ranksum TotTrade if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==5), by(fq_dktraderatio)

tabstat TotLitTrade if urncomposition == 1, by(fq_dktraderatio) stat(mean sd min max n)
ranksum TotLitTrade if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==1), by(fq_dktraderatio)
ranksum TotLitTrade if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==2), by(fq_dktraderatio)
ranksum TotLitTrade if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==3), by(fq_dktraderatio)
ranksum TotLitTrade if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==4), by(fq_dktraderatio)
ranksum TotLitTrade if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==5), by(fq_dktraderatio)

tabstat Depth if urncomposition == 1, by(fq_dktraderatio) stat(mean sd min max n)
ranksum Depth if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==1), by(fq_dktraderatio)
ranksum Depth if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==2), by(fq_dktraderatio)
ranksum Depth if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==3), by(fq_dktraderatio)
ranksum Depth if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==4), by(fq_dktraderatio)
ranksum Depth if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==5), by(fq_dktraderatio)

tabstat Quotedspreadwt if urncomposition == 1, by(fq_dktraderatio) stat(mean sd min max n)
ranksum Quotedspreadwt if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==1), by(fq_dktraderatio)
ranksum Quotedspreadwt if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==2), by(fq_dktraderatio)
ranksum Quotedspreadwt if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==3), by(fq_dktraderatio)
ranksum Quotedspreadwt if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==4), by(fq_dktraderatio)
ranksum Quotedspreadwt if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==5), by(fq_dktraderatio)

tabstat Effspreadwt if urncomposition == 1, by(fq_dktraderatio) stat(mean sd min max n)
ranksum Effspreadwt if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==1), by(fq_dktraderatio)
ranksum Effspreadwt if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==2), by(fq_dktraderatio)
ranksum Effspreadwt if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==3), by(fq_dktraderatio)
ranksum Effspreadwt if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==4), by(fq_dktraderatio)
ranksum Effspreadwt if urncomposition == 1 & (fq_dktraderatio==0|fq_dktraderatio==5), by(fq_dktraderatio)

//////////Mann-Whitney test, Uninformed/Moderately informed/Strongly informed submission 
replace uninfolitsubmission = 0 if uninfolitsubmission == .
replace moderatelitsubmission = 0 if moderatelitsubmission == .
replace stronglitsubmission = 0 if stronglitsubmission == .
replace uninfodarksubmission = 0 if uninfodarksubmission == .
replace moderatedarksubmission = 0 if moderatedarksubmission == .
replace strongdarksubmission = 0 if strongdarksubmission == .

tabstat uninfolitsubmission, by(Treatment) stat(mean sd min max n)
ranksum uninfolitsubmission if urncomposition == 0, by(mkt)
ranksum uninfolitsubmission if urncomposition == 1, by(mkt)

tabstat moderatelitsubmission, by(Treatment) stat(mean sd min max n)
ranksum moderatelitsubmission if urncomposition == 0, by(mkt)
ranksum moderatelitsubmission if urncomposition == 1, by(mkt)

tabstat stronglitsubmission, by(Treatment) stat(mean sd min max n)
ranksum stronglitsubmission if urncomposition == 0, by(mkt)
ranksum stronglitsubmission if urncomposition == 1, by(mkt)

tabstat uninfodarksubmission, by(Treatment) stat(mean sd min max n)
tabstat moderatedarksubmission, by(Treatment) stat(mean sd min max n)
tabstat strongdarksubmission, by(Treatment) stat(mean sd min max n)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
drop fq_dktraderatio
bysort Treatment: quantiles darktraderatio, gen(fq_dktraderatio) nq(3)
replace fq_dktraderatio = 0 if mkt == 0

gen Q1 = 1 if fq_dktraderatio == 1
replace Q1 = 0 if fq_dktraderatio != 1
gen Q2 = 1 if fq_dktraderatio == 2
replace Q2 = 0 if fq_dktraderatio != 2
gen Q3 = 1 if fq_dktraderatio == 3
replace Q3 = 0 if fq_dktraderatio != 3
/////////////////////////////////////////////////////////////////////////////////////////////////////
//low precision
reg LAPELIT mkt Period if urncomposition == 0, vce(cluster Session)
outreg2 using reg.xls, replace
reg LAPELIT mkt TotLitTradeNum bfiaccuracy age gender majorecon riskaversion Period if urncomposition == 0, vce(cluster Session)
outreg2 using reg.xls, append
reg LAPELIT Q1 Q2 Q3 Period if urncomposition == 0, vce(cluster Session)
outreg2 using reg.xls, append
reg LAPELIT Q1 Q2 Q3 TotLitTradeNum bfiaccuracy age gender majorecon riskaversion Period if urncomposition == 0, vce(cluster Session)
outreg2 using reg.xls, append
////high precision 
reg LAPELIT mkt Period if urncomposition == 1, vce(cluster Session)
outreg2 using reg.xls, append
reg LAPELIT mkt TotLitTradeNum bfiaccuracy age gender majorecon riskaversion Period if urncomposition == 1, vce(cluster Session)
outreg2 using reg.xls, append
reg LAPELIT Q1 Q2 Q3 Period if urncomposition == 1, vce(cluster Session)
outreg2 using reg.xls, append
reg LAPELIT Q1 Q2 Q3 TotLitTradeNum bfiaccuracy age gender majorecon riskaversion Period if urncomposition == 1, vce(cluster Session)
outreg2 using reg.xls, append
/////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
drop fq_dktraderatio
bysort Treatment: quantiles darktraderatio, gen(fq_dktraderatio) nq(4)
replace fq_dktraderatio = 0 if mkt == 0

drop Q1 Q2 Q3 
gen Q1 = 1 if fq_dktraderatio == 1
replace Q1 = 0 if fq_dktraderatio != 1
gen Q2 = 1 if fq_dktraderatio == 2
replace Q2 = 0 if fq_dktraderatio != 2
gen Q3 = 1 if fq_dktraderatio == 3
replace Q3 = 0 if fq_dktraderatio != 3
gen Q4 = 1 if fq_dktraderatio == 4
replace Q4 = 0 if fq_dktraderatio != 4
/////////////////////////////////////////////////////////////////////////////////////////////////////
//low precision
reg LAPELIT mkt Period if urncomposition == 0, vce(cluster Session)
outreg2 using reg.xls, replace
reg LAPELIT mkt TotLitTradeNum bfiaccuracy age gender majorecon riskaversion Period if urncomposition == 0, vce(cluster Session)
outreg2 using reg.xls, append
reg LAPELIT Q1 Q2 Q3 Q4 Period if urncomposition == 0, vce(cluster Session)
outreg2 using reg.xls, append
reg LAPELIT Q1 Q2 Q3 Q4 TotLitTradeNum bfiaccuracy age gender majorecon riskaversion Period if urncomposition == 0, vce(cluster Session)
outreg2 using reg.xls, append
////high precision 
reg LAPELIT mkt Period if urncomposition == 1, vce(cluster Session)
outreg2 using reg.xls, append
reg LAPELIT mkt TotLitTradeNum bfiaccuracy age gender majorecon riskaversion Period if urncomposition == 1, vce(cluster Session)
outreg2 using reg.xls, append
reg LAPELIT Q1 Q2 Q3 Q4 Period if urncomposition == 1, vce(cluster Session)
outreg2 using reg.xls, append
reg LAPELIT Q1 Q2 Q3 Q4 TotLitTradeNum bfiaccuracy age gender majorecon riskaversion Period if urncomposition == 1, vce(cluster Session)
outreg2 using reg.xls, append
/////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
drop fq_dktraderatio
bysort Treatment: quantiles darktraderatio, gen(fq_dktraderatio) nq(5)
replace fq_dktraderatio = 0 if mkt == 0

drop Q1 Q2 Q3 Q4
gen Q1 = 1 if fq_dktraderatio == 1
replace Q1 = 0 if fq_dktraderatio != 1
gen Q2 = 1 if fq_dktraderatio == 2
replace Q2 = 0 if fq_dktraderatio != 2
gen Q3 = 1 if fq_dktraderatio == 3
replace Q3 = 0 if fq_dktraderatio != 3
gen Q4 = 1 if fq_dktraderatio == 4
replace Q4 = 0 if fq_dktraderatio != 4
gen Q5 = 1 if fq_dktraderatio == 5
replace Q5 = 0 if fq_dktraderatio != 5
/////////////////////////////////////////////////////////////////////////////////////////////////////
//low precision
reg LAPELIT mkt Period if urncomposition == 0, vce(cluster Session)
outreg2 using reg.xls, replace
reg LAPELIT mkt TotLitTradeNum bfiaccuracy age gender majorecon riskaversion Period if urncomposition == 0, vce(cluster Session)
outreg2 using reg.xls, append
reg LAPELIT Q1 Q2 Q3 Q4 Q5 Period if urncomposition == 0, vce(cluster Session)
outreg2 using reg.xls, append
reg LAPELIT Q1 Q2 Q3 Q4 Q5 TotLitTradeNum bfiaccuracy age gender majorecon riskaversion Period if urncomposition == 0, vce(cluster Session)
outreg2 using reg.xls, append
////high precision 
reg LAPELIT mkt Period if urncomposition == 1, vce(cluster Session)
outreg2 using reg.xls, append
reg LAPELIT mkt TotLitTradeNum bfiaccuracy age gender majorecon riskaversion Period if urncomposition == 1, vce(cluster Session)
outreg2 using reg.xls, append
reg LAPELIT Q1 Q2 Q3 Q4 Q5 Period if urncomposition == 1, vce(cluster Session)
outreg2 using reg.xls, append
reg LAPELIT Q1 Q2 Q3 Q4 Q5 TotLitTradeNum bfiaccuracy age gender majorecon riskaversion Period if urncomposition == 1, vce(cluster Session)
outreg2 using reg.xls, append
/////////////////////////////////////////////////////////////////////////////////////////////////////
