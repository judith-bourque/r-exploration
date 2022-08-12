# Description

A collection of quick notes and References for personal use.

# R basics

<table>
<caption>R file types</caption>
<colgroup>
<col style="width: 6%" />
<col style="width: 86%" />
<col style="width: 6%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">name</th>
<th style="text-align: left;">purpose</th>
<th style="text-align: left;">extension</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">R script</td>
<td style="text-align: left;">analysis mode and want a report as a side
effect</td>
<td style="text-align: left;">.R</td>
</tr>
<tr class="even">
<td style="text-align: left;">R Markdown</td>
<td style="text-align: left;">writing a report with a lot of R code in
it</td>
<td style="text-align: left;">.Rmd</td>
</tr>
<tr class="odd">
<td style="text-align: left;">R Notebook</td>
<td style="text-align: left;">R Markdown document with chunks that can
be executed independently and interactively, with output visible
immediately beneauth the input</td>
<td style="text-align: left;"></td>
</tr>
</tbody>
</table>

R file types

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

-   /code: contains .R files
-   /graphs: contains graphs
-   README.md: describe the project

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
your project-level .Rprofile with source(“~/.Rprofile”).

.Rprofile files are sourced as regular R code, so setting environment
variables must be done inside a Sys.setenv(key = “value”) call.

One easy way to edit your .Rprofile file is to use the
usethis::edit\_r\_profile() function from within an R session. You can
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

<table>
<caption>git commands</caption>
<thead>
<tr class="header">
<th style="text-align: left;">command</th>
<th style="text-align: left;">purpose</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">cd</td>
<td style="text-align: left;"></td>
</tr>
<tr class="even">
<td style="text-align: left;">cd ..</td>
<td style="text-align: left;"></td>
</tr>
<tr class="odd">
<td style="text-align: left;">git status</td>
<td style="text-align: left;">View project changes</td>
</tr>
<tr class="even">
<td style="text-align: left;">git diff</td>
<td style="text-align: left;">View difference in file</td>
</tr>
<tr class="odd">
<td style="text-align: left;">git add</td>
<td style="text-align: left;"></td>
</tr>
<tr class="even">
<td style="text-align: left;">git add -A</td>
<td style="text-align: left;">Add all files</td>
</tr>
<tr class="odd">
<td style="text-align: left;">git commit -m “”</td>
<td style="text-align: left;"></td>
</tr>
<tr class="even">
<td style="text-align: left;">git push</td>
<td style="text-align: left;"></td>
</tr>
<tr class="odd">
<td style="text-align: left;">git pull</td>
<td style="text-align: left;"></td>
</tr>
<tr class="even">
<td style="text-align: left;">git rm –cached</td>
<td style="text-align: left;">stop tracking a file that is currently
tracked</td>
</tr>
</tbody>
</table>

git commands

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

<table>
<caption>.gitignore code</caption>
<thead>
<tr class="header">
<th style="text-align: left;">code</th>
<th style="text-align: left;">purpose</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">*</td>
<td style="text-align: left;">Matches 0 or more characters, except
/</td>
</tr>
<tr class="even">
<td style="text-align: left;">!</td>
<td style="text-align: left;">Not ignore a file that would be
ignored</td>
</tr>
<tr class="odd">
<td style="text-align: left;">#</td>
<td style="text-align: left;">Comments</td>
</tr>
</tbody>
</table>

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

## YAML

Optional header surrounded by `---`

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

When you put output as github\_document, you will knit a .md. Useful as
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

    library(rmarkdown)
    render("example.Rmd")

## Headers

    # Numbered header
    # Unnumbered header {-}
    # Also unnumbered header {.unnumbered}

## Markdown Syntax

<table>
<caption>Pandoc’s Markdown</caption>
<thead>
<tr class="header">
<th style="text-align: left;">syntax</th>
<th style="text-align: left;">code</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">Images</td>
<td
style="text-align: left;"><code>![alt text or image title](path/to/image)</code></td>
</tr>
<tr class="even">
<td style="text-align: left;">Footnotes</td>
<td style="text-align: left;"><code>^[This is a footnote.]</code></td>
</tr>
<tr class="odd">
<td style="text-align: left;">Horizontal rules</td>
<td style="text-align: left;">three or more of *, -, _</td>
</tr>
</tbody>
</table>

Pandoc’s Markdown

Resource

