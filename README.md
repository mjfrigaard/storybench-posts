StorybenchR - tutorials for data storytelling with R
================

# Welcome to `StorybenchR`

This is a series of tutorials from Data Journalism in R from
[Storybench.org](http://www.storybench.org/category/data-journalism-in-r/)
using the `tidyverse`

    ## ⬢ __  _    __   .    ⬡           ⬢  . 
    ##  / /_(_)__/ /_ ___  _____ _______ ___ 
    ## / __/ / _  / // / |/ / -_) __(_-</ -_)
    ## \__/_/\_,_/\_, /|___/\__/_/ /___/\__/ 
    ##      ⬢  . /___/      ⬡      .       ⬢

This document is also maintained in this [Google
Doc](http://bit.ly/gdocstorybenchR). To convert this to markdown, use
this [script](https://blog.plover.com/Unix/google-doc-to-markdown.html)
from [Renato Magini](https://github.com/mangini).

## Outline

Below is the general outline for these tutorials. More lessons are added
as new packages come out or better workflows/methods are discovered.

Table of Contents

# Day 1 (section 1)

## 1\) Getting Started With R in RStudio Notebooks (R markdown)

Rmarkdown is the foundation for sharing/using code, so this should be in
the introduction. We might need to move this behind the intro to
RStudio’s IDE, but still needs to be a taught within the first hour.

### 1 a) Learning Objectives:

1)  learn basic markdown formatting (headers, bold, italic, code chunks,
    etc.) and 2) know how to navigate the RStudio IDE (console, source,
    environment, packages).

### 1 b) Packages used:

`tidyverse`, rmarkdown, `knitr`.

### 1 c) Data set(s) used:

none, basic data objects are created in RStudio.

### 1 d) Current version

``` bash
01-r-markdown-4-code/
├── 01-rstudio_setup.png
├── 02-play-button.png
├── 03-preview-button.png
├── 04-r-notebook-preview.png
├── 05-insert-r-rnotebook.png
├── 06-workingenviro.png
├── 1-getting-started-rstudio-notebooks.Rmd
├── 1-getting-started-rstudio-notebooks.md
└── README.md
```

#### 1 e) Notes

1.  ***Need to add RStudio IDE***:

We don’t have anything on this explicitly, but now there are enough
bells and whistles that we could do a post on Add-inns, pane layouts,
Terminal, etc. Also add [RStudio Cloud](https://rstudio.cloud/).

2.  ***Need to add Markdown resources: ***

Include a link to pandoc markdown, basic table formatting, bullets,
bold, italics, etc.

**Tutorial**:
<http://www.storybench.org/getting-started-r-rstudio-notebooks/>

## 2\) Getting Started with tidyverse in R

Don’t change much but add a bit on basic visualization with `qplot()`.
This will keep them engaged and shows how visualization is important at
every step.

### 2 a) Learning Objectives:

1)  the pipe 2) introduce tabular data and map them onto tidyverse
    terminology (columns = variables and rows = observations), 3)
    overview of tidy data principles (different ways of representing the
    same information).

### 2 b) Packages used:

`tidyverse`, specifically `tidyr` and `qplot()`

### 2 c) Data set(s) used:

none, basic data objects are created in RStudio.

### 2 d) Current version

``` bash
02.1-getting-started-with-the-tidyverse/
├── 02.1-getting-started-with-the-tidyverse.Rmd
├── 02.1-getting-started-with-the-tidyverse.Rproj
├── README.md
├── images
│   ├── gathered.png
│   ├── qplot-1-1.png
│   ├── qplot-2-1.png
│   ├── qplot-3-1.png
│   ├── qplot-4-1.png
│   ├── spread.png
│   ├── table.png
│   ├── tables.xml
│   ├── tibble1.png
│   └── unnamed-chunk-1-1.png
└── tables.md

1 directory, 14 files
```

#### 2 e) Notes:

Need to add Importing data, stick to the basic spreadsheets (.csv, .tsv.
.xslx)

Post/Tutorial:
<http://www.storybench.org/getting-started-with-tidyverse-in-r/>

## 3\) How to explore and manipulate a dataset from the fivethirtyeight package in R (`tidyr` for shaping data)

This is still good to go, but we need to add a few new functions.

### 3 a) Learning Objectives:

1)  learn basic column/row reshaping using key/value pairs, 2)
    `separate` and `unite` column contents, 3) introduce the `ggplot2`
    geoms

### 3 b) Packages used:

`tidyverse`, `fivethirtyeight`

### 3 c) Data set(s) used:

`murder_2015_final`, `mad_men`, `police_killings`

### 3 d) Current version

