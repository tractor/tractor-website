# Getting started

## System requirements

TractoR was developed for Unix-like systems. It has been developed and tested on Mac OS X and Linux operating systems, and should work on other Unix variants that meet [R's](http://www.r-project.org) requirements. Support for Windows/Cygwin is not guaranteed but things may work. A better bet on Windows may be to run Linux within a virtual machine environment such as [VirtualBox](http://www.virtualbox.org/) or [VMware](http://www.vmware.com).

In its basic form, TractoR is a set of packages written for the R language and environment. R (version 2.12.1 or later) is therefore an absolute prerequisite. R is an open-source package that is easy to install. Precompiled binaries are available from a number of [CRAN mirror sites](http://cran.r-project.org/mirrors.html), along with the source code.

TractoR contains an algorithm for performing tractography, but not all functions can be used with this built-in tracker. It therefore additionally provides an interface to the tractography algorithm implemented as part of the [FSL package](http://www.fmrib.ox.ac.uk/fsl/), as well as various other related FSL tools such as BET for brain extraction, and FLIRT for registration. Installation of FSL (version 4.0 or later) is therefore important for portions of TractoR's functionality.

Finally, TractoR makes use of the [ImageMagick](http://www.imagemagick.org) image processing suite for 2D visualisation. While TractoR will be more-or-less fully functional without ImageMagick, it is nevertheless recommended to install this software (unless it is preinstalled, which is not uncommon on Unix-like systems). Version 6.3.x is recommended.

**Summary**: The best platform for TractoR is a Unix-like operating system with R, FSL and ImageMagick installed.

## Installation

After downloading the TractoR tarball, installing the R packages should just be a matter of typing the following into a terminal, adjusting the file name in the first line if necessary.

    tar -xzf tractor-2.0.2.tar.gz
    cd tractor
    make install

In most cases the installer will find R without any help, but if an error message reports "command not found" or similar, then please use `make install R=/path/to/R`, replacing `/path/to/R` with the actual path on your system. The install command could also fail if you do not have write access to the R library. This can be worked around by creating an R library directory in your home directory:

    mkdir ~/Rlibrary

In this case you will need to add the line `export R_LIBS_USER=${HOME}/Rlibrary` to the `.bashrc` file in your home directory (create it if it doesn't exist). The install command should then run properly.

In order to take advantage of the parallel processing capabilities of TractoR version 1.5.0 and above, you will need to install the "multicore" package for R. This is provided with TractoR, but requires some C code to be compiled. Likewise, the "tractor.native" package, which provides the built-in tractography algorithm, also requires compilation. If you have a C compiler on your system, you should be able to install these packages with the command

    make install-native

If this fails, it is likely that you don't have a suitable compiler (e.g. gcc) installed. If you're running on Mac OS X, you can obtain a [precompiled binary version](http://cran.r-project.org/web/packages/multicore/index.html) of the "multicore" package, but no equivalent is currently provided for "tractor.native". Otherwise, you will need to install gcc or similar, or simply proceed without these optional packages.

To check that the TractoR packages have been installed properly and TractoR scripts can be run successfully, you can run the set of tests included with TractoR 1.3.0 and later by typing

    make clean test

Running these tests will typically take a minute or two, during which time you should see a series of messages confirming the success of each test. If any errors arise, something is probably wrong with your installation.

Unless you want to interact with TractoR exclusively through R (which is unlikely in most cases), you will also need to set up your environment so that you can use the `tractor` shell program and associated script files. To do this - assuming you use the bash shell - add the following lines to the `.bashrc` file in your home directory:

    export TRACTOR_HOME=/usr/local/tractor
    export PATH=${TRACTOR_HOME}/bin:$PATH
    export MANPATH=${TRACTOR_HOME}/man:$MANPATH

(If you have unpacked the tarball somewhere than /usr/local/tractor, you will need to alter the first line accordingly.) In order to test that the environment is set up correctly, try typing

    tractor list

which should produce output similar to the following:

    Starting TractoR environment...
    Experiment scripts found in /usr/local/tractor/share/experiments:
     [1] age             bedpost         binarise        camino2fsl     
     [5] caminofiles     chfiletype      clone           contact        
     [9] dicomread       dicomsort       dicomtags       dirviz         
    [13] dpreproc        extract         fsl2camino      gmap           
    [17] gmean           gradcheck       gradread        gradrotate     
    [21] hnt-eval        hnt-interpret   hnt-ref         hnt-viz        
    [25] identify        imageinfo       list            mean           
    [29] mkroi           mtrack          peek            platform       
    [33] plotcorrections pnt-collate     pnt-data-sge    pnt-data       
    [37] pnt-em          pnt-eval        pnt-interpret   pnt-prune      
    [41] pnt-ref         pnt-train       pnt-viz         proj           
    [45] rtrack          slice           status          tensorfit      
    [49] track           values          view
    Experiment completed with 0 warning(s) and 0 error(s)

If instead you get an error from the shell saying that it couldn't find the `tractor` executable, or from `tractor` itself reporting the script file not found, the install has not worked correctly. Check that you have set up your environment correctly, as shown above, and make sure that you have started a new shell or sourced your `.bashrc` file to pick up the changes (`source ~/.bashrc`). Running the command `man tractor` should show the `tractor` man page.

## Usage

The `tractor` command line interface program is a wrapper which obviates the need to interact with R directly in order to use TractoR. Many common tasks, including neighbourhood tractography (see "Next steps" below), can be performed in this way through short R scripts which are stored within the TractoR home directory.

A full list of the scripts provided with the distribution can be obtained by typing `tractor list`, as shown above. Further information on a particular script, including a list of options that it supports, can be obtrained using `tractor -o (script_name)`. For more details on the usage of the `tractor` program, please see its man page.

## Next steps

TractoR provides implementations of "neighbourhood tractography" methods for consistent white matter tract segmentation. Tutorials on the earlier (and simpler) [heuristic approach](https://github.com/jonclayden/tractor/wiki/HNT-tutorial) and the more complex but more robust [probabilistic approach](https://github.com/jonclayden/tractor/wiki/PNT-tutorial) to neighbourhood tractography are good places to start to gain familiarity with TractoR's way of doing things. A quick overview of TractoR's specific [conventions](https://github.com/jonclayden/tractor/wiki/Conventions) is also provided.