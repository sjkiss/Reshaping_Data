## ----setup, include=FALSE--------------------
knitr::opts_chunk$set(echo = TRUE, warning=F, message=F)


## ----install-if-necessary, eval=F------------
## install.packages("tidyverse")
## install.packages("haven")
## install.packages("here")
## install.packages("knitr")


## ----load-libraries--------------------------
library(haven)
library(tidyverse)
library(here)
library(knitr)


## ----import-data-----------------------------

unemployment<-read.csv(here("data/1410002301-eng.csv"), skip=14, nrows=42-15, header=F)


## ----view, eval=F----------------------------
## View(unemployment)


## ----image1, echo=F--------------------------
include_graphics(here("images/unemployment.png"))


## ----glimpse-unemp---------------------------
glimpse(unemployment)


## ----select-rename---------------------------
unemployment %>% 
  select(Sector=1, `2017`=2, `2018`=3, `2019`=4, `2020`=5)->unemployment
unemployment


## ----pivot-longer----------------------------
unemployment %>% 
  pivot_longer(., cols=`2017`:`2020`)



## ----pivot-longer-select---------------------
unemployment %>% 
  pivot_longer(., cols=2:5)



## ----pivot-with-names------------------------
unemployment %>% 
  pivot_longer(., cols=`2017`:`2020`, names_to=c("Year"), values_to=c("Unemployment Rate"))->unemployment
head(unemployment)


## ----unemployment-plot,fig.width=10, fig.height=3----
unemployment %>% 
  ggplot(., aes(x=Year, y=`Unemployment Rate`, col=Sector, group=Sector))+geom_line()


## ----import2---------------------------------
immunization<-read.csv(file=here("data/immunization-coverage-2017-2018.csv"))


## ----glimpse-immunization--------------------
glimpse(immunization)


## ----load-janitor-clean-names----------------
library(janitor)
immunization<-clean_names(immunization)


## ----immunization-pivot-longer---------------

immunization %>% 
pivot_longer(., cols=4:7, names_to=c("Measure"), values_to=c("Value")) ->immunization_long



## ----pivot-longer-names----------------------

immunization %>% 
pivot_longer(., cols=dtp_coverage_rate:mmr_religious_exemption_rate, names_to=c("Measure"), values_to=c("Value")) 


## ----pivot-longer-with-contains--------------
immunization %>% 
pivot_longer(., cols=contains("mmr")|contains("dpt"), names_to=c("Measure"), values_to=c("Value")) 



## ----viewimmunization-long, eval=F-----------
## View(immunization_long)


## ----image2, echo=F, fig.cap="A long version of the immunization dataset"----
include_graphics(here("images/immunization_long.png"))


## ----help-separate, eval=F-------------------
## ?separate


## ----separate--------------------------------
immunization_long %>% 
  separate(., col="Measure", sep="_", into=c("Disease", "Measure"))->immunization_long



## ----view-measure, eval=F--------------------
## View(immunization_long)


## ----image3, echo=F, fig.cap="The results of separate."----
include_graphics(path=here("images/immunization_separate.png"))


## ----fig.height=20, fig.width=8--------------
immunization_long %>% 
  ggplot(., aes(x=Value, y=fct_reorder(school_name, Value), fill=Disease))+geom_col(position="dodge")+facet_grid(~Measure)


## ----installplotly---------------------------
#install.packages('plotly')
library(plotly)


## ----fig.height=20, fig.width=8--------------

immunization_long %>% 
  ggplot(., aes(x=Value, y=fct_reorder2(school_name, Measure, Value, .desc=F), fill=Disease))+geom_col(position="dodge")+facet_grid(~Measure)+theme(axis.text.y=element_blank())->plot1
ggplotly(plot1)


## ----fig.height=20, fig.width=8--------------

immunization_long %>% 
  ggplot(., aes(x=Value, y=fct_reorder2(school_name, Disease, Value, .desc=F), fill=Measure))+geom_col(position="dodge")+facet_grid(~Disease)+theme(axis.text.y=element_blank())->plot2
ggplotly(plot2)



## ----import3---------------------------------
unemployment_long<-read.csv(file=here("data/unemployment_long.csv.csv"))
# Clean the names
unemployment_long<-clean_names(unemployment_long)


## ----view-problem, eval=F--------------------
## View(unemployment_long)


## ----image4, echo=F, fig.cap="A long dataset of unemployment rates in Canada."----
include_graphics(path=here("images/unemployment_long.png"))


## ----names-unemployment-long-----------------
names(unemployment_long)


## ----pivot-wider-1---------------------------

unemployment_long %>% 
  pivot_wider(., names_from=c("labour_force_characteristics"), values_from=c("value"))->unemployment_wide



## ----view-wide, eval=F-----------------------
## View(unemployment_wide)


## ----problem-wide, echo=F, fig.cap="Problem with the wide dataset"----
include_graphics(here("images/problem_with_wide.png"))


## ----show-labour-force-characteristics-uom----
unemployment_long %>% 
  select(labour_force_characteristics, uom) %>% 
  slice_sample(n=20)


## ----select-then-pivot-wider-----------------

unemployment_long %>% 
  select(ref_date, labour_force_characteristics, north_american_industry_classification_system_naics, age_group, value) %>% 
  pivot_wider(., names_from=c("labour_force_characteristics"), values_from=c("value"))->unemployment_wide



## ---- eval=F---------------------------------
## View(unemployment_wide)


## ----image5, echo=F, fig.cap="A wide dataset"----
include_graphics(path=here("images/select_pivot.png"))


## ----employment,fig.width=10, fig.height=3----

unemployment_wide %>% 
  ggplot(., aes(x=ref_date, y=Employment, col=north_american_industry_classification_system_naics))+geom_line()


## ----unemployment,fig.width=10, fig.height=3----

unemployment_wide %>% 
  ggplot(., aes(x=ref_date, y=`Unemployment rate`, col=north_american_industry_classification_system_naics))+geom_line()

