# StateACS

Scraping data from the U.S. Census Bureau's American Community Survey

## Installation

```
library("devtools")
install_github("lrdegeest/StateACS")
```

## Example 

Pull household data from Iowa betwen 2011 and 2016 into your R workspace and save the .csv files for each year in your current directory:

```R
library(StateACS)
p.data <- getStateACS(2001, 2016, state = "IA", type = "h", save = TRUE)
```
