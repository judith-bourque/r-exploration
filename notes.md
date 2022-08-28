r-exploration notes
================
Judith Bourque
2022-08-27

# Overview

A collection of quick notes and References for personal use.

Please note this is a work in progress.

# R basics

References

-   [Introduction to R](http://r.sund.ku.dk/index.html)
-   [RStudio
    Cheatsheets](https://www.rstudio.com/resources/cheatsheets/)
-   [Using R and RStudio for Data Management, Statistical Analysis, and
    Graphics](https://englianhu.files.wordpress.com/2016/01/using-r-and-rstudio-for-data-management-statistical-analysis-and-graphics-2nd-edit.pdf)
-   [ProgrammingR](https://www.programmingr.com/)
-   [Advanced R](https://adv-r.hadley.nz/index.html)
-   [Efficient R programming](https://csgillespie.github.io/efficientR/)

# Workflow

Programs

-   R
-   RStudio
-   GitHub: git repository
-   GitBash: command line

New project setup

1.  Create and clone repository from GitHub
2.  Create .Rproject
3.  Use `renv::init()` to initialize renv with a new or existing
    project. Enter autorisations needed.
4.  Set up .gitignore

File and folder structure

-   /R: contains .R files
-   /graphs: contains graphs
-   README.md: describe the project

| name       | purpose                                                                                                                                  | extension |
|:-----------|:-----------------------------------------------------------------------------------------------------------------------------------------|:----------|
| R script   | analysis mode and want a report as a side effect                                                                                         | .R        |
| R Markdown | writing a report with a lot of R code in it                                                                                              | .Rmd      |
| R Notebook | R Markdown document with chunks that can be executed independently and interactively, with output visible immediately beneauth the input |           |

R file types

References

-   [Streamline workflows in
    R](https://jules32.github.io/streamlined-workflows/#1)

# Renv

Your project may make use of packages which are available from remote
sources requiring some form of authentication to access. Usually, either
a personal access token (PAT) or username + password combination is
required for authentication. renv is able to authenticate when
downloading from such sources.

Credentials can be stored in .Renviron, or can be set in your R session
through other means as appropriate.

If you require custom authentication for different packages (for
example, your project makes use of packages available on different
GitHub enterprise servers), you can use the renv.auth R option to
provide package-specific authentication settings. renv.auth can either
be a a named list associating package names with environment variables,
or a function accepting a package name + record, and returning a list of
environment variables. For example:

    # define a function providing authentication
    options(renv.auth = function(package, record) {
          if (package == "MyPackage")
            return(list(GITHUB_PAT = "<pat>"))
        })

    # use a named list directly
        options(renv.auth = list(
          MyPackage = list(GITHUB_PAT = "<pat>")
        ))

        # alternatively, set package-specific option
        options(renv.auth.MyPackage = list(GITHUB_PAT = "<pat>"))

## .Rprofile

.Rprofile files are user-controllable files to set options and
environment variables. `.Rprofile` files can be either at the user or
project level. User-level .Rprofile files live in the base of the user’s
home directory, and project-level .Rprofile files live in the base of
the project directory.

R will source only one .Rprofile file. So if you have both a
project-specific .Rprofile file and a user .Rprofile file that you want
to use, you explicitly source the user-level .Rprofile at the top of
your project-level .Rprofile with source(“\~/.Rprofile”).

.Rprofile files are sourced as regular R code, so setting environment
variables must be done inside a Sys.setenv(key = “value”) call.

One easy way to edit your .Rprofile file is to use the
usethis::edit_r\_profile() function from within an R session. You can
specify whether you want to edit the user or project level .Rprofile.

## .Renviron

.Renviron is a user-controllable file that can be used to create
environment variables. This is especially useful to avoid including
credentials like API keys inside R scripts. This file is written in a
key-value format, so environment variables are created in the format:

    Key1=value1
    Key2=value2

And then Sys.getenv(“Key1”) will return “value1” in an R session.

Like with the .Rprofile file, .Renviron files can be at either the user
or project level. If there is a project-level .Renviron, the user-level
file will not be sourced. The usethis package includes a helper function
for editing .Renviron files from an R session with
`usethis::edit_r_environ()`.

References

-   [renv](https://rstudio.github.io/renv/articles/renv.html#authentication):
    documentation
-   [Managing R with .Rprofile, .Renviron, Rprofile.site, Renviron.site,
    rsession.conf, and
    repos.conf](https://support.rstudio.com/hc/en-us/articles/360047157094-Managing-R-with-Rprofile-Renviron-Rprofile-site-Renviron-site-rsession-conf-and-repos-conf#:~:text=Rprofile%20files%20are%20user%2Dcontrollable,base%20of%20the%20project%20directory.)

# Git and GitHub

| command          | purpose                                        |
|:-----------------|:-----------------------------------------------|
| cd               |                                                |
| cd ..            |                                                |
| git status       | View project changes                           |
| git diff         | View difference in file                        |
| git add          |                                                |
| git add -A       | Add all files                                  |
| git commit -m “” |                                                |
| git push         |                                                |
| git pull         |                                                |
| git rm –cached   | stop tracking a file that is currently tracked |

git commands

``` r
# Initialise git directory
use_this::use_git()
```

References

-   [Happy Git and GitHub for the useR:
    Installation](https://happygitwithr.com/install-intro.html): course

## gitignore

A `.gitignore` file is a plain text file where each line contains a
pattern for files/directories to ignore. Generally, this is placed in
the root folder of the repository, and that’s what I recommend. However,
you can put it in any folder in the repository and you can also have
multiple `.gitignore` files. The patterns in the files are relative to
the location of that `.gitignore` file.

| code | purpose                                 |
|:-----|:----------------------------------------|
| \*   | Matches 0 or more characters, except /  |
| !    | Not ignore a file that would be ignored |
| \#   | Comments                                |

.gitignore code

`.gitignore` options

    # Private files
    _*

To ignore some files in all repositories on your computer, put them in a
global `.gitignore` file. First, you have to add a setting to Git with
this command:

    git config --global core.excludesFile ~/.gitignore

To ignore a currently tracked file, use this command:

    git rm --cached FILENAME

References

-   [gitignore](https://git-scm.com/docs/gitignore): official
    documentation

## GitHub Flavored Markdown

References

-   [Writing on
    GitHub](https://docs.github.com/en/get-started/writing-on-github):
    tips for GitHub flavored markdown and other writing formats
-   [Github Flavored Markdown
    cheatsheet](https://gist.github.com/stevenyap/7038119)

# R Markdown

| package    | definition                                              |
|:-----------|:--------------------------------------------------------|
| knitr      | NA                                                      |
| rmarkdown  | reproducible documents                                  |
| thesisdown | reproducible thesis                                     |
| bookdown   | Write HTML, PDF, ePub, and Kindle books with R Markdown |

R markdown packages

References

-   [R Markdown: The Definitive
    Guide](https://bookdown.org/yihui/rmarkdown/)
-   [R Markdown from
    RStudio](https://rmarkdown.rstudio.com/lesson-1.html)
-   [R Markdown Reference
    guide](https://www.rstudio.com/wp-content/uploads/2015/03/rmarkdown-reference.pdf?_ga=2.164587583.1800627063.1648159135-864680125.1644240072)
-   [R Markdown Formats](https://rmarkdown.rstudio.com/formats.html)
-   [R Markdown
    Cookbook](https://bookdown.org/yihui/rmarkdown-cookbook/)
-   [RMarkdown how
    to](http://www.ece.ualberta.ca/~terheide/rmarkdown-how-to/markdown.html#more_information)
-   [bookdown: Authoring Books and Technical Documents with R
    Markdown](https://bookdown.org/yihui/bookdown/)
-   [Bookdown](https://github.com/rstudio/bookdown)
-   [Branding and automating your work with R
    Markdown](https://www.rstudio.com/resources/rstudioconf-2018/branding-and-automating-your-work-with-r-markdown/)

## YAML

Optional header surrounded by `---`

``` r
---
title: "Title of my Document"
subtitle: "Subtitle of my Document"
author: "Judith Bourque"
# Date updates automatically
date: '`r Sys.Date()`'
output: 
  github_document:
  # Table of contents
    toc: true
    number_sections: true
# Parameters set values automatically
params:
  data: "data"
---
```

When you put output as github_document, you will knit a .md. Useful as
it is a GitHub friendly markdown document and quite pleasant to look at.

Parameters are values you can set when you render the report. They help
to re-render the same report with distinct values for various key
inputs.

To access a parameter in code, call `params$<parameter name>`.

### Output formats

Documents

-   `github_document`: GitHub Flavored Markdown document
-   `md_document`
-   `pdf_document`: PDF document (via LaTeX template)
-   `word_document` Mirosoft Word document (docx)
-   `context_document`
-   `html_document`
-   `latex_document`
-   `odt_document`: OpenDocument Text document
-   `rtf_document`

Interactive documents

-   `htmlwidgets`: package
-   `shiny`: package
-   `html_notebook`: Interactive R Notebooks

Presentations

-   `powerpoint_presentation`
-   `beamer_presentation`: PDF presentation with LaTeX Beamer
-   `slidy_presentation`

Other

-   `flexdashboard::flex_dashboard`: interactive dashboards

Resource

-   [Output formats](https://rmarkdown.rstudio.com/lesson-9.html)

### Render output

If you don’t want to knit, run the `render` command

``` r
library(rmarkdown)
render("example.Rmd")
```

## Headers

``` md
# Numbered header
# Unnumbered header {-}
# Also unnumbered header {.unnumbered}
```

## Markdown Syntax

| syntax           | code                                        |
|:-----------------|:--------------------------------------------|
| Images           | `![alt text or image title](path/to/image)` |
| Footnotes        | `^[This is a footnote.]`                    |
| Horizontal rules | three or more of \*, -, \_                  |

Pandoc’s Markdown

Resource

-   [Pandoc User’s Guide](https://pandoc.org/MANUAL.html)

## Tables

Display options for data frames and matrixes

-   Default: like in the R terminal
-   `knitr::kable`: pretty

Code for creating a table using a new data frame

``` r
# ```{r echo = FALSE}
df <- data.frame(
  column1 = c(
    "1",
    "2",
    "3",
    "4",
    "5"),
  column2 = c(
    "1",
    "2",
    "3",
    "4",
    "5"))
knitr::kable(df, caption = "caption")
# ```
```

## Code chunks

Code chunks can be run individually in RStudio by clicking the green
arrow pointing right.

Code chunks start with ```` ```{} ```` and ends with ```` ``` ````.

``` r
# ```{r}
# ```
```

| option            | purpose                                                                                                                                               |
|:------------------|:------------------------------------------------------------------------------------------------------------------------------------------------------|
| `include = FALSE` | prevents code and results from appearing in the output file. R Markdown still runs the code in the chunk, and the results can be used by other chunks |
| `echo = FALSE`    | prevents code, but not the results from appearing in the finished file. Good to embed figures                                                         |
| `message = FALSE` | prevents messages that are generated by code from appearing in the finished file                                                                      |
| `warning = FALSE` | prevents warnings that are generated by code from appearing in the finished                                                                           |
| `fig.cap = "..."` | adds a caption to graphical results                                                                                                                   |
| `eval = FALSE`    |                                                                                                                                                       |

Code chunk options

Global options

To set global options that apply to every chunk in your file, call
`knitr::opts_chunk$set` in a code chunk. Knitr will treat each option
that you pass to `knitr::opts_chunk$set` as a global default that can be
overwritten in individual chunk headers.

## Inline code

Insert code results directly by enclosing the code with `` `r ` ``

Example: `There are 10 individuals.` becomes
`` There are `nrow(my_data)` individuals. ``

To include *n* literal backticks, use at least *n + 1* backticks
outside, e.g., you can use four backticks to preserve three backtick
inside ````` ```` ```code``` ```` `````, which is rendered as
```` ```code``` ````.

## Citations

BibTeX databases: plain-texte file with filename extension `.bib`. Tool
and a file format which are used to describe and process lists of
references, mostly in conjunction with LaTeX documents.

``` r
@Manual{R-base,
  title = {R: A Language and Environment for Statistical
    Computing},
  author = {{R Core Team}},
  organization = {R Foundation for Statistical Computing},
  address = {Vienna, Austria},
  year = {2017},
  url = {https://www.R-project.org/},
}
```

References

-   [Citation Management and Writing Tools: LaTeX and
    BibTex](https://libguides.mit.edu/cite-write/bibtex)
-   [BibTex](http://www.bibtex.org/)
-   [JabRef](https://www.jabref.org/#): open-source reference manager
    compatible with BibTex. Works on Windows.

## Blockquotes

Code

``` md
> "This is a quote that can be long and go until another line."
>
> --- Author
```

Output

> “This is a quote that can be long and go until another line.”
>
> — Author

# R for data science

References

-   [R for Data Science](https://r4ds.had.co.nz/index.html)
-   [R Programming for Data
    Science](https://bookdown.org/rdpeng/rprogdatascience/)
-   [R for Data Science: Exercice
    Solutions](https://jrnold.github.io/r4ds-exercise-solutions/)
-   [R for Graduate
    Students](https://bookdown.org/yih_huynh/Guide-to-R-Book/)
-   [thesisdown](https://github.com/ismayc/thesisdown)
-   [Statistical Inference via Data Science](https://moderndive.com/)
-   [Introduction to Data Science](https://rafalab.github.io/dsbook/)
-   [STAT 545 Data wrangling, exploration, and analysis with
    R](https://stat545.com/index.html) (course)

## Tidyverse package

`tidyverse` is a collection of R packages designed for data science.

Core packages loaded automatically with `library(tidyverse)`

| package | definition                                                                            |
|:--------|:--------------------------------------------------------------------------------------|
| dplyr   | manipulate data                                                                       |
| forcats | tools to work with factors                                                            |
| ggplot2 | create graphics                                                                       |
| purrr   | loops                                                                                 |
| readr   | read rectangular data (csv, tsv)                                                      |
| stringr | functions to work with strings                                                        |
| tibble  | data frame 2.0, they do less and complain more forcing you to adress problems earlier |
| tidyr   | tidy data                                                                             |

Theme packages

References

-   [Tidyverse](https://www.tidyverse.org/)
-   [The Tidyverse
    Cookbook](https://rstudio-education.github.io/tidyverse-cookbook/index.html)
-   [Learn to
    purrr](https://www.rebeccabarter.com/blog/2019-08-19_purrr/#:~:text=Purrr%20is%20one%20of%20those,purrr%20is%20all%20about%20iteration.)
-   [Forcats](https://forcats.tidyverse.org/reference/fct_reorder.html)

# Data import

Workflow

-   If authentification is required to access the data, update
    `.Renviron` file using `usethis::edit_r_environ()`

References

-   [Databases using R](https://db.rstudio.com/getting-started/)
-   [10 Easy Steps to a Complete Understanding of
    SQL](https://blog.jooq.org/10-easy-steps-to-a-complete-understanding-of-sql/)
-   [SQL Query Planning](https://www.sqlite.org/queryplanner.html)

## API wrapper packages

| package        | definition                                                                                            |
|:---------------|:------------------------------------------------------------------------------------------------------|
| pageviews      | retrieve wikimedia pageviews                                                                          |
| spotifyr       | R package for Spotify API                                                                             |
| tidywikidatar  | read and query Wikidata in a tidy format                                                              |
| waxer          | querying Wikimedia Analytics Query Service in R                                                       |
| WikidataR      | read and query wikidata. Uses Wikidata and Quickstatements APIs.                                      |
| wikipediatrend | read and query Wikidata in a tidy format                                                              |
| WikipediR      | wrapper for MediaWiki API                                                                             |
| wmfastr        | Speedily computes various dwelltime and preference-related metrics in the context of search sessions. |
| wmfdata        | for working with Wikimedia data in R                                                                  |

API wrapper packages

### Wikipedia

-   [waxer](https://github.com/wikimedia/waxer): querying Wikimedia
    Analytics Query Service in R.
-   [tidywikidatar](https://edjnet.github.io/tidywikidatar/index.html):
    read and query Wikidata in a tidy format
-   [wmfastr](https://github.com/wikimedia/wmfastr): Speedily computes
    various dwelltime and preference-related metrics in the context of
    search sessions.
-   [wmfdata](https://github.com/wikimedia/wmfdata-r): for working with
    Wikimedia data in R
-   WikidataQueryServiceR: R wrapper for Wikidata Query Service
-   [A new R package for exploring the wealth of information stored by
    Wikidata:
    tidywikidatar](https://medium.com/european-data-journalism-network/a-new-r-package-for-exploring-the-wealth-of-information-stored-by-wikidata-fe85e82b6440)

### Spotify

To set up spotifyr, in the app settings, fill in Redirect URls with
<http://localhost:1410/>.

Item IDs are the base-62 identifier (string of letters and numbers)
between `/` and `?` at the end of the Spotify URI for an artist, track,
album, playlist, etc.

# Data analysis

References

-   [Exploratory Data
    Analysis](https://mgimond.github.io/ES218/Week01.html)
-   [Geocomputation with R](https://geocompr.robinlovelace.net/):
    geographic data analysis

## Text mining

-   [Welcome to Text Mining with
    R](https://www.tidytextmining.com/index.html)
-   [Notes for “Text Mining with R: A Tidy
    Approach”](https://bookdown.org/Maxine/tidy-text-mining/)
-   [Work with strings with stringr cheat
    sheet](https://evoldyn.gitlab.io/evomics-2018/ref-sheets/R_strings.pdf)
-   [Stringr](https://stringr.tidyverse.org/) (see cheat sheet for
    regex)
-   [What Every Programmer Absolutely, Positively Needs To Know About
    Encodings And Character Sets To Work With
    Text](https://kunststube.net/encoding/)

# Data visualization

| package         | definition                                                                                                         |
|:----------------|:-------------------------------------------------------------------------------------------------------------------|
| cowplot         | Streamlined plot theme and plot annotations for ggplot2                                                            |
| fivethirtyeight | package containing data from the website and theme for similar aesthetic ggplot                                    |
| geofacet        | geofaceting functionality for ggplot2                                                                              |
| geogrid         | Turn geospatial polygons like states, counties or local authorities into regular or hexagonal grids automatically. |
| gganimate       | animate plot                                                                                                       |
| ggetch          | Tech themes and scales                                                                                             |
| ggplot2         | create graphics                                                                                                    |
| ggpmisc         | ggplot2 extension which includes tables                                                                            |
| ggpomological   | water-colour look for figures                                                                                      |
| ggrepel         | repel labels from overlap                                                                                          |
| ggridges        | create ridges                                                                                                      |
| ggspatial       | Spatial data plus the power of the ggplot2 framework                                                               |
| ggthemes        | Some extra geoms, scales, and themes for ggplot.                                                                   |
| gt              | create tables in R                                                                                                 |
| gtextras        | add-on to gt that lets you add visualizations into tables                                                          |
| highcharter     | show and hide graph elements (and option to download graph)                                                        |
| hrbrthemes      | Additional Themes and Theme Components for ‘ggplot2’                                                               |
| leaflet         | interactive maps                                                                                                   |
| plotly          | make any ggplot2 interactive                                                                                       |
| rCharts         | switch graph format with one click (ex: grouped vs. stacked barchart)                                              |
| viridis         | colour-blind friendly color maps in R                                                                              |
| wesanderson     | Wes Anderson inspired color palette package                                                                        |

data visualization packages

Use tables when

-   The display will be used to look up individual values
-   It will be used to compare individual values
-   Precise values are required
-   Quantitative values include more than one unit of measure
-   Both detail and summary values are included

Use graphs when

-   The display will be used to reveal relationships among whole sets of
    values
-   The message is contained in the shape of the values (e.g., patterns,
    trends, exceptions)

Source: [10+ Guidelines for Better Tables in
R](https://themockup.blog/posts/2020-09-04-10-table-rules-in-r/)

References

-   [ggplot2: elegant graphics for data
    analysis](https://ggplot2-book.org/index.html)
-   [R graphics cookbook](https://r-graphics.org/)
-   [Data Visualization with R](https://rkabacoff.github.io/datavis/)
-   [Data Visualization](https://socviz.co/index.html#preface)
-   [Fundamentals of Data
    Visualization](https://clauswilke.com/dataviz/)
-   [R graph gallery](https://r-graph-gallery.com/index.html): overview
    of R graphs and code
-   [ggridges](https://wilkelab.org/ggridges/index.html)
-   [from Data to Vis](https://www.data-to-viz.com/): choose data
    visualization format based on data type
-   [strategies for avoiding the spaghetti
    graph](https://www.storytellingwithdata.com/blog/2013/03/avoiding-spaghetti-graph):
    what not to do with line graphs
-   [GGplot
    cheatsheet](https://github.com/rstudio/cheatsheets/blob/main/data-visualization-2.1.pdf)
-   [ggrepel](https://ggrepel.slowkow.com/articles/examples.html)
-   [How to Make Beautiful Tables in
    R](https://rfortherestofus.com/2019/11/how-to-make-beautiful-tables-in-r/)
-   [10+ Guidelines for Better Tables in
    R](https://themockup.blog/posts/2020-09-04-10-table-rules-in-r/)
-   [A ggplot2 tutorial for beautiful plotting in
    R](https://cedricscherer.netlify.app/2019/08/05/a-ggplot2-tutorial-for-beautiful-plotting-in-r/)

Packages

-   [magick](https://cran.r-project.org/web/packages/magick/vignettes/intro.html#Installing_magick):
    Advanced Image-Processing in R
-   [ggpmisc](): a set of extensions to R package ‘ggplot2’ (\>= 3.0.0)
    with emphasis on annotations and highlighting related to fitted
    models and data summaries.
-   [patchwork](https://patchwork.data-imaginist.com/): combine ggplots
-   [bbplot](https://github.com/bbc/bbplot/): provides helpful functions
    for creating and exporting graphics made in ggplot in the style used
    by the BBC News data team.
-   [sportyR](https://sportyr.sportsdataverse.org/): package for data
    visualization on sports fields
-   [roughnet](https://github.com/schochastics/roughnet): hand-drawn
    network graphs
-   [roughsf](https://github.com/schochastics/roughsf): hand-drawn maps

## Interactive graphs

| package     | definition                                                            |
|:------------|:----------------------------------------------------------------------|
| highcharter | show and hide graph elements (and option to download graph)           |
| leaflet     | interactive maps                                                      |
| plotly      | make any ggplot2 interactive                                          |
| rCharts     | switch graph format with one click (ex: grouped vs. stacked barchart) |

Interactive graph packages

## Data art

-   [Creating Generative Art with
    R](https://cpastem.caltech.edu/documents/18024/ARt.nb.html)
-   [Tiny Art with R (R
    studio)](https://alinastepanova.medium.com/tiny-art-with-r-d6d93d110619)
-   [Tweetable Mathematical Art With
    R](https://fronkonstin.com/2018/09/06/tweetable-mathematical-art-with-r/)
-   [making memes in
    R](http://jenrichmond.rbind.io/post/making-memes-in-r/)
-   [Data art posters about music (streaming) data for Sony
    Music](https://www.visualcinnamon.com/2020/06/sony-music-data-art/)

## Data storytelling

-   [How to Tell a Story with Data: Titles, Subtitles, Annotations,
    Dark/Light Contrast, and Selective
    Labeling](https://depictdatastudio.com/how-to-tell-a-story-with-data-titles-subtitles-annotations-dark-light-contrast-and-selective-labeling/)

Examples

-   [In a tight labour market, this is where Canadian workers are
    going](https://www.cbc.ca/news/canada/canada-labour-worker-changes-charts-1.6556305)
    by CBC News

## Themes

| package         | definition                                                                      |
|:----------------|:--------------------------------------------------------------------------------|
| fivethirtyeight | package containing data from the website and theme for similar aesthetic ggplot |
| wesanderson     | Wes Anderson inspired color palette package                                     |

Theme packages

-   [Creating quick corporate plot themes with
    ggplot2](https://austinwehrwein.com/tutorials/corporatethemes/)

## Inspiration

-   [The 56 Best - And Weirdest - Charts We Made In
    2019](https://fivethirtyeight.com/features/the-56-best-and-weirdest-charts-we-made-in-2019/)
    by FiveThirtyEight
-   [Over 60 New York Times Graphs for Students to
    Analyze](https://www.nytimes.com/2020/06/10/learning/over-60-new-york-times-graphs-for-students-to-analyze.html)
    by the New York Times

# Create an R package

References

-   [R Packages (2e)](https://r-pkgs.org/)
-   [Making Your First R
    Package](https://tinyheero.github.io/jekyll/update/2015/07/26/making-your-first-R-package.html)
-   [How to write your own R package and publish it on
    CRAN](https://www.mzes.uni-mannheim.de/socialsciencedatalab/article/r-package/)

| package  | definition                             |
|:---------|:---------------------------------------|
| pkgdown  | documentation for packages             |
| roxygen2 | documentation for individual functions |
| testthat | unit testing                           |

Packages for building packages

## Functions

-   [Functions in Advanced R](https://adv-r.hadley.nz/functions.html)
-   [Functions in R4DS](https://r4ds.had.co.nz/functions.html)

# Other References

Other

-   [Engineering Production-Grade Shiny
    Apps](https://engineering-shiny.org/)
-   [R Packages](https://r-pkgs.org/index.html)
-   [WikipediR](https://github.com/Ironholds/WikipediR)
-   [Reader expectations
    approach](https://georgegopen.com/litigation-articles)

# Complete packages list

    ## Adding missing grouping variables: `category`

<div id="bjkdrkuogy" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#bjkdrkuogy .gt_table {
  display: table;
  border-collapse: collapse;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#bjkdrkuogy .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#bjkdrkuogy .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#bjkdrkuogy .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#bjkdrkuogy .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#bjkdrkuogy .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#bjkdrkuogy .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#bjkdrkuogy .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#bjkdrkuogy .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#bjkdrkuogy .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#bjkdrkuogy .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#bjkdrkuogy .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
}

#bjkdrkuogy .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#bjkdrkuogy .gt_from_md > :first-child {
  margin-top: 0;
}

#bjkdrkuogy .gt_from_md > :last-child {
  margin-bottom: 0;
}

#bjkdrkuogy .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#bjkdrkuogy .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#bjkdrkuogy .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#bjkdrkuogy .gt_row_group_first td {
  border-top-width: 2px;
}

#bjkdrkuogy .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#bjkdrkuogy .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#bjkdrkuogy .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#bjkdrkuogy .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#bjkdrkuogy .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#bjkdrkuogy .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#bjkdrkuogy .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#bjkdrkuogy .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#bjkdrkuogy .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#bjkdrkuogy .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-left: 4px;
  padding-right: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#bjkdrkuogy .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#bjkdrkuogy .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#bjkdrkuogy .gt_left {
  text-align: left;
}

#bjkdrkuogy .gt_center {
  text-align: center;
}

#bjkdrkuogy .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#bjkdrkuogy .gt_font_normal {
  font-weight: normal;
}

#bjkdrkuogy .gt_font_bold {
  font-weight: bold;
}

#bjkdrkuogy .gt_font_italic {
  font-style: italic;
}

#bjkdrkuogy .gt_super {
  font-size: 65%;
}

#bjkdrkuogy .gt_footnote_marks {
  font-style: italic;
  font-weight: normal;
  font-size: 75%;
  vertical-align: 0.4em;
}

#bjkdrkuogy .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#bjkdrkuogy .gt_indent_1 {
  text-indent: 5px;
}

#bjkdrkuogy .gt_indent_2 {
  text-indent: 10px;
}

#bjkdrkuogy .gt_indent_3 {
  text-indent: 15px;
}

#bjkdrkuogy .gt_indent_4 {
  text-indent: 20px;
}

#bjkdrkuogy .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table">
  
  <thead class="gt_col_headings">
    <tr>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col">package</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col">definition</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr class="gt_group_heading_row">
      <td colspan="2" class="gt_group_heading">data visualization</td>
    </tr>
    <tr class="gt_row_group_first"><td class="gt_row gt_left">cowplot</td>
<td class="gt_row gt_left">Streamlined plot theme and plot annotations for ggplot2</td></tr>
    <tr><td class="gt_row gt_left">fivethirtyeight</td>
<td class="gt_row gt_left">package containing data from the website and theme for similar aesthetic ggplot</td></tr>
    <tr><td class="gt_row gt_left">geofacet</td>
<td class="gt_row gt_left">geofaceting functionality for ggplot2</td></tr>
    <tr><td class="gt_row gt_left">geogrid</td>
<td class="gt_row gt_left">Turn geospatial polygons like states, counties or local authorities into regular or hexagonal grids automatically.</td></tr>
    <tr><td class="gt_row gt_left">gganimate</td>
<td class="gt_row gt_left">animate plot</td></tr>
    <tr><td class="gt_row gt_left">ggetch</td>
<td class="gt_row gt_left">Tech themes and scales</td></tr>
    <tr><td class="gt_row gt_left">ggplot2</td>
<td class="gt_row gt_left">create graphics</td></tr>
    <tr><td class="gt_row gt_left">ggpmisc</td>
<td class="gt_row gt_left">ggplot2 extension which includes tables</td></tr>
    <tr><td class="gt_row gt_left">ggpomological</td>
<td class="gt_row gt_left">water-colour look for figures</td></tr>
    <tr><td class="gt_row gt_left">ggrepel</td>
<td class="gt_row gt_left">repel labels from overlap</td></tr>
    <tr><td class="gt_row gt_left">ggridges</td>
<td class="gt_row gt_left">create ridges</td></tr>
    <tr><td class="gt_row gt_left">ggspatial</td>
<td class="gt_row gt_left">Spatial data plus the power of the ggplot2 framework</td></tr>
    <tr><td class="gt_row gt_left">ggthemes</td>
<td class="gt_row gt_left">Some extra geoms, scales, and themes for ggplot.
</td></tr>
    <tr><td class="gt_row gt_left">gt</td>
<td class="gt_row gt_left">create tables in R</td></tr>
    <tr><td class="gt_row gt_left">gtextras</td>
<td class="gt_row gt_left">add-on to gt that lets you add visualizations into tables</td></tr>
    <tr><td class="gt_row gt_left">highcharter</td>
<td class="gt_row gt_left">show and hide graph elements (and option to download graph)</td></tr>
    <tr><td class="gt_row gt_left">hrbrthemes</td>
<td class="gt_row gt_left">Additional Themes and Theme Components for ‘ggplot2’
</td></tr>
    <tr><td class="gt_row gt_left">leaflet</td>
<td class="gt_row gt_left">interactive maps</td></tr>
    <tr><td class="gt_row gt_left">plotly</td>
<td class="gt_row gt_left">make any ggplot2 interactive</td></tr>
    <tr><td class="gt_row gt_left">rCharts</td>
<td class="gt_row gt_left">switch graph format with one click (ex: grouped vs. stacked barchart)</td></tr>
    <tr><td class="gt_row gt_left">viridis</td>
<td class="gt_row gt_left">colour-blind friendly color maps in R</td></tr>
    <tr><td class="gt_row gt_left">wesanderson</td>
<td class="gt_row gt_left">Wes Anderson inspired color palette package</td></tr>
    <tr class="gt_group_heading_row">
      <td colspan="2" class="gt_group_heading">generic</td>
    </tr>
    <tr class="gt_row_group_first"><td class="gt_row gt_left">dplyr</td>
<td class="gt_row gt_left">manipulate data</td></tr>
    <tr><td class="gt_row gt_left">purrr</td>
<td class="gt_row gt_left">loops</td></tr>
    <tr><td class="gt_row gt_left">tibble</td>
<td class="gt_row gt_left">data frame 2.0, they do less and complain more forcing you to adress problems earlier</td></tr>
    <tr class="gt_group_heading_row">
      <td colspan="2" class="gt_group_heading">data import</td>
    </tr>
    <tr class="gt_row_group_first"><td class="gt_row gt_left">espnscrapeR</td>
<td class="gt_row gt_left">collect or scrape QBR, NFL standings, and stats from ESPN</td></tr>
    <tr><td class="gt_row gt_left">readr</td>
<td class="gt_row gt_left">read rectangular data (csv, tsv)</td></tr>
    <tr class="gt_group_heading_row">
      <td colspan="2" class="gt_group_heading">data manipulation</td>
    </tr>
    <tr class="gt_row_group_first"><td class="gt_row gt_left">forcats</td>
<td class="gt_row gt_left">tools to work with factors</td></tr>
    <tr><td class="gt_row gt_left">stringr</td>
<td class="gt_row gt_left">functions to work with strings</td></tr>
    <tr><td class="gt_row gt_left">tidyr</td>
<td class="gt_row gt_left">tidy data</td></tr>
    <tr class="gt_group_heading_row">
      <td colspan="2" class="gt_group_heading">R markdown</td>
    </tr>
    <tr class="gt_row_group_first"><td class="gt_row gt_left">knitr</td>
<td class="gt_row gt_left">NA</td></tr>
    <tr><td class="gt_row gt_left">rmarkdown</td>
<td class="gt_row gt_left">reproducible documents</td></tr>
    <tr><td class="gt_row gt_left">thesisdown</td>
<td class="gt_row gt_left">reproducible thesis</td></tr>
    <tr><td class="gt_row gt_left">bookdown</td>
<td class="gt_row gt_left">Write HTML, PDF, ePub, and Kindle books with R Markdown</td></tr>
    <tr class="gt_group_heading_row">
      <td colspan="2" class="gt_group_heading">API wrapper</td>
    </tr>
    <tr class="gt_row_group_first"><td class="gt_row gt_left">pageviews</td>
<td class="gt_row gt_left">retrieve wikimedia pageviews</td></tr>
    <tr><td class="gt_row gt_left">spotifyr</td>
<td class="gt_row gt_left">R package for Spotify API</td></tr>
    <tr><td class="gt_row gt_left">tidywikidatar</td>
<td class="gt_row gt_left">read and query Wikidata in a tidy format</td></tr>
    <tr><td class="gt_row gt_left">waxer</td>
<td class="gt_row gt_left">querying Wikimedia Analytics Query Service in R</td></tr>
    <tr><td class="gt_row gt_left">WikidataR</td>
<td class="gt_row gt_left">read and query wikidata. Uses Wikidata and Quickstatements APIs.</td></tr>
    <tr><td class="gt_row gt_left">wikipediatrend</td>
<td class="gt_row gt_left">read and query Wikidata in a tidy format</td></tr>
    <tr><td class="gt_row gt_left">WikipediR</td>
<td class="gt_row gt_left">wrapper for MediaWiki API</td></tr>
    <tr><td class="gt_row gt_left">wmfastr</td>
<td class="gt_row gt_left">Speedily computes various dwelltime and preference-related metrics in the context of search sessions.</td></tr>
    <tr><td class="gt_row gt_left">wmfdata</td>
<td class="gt_row gt_left">for working with Wikimedia data in R</td></tr>
    <tr class="gt_group_heading_row">
      <td colspan="2" class="gt_group_heading">package</td>
    </tr>
    <tr class="gt_row_group_first"><td class="gt_row gt_left">pkgdown</td>
<td class="gt_row gt_left">documentation for packages</td></tr>
    <tr><td class="gt_row gt_left">roxygen2</td>
<td class="gt_row gt_left">documentation for individual functions</td></tr>
    <tr><td class="gt_row gt_left">testthat</td>
<td class="gt_row gt_left">unit testing</td></tr>
    <tr class="gt_group_heading_row">
      <td colspan="2" class="gt_group_heading">data science</td>
    </tr>
    <tr class="gt_row_group_first"><td class="gt_row gt_left">tidyverse</td>
<td class="gt_row gt_left">NA</td></tr>
  </tbody>
  
  
</table>
</div>