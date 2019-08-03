How to manipulate data with dplyr in R
================
Martin Frigaard
2019-08-03

![](images/04.1-pliers.png)<!-- -->

In the last
[tutorial](http://www.storybench.org/getting-started-with-tidyverse-in-r/)
we introduced the concept of tidy data, which is characterized by having
one observation per row, and one variable per column. We also went over
how to change to shape of our data set with `tidyr` using data sets from
the
[`fivethirtyeight`](https://cran.r-project.org/web/packages/fivethirtyeight/index.html)
package.

For newcomers to R, check out my introductory tutorial for Storybench
[here.](http://www.storybench.org/getting-started-r-rstudio-notebooks/)

## Data manipulation

In this tutorial we will dive a little deeper into data manipulation to
focus on processing and creating variables. Most of the time you’ll need
to do some manipulation in order to get your data into a
structure/arrangement to suit your needs; whether you’re building
models, creating visualizations, or just passing a processed dataset
onto another analyst.

The clearest example of this fact is the paper survey or data collection
form, which has to be re-entered into a separate software environment or
spreadsheet for analysis. Web-based collection tools like [Survey
Monkey](https://www.surveymonkey.com/) and
[Qualtrics](https://www.qualtrics.com/) has made the process easier, but
not perfect. There might be occasions when the data management is
arranged in such a way that allows for a seamless transition between
data collection and analysis, but I think these cases are rare.

### A quick note on terminology

The preparation work for a dataset before analysis or modeling has many
names: munging, wrangling, cleaning, etc. As you can see by the general
theme of these terms, this process is often viewed as the “grunt-work”
of any analysis/modeling project. I prefer the term “Data Carpentry”
from [David Mimno](http://www.mimno.org/articles/carpentry/). I suggest
not thinking of any data set as “dirty.” This implies there is an
immaculate version underneath the grime and that isn’t necessarily true.

> “Looking at data carpentry as a fundamental data skill transforms
> these burdensome, monotonous tasks into a set of bedrock competencies”

For example, say you have a dataset with a variable containing date
information from the `year` down to the `millisecond`, but all you need
is the `month`. The other information is not ‘dirt’ – in fact, you might
later decide you need `month` and `year`.

Every bit in your data set is telling you something, but the information
you need might not be accessible in it’s current state. The carpentry
skills take the data from its current form into a something you can use
to gain insight.

The process doesn’t have to be painful, either\! I’ve found looking at
data carpentry as a fundamental data skill transforms these burdensome,
monotonous tasks into a set of bedrock competencies to take pride in. As
the famous coach John Wooden wrote, “These seemingly trivial matters,
taken together and added to many, many other so-called trivial matters
build into something very big: namely, your success.” Data analysis
isn’t different than college basketball in this sense–mastering the
fundamentals is essential to success.

## Thinking in verbs

The [`tidyverse`](https://www.tidyverse.org/) package for manipulating
data is `dplyr` (pronounced “d-plier”” where “plier” is pronounced just
like the tool). The `dplyr` package comes with an entire grammar for
data manipulation, which uses a small set of verbs to accomplish an
array of data processing tasks. There is a different verb – or “plier” –
for each different data manipulation task. Read about all the different
types of pliers [here](https://en.wikipedia.org/wiki/Pliers)

When you combine dplyr with magrittr, you’ll be able to create data
carpentry pipelines that are efficient and easy to read.

``` r
library(tidyverse)
library(dplyr)
library(magrittr)
```

    #>  
    #>  Attaching package: 'magrittr'

    #>  The following object is masked from 'package:purrr':
    #>  
    #>      set_names

    #>  The following object is masked from 'package:tidyr':
    #>  
    #>      extract

``` r
library(fivethirtyeight)
# data(package = "fivethirtyeight")
```

The first data set we will be using from the `fivethirtyeight` package
is from the article titled, “ [Every mention of the 2016 primary
candidates in hip-hop
songs](https://projects.fivethirtyeight.com/clinton-trump-hip-hop-lyrics/)
“.

To view the status of each data set in the `fivethiryeight` package, you
can look at the Google sheet available [here.](https://goo.gl/S2QMkS)

First we will use the `tbl_df` function from the
[`tibble`](https://tibble.tidyverse.org/) package to put the data set
into the working environment.

Quick tip: 1) to use a particular function within a package you can use
the syntax `package::function`

``` r
hiphop_cand_lyrics <- fivethirtyeight::hiphop_cand_lyrics %>% tbl_df
hiphop_cand_lyrics 
```

    #>  # A tibble: 377 x 8
    #>     candidate     song                 artist              sentiment
    #>     <chr>         <chr>                <chr>               <ord>    
    #>   1 Mike Huckabee None Shall Pass      Aesop Rock          neutral  
    #>   2 Mike Huckabee Wellstone            Soul Khan           negative 
    #>   3 Jeb Bush      Awe                  Dez & Nobs          neutral  
    #>   4 Jeb Bush      The Truth            Diabolic            negative 
    #>   5 Jeb Bush      Money Man            Gorilla Zoe         negative 
    #>   6 Jeb Bush      Hidden Agenda        K-Rino              negative 
    #>   7 Jeb Bush      Bricks and Marijuana Kase                neutral  
    #>   8 Jeb Bush      Bush Song            Macklemore          negative 
    #>   9 Jeb Bush      Shoot Me in the Head R.A. The Rugged Man negative 
    #>  10 Jeb Bush      Chamber of Fear      RZA                 neutral  
    #>     theme   album_release_da… line                     url                  
    #>     <chr>               <int> <chr>                    <chr>                
    #>   1 <NA>                 2011 Wither by the watering … http://genius.com/Ae…
    #>   2 <NA>                 2012 Might find the door but… http://genius.com/So…
    #>   3 <NA>                 2006 I heard Jeb Bush lookin… http://genius.com/De…
    #>   4 politi…              2006 What you heard before a… http://genius.com/Di…
    #>   5 person…              2007 I'm comin back from Flo… http://genius.com/Go…
    #>   6 politi…              2012 The Rockefeller's and t… http://genius.com/K-…
    #>   7 <NA>                 2001 When Jeb Bush pushing l… http://genius.com/Tr…
    #>   8 politi…              2005 Way to go Jeb, really g… http://genius.com/Ma…
    #>   9 politi…              2013 Obama nation, the Bushe… http://genius.com/Ra…
    #>  10 person…              2005 Bobby got Bush like Geo… http://genius.com/Rz…
    #>  # … with 367 more rows

The first verb we will use to explore this data set is `select()`.

## `select()`

`select()` works on variables (columns). For example, we can use it to
pick out a single column, like the candidate’s name (`candidate`):

``` r
hiphop_cand_lyrics %>% 
    dplyr::select(candidate) %>% 
    glimpse()
```

    #>  Observations: 377
    #>  Variables: 1
    #>  $ candidate <chr> "Mike Huckabee", "Mike Huckabee", "Jeb Bush", "Jeb Bush",…

Quick tip: The `glimpse()` function is also from the `tibble` package
and is very handy for viewing data frames (or tibbles). The result
prints out the variables transposed as rows, the variable class (`<chr>`
in this case), and as much of the data as that will fit on the screen.

Let’s assume for our current purpose, we don’t need the `url`. There are
a few ways we can remove this variable.

First, we can use the `select()` function to name the variables we want
explicitly. We can also use this opportunity to reorder the variables in
our data set and rename the `album_release_date` to something a little
easier to write, like date.

``` r
hiphop_cand_lyrics %>% 
    dplyr::select(
        candidate,
        date = album_release_date,
        song,
        artist,
        sentiment,
        theme,
        line) %>% glimpse()
```

    #>  Observations: 377
    #>  Variables: 7
    #>  $ candidate <chr> "Mike Huckabee", "Mike Huckabee", "Jeb Bush", "Jeb Bush",…
    #>  $ date      <int> 2011, 2012, 2006, 2006, 2007, 2012, 2001, 2005, 2013, 200…
    #>  $ song      <chr> "None Shall Pass", "Wellstone", "Awe", "The Truth", "Mone…
    #>  $ artist    <chr> "Aesop Rock", "Soul Khan", "Dez & Nobs", "Diabolic", "Gor…
    #>  $ sentiment <ord> neutral, negative, neutral, negative, negative, negative,…
    #>  $ theme     <chr> NA, NA, NA, "political", "personal", "political", NA, "po…
    #>  $ line      <chr> "Wither by the watering hole, Border patrol / What are we…

But if our data set has a ton of variables, we can always just select
the variables we want to remove using a `-` symbol.

``` r
hiphop_cand_lyrics %>% 
    dplyr::select(
        -(url),
        date = album_release_date) %>% 
    glimpse()
```

    #>  Observations: 377
    #>  Variables: 7
    #>  $ candidate <chr> "Mike Huckabee", "Mike Huckabee", "Jeb Bush", "Jeb Bush",…
    #>  $ song      <chr> "None Shall Pass", "Wellstone", "Awe", "The Truth", "Mone…
    #>  $ artist    <chr> "Aesop Rock", "Soul Khan", "Dez & Nobs", "Diabolic", "Gor…
    #>  $ sentiment <ord> neutral, negative, neutral, negative, negative, negative,…
    #>  $ theme     <chr> NA, NA, NA, "political", "personal", "political", NA, "po…
    #>  $ date      <int> 2011, 2012, 2006, 2006, 2007, 2012, 2001, 2005, 2013, 200…
    #>  $ line      <chr> "Wither by the watering hole, Border patrol / What are we…

We also need to explicitly assign these variables to a new data frame
with the variables we’ve selected.

``` r
(hiphop <- hiphop_cand_lyrics %>% 
    dplyr::select(
        candidate,
        date = album_release_date,
        song,
        artist,
        sentiment,
        theme,
        line))
```

    #>  # A tibble: 377 x 7
    #>     candidate      date song                 artist              sentiment
    #>     <chr>         <int> <chr>                <chr>               <ord>    
    #>   1 Mike Huckabee  2011 None Shall Pass      Aesop Rock          neutral  
    #>   2 Mike Huckabee  2012 Wellstone            Soul Khan           negative 
    #>   3 Jeb Bush       2006 Awe                  Dez & Nobs          neutral  
    #>   4 Jeb Bush       2006 The Truth            Diabolic            negative 
    #>   5 Jeb Bush       2007 Money Man            Gorilla Zoe         negative 
    #>   6 Jeb Bush       2012 Hidden Agenda        K-Rino              negative 
    #>   7 Jeb Bush       2001 Bricks and Marijuana Kase                neutral  
    #>   8 Jeb Bush       2005 Bush Song            Macklemore          negative 
    #>   9 Jeb Bush       2013 Shoot Me in the Head R.A. The Rugged Man negative 
    #>  10 Jeb Bush       2005 Chamber of Fear      RZA                 neutral  
    #>     theme     line                                                          
    #>     <chr>     <chr>                                                         
    #>   1 <NA>      Wither by the watering hole, Border patrol / What are we to H…
    #>   2 <NA>      Might find the door but never touch the key / They get tricke…
    #>   3 <NA>      I heard Jeb Bush looking for a (inaudible)                    
    #>   4 political What you heard before ain't as big of a lesson / As George an…
    #>   5 personal  I'm comin back from Florida / Wit Jeb Bush and his daughter   
    #>   6 political The Rockefeller's and the Bush family in the same box G / Hen…
    #>   7 <NA>      When Jeb Bush pushing life / If I tout my weapon              
    #>   8 political Way to go Jeb, really great strategy                          
    #>   9 political Obama nation, the Bushes, the Clintons or '80s Reaganomics / …
    #>  10 personal  Bobby got Bush like George and Jeb                            
    #>  # … with 367 more rows

Quick Tip: In RStudio, you can get the command to print in a notebook or
R Markdown file by enclosing the call in parentheses `()`.

`select()` also comes with a lot of handy pattern matching abilities on
column names. For example, we can use the matches function to look for
variables that contain a specific character.

Say we only wanted variables that had the letter `t` in them.

``` r
hiphop %>% 
    dplyr::select(matches("t")) %>% 
    glimpse()
```

    #>  Observations: 377
    #>  Variables: 5
    #>  $ candidate <chr> "Mike Huckabee", "Mike Huckabee", "Jeb Bush", "Jeb Bush",…
    #>  $ date      <int> 2011, 2012, 2006, 2006, 2007, 2012, 2001, 2005, 2013, 200…
    #>  $ artist    <chr> "Aesop Rock", "Soul Khan", "Dez & Nobs", "Diabolic", "Gor…
    #>  $ sentiment <ord> neutral, negative, neutral, negative, negative, negative,…
    #>  $ theme     <chr> NA, NA, NA, "political", "personal", "political", NA, "po…

You can also use periods as placeholders (as in regular expressions) to
select variables that only have a `t` in the third position or after,
but not in the first or second (i.e. omitting the `theme` variable).

``` r
hiphop %>% 
    dplyr::select(matches(".t")) %>% 
    #                      candidate
    #                      artist
    #                      date
    #                      sentiment
    #                      but not 'theme'
    glimpse()
```

    #>  Observations: 377
    #>  Variables: 4
    #>  $ candidate <chr> "Mike Huckabee", "Mike Huckabee", "Jeb Bush", "Jeb Bush",…
    #>  $ date      <int> 2011, 2012, 2006, 2006, 2007, 2012, 2001, 2005, 2013, 200…
    #>  $ artist    <chr> "Aesop Rock", "Soul Khan", "Dez & Nobs", "Diabolic", "Gor…
    #>  $ sentiment <ord> neutral, negative, neutral, negative, negative, negative,…

There are different ways to pick columns based on the column names:

## `filter()`

The `filter()` command works on observations the same way `select()`
works on variables. Lets say we are looking for observations that
contain song lyrics that were only referring to `“Jeb Bush”`. We can do
this using the double equal symbol `==`:

``` r
hiphop %>% filter(candidate == "Jeb Bush") %>% glimpse()
```

    #>  Observations: 9
    #>  Variables: 7
    #>  $ candidate <chr> "Jeb Bush", "Jeb Bush", "Jeb Bush", "Jeb Bush", "Jeb Bush…
    #>  $ date      <int> 2006, 2006, 2007, 2012, 2001, 2005, 2013, 2005, 2005
    #>  $ song      <chr> "Awe", "The Truth", "Money Man", "Hidden Agenda", "Bricks…
    #>  $ artist    <chr> "Dez & Nobs", "Diabolic", "Gorilla Zoe", "K-Rino", "Kase"…
    #>  $ sentiment <ord> neutral, negative, negative, negative, neutral, negative,…
    #>  $ theme     <chr> NA, "political", "personal", "political", NA, "political"…
    #>  $ line      <chr> "I heard Jeb Bush looking for a (inaudible)", "What you h…

We can also `filter()` with multiple criteria. We can use the `%in%` to
identify lyrics referring to `“Jeb Bush”` or `“Chris Christie”`.

``` r
hiphop %>% 
    filter(candidate %in% c("Jeb Bush", 
                            "Chris Christie")) %>% glimpse()
```

    #>  Observations: 11
    #>  Variables: 7
    #>  $ candidate <chr> "Jeb Bush", "Jeb Bush", "Jeb Bush", "Jeb Bush", "Jeb Bush…
    #>  $ date      <int> 2006, 2006, 2007, 2012, 2001, 2005, 2013, 2005, 2005, 201…
    #>  $ song      <chr> "Awe", "The Truth", "Money Man", "Hidden Agenda", "Bricks…
    #>  $ artist    <chr> "Dez & Nobs", "Diabolic", "Gorilla Zoe", "K-Rino", "Kase"…
    #>  $ sentiment <ord> neutral, negative, negative, negative, neutral, negative,…
    #>  $ theme     <chr> NA, "political", "personal", "political", NA, "political"…
    #>  $ line      <chr> "I heard Jeb Bush looking for a (inaudible)", "What you h…

We can also use logical operators (`>`, `>=`, `<`, `<=`, `!=`, `==`) to
filter any numerical variables.

``` r
hiphop %>% # all observations after 2005 and before or on 2014
    filter(date > 2005 & date <= 2014) %>% 
    glimpse() 
```

    #>  Observations: 202
    #>  Variables: 7
    #>  $ candidate <chr> "Mike Huckabee", "Mike Huckabee", "Jeb Bush", "Jeb Bush",…
    #>  $ date      <int> 2011, 2012, 2006, 2006, 2007, 2012, 2013, 2011, 2014, 201…
    #>  $ song      <chr> "None Shall Pass", "Wellstone", "Awe", "The Truth", "Mone…
    #>  $ artist    <chr> "Aesop Rock", "Soul Khan", "Dez & Nobs", "Diabolic", "Gor…
    #>  $ sentiment <ord> neutral, negative, neutral, negative, negative, negative,…
    #>  $ theme     <chr> NA, NA, NA, "political", "personal", "political", "politi…
    #>  $ line      <chr> "Wither by the watering hole, Border patrol / What are we…

`filter()` also comes with three
[scoped](https://dplyr.tidyverse.org/reference/filter_all.html)
variations. For example, we can use `filter_all` to return all variables
and observations that are greater than `2005`

``` r
hiphop %>% filter_all(any_vars(. > 2005)) %>% glimpse()
```

    #>  Observations: 377
    #>  Variables: 7
    #>  $ candidate <chr> "Mike Huckabee", "Mike Huckabee", "Jeb Bush", "Jeb Bush",…
    #>  $ date      <int> 2011, 2012, 2006, 2006, 2007, 2012, 2001, 2005, 2013, 200…
    #>  $ song      <chr> "None Shall Pass", "Wellstone", "Awe", "The Truth", "Mone…
    #>  $ artist    <chr> "Aesop Rock", "Soul Khan", "Dez & Nobs", "Diabolic", "Gor…
    #>  $ sentiment <ord> neutral, negative, neutral, negative, negative, negative,…
    #>  $ theme     <chr> NA, NA, NA, "political", "personal", "political", NA, "po…
    #>  $ line      <chr> "Wither by the watering hole, Border patrol / What are we…

Because date is the only variable with numeric values, we know this new
data frame only contains observations after `2005`.

## `mutate()`

Often times you’ll want to create a new variable based on existing
variables. We will create a new variable called (`new_2010`) and base it
on songs that were released before or after `2010`. A song will be
considered new if it was released on or after 2010, and not new if it
was before 2010. In order to do this we will need to introduce another
handy tool for creating new variables, `if_else`.

The components to this function are pretty straightforward.

``` r
if_else(condition, true, false, missing = NULL)
```

It takes a condition, evaluates it, then returns a value based on it
being true or false.

``` r
hiphop %>% 
    mutate(new_2010 = 
       if_else(condition = date >= 2010,
               true = "new song",
               false = "not new")) %>% glimpse()
```

    #>  Observations: 377
    #>  Variables: 8
    #>  $ candidate <chr> "Mike Huckabee", "Mike Huckabee", "Jeb Bush", "Jeb Bush",…
    #>  $ date      <int> 2011, 2012, 2006, 2006, 2007, 2012, 2001, 2005, 2013, 200…
    #>  $ song      <chr> "None Shall Pass", "Wellstone", "Awe", "The Truth", "Mone…
    #>  $ artist    <chr> "Aesop Rock", "Soul Khan", "Dez & Nobs", "Diabolic", "Gor…
    #>  $ sentiment <ord> neutral, negative, neutral, negative, negative, negative,…
    #>  $ theme     <chr> NA, NA, NA, "political", "personal", "political", NA, "po…
    #>  $ line      <chr> "Wither by the watering hole, Border patrol / What are we…
    #>  $ new_2010  <chr> "new song", "new song", "not new", "not new", "not new", …

NOTE: Avoid using periods (`.`) in the names of variables (or anything
in R, really) because it can mess with R’s programming model. Either use
`snake_case` or `CamelCase`, but try to pick one and stick with it so
its easier for people to follow.

This is helpful, but most of these data are text. The article
categorized the mentions of candidates by their `sentiment` (“negative”,
“neutral”, “positive”), but what if we also wanted to see if the lyrics
contained obscenities (specifically, the word “fuck.”).

This isn’t just out of a juvenile interest in vulgar and lewd language.
The use of obscene language has been used as a reason for certain albums
to be censored or receive a “Parental Advisory: Explicit Content” label
( [see 2 Live
Crew](https://www.washingtonpost.com/news/the-fix/wp/2015/06/11/25-years-ago-2-live-crew-were-arrested-for-obscenity-heres-the-fascinating-back-story/?utm_term=.70b822dcf00f)
).

I want to know how the use of the word “fuck” relates to the three
categories of `sentiment`. I can do this by creating a new variable
called `lewd_lang` that has the values “fucks” and “zero fucks”.

We will use the `mutate()` function, and also introduce the grepl
function for dealing with text variables. Read about `grepl`.

``` r
grepl(pattern, x, ignore.case = FALSE, perl = FALSE,
      fixed = FALSE, useBytes = FALSE)
```

“search for matches to argument pattern within each element of a
character vector”

We will use the `grepl` command with `if_else`, but also use the
`filter` function to return the observations with lewd language.

``` r
hiphop %>% 
    mutate(lewd_lang = 
               if_else(grepl("fuck", line), 
                            "fucks", "zero fucks")) %>% 
                filter(lewd_lang == "fucks") %>% glimpse()
```

    #>  Observations: 29
    #>  Variables: 8
    #>  $ candidate <chr> "Ted Cruz", "Hillary Clinton", "Hillary Clinton", "Hillar…
    #>  $ date      <int> 2015, 2013, 2012, 2007, 2008, 1999, 1994, 2015, 2008, 199…
    #>  $ song      <chr> "PNT", "Shorty Baby", "No Church in the Wild Freestyle", …
    #>  $ artist    <chr> "Apollo Brown & Ras Kass", "Bas", "Angel Haze", "Rhymefes…
    #>  $ sentiment <ord> negative, negative, negative, positive, negative, negativ…
    #>  $ theme     <chr> "political", "personal", "political", "money", "political…
    #>  $ line      <chr> "Fuck Fox News and fuck Ted Cruz", "Makin me call Lewinsk…
    #>  $ lewd_lang <chr> "fucks", "fucks", "fucks", "fucks", "fucks", "fucks", "fu…

Now, the final command we will use can give us a cross-tabulation of how
many songs contained lewd language by their sentiment (i.e “negative”,
“neutral”, or “positive”).

### `count()`

The `count()` function is one you’ll use constantly if you deal with
categorical or nominal variables (i.e. non-numeric values). `count()`
actually combines three functions, `group_by()`, `tally()`, and
`ungroup()`.

When we use `count()` with one variable, we get the relative
distribution in each value (or level) of the variable. We can test this
new function out on the theme variable.

``` r
theme = "Theme of lyric"
hiphop %>% 
    count(theme)
```

    #>  # A tibble: 8 x 2
    #>    theme              n
    #>    <chr>          <int>
    #>  1 hotel             68
    #>  2 money            107
    #>  3 personal          47
    #>  4 political         52
    #>  5 power              2
    #>  6 sexual             4
    #>  7 The Apprentice    18
    #>  8 <NA>              79

[Jenny Bryan](https://twitter.com/JennyBryan) was nice enough to compile
a list of methods from a
[tweet](https://twitter.com/JennyBryan/status/599379158452416512) for
creating cross tabulations. Feel free to experiment with all of them
(found [here](https://gist.github.com/jennybc/04b71bfaaf0f88d9d2eb) )

For example, we can get a cross tabulation using a function from the
`tidyr` function (`spread()`) we covered in the last tutorial.

``` r
hiphop %>% 
    mutate(lewd_lang = 
    if_else(grepl("fuck", line), 
                  "fucks", "zero fucks")) %>% 
    count(sentiment, lewd_lang) %>% 
    spread(sentiment, n)
```

    #>  # A tibble: 2 x 4
    #>    lewd_lang  negative neutral positive
    #>    <chr>         <int>   <int>    <int>
    #>  1 fucks            17       8        4
    #>  2 zero fucks       54     120      174

We can extend this further and use `mutate()` with the `prop.table`
function to get relative the percentages in each category.

``` r
hiphop %>% 
    mutate(lewd_lang = 
    if_else(grepl("fuck", line), 
                  "fucks", "zero fucks")) %>% 
    count(sentiment, lewd_lang) %>% 
    mutate(prop = prop.table(n)) %>% 
    spread(sentiment, n)
```

    #>  # A tibble: 6 x 5
    #>    lewd_lang    prop negative neutral positive
    #>    <chr>       <dbl>    <int>   <int>    <int>
    #>  1 fucks      0.0106       NA      NA        4
    #>  2 fucks      0.0212       NA       8       NA
    #>  3 fucks      0.0451       17      NA       NA
    #>  4 zero fucks 0.143        54      NA       NA
    #>  5 zero fucks 0.318        NA     120       NA
    #>  6 zero fucks 0.462        NA      NA      174
