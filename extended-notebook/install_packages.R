#  - run the following to recognize dependencies:
d <- getDependencies("rgdal", installed=FALSE, available=FALSE, base=TRUE, recommended=TRUE )

#  - install in the following order:
install.packages('RPostgreSQL', clean=TRUE)
install.packages('osmdata', clean = TRUE)
install.packages("tmap", clean = TRUE)
install.packages('pkgbuild', clean=TRUE)
install.packages('remotes', clean=TRUE)
#install.packages("odbc", clean = TRUE) use below one
devtools::install_github("rstats-db/odbc@SQLTable")

#  - required package for research
install.packages("RcppGSL",dependencies=TRUE, clean=TRUE)
install.packages("Rfast",dependencies=TRUE, clean=TRUE)