-   [Pandoc User’s Guide](https://pandoc.org/MANUAL.html)

## Tables

Display options for data frames and matrixes

-   Default: like in the R terminal
-   `knitr::kable`: pretty

Code for creating a table using a new data frame

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

## Code chunks

Code chunks can be run individually in RStudio by clicking the green
arrow pointing right.

Code chunks start with ```` ```{} ```` and ends with ```` ``` ````.

    # ```{r}
    # ```

<table>
<caption>Code chunk options</caption>
<colgroup>
<col style="width: 10%" />
<col style="width: 89%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">option</th>
<th style="text-align: left;">purpose</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><code>include = FALSE</code></td>
<td style="text-align: left;">prevents code and results from appearing
in the output file. R Markdown still runs the code in the chunk, and the
results can be used by other chunks</td>
</tr>
<tr class="even">
<td style="text-align: left;"><code>echo = FALSE</code></td>
<td style="text-align: left;">prevents code, but not the results from
appearing in the finished file. Good to embed figures</td>
</tr>
<tr class="odd">
<td style="text-align: left;"><code>message = FALSE</code></td>
<td style="text-align: left;">prevents messages that are generated by
code from appearing in the finished file</td>
</tr>
<tr class="even">
<td style="text-align: left;"><code>warning = FALSE</code></td>
<td style="text-align: left;">prevents warnings that are generated by
code from appearing in the finished</td>
</tr>
<tr class="odd">
<td style="text-align: left;"><code>fig.cap = "..."</code></td>
<td style="text-align: left;">adds a caption to graphical results</td>
</tr>
<tr class="even">
<td style="text-align: left;"><code>eval = FALSE</code></td>
<td style="text-align: left;"></td>
</tr>
</tbody>
</table>

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

    @Manual{R-base,
      title = {R: A Language and Environment for Statistical
        Computing},
      author = {{R Core Team}},
      organization = {R Foundation for Statistical Computing},
      address = {Vienna, Austria},
      year = {2017},
      url = {https://www.R-project.org/},
    }

References

-   [Citation Management and Writing Tools: LaTeX and
    BibTex](https://libguides.mit.edu/cite-write/bibtex)
-   [BibTex](http://www.bibtex.org/)
-   [JabRef](https://www.jabref.org/#): open-source reference manager
    compatible with BibTex. Works on Windows.

## Blockquotes

Code

    > "This is a quote that can be long and go until another line."
    >
    > --- Author

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

<table>
<caption>tidyverse core packages</caption>
<colgroup>
<col style="width: 8%" />
<col style="width: 91%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">package</th>
<th style="text-align: left;">purpose</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">ggplot2</td>
<td style="text-align: left;">create graphics</td>
</tr>
<tr class="even">
<td style="text-align: left;">dplyr</td>
<td style="text-align: left;">manipulate data</td>
</tr>
<tr class="odd">
<td style="text-align: left;">tidyr</td>
<td style="text-align: left;">tidy data</td>
</tr>
<tr class="even">
<td style="text-align: left;">readr</td>
<td style="text-align: left;">read rectangular data (csv, tsv)</td>
</tr>
<tr class="odd">
<td style="text-align: left;">purrr</td>
<td style="text-align: left;">loops</td>
</tr>
<tr class="even">
<td style="text-align: left;">tibble</td>
<td style="text-align: left;">data frame 2.0, they do less and complain
more forcing you to adress problems earlier</td>
</tr>
<tr class="odd">
<td style="text-align: left;">stringr</td>
<td style="text-align: left;">functions to work with strings</td>
</tr>
<tr class="even">
<td style="text-align: left;">forcats</td>
<td style="text-align: left;">tools to work with factors</td>
</tr>
</tbody>
</table>

tidyverse core packages

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

## Wikimedia packages

-   [pageviews](https://cran.r-project.org/web/packages/pageviews/pageviews.pdf):
    retrieve wikimedia pageviews
-   [waxer](https://github.com/wikimedia/waxer): querying Wikimedia
    Analytics Query Service in R.
-   [WikidataR](https://cran.r-project.org/web/packages/WikidataR/index.html):
    read and query wikidata. Uses Wikidata and Quickstatements APIs.
-   [wikipediatrend](https://cran.r-project.org/package=wikipediatrend):
    pageviews from 2007 and beyond
-   [WikipediR](https://cran.r-project.org/web/packages/WikipediR/WikipediR.pdf):
    Wrapper for MediaWiki API
-   [wmfastr](https://github.com/wikimedia/wmfastr): Speedily computes
    various dwelltime and preference-related metrics in the context of
    search sessions.
-   [wmfdata](https://github.com/wikimedia/wmfdata-r): for working with
    Wikimedia data in R

# Data analysis

References

-   [Exploratory Data
    Analysis](https://mgimond.github.io/ES218/Week01.html)
-   [Geocomputation with R](https://geocompr.robinlovelace.net/):
    geographic data analysis

# Text mining

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

<table>
<caption>data visualization packages</caption>
<thead>
<tr class="header">
<th style="text-align: left;">package</th>
<th style="text-align: left;">purpose</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">ggplot2</td>
<td style="text-align: left;">plot</td>
</tr>
<tr class="even">
<td style="text-align: left;">gganimate</td>
<td style="text-align: left;">animate plot</td>
</tr>
<tr class="odd">
<td style="text-align: left;">ggrepel</td>
<td style="text-align: left;">repel labels from overlap</td>
</tr>
<tr class="even">
<td style="text-align: left;">ggridges</td>
<td style="text-align: left;">create ridges</td>
</tr>
<tr class="odd">
<td style="text-align: left;">viridis</td>
<td style="text-align: left;">colour-blind friendly color maps for
R</td>
</tr>
</tbody>
</table>

data visualization packages

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
-   [patchwork](https://patchwork.data-imaginist.com/): combine ggplots

## Interactive graphs

-   leaflet: interactive maps
-   plotly: make any ggplot2 interactive
-   rCharts: switch graph format with one click (ex: grouped vs. stacked
    barchart)
-   highcharter: show and hide graph elements (and option to download
    graph)

## Data art

-   [Creating Generative Art with
    R](https://cpastem.caltech.edu/documents/18024/ARt.nb.html)
-   [Tiny Art with R (R
    studio)](https://alinastepanova.medium.com/tiny-art-with-r-d6d93d110619)
-   [Tweetable Mathematical Art With
    R](https://fronkonstin.com/2018/09/06/tweetable-mathematical-art-with-r/)
-   [making memes in
    R](http://jenrichmond.rbind.io/post/making-memes-in-r/)

# Other References

Other

-   [Engineering Production-Grade Shiny
    Apps](https://engineering-shiny.org/)
-   [R Packages](https://r-pkgs.org/index.html)
-   [WikipediR](https://github.com/Ironholds/WikipediR)
-   [Reader expectations
    approach](https://georgegopen.com/litigation-articles)