``` bash
03.1-tidyr-to-shape-qplot/
├── 03.1-how-to-explore-manipulate-dataset-from-538-package.Rmd
├── 03.1-how-to-explore-manipulate-dataset-from-538-package.Rproj
├── 03.1-how-to-explore-manipulate-dataset-from-538-package.md
├── README.md
├── _config.yml
├── data
└── images
    ├── 03.1-Separate-Rows.png
    ├── 03.2-Separate-Rows.png
    ├── 03.3-Separate-Rows.png
    ├── 03.3-Separate-Rows.xml
    ├── 04-MadMen-Separate.gif
    ├── 04.1-MadMen-Separate.png
    ├── 05.1-PoliceKillingsUnited.png
    ├── 07-MurdersArranged.png
    ├── 07-MurdersGathered.png
    ├── 07.1-MurdersGathered.png
    ├── 07.1-MurdersSpread.jpg
    ├── 07.1-MurdersSpread.png
    ├── 07.2-MurdersGathered.jpg
    ├── 07.2-MurdersGathered.png
    ├── 07.3-MurderSpread.jpg
    ├── 07.3-MurderSpread.png
    ├── 07.4-MurderSpread.jpg
    ├── 07.4-MurderSpread.png
    ├── 07.5-MurderSpread.png
    ├── 07.6-MurderSpread.png
    ├── MadMen-Separate-Rows.gif
    ├── bar-plot-1.png
    ├── box-plot-1.png
    ├── box-plot-median.png
    ├── og-box-whisker.png
    ├── pipe-data-args.png
    ├── rstudio-head-madmen.gif
    ├── separate-rows-madmen-head.gif
    └── ylim-1.png

2 directories, 34 files
```

#### 3 e) Notes

Recently added: `separate_rows()` and `ggplot2` geoms with `qplot()`

This extends the previous plotting technique (`qplot()`) with geoms and
introduce
layers.

## 4\) Getting started with data visualization in R using ggplot2 (part 1 of visualize with `ggplot2`)

Split our tutorial into two parts and start with basic layers and
mappings.

### 4 a) Learning Objectives:

1)  Learn mental model for `ggplot2`’s grammar of graphics and the
    standard function call 2) learn basic plots for univariate graphs.

### 4 b) Packages used:

`tidyverse`

### 4 c) Data set(s) used:

### 4 d) Current version

#### Notes

***Need to add ggplot2 template and mental model
image:***

## 5.1) How to manipulate data with dplyr in R (Part 1 = overview of dplyr variable functions)

Change this to use actual survey data from fivethirtyeight’s [Github
account](https://github.com/fivethirtyeight/data/tree/master/masculinity-survey).

**Learning Objectives: **1) dplyr overview (select, pull, count, filter,
mutate, if\_else, case\_when), 2) [naming
things](https://speakerdeck.com/jennybc/how-to-name-files).

### Data set(s) used:raw masculinity [survey data](https://github.com/fivethirtyeight/data/blob/master/masculinity-survey/raw-responses.csv).

# Day 2 (section 2)

*End the first day with data manipulation and some basic visualizations.
The second day we can pick up with more visualizations (the fun stuff)
before getting into more abstract concepts (like iteration, for loops,
etc.).*

## 5.2) How to manipulate data with dplyr in R (Part 2 = overview of dplyr case (row) functions)

Continue with survey data from fivethirtyeight’s [Github
account](https://github.com/fivethirtyeight/data/tree/master/masculinity-survey).
\#\#\# 5.2 a) Learning Objectives

1)  dplyr overview (slice(), filter(), arrange(), add\_row()) 2)
    introduce str\_detect() inside filter() for case\_when() condition.

### 5.2 b) Data set(s) used

raw masculinity [survey
data](https://github.com/fivethirtyeight/data/blob/master/masculinity-survey/raw-responses.csv).

## 6\) **Getting started with data visualization in R using ggplot2 (part **2\*\* of visualize with ggplot2)\*\*

Second part of the ggplot2 tutorial. This adds multivariate plots,
themes, and maps. First objective is to provide lots of code and
examples of customizing ggplot2 with layers, second is to understand how
facetting can aid in understanding
variation.

### Learning Objectives: 1) introduce scatter plots, color aesthetic, adjusting scales, coordinate manipulation, variation (box-plots, violin-plots) 2) faceting vs. plotting relationships.

### Data set(s) used:Lahman::Master, fivethirtyeight::fandango, [World Bank Open Data](https://data.worldbank.org/) (agriculture, industry, and service sector), fivethirtyeight::weather\_check, iris data set (but we should change this to something better).

## 7\) How to merge and clean up multiple CSVs using R (for loops, iterate, functions, intro)

Add a few points but this is generally ok. Need to introduce some
background on for loops, apply functions, and purrr for iteration.

### Learning Objectives:

### Data set(s) used:

## 8\) Getting started with stringr for textual analysis in R

Introduce regex and strings
    manipulations.

    1. **_Need to add _****_web data collection_****_:_****_ _**Add a tutorial on web tools for data collection.

### Learning Objectives:

### Data set(s) used:

## 9\) (Need to create) Collecting data from the web

-----

*Now we have multiple examples we can pull from to demonstrate what
they’ve learned. These can be sprinkled in depending on the
workshop/audience. *

### 9.1) Working with The New York Times API in R

Introduce APIs and how to get data from other web sources.

### 9.2) How to get Twitter data with rtweet in R (twitter api)

Maybe keep/change this because APIs change?

### 9.3) Scraping HTML tables and downloading files with R

This is scraping and more iteration with purrr, so could be part 2 of
web data collection
above?

### 9.4) How to build an animated map of tweets about the NBA finals in R (twitter data animated maps)

Keep this but update with current data or hashtag?

### 9.5) How to plot state-by-state data on a map of the U.S. in R

This is more maps and customizations.

# Day 3 (section 3)

*This is modeling, shiny, or anything else that goes beyond the scope of
importing, wrangling, visualizing, and communicating. *

## 10\) Sentiment analysis of (you guessed it\!) Donald Trump’s tweets

This is a great place to give an example of what can be done with the
tools learned thus far…
