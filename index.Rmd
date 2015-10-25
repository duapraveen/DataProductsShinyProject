---
title       : College Finder App 
subtitle    : Usage Notes Document
author      : Praveen Dua
job         : Data Scientist
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : []            # {mathjax, quiz, bootstrap}
mode        : standalone # {standalone, draft}
knit        : slidify::knit2slides

--- .class #id 

## Why a College Finder App ?

### The problem

- There are more than 7000 colleges in U.S.
- It is difficult for high school students to find good target schools to apply to
- Even harder for parents, especially first generation immigrant parents, to engage 


#### This app allows students and parents to sit around the kitchen table and find 

- how many colleges are accessible 
- what is the tution cost
- where are they located, geographically
- click the link for more info on the colleges in the tool-tip

### Quickly come up with an initial working list of colleges to start the process

--- .class #id 

## Filter Criteria

### Which colleges can I go to - Where are they located - What is the cost ?

### Enter search criteria for colleges on the left sidebar panel
  * enter the home state ( 2 letter state abbreviation, e.g : CA )
  * enter a list of additional states of interest ( comma separated list of state abbreviations )
     * Example : MA, IL, FL
     * leave this box blank to include all states
  * set the SAT slider to the target score accepted by colleges ( SAT math + verbal )
  * set the desired tuition fee for
     * in-state tuition for home state
     * out-of-state tuition for other states
  * select the desired program 
  * select the desired degree

---

## Entering college finder selection criteria : Example

- enter your selections on this left sidebar pane as shown below
- The data used for this app is obtained from the US Dept of Education site [here](https://collegescorecard.ed.gov/data/) 

![10](assets/img/input_criteria_3.png)


---

## Results shown on the main panel

   * Number of colleges matching the selection criteria (if > 0, below 2 plots also shown)
   * SAT -vs- Tuition plot : hover mouse on a point for name of college
   * Locations of colleges : click on the school name in tool-tip for college info


 ![5](assets/img/histplot.png)  ![5](assets/img/locations.png) 




