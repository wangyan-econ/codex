********************************************************************************
* JEDC Revision: Additional Data Analysis
* Responding to Referee Report JEDC-D-26-00041
* Date: April 2026
********************************************************************************
* This do file contains NEW analyses to address referee concerns, organized as:
*   Part 1: Standardize covariates (Item 6)
*   Part 2: Individual-level information acquisition dynamics (Item 2)
*   Part 3: Execution risk and learning (Item 2)
*   Part 4: Why more information doesn't improve price discovery (Item 2)
*   Part 5: Systematic comparison with Zhu (2013) predictions (Item 2)
*   Part 6: Mediation/Decomposition analysis (Item 2 + Item 3 alternative)
********************************************************************************

global dropbox "/Users/yan/Library/CloudStorage/Dropbox/Project with WANG YAN 2019/1ST PROJECT/DO and DTA Files/211028 summary"
global output "/Users/yan/Desktop/JEDC Revision"

********************************************************************************
* Part 1: Standardized Covariates (Item 6)
* "standardize covariates such that the constants are better interpretable
*  as average effects for some group"
********************************************************************************

//--- 1A. Market-level: SumNumAcq regressions with centered covariates ---
use "$dropbox/mktsummary.dta", replace

gen mkt = 1 if Treatment == 1 | Treatment == 3
replace mkt = 0 if Treatment == 2 | Treatment == 4
gen urncomposition = 1 if Treatment == 1 | Treatment == 2
replace urncomposition = 0 if Treatment == 3 | Treatment == 4

merge m:m Session using "$dropbox/questionnaire.dta", keepusing(avgage avggender avgmajorecon avgriskaversion Grp2avgage Grp2avggender Grp2avgmajorecon Grp2avgriskaversion)
drop _merge
gen Grp2age = Grp2avgage
gen Grp2gender = Grp2avggender
gen Grp2majorecon = Grp2avgmajorecon
gen Grp2riskaversion = Grp2avgriskaversion
drop Grp2avgage Grp2avggender Grp2avgmajorecon Grp2avgriskaversion

// Center continuous variables at their sample means
foreach var of varlist Grp2age Grp2gender Grp2majorecon Grp2riskaversion Period {
    quietly sum `var'
    gen `var'_c = `var' - r(mean)
}

// Table I (revised): SumNumAcq with centered covariates
// Low precision
reg SumNumAcq mkt Period_c if urncomposition == 0, vce(cluster Session)
outreg2 using "$output/Table_SumNumAcq_standardized.xls", replace ctitle(Low, No Controls) label
reg SumNumAcq mkt Grp2age_c Grp2gender_c Grp2majorecon_c Grp2riskaversion_c Period_c if urncomposition == 0, vce(cluster Session)
outreg2 using "$output/Table_SumNumAcq_standardized.xls", append ctitle(Low, Controls) label

// High precision
reg SumNumAcq mkt Period_c if urncomposition == 1, vce(cluster Session)
outreg2 using "$output/Table_SumNumAcq_standardized.xls", append ctitle(High, No Controls) label
reg SumNumAcq mkt Grp2age_c Grp2gender_c Grp2majorecon_c Grp2riskaversion_c Period_c if urncomposition == 1, vce(cluster Session)
outreg2 using "$output/Table_SumNumAcq_standardized.xls", append ctitle(High, Controls) label


//--- 1B. Contract-level: BidAskSpread regressions with centered covariates ---
use "$dropbox/contractsandcontractdark.dta", replace

gen mkt = 1 if Treatment == 1 | Treatment == 3
replace mkt = 0 if Treatment == 2 | Treatment == 4
gen urncomposition = 1 if Treatment == 1 | Treatment == 2
replace urncomposition = 0 if Treatment == 3 | Treatment == 4

gen volume1 = Volume
replace volume1 = . if volume1 > 120
drop Volume
gen Volume = volume1
drop volume1

gen Subject = Creator
merge m:m Session Subject using "$dropbox/questionnaire.dta", keepusing(age gender majorecon RiskAversion)
keep if _merge == 3 | _merge == 1
drop _merge

merge m:1 Session Period using "$dropbox/mktsummary.dta", keepusing(SumNumAcq)
keep if _merge == 1 | _merge == 3
drop _merge

gen BidAskSpread = bidaskspread
drop bidaskspread

// Center covariates
foreach var of varlist SumNumAcq age gender majorecon RiskAversion Period {
    quietly sum `var'
    gen `var'_c = `var' - r(mean)
}

// Spreads with centered covariates
reg BidAskSpread mkt SumNumAcq_c age_c gender_c majorecon_c RiskAversion_c Period_c [aweight=Volume] if urncomposition == 0 & lit == 1, vce(cluster Session)
outreg2 using "$output/Table_Spreads_standardized.xls", replace ctitle(Low Precision) label

