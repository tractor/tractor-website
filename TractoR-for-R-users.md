# TractoR for R users

TractoR consists of a set of R packages, along with a scripting system which provides access to the underlying code for non-useRs and those who wish to perform only "standard" tasks. This page describes the general set-up of TractoR, and how it can be used as a general purpose library for working with magnetic resonance images. It also describes how the interface between the shell and R works, and how you can write your own experiment scripts for use with the `tractor` shell program.

## General set-up

The `tractor.base` package is the most general-purpose of the TractoR packages, and the only one to be currently [on CRAN](http://cran.r-project.org/web/packages/tractor.base/index.html). It provides functions for reading, writing and manipulating MR images, along with various general-purpose functions which are used by the other packages.

The key class in the base package is `MriImage`, which is a reference class representing an MR image, including metadata such as the source file, image dimensions and so on. Functions are provided for reading such images from Analyze/NIfTI files (`readImageFile`), from DICOM files (`readDicomDirectory`); and for creating them from other `MriImage` objects via operations such as thresholding or masking (see `?asMriImage`). The class inherits from `SerialisableObject`, a simple extension of the base reference class which adds a method for serialising the fields of the object to a list. If only the underlying array of image data values is required, it can be extracted from an `MriImage` object, say `image`, with

    image$getData()

The result is a standard numeric array with appropriate dimensions. The group generic functions `Math`, `Ops` and `Summary` are defined for the `MriImage` class (although the `Summary` group generic currently works only for a single image argument, so `max(image1,image2)` won't work). Standard array element extraction and replacement also work, with extraction returning an array and replacement a new `MriImage` object (`?MriImage` for details).

TractoR uses the `reportr` package for message reporting, in preference to the standard R functions `message`, `warning` and `stop`. This system provides some useful features and debugging benefits, which are detailed on the help page for `report`. When TractoR is used directly from the command line (see next section), R-level warnings and errors are converted into `report()` calls.

Please see the [full documentation](http://cran.r-project.org/web/packages/tractor.base/tractor.base.pdf) (pdf) for more information on these topics.

The `tractor.reg` package is involved with all aspects of [image registration](registration.html), interfacing to both FSL-FLIRT (through its command line interface) and the `RNiftyReg` R package. The `tractor.session` package creates and maintains [session directories](conventions.html), and includes other functions which interface with the [FSL](http://www.fmrib.ox.ac.uk/fsl) and [Camino](http://www.camino.org.uk) software packages. The `tractor.track` package implements the tractography algorithm used by TractoR (in C). The `tractor.nt` package provides implementations of [heuristic](HNT-tutorial.html) and [probabilistic](PNT-tutorial.html) neighbourhood tractography. The `tractor.utils` package exists mainly to support the command-line interface (see below). At present none of these four more specialist packages are documented at the R level, i.e. function by function.

## From command line to R

The `tractor` shell script is a convenience interface for performing common tasks using the TractoR packages. It is based around a set of R script files, one per task, each of which contains a `runExperiment()` function. (The `console` script is a rare exception.) The shell script in turn calls a binary program which uses R's APIs to provide an alternative front-end to the usual `R` program. It loads the `tractor.utils` package and calls the `bootstrapExperiment()` function to set up the required environment and execute the `runExperiment()` function for the requested script. The shell script also facilitates passing information between the command line and R, reporting errors and warnings, and maintaining a command history. 

Further information on the usage and function of the `tractor` shell script can be found in its man page (type `man tractor` from the shell, assuming that [your MANPATH is set correctly](getting-started.html)).

## Writing your own TractoR scripts

A reasonably simple TractoR script is shown below, by way of illustration. This is in fact the script called `mean`, which averages the value of some metric within the nonzero region of a mask image. It exhibits many of the common characteristics of these scripts. The lines are numbered here for ease of reference, but in a real script these should not be included.

    01  #@args metric image, [mask image]
    02  #@desc Calculate the mean or weighted mean value of a metric within the nonzero region of a brain volume. The specified mask image can be used as a binary mask (the default) or as a set of weights (with AveragingMode:weighted). In the latter case any weight threshold given is ignored. If the mask is missing then the metric image is itself the mask.
    03  
    04  runExperiment <- function ()
    05  {
    06      requireArguments("metric image")
    07      metricImage <- readImageFile(Arguments[1])
    08      
    09      if (nArguments() > 1)
    10          maskImage <- readImageFile(Arguments[2])
    11      else
    12          maskImage <- metricImage$copy()
    13      
    14      mode <- getConfigVariable("AveragingMode", "binary", validValues=c("binary","weighted"))
    15      threshold <- getConfigVariable("ThresholdLevel", 0.01)
    16      thresholdMode <- getConfigVariable("ThresholdRelativeTo", "nothing", validValues=c("nothing","maximum","minimum"))
    17      
    18      if (thresholdMode == "maximum")
    19          threshold <- threshold * max(maskImage, na.rm=TRUE)
    20      else if (thresholdMode == "minimum")
    21          threshold <- threshold * min(maskImage, na.rm=TRUE)
    22      
    23      if (mode == "binary")
    24          maskImage$threshold(threshold)$binarise()
    25      
    26      metric <- sum(metricImage * maskImage, na.rm=TRUE) / sum(maskImage, na.rm=TRUE)
    27      cat(paste(metric, "\n", sep=""))
    28  }

The only mandatory part of a script file is the definition of a `runExperiment()` function, with no arguments, as on line 4. The R code which forms the functional body of the script must be put exclusively within this function. No other functions will be run. Moreover, with the exception of statements to load required packages, no R code should be positioned outside of the `runExperiment()` function. Calls to `library()` or `require()` for all required packages except `tractor.utils`, `utils`, `graphics`, `grDevices` and `stats` should be included in this way.

Scripts may take any number of unnamed arguments and/or named configuration parameters. Unnamed arguments are put into the character vector `Arguments` (see lines 7 and 10 above), and must be coerced to numeric or another mode if required. The `nArguments()` function returns the number of arguments that the user passed (see line 9), where a new argument is counted as having started after any whitespace. The `requireArguments()` function can be used to list the names of mandatory arguments, and will produce an error if too few arguments were passed by the user (line 6). Named parameters are recovered using the `getConfigVariable()` function, which gives the name of the parameter as its first argument (by convention, these always start with an upper case letter), a default value as the second, and optionally, the expected storage mode of the variable (i.e. "character", "integer", etc.). The returned value will be of this mode, and an error will be produced if the value given cannot be coerced to the specified mode. Likewise, the `validValues` argument can be provided if the parameter can only take certain specific values (as in lines 14 and 16). Script authors should call `getConfigVariable()` with `errorIfMissing=TRUE` if the parameter is mandatory.

TractoR scripts are self-documenting, and a number of special comments are used to provide this documentation. The `#@args` comment specifies unnamed arguments which the script accepts, with optional arguments in square brackets (line 1), and lines starting `#@desc` describe the function of the script (line 2). Note that there should be only one line of arguments, but there can be many lines of description. If the script is purely informative and doesn't need to be included within the history log file, you should include a line containing just

    #@nohistory TRUE

so that the `tractor` shell script will handle it properly. The shell script will also look for calls to `getConfigVariable()`, so that it can report the named parameters supported by the script.
