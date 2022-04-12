*Part I - RD and Potential Outcomes

*1.
clear
set obs 10000 
*2. 
*Generate the forcing or running variable 
generate Running = runiform(0,10)
*3. 
*Generate the treatment assignment variable 
generate D = 0
replace D = 1 if Running >= 7
*4 and 5. 
*Draw the treatment assignment variable 
sort Running 
twoway line D Running, xtitle("First-Year GPA") ytitle("Mandatory Attendance (Yes=1, No=0)") /// 
ylabel(0 1) ysc(titlegap(2)) xlabel(0 1 2 3 4 5 6 7 8 9 10) xsc(titlegap(2)) ///
lpattern(dash) 
/*Bob is right. We have full compliance. We should use Sharp RD*/
*6 and 7. 
*Generate potential outcomes 
preserve
keep if (Running>=5.5&Running<=8.5)
generate Grades0 = -3 + Running
generate Grades1 = -1 + Running
twoway line Grades0 Grades1 Running, xline(7) xlabel(5.5 6 6.5 7 7.5 8 8.5) ///
xtitle("First-Year GPA") ytitle("Second-Year GPA") legend(off) lpattern("dash" "dash")
/*There are 2 potential outcomes. One where the student is assigned to voluntary attendance. One where the student is assigned to mandatory attendance. 
Which potential outcome you observe will depend on your view of the effect of voluntary attendance. If you think it is better for attendance to be voluntary 
then, we will observe points on the blue line to the right of 7. We will observe points on the red line to left of 7. If you think it is attendance to be 
voluntary, then we will observe the opposite.*/
*8. 
*Generate non-linearity 
generate Grades2 = 4.3 + 2/(1 + exp(-20*(Running-7)))
replace Grades2 = Grades1 if _n>=1593
replace Grades2 = Running - 2.44 if _n<=1209
twoway line Grades2 Running, lcolor(gs11) xline(7) ///
xtitle("First-Year GPA") ytitle("Second-Year GPA") legend(off)
/*You can include in your specification higher order polynomials in the running variable. */
*9. 
*Generate a change in slopes
generate Grades3 = Grades0
replace Grades3 = 2 + (2/7)*Running if Running>=7
replace Grades3 = -13.5 + 2.5*Running if Running<7
generate Grades4 = Grades1
replace Grades4 = 4 + (2/7)*Running if Running>=7
replace Grades4 = -11.5 + 2.5*Running if Running<7
twoway line Grades3 Grades4 Running, xline(7) xlabel(5.5 6 6.5 7 7.5 8 8.5) ///
xtitle("First-Year GPA") ytitle("Second-Year GPA") legend(off) lpattern("dash" "dash")
/*You can include in your specificaiton the interaction between some function of the running variable and the treatment dummy (see the slides).  */
*8. 
*Generate a change in slopes
restore 
generate NewAssignment = .3*sqrt(Running) 
replace NewAssignment = .3*sqrt(Running) - .4 if Running<7
replace NewAssignment = .02 if Running<2
keep if (Running>=4&Running<=10)
twoway line NewAssignment Running, xtitle("First-Year GPA") ytitle("Mandatory Attendance (Yes=1, No=0)") /// 
ylabel(0 1) ysc(titlegap(2)) xlabel(4 5 6 7 8 9 10) xsc(titlegap(2)) ///
lpattern(dash)
/*Bob is wrong. We have some non-compliance. We should use Fuzzy RD*/