reg BidAskSpread mkt SumNumAcq_c age_c gender_c majorecon_c RiskAversion_c Period_c [aweight=Volume] if urncomposition == 1 & lit == 1, vce(cluster Session)
outreg2 using "$output/Table_Spreads_standardized.xls", append ctitle(High Precision) label

// Traded contracts only
reg BidAskSpread mkt SumNumAcq_c age_c gender_c majorecon_c RiskAversion_c Period_c [aweight=Volume] if urncomposition == 0 & lit == 1 & Status == 1, vce(cluster Session)
outreg2 using "$output/Table_Spreads_standardized.xls", append ctitle(Low, Traded) label

reg BidAskSpread mkt SumNumAcq_c age_c gender_c majorecon_c RiskAversion_c Period_c [aweight=Volume] if urncomposition == 1 & lit == 1 & Status == 1, vce(cluster Session)
outreg2 using "$output/Table_Spreads_standardized.xls", append ctitle(High, Traded) label


********************************************************************************
* Part 2: Individual-Level Information Acquisition Dynamics (Item 2)
* Deeper exploration of the channel: WHY does dark pool lead to more
* information production?
********************************************************************************

use "$dropbox/subjects_updated 260317.dta", replace

gen mkt = 1 if Treatment == 1 | Treatment == 3
replace mkt = 0 if Treatment == 2 | Treatment == 4
gen urncomposition = 1 if Treatment == 1 | Treatment == 2
replace urncomposition = 0 if Treatment == 3 | Treatment == 4
gen subjectid = 100*Session + Subject

gen info = 1 if ProbA != 0.5
replace info = 0 if ProbA == 0.5

merge 1:m Session Period Subject using "$dropbox/contractsandcontractdark.dta", keepusing(sublitsubmission subdarksubmission subtotsubmission sublittrade subdarktrade subtottrade)
keep in 1/5760
drop _merge

replace sublitsubmission = 0 if sublitsubmission == .
replace subdarksubmission = 0 if subdarksubmission == .
replace subtotsubmission = 0 if subtotsubmission == .
replace sublittrade = 0 if sublittrade == .
replace subdarktrade = 0 if subdarktrade == .
replace subtottrade = 0 if subtottrade == .

merge m:1 Session Subject using "$dropbox/questionnaire.dta", keepusing(age gender majorecon RiskAversion)
drop _merge

//--- 2A. Individual information acquisition with period interaction ---
// Test whether the dark pool effect diminishes over time at individual level
// This directly addresses the referee's observation about Table 7

xtset subjectid Period

