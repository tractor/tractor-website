# Getting started

## System requirements

TractoR was developed for Unix-like systems. It has been developed and tested on Mac OS X and Linux operating systems, and should work on other Unix variants that meet [R's](http://www.r-project.org) requirements. Support for Windows/Cygwin is not guaranteed but things may work. A better bet on Windows may be to run Linux within a virtual machine environment such as [VirtualBox](http://www.virtualbox.org/) or [VMware](http://www.vmware.com).

In its basic form, TractoR is a set of packages written for the R language and environment. R (version 2.12.1 or later) is therefore an absolute prerequisite. R is an open-source package that is easy to install. Precompiled binaries are available from a number of [CRAN mirror sites](http://cran.r-project.org/mirrors.html), along with the source code.

A C/C++ compiler, such as `gcc`/`g++`, is also required. A suitable compiler can be installed using an appropriate package manager (`aptitude`, `yum`, etc.) on Linux, or with Xcode (from the Mac App Store) on OS X. R handles all the details of actually compiling code.

TractoR makes use of the [ImageMagick](http://www.imagemagick.org) image processing suite for 2D visualisation. While TractoR will be more-or-less fully functional without ImageMagick, it is nevertheless recommended to install this software (unless it is preinstalled, which is not uncommon on Unix-like systems).

Finally, TractoR's tractography is currently based on output from the BEDPOSTX tool in the [FSL package](http://www.fmrib.ox.ac.uk/fsl/). FSL is therefore required for performing tractography. TractoR also provides interfaces to other third-party medical imaging tools, such as FSL's BET (for brain extraction) and FLIRT (for linear registration), as well as image viewers such as FSLview and Freeview, but these are all optional.

## Installation

After downloading the TractoR tarball, installing the R packages should just be a matter of typing the following into a terminal, adjusting the file name in the first line if necessary.

    tar -xzf tractor.tar.gz
    cd tractor
    make install

In most cases the installer will find R without any help, but if an error message reports "command not found" or similar, then please use `make install R=/path/to/R`, replacing `/path/to/R` with the actual path on your system.

The install command could also fail if you do not have write access to the R library. The easiest way around this is to run instead

    make install-local

which will install the required R packages within TractoR's own file hierarchy. This can also be useful if you want to run multiple versions of TractoR in parallel.

To check that the TractoR packages have been installed properly and TractoR scripts can be run successfully, you can run the set of tests included with TractoR 1.3.0 and later by typing

    make clean test

Running these tests will typically take a minute or two, during which time you should see a series of messages confirming the success of each test. If any errors arise, something is probably wrong with your installation.

Unless you want to interact with TractoR exclusively through R (which is unlikely in most cases), you will also need to set up your environment so that you can use the `tractor` shell program and associated script files. To do this - assuming you use the bash shell - add the following lines to the `.bashrc` file in your home directory:

    export TRACTOR_HOME=/usr/local/tractor
    export PATH=${TRACTOR_HOME}/bin:$PATH
    export MANPATH=${TRACTOR_HOME}/man:$MANPATH

(If you have unpacked the tarball somewhere than `/usr/local/tractor`, you will need to alter the first line accordingly.) In order to test that the environment is set up correctly, try typing

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

A full list of the scripts provided with the distribution can be obtained by typing `tractor list`, as shown above. Further information on a particular script, including a list of options that it supports, can be obtained using `tractor -o (script name)`. For more details on the usage of the `tractor` program, please see its man page.

## Next steps

TractoR provides implementations of "neighbourhood tractography" methods for consistent white matter tract segmentation. Tutorials on the earlier (and simpler) [heuristic approach](HNT-tutorial.html) and the more complex but more robust [probabilistic approach](PNT-tutorial.html) to neighbourhood tractography are good places to start to gain familiarity with TractoR's way of doing things. A quick overview of TractoR's specific [conventions](conventions.html) is also provided.