// Individual-level: NumAcq (number of signals acquired by each individual)
reg NumAcq mkt i.mkt#c.Period Period age gender majorecon RiskAversion if urncomposition == 0 & Group == 2, vce(cluster subjectid)
outreg2 using "$output/Table_IndivInfoAcq_dynamics.xls", replace ctitle(Low, NumAcq) label
lincom _b[1.mkt] + 1*_b[1.mkt#c.Period]
lincom _b[1.mkt] + 10*_b[1.mkt#c.Period]
lincom _b[1.mkt] + 20*_b[1.mkt#c.Period]

reg NumAcq mkt i.mkt#c.Period Period age gender majorecon RiskAversion if urncomposition == 1 & Group == 2, vce(cluster subjectid)
outreg2 using "$output/Table_IndivInfoAcq_dynamics.xls", append ctitle(High, NumAcq) label
lincom _b[1.mkt] + 1*_b[1.mkt#c.Period]
lincom _b[1.mkt] + 10*_b[1.mkt#c.Period]
lincom _b[1.mkt] + 20*_b[1.mkt#c.Period]

// AcqInfo (whether individual becomes informed = acquires enough signals)
reg AcqInfo mkt i.mkt#c.Period Period age gender majorecon RiskAversion if urncomposition == 0 & Group == 2, vce(cluster subjectid)
outreg2 using "$output/Table_IndivInfoAcq_dynamics.xls", append ctitle(Low, AcqInfo) label

reg AcqInfo mkt i.mkt#c.Period Period age gender majorecon RiskAversion if urncomposition == 1 & Group == 2, vce(cluster subjectid)
outreg2 using "$output/Table_IndivInfoAcq_dynamics.xls", append ctitle(High, AcqInfo) label


//--- 2B. Lagged profit effect on information acquisition ---
// Does previous period profit affect current period info acquisition?
// This tests learning channel

sort subjectid Period
by subjectid: gen L_GrossProfit = GrossProfit[_n-1]
by subjectid: gen L_NetProfit = NetProfit[_n-1]
by subjectid: gen L_info = info[_n-1]
by subjectid: gen L_NumAcq = NumAcq[_n-1]

// Previous profit -> current info acquisition (learning channel)
reg NumAcq mkt L_GrossProfit i.mkt#c.L_GrossProfit Period age gender majorecon RiskAversion if urncomposition == 1 & Group == 2, vce(cluster subjectid)
outreg2 using "$output/Table_Learning_InfoAcq.xls", replace ctitle(High, GrossProfit) label

reg NumAcq mkt L_NetProfit i.mkt#c.L_NetProfit Period age gender majorecon RiskAversion if urncomposition == 1 & Group == 2, vce(cluster subjectid)
outreg2 using "$output/Table_Learning_InfoAcq.xls", append ctitle(High, NetProfit) label

// Low precision
reg NumAcq mkt L_GrossProfit i.mkt#c.L_GrossProfit Period age gender majorecon RiskAversion if urncomposition == 0 & Group == 2, vce(cluster subjectid)
outreg2 using "$output/Table_Learning_InfoAcq.xls", append ctitle(Low, GrossProfit) label

reg NumAcq mkt L_NetProfit i.mkt#c.L_NetProfit Period age gender majorecon RiskAversion if urncomposition == 0 & Group == 2, vce(cluster subjectid)
outreg2 using "$output/Table_Learning_InfoAcq.xls", append ctitle(Low, NetProfit) label


//--- 2C. State dependence: did being informed last period affect this period? ---
reg NumAcq mkt L_info i.mkt#c.L_info Period age gender majorecon RiskAversion if urncomposition == 1 & Group == 2, vce(cluster subjectid)
outreg2 using "$output/Table_StateDependence_InfoAcq.xls", replace ctitle(High, L_info) label

reg NumAcq mkt L_info i.mkt#c.L_info Period age gender majorecon RiskAversion if urncomposition == 0 & Group == 2, vce(cluster subjectid)
outreg2 using "$output/Table_StateDependence_InfoAcq.xls", append ctitle(Low, L_info) label

// Persistence: does number of signals acquired exhibit autocorrelation?
reg NumAcq mkt L_NumAcq i.mkt#c.L_NumAcq Period age gender majorecon RiskAversion if urncomposition == 1 & Group == 2, vce(cluster subjectid)
outreg2 using "$output/Table_StateDependence_InfoAcq.xls", append ctitle(High, L_NumAcq) label

reg NumAcq mkt L_NumAcq i.mkt#c.L_NumAcq Period age gender majorecon RiskAversion if urncomposition == 0 & Group == 2, vce(cluster subjectid)
outreg2 using "$output/Table_StateDependence_InfoAcq.xls", append ctitle(Low, L_NumAcq) label


********************************************************************************
* Part 3: Execution Risk and Learning (Item 2)
* Referee hypothesis: "with experience, seeing that their execution odds
* are better in lit markets, the effect should vanish"
********************************************************************************

use "$dropbox/subjects_updated 260317.dta", replace

gen mkt = 1 if Treatment == 1 | Treatment == 3
replace mkt = 0 if Treatment == 2 | Treatment == 4
gen urncomposition = 1 if Treatment == 1 | Treatment == 2
replace urncomposition = 0 if Treatment == 3 | Treatment == 4
gen subjectid = 100*Session + Subject

gen info = 1 if ProbA != 0.5
replace info = 0 if ProbA == 0.5

merge 1:m Session Period Subject using "$dropbox/contractsandcontractdark.dta", keepusing(sublitsubmission subdarksubmission subtotsubmission sublittrade subdarktrade subtottrade)
keep in 1/5760
drop _merge

replace sublitsubmission = 0 if sublitsubmission == .
replace subdarksubmission = 0 if subdarksubmission == .
replace subtotsubmission = 0 if subtotsubmission == .
replace sublittrade = 0 if sublittrade == .
replace subdarktrade = 0 if subdarktrade == .
replace subtottrade = 0 if subtottrade == .

merge m:1 Session Subject using "$dropbox/questionnaire.dta", keepusing(age gender majorecon RiskAversion)
drop _merge

//--- 3A. Compute execution rates ---
gen lit_exec_rate = sublittrade / sublitsubmission if sublitsubmission > 0
gen dark_exec_rate = subdarktrade / subdarksubmission if subdarksubmission > 0

// Summary stats of execution rates
tabstat lit_exec_rate dark_exec_rate if mkt == 1 & urncomposition == 1, by(info) stat(mean sd n)
tabstat lit_exec_rate dark_exec_rate if mkt == 1 & urncomposition == 0, by(info) stat(mean sd n)

// Test: execution rate lit vs dark
signrank lit_exec_rate = dark_exec_rate if mkt == 1 & urncomposition == 1

//--- 3B. Lagged execution rate -> current info acquisition ---
sort subjectid Period
by subjectid: gen L_lit_exec = lit_exec_rate[_n-1]
by subjectid: gen L_dark_exec = dark_exec_rate[_n-1]

// Does experiencing low dark execution rate reduce future info acquisition?
reg NumAcq L_dark_exec L_lit_exec Period age gender majorecon RiskAversion if mkt == 1 & urncomposition == 1 & Group == 2, vce(cluster subjectid)
outreg2 using "$output/Table_ExecRate_InfoAcq.xls", replace ctitle(High, Exec Rates) label

reg NumAcq L_dark_exec L_lit_exec Period age gender majorecon RiskAversion if mkt == 1 & urncomposition == 0 & Group == 2, vce(cluster subjectid)
outreg2 using "$output/Table_ExecRate_InfoAcq.xls", append ctitle(Low, Exec Rates) label

//--- 3C. Execution rate evolution over time ---
// Does the gap between lit and dark execution rates change with experience?
gen exec_gap = lit_exec_rate - dark_exec_rate

reg exec_gap Period info i.info#c.Period age gender majorecon RiskAversion if mkt == 1 & urncomposition == 1, vce(cluster subjectid)
outreg2 using "$output/Table_ExecRate_InfoAcq.xls", append ctitle(High, Exec Gap) label

reg exec_gap Period info i.info#c.Period age gender majorecon RiskAversion if mkt == 1 & urncomposition == 0, vce(cluster subjectid)
outreg2 using "$output/Table_ExecRate_InfoAcq.xls", append ctitle(Low, Exec Gap) label

//--- 3D. Lagged execution rate -> venue choice (dark share) ---
gen dark_share = subdarksubmission / subtotsubmission if subtotsubmission > 0 & mkt == 1

reg dark_share L_dark_exec L_lit_exec info Period age gender majorecon RiskAversion if mkt == 1 & urncomposition == 1, vce(cluster subjectid)
outreg2 using "$output/Table_ExecRate_VenueChoice.xls", replace ctitle(High, DarkShare) label

reg dark_share L_dark_exec L_lit_exec info Period age gender majorecon RiskAversion if mkt == 1 & urncomposition == 0, vce(cluster subjectid)
outreg2 using "$output/Table_ExecRate_VenueChoice.xls", append ctitle(Low, DarkShare) label


********************************************************************************
* Part 4: Why More Information Doesn't Improve Price Discovery (Item 2)
* Referee puzzle: "even though traders acquire more information, and informed
* traders choose lit markets ... price discovery does not improve"
********************************************************************************

use "$dropbox/mktsummary.dta", replace

gen mkt = 1 if Treatment == 1 | Treatment == 3
replace mkt = 0 if Treatment == 2 | Treatment == 4
gen urncomposition = 1 if Treatment == 1 | Treatment == 2
replace urncomposition = 0 if Treatment == 3 | Treatment == 4

merge m:m Session using "$dropbox/questionnaire.dta", keepusing(Grp2avgage Grp2avggender Grp2avgmajorecon Grp2avgriskaversion)
drop _merge
gen Grp2age = Grp2avgage
gen Grp2gender = Grp2avggender
gen Grp2majorecon = Grp2avgmajorecon
gen Grp2riskaversion = Grp2avgriskaversion
drop Grp2avgage Grp2avggender Grp2avgmajorecon Grp2avgriskaversion

merge 1:m Session Period using "$dropbox/subjects_updated 260317.dta", keepusing(informed uninformed infolitsubmission infodarksubmission uninfolitsubmission uninfodarksubmission)
keep in 1/480
drop _merge

//--- 4A. Information dispersion: informed trader distribution across venues ---
// Hypothesis: Even with more info acquired, info is dispersed between
// lit and dark venues, weakening price discovery in either venue

gen info_lit_share = infolitsubmission / (infolitsubmission + infodarksubmission) if mkt == 1 & infodarksubmission != .
gen uninfo_lit_share = uninfolitsubmission / (uninfolitsubmission + uninfodarksubmission) if mkt == 1 & uninfodarksubmission != .

// Summary: where do informed traders submit?
tabstat info_lit_share uninfo_lit_share if mkt == 1, by(urncomposition) stat(mean sd n)

// Does dispersion of informed traders hurt price discovery?
reg LADLIT info_lit_share SumNumAcq Period if urncomposition == 1 & mkt == 1, vce(cluster Session)
outreg2 using "$output/Table_InfoDispersion_PriceDiscovery.xls", replace ctitle(High, Lit LAD) label

reg LADLIT info_lit_share SumNumAcq Period if urncomposition == 0 & mkt == 1, vce(cluster Session)
outreg2 using "$output/Table_InfoDispersion_PriceDiscovery.xls", append ctitle(Low, Lit LAD) label


//--- 4B. Diminishing returns to information ---
// Non-linear effect of info on price discovery

gen SumNumAcq_sq = SumNumAcq^2
gen NumSubInformed_sq = NumSubInformed^2

// Quadratic: more signals improve LAD but with diminishing returns?
reg LADLIT SumNumAcq SumNumAcq_sq Period if urncomposition == 1, vce(cluster Session)
outreg2 using "$output/Table_NonlinearInfo_PD.xls", replace ctitle(High, SumAcq) label

reg LADLIT NumSubInformed NumSubInformed_sq Period if urncomposition == 1, vce(cluster Session)
outreg2 using "$output/Table_NonlinearInfo_PD.xls", append ctitle(High, NumInformed) label

reg LADLIT SumNumAcq SumNumAcq_sq Period if urncomposition == 0, vce(cluster Session)
outreg2 using "$output/Table_NonlinearInfo_PD.xls", append ctitle(Low, SumAcq) label

reg LADLIT NumSubInformed NumSubInformed_sq Period if urncomposition == 0, vce(cluster Session)
outreg2 using "$output/Table_NonlinearInfo_PD.xls", append ctitle(Low, NumInformed) label


//--- 4C. Informed-to-Uninformed ratio in lit market ---
// If both informed and uninformed increase submissions in lit,
// the ratio may not change, hence no improvement in price discovery

gen infotouninforatiolit = infolitsubmission / uninfolitsubmission if uninfolitsubmission > 0

// Does ratio differ between lit-only and lit&dark?
ranksum infotouninforatiolit if urncomposition == 1, by(mkt)
ranksum infotouninforatiolit if urncomposition == 0, by(mkt)

reg infotouninforatiolit mkt Period Grp2age Grp2gender Grp2majorecon Grp2riskaversion if urncomposition == 1, vce(cluster Session)
outreg2 using "$output/Table_InfoRatio_Lit.xls", replace ctitle(High, Ratio) label

reg infotouninforatiolit mkt Period Grp2age Grp2gender Grp2majorecon Grp2riskaversion if urncomposition == 0, vce(cluster Session)
outreg2 using "$output/Table_InfoRatio_Lit.xls", append ctitle(Low, Ratio) label


//--- 4D. Conditional on being in lit market, does more info help? ---
// Separate the structural effect from the info effect

reg LADLIT mkt SumNumAcq i.mkt#c.SumNumAcq Period if urncomposition == 1, vce(cluster Session)
outreg2 using "$output/Table_MktxInfo_PD.xls", replace ctitle(High) label

reg LADLIT mkt SumNumAcq i.mkt#c.SumNumAcq Period if urncomposition == 0, vce(cluster Session)
outreg2 using "$output/Table_MktxInfo_PD.xls", append ctitle(Low) label

// With controls
reg LADLIT mkt SumNumAcq i.mkt#c.SumNumAcq Grp2age Grp2gender Grp2majorecon Grp2riskaversion Period if urncomposition == 1, vce(cluster Session)
outreg2 using "$output/Table_MktxInfo_PD.xls", append ctitle(High, Controls) label

reg LADLIT mkt SumNumAcq i.mkt#c.SumNumAcq Grp2age Grp2gender Grp2majorecon Grp2riskaversion Period if urncomposition == 0, vce(cluster Session)
outreg2 using "$output/Table_MktxInfo_PD.xls", append ctitle(Low, Controls) label


********************************************************************************
* Part 5: Systematic Comparison with Zhu (2013) Predictions (Item 2)
* Map experimental results to each prediction of the Zhu (2013) model
********************************************************************************

//--- 5A. Sorting / Venue choice by information status ---
// Zhu (2013): Informed traders prefer lit (avoid execution risk in dark)
//             Uninformed traders prefer dark (avoid adverse selection in lit)

use "$dropbox/subjects_updated 260317.dta", replace

gen mkt = 1 if Treatment == 1 | Treatment == 3
replace mkt = 0 if Treatment == 2 | Treatment == 4
gen urncomposition = 1 if Treatment == 1 | Treatment == 2
replace urncomposition = 0 if Treatment == 3 | Treatment == 4
gen subjectid = 100*Session + Subject

gen info = 1 if ProbA != 0.5
replace info = 0 if ProbA == 0.5

gen moderate = 1 if ((ProbA <= 0.75)&(ProbA > 0.5))|((ProbA < 0.5)&(ProbA >= 0.25))
replace moderate = 0 if moderate == .
gen strong = 1 if (ProbA > 0.75)|(ProbA < 0.25)
replace strong = 0 if strong == .
gen signalstrength = 2 if moderate == 1
replace signalstrength = 3 if strong == 1
replace signalstrength = 1 if signalstrength == .

merge 1:m Session Period Subject using "$dropbox/contractsandcontractdark.dta", keepusing(sublitsubmission subdarksubmission subtotsubmission sublittrade subdarktrade subtottrade)
keep in 1/5760
drop _merge

replace sublitsubmission = 0 if sublitsubmission == .
replace subdarksubmission = 0 if subdarksubmission == .
replace subtotsubmission = 0 if subtotsubmission == .
replace sublittrade = 0 if sublittrade == .
replace subdarktrade = 0 if subdarktrade == .
replace subtottrade = 0 if subtottrade == .

merge m:1 Session Subject using "$dropbox/questionnaire.dta", keepusing(age gender majorecon RiskAversion)
drop _merge

gen dark_share = subdarksubmission / subtotsubmission if subtotsubmission > 0 & mkt == 1

// Zhu prediction: informed -> lower dark_share
// Test with signal strength for finer granularity
reg dark_share i.signalstrength Period age gender majorecon RiskAversion if mkt == 1 & urncomposition == 1, vce(cluster subjectid)
outreg2 using "$output/Table_Zhu_Sorting.xls", replace ctitle(High, Level) label

// Does sorting strengthen over time? (learning to sort as in Zhu)
reg dark_share i.signalstrength##c.Period age gender majorecon RiskAversion if mkt == 1 & urncomposition == 1, vce(cluster subjectid)
outreg2 using "$output/Table_Zhu_Sorting.xls", append ctitle(High, Interaction) label

// Low precision
reg dark_share i.signalstrength Period age gender majorecon RiskAversion if mkt == 1 & urncomposition == 0, vce(cluster subjectid)
outreg2 using "$output/Table_Zhu_Sorting.xls", append ctitle(Low, Level) label

reg dark_share i.signalstrength##c.Period age gender majorecon RiskAversion if mkt == 1 & urncomposition == 0, vce(cluster subjectid)
outreg2 using "$output/Table_Zhu_Sorting.xls", append ctitle(Low, Interaction) label


//--- 5B. Zhu (2013) Table: Summary of predictions vs experimental results ---
// Create a clean comparison table

// Dark share by info status (submission-based)
tabstat dark_share if mkt == 1 & urncomposition == 1, by(signalstrength) stat(mean sd n)
tabstat dark_share if mkt == 1 & urncomposition == 0, by(signalstrength) stat(mean sd n)

// Dark share by info status (trade-based)
gen dark_trade_share = subdarktrade / subtottrade if subtottrade > 0 & mkt == 1
tabstat dark_trade_share if mkt == 1 & urncomposition == 1, by(signalstrength) stat(mean sd n)
tabstat dark_trade_share if mkt == 1 & urncomposition == 0, by(signalstrength) stat(mean sd n)

// Wilcoxon tests: informed vs uninformed in dark usage
ranksum dark_share if mkt == 1 & urncomposition == 1 & (signalstrength == 1 | signalstrength == 3), by(signalstrength)
ranksum dark_share if mkt == 1 & urncomposition == 0 & (signalstrength == 1 | signalstrength == 3), by(signalstrength)


********************************************************************************
* Part 6: Mediation / Decomposition Analysis (Item 2 + Item 3 alternative)
* Decompose the effect of dark pool on price discovery into:
*   (a) indirect effect through information acquisition
*   (b) direct structural effect of market structure
* This directly addresses Item 3 without needing new experiments
********************************************************************************

use "$dropbox/mktsummary.dta", replace

gen mkt = 1 if Treatment == 1 | Treatment == 3
replace mkt = 0 if Treatment == 2 | Treatment == 4
gen urncomposition = 1 if Treatment == 1 | Treatment == 2
replace urncomposition = 0 if Treatment == 3 | Treatment == 4

merge m:m Session using "$dropbox/questionnaire.dta", keepusing(Grp2avgage Grp2avggender Grp2avgmajorecon Grp2avgriskaversion)
drop _merge
gen Grp2age = Grp2avgage
gen Grp2gender = Grp2avggender
gen Grp2majorecon = Grp2avgmajorecon
gen Grp2riskaversion = Grp2avgriskaversion
drop Grp2avgage Grp2avggender Grp2avgmajorecon Grp2avgriskaversion

//--- 6A. Baron-Kenny Mediation Steps ---
// Mediator: SumNumAcq (total signals acquired)
// Treatment: mkt (0=lit only, 1=lit&dark)
// Outcome: LADLIT (price discovery in lit market)

// HIGH PRECISION
display "============================================="
display "MEDIATION ANALYSIS: HIGH PRECISION"
display "============================================="

// Step 1: Treatment -> Mediator (mkt -> SumNumAcq)
display "Step 1: mkt -> SumNumAcq"
reg SumNumAcq mkt Period Grp2age Grp2gender Grp2majorecon Grp2riskaversion if urncomposition == 1, vce(cluster Session)
est store step1_high

// Step 2: Treatment -> Outcome (total effect: mkt -> LADLIT)
display "Step 2: mkt -> LADLIT (total effect)"
reg LADLIT mkt Period Grp2age Grp2gender Grp2majorecon Grp2riskaversion if urncomposition == 1, vce(cluster Session)
est store step2_high

// Step 3: Treatment + Mediator -> Outcome (direct effect)
display "Step 3: mkt + SumNumAcq -> LADLIT (direct effect)"
reg LADLIT mkt SumNumAcq Period Grp2age Grp2gender Grp2majorecon Grp2riskaversion if urncomposition == 1, vce(cluster Session)
est store step3_high

// Output together
outreg2 [step1_high step2_high step3_high] using "$output/Table_Mediation_High.xls", replace label

// Sobel test (if sgmediation is installed)
capture sgmediation LADLIT if urncomposition == 1, mv(SumNumAcq) iv(mkt) cv(Period Grp2age Grp2gender Grp2majorecon Grp2riskaversion)


// LOW PRECISION
display "============================================="
display "MEDIATION ANALYSIS: LOW PRECISION"
display "============================================="

// Step 1
display "Step 1: mkt -> SumNumAcq"
reg SumNumAcq mkt Period Grp2age Grp2gender Grp2majorecon Grp2riskaversion if urncomposition == 0, vce(cluster Session)
est store step1_low

// Step 2
display "Step 2: mkt -> LADLIT (total effect)"
reg LADLIT mkt Period Grp2age Grp2gender Grp2majorecon Grp2riskaversion if urncomposition == 0, vce(cluster Session)
est store step2_low

// Step 3
display "Step 3: mkt + SumNumAcq -> LADLIT (direct effect)"
reg LADLIT mkt SumNumAcq Period Grp2age Grp2gender Grp2majorecon Grp2riskaversion if urncomposition == 0, vce(cluster Session)
est store step3_low

outreg2 [step1_low step2_low step3_low] using "$output/Table_Mediation_Low.xls", replace label

capture sgmediation LADLIT if urncomposition == 0, mv(SumNumAcq) iv(mkt) cv(Period Grp2age Grp2gender Grp2majorecon Grp2riskaversion)


//--- 6B. Mediation with NumSubInformed as alternative mediator ---
// Use number of informed traders (extensive margin) instead of total signals

display "============================================="
display "MEDIATION: NumSubInformed as mediator (HIGH)"
display "============================================="

reg NumSubInformed mkt Period Grp2age Grp2gender Grp2majorecon Grp2riskaversion if urncomposition == 1, vce(cluster Session)
est store step1b_high

reg LADLIT mkt NumSubInformed Period Grp2age Grp2gender Grp2majorecon Grp2riskaversion if urncomposition == 1, vce(cluster Session)
est store step3b_high

outreg2 [step1b_high step2_high step3b_high] using "$output/Table_Mediation_NumInformed_High.xls", replace label

capture sgmediation LADLIT if urncomposition == 1, mv(NumSubInformed) iv(mkt) cv(Period Grp2age Grp2gender Grp2majorecon Grp2riskaversion)


//--- 6C. Mediation for Spreads ---
// Same decomposition for bid-ask spreads

use "$dropbox/contractsandcontractdark.dta", replace

gen mkt = 1 if Treatment == 1 | Treatment == 3
replace mkt = 0 if Treatment == 2 | Treatment == 4
gen urncomposition = 1 if Treatment == 1 | Treatment == 2
replace urncomposition = 0 if Treatment == 3 | Treatment == 4

gen volume1 = Volume
replace volume1 = . if volume1 > 120
drop Volume
gen Volume = volume1
drop volume1

gen Subject = Creator
merge m:m Session Subject using "$dropbox/questionnaire.dta", keepusing(age gender majorecon RiskAversion)
keep if _merge == 3 | _merge == 1
drop _merge
merge m:1 Session Period using "$dropbox/mktsummary.dta", keepusing(SumNumAcq)
keep if _merge == 1 | _merge == 3
drop _merge

gen BidAskSpread = bidaskspread
drop bidaskspread

// Center for interpretability
foreach var of varlist SumNumAcq age gender majorecon RiskAversion Period {
    quietly sum `var'
    gen `var'_c = `var' - r(mean)
}

display "============================================="
display "MEDIATION FOR SPREADS: HIGH PRECISION"
display "============================================="

// Step 2: total effect
reg BidAskSpread mkt age_c gender_c majorecon_c RiskAversion_c Period_c [aweight=Volume] if urncomposition == 1 & lit == 1, vce(cluster Session)
est store spread_step2_high

// Step 3: direct effect controlling for info
reg BidAskSpread mkt SumNumAcq_c age_c gender_c majorecon_c RiskAversion_c Period_c [aweight=Volume] if urncomposition == 1 & lit == 1, vce(cluster Session)
est store spread_step3_high

outreg2 [spread_step2_high spread_step3_high] using "$output/Table_Mediation_Spreads_High.xls", replace label

display "============================================="
display "MEDIATION FOR SPREADS: LOW PRECISION"
display "============================================="

reg BidAskSpread mkt age_c gender_c majorecon_c RiskAversion_c Period_c [aweight=Volume] if urncomposition == 0 & lit == 1, vce(cluster Session)
est store spread_step2_low

reg BidAskSpread mkt SumNumAcq_c age_c gender_c majorecon_c RiskAversion_c Period_c [aweight=Volume] if urncomposition == 0 & lit == 1, vce(cluster Session)
est store spread_step3_low

outreg2 [spread_step2_low spread_step3_low] using "$output/Table_Mediation_Spreads_Low.xls", replace label


********************************************************************************
* Part 7 (Bonus): Exogenous vs Endogenous Information Comparison (Item 3)
* Using existing data to simulate what an exogenous-info treatment would show
* Compare lit-only sessions: how do informed vs uninformed behave differently?
* This approximates Zhu (2013)'s exogenous information setting
********************************************************************************

use "$dropbox/subjects_updated 260317.dta", replace

gen mkt = 1 if Treatment == 1 | Treatment == 3
replace mkt = 0 if Treatment == 2 | Treatment == 4
gen urncomposition = 1 if Treatment == 1 | Treatment == 2
replace urncomposition = 0 if Treatment == 3 | Treatment == 4
gen subjectid = 100*Session + Subject

gen info = 1 if ProbA != 0.5
replace info = 0 if ProbA == 0.5

gen moderate = 1 if ((ProbA <= 0.75)&(ProbA > 0.5))|((ProbA < 0.5)&(ProbA >= 0.25))
replace moderate = 0 if moderate == .
gen strong = 1 if (ProbA > 0.75)|(ProbA < 0.25)
replace strong = 0 if strong == .

merge 1:m Session Period Subject using "$dropbox/contractsandcontractdark.dta", keepusing(sublitsubmission subdarksubmission subtotsubmission sublittrade subdarktrade subtottrade)
keep in 1/5760
drop _merge

replace sublitsubmission = 0 if sublitsubmission == .
replace subdarksubmission = 0 if subdarksubmission == .
replace subtotsubmission = 0 if subtotsubmission == .
replace sublittrade = 0 if sublittrade == .
replace subdarktrade = 0 if subdarktrade == .
replace subtottrade = 0 if subtottrade == .

merge m:1 Session Subject using "$dropbox/questionnaire.dta", keepusing(age gender majorecon RiskAversion)
drop _merge

//--- 7A. In lit-only sessions, compare informed vs uninformed behavior ---
// This serves as a quasi-exogenous baseline (info is endogenous but
// there's no dark pool -> comparable to Zhu's lit-only benchmark)

// Submission volume: do informed trade more aggressively?
reg sublitsubmission info moderate strong Period age gender majorecon RiskAversion if mkt == 0 & urncomposition == 1, vce(cluster subjectid)
outreg2 using "$output/Table_ExogBenchmark.xls", replace ctitle(High, LitOnly, Sub) label

// Now compare with lit&dark sessions
reg sublitsubmission info moderate strong Period age gender majorecon RiskAversion if mkt == 1 & urncomposition == 1, vce(cluster subjectid)
outreg2 using "$output/Table_ExogBenchmark.xls", append ctitle(High, LitDark, LitSub) label

reg subdarksubmission info moderate strong Period age gender majorecon RiskAversion if mkt == 1 & urncomposition == 1, vce(cluster subjectid)
outreg2 using "$output/Table_ExogBenchmark.xls", append ctitle(High, LitDark, DarkSub) label

// Same for low precision
reg sublitsubmission info moderate strong Period age gender majorecon RiskAversion if mkt == 0 & urncomposition == 0, vce(cluster subjectid)
outreg2 using "$output/Table_ExogBenchmark.xls", append ctitle(Low, LitOnly, Sub) label

reg sublitsubmission info moderate strong Period age gender majorecon RiskAversion if mkt == 1 & urncomposition == 0, vce(cluster subjectid)
outreg2 using "$output/Table_ExogBenchmark.xls", append ctitle(Low, LitDark, LitSub) label

reg subdarksubmission info moderate strong Period age gender majorecon RiskAversion if mkt == 1 & urncomposition == 0, vce(cluster subjectid)
outreg2 using "$output/Table_ExogBenchmark.xls", append ctitle(Low, LitDark, DarkSub) label


//--- 7B. Profit comparison: does being informed pay more in dark? ---
// Zhu (2013) predicts informed should prefer lit for better execution
// But if informed traders earn more in dark, this contradicts Zhu

reg GrossProfit info moderate strong Period age gender majorecon RiskAversion if mkt == 0 & urncomposition == 1, vce(cluster subjectid)
outreg2 using "$output/Table_ExogBenchmark_Profit.xls", replace ctitle(High, LitOnly) label

reg GrossProfit info moderate strong Period age gender majorecon RiskAversion if mkt == 1 & urncomposition == 1, vce(cluster subjectid)
outreg2 using "$output/Table_ExogBenchmark_Profit.xls", append ctitle(High, LitDark) label

reg GrossProfit info moderate strong Period age gender majorecon RiskAversion if mkt == 0 & urncomposition == 0, vce(cluster subjectid)
outreg2 using "$output/Table_ExogBenchmark_Profit.xls", append ctitle(Low, LitOnly) label

reg GrossProfit info moderate strong Period age gender majorecon RiskAversion if mkt == 1 & urncomposition == 0, vce(cluster subjectid)
outreg2 using "$output/Table_ExogBenchmark_Profit.xls", append ctitle(Low, LitDark) label


display "============================================="
display "ALL ADDITIONAL ANALYSES COMPLETE"
display "============================================="
display "Output files saved to: $output"
display "============================================="
