# Installation

TractoR can be downloaded directly below, cloned from [GitHub](https://github.com/tractor/tractor/) using `git`, or installed using Homebrew (on macOS) or Docker. This page outlines the process of installing the package on different platforms. If you run into problems or need help, you can email <help@tractor-mri.org.uk>.

## System requirements

In its basic form, TractoR is a set of packages written for the [R language and environment](http://www.r-project.org). R (version 3.5.0 or later) is therefore an absolute prerequisite unless you want to use Docker to run TractoR fully containerised. R is an open-source package that is easy to install. Precompiled binaries are available from a number of [CRAN mirror sites](https://cran.r-project.org/mirrors.html), along with the source code.

A C/C++ compiler, such as `gcc`/`g++` or `clang`/`clang++`, is also required to install TractoR from source, although R handles all the details of actually compiling code.

## Downloads

<div id="download-box">
  <p>The latest version of TractoR is <span id="version"><!--LATEST--></span>.</p>
  <img src="download.png" alt="Download icon" />
  <p>Download <a href="#" onClick="gtag('event','download_tarball'); window.location.href='http://www.tractor-mri.org.uk/tractor.tar.gz'">tractor.tar.gz</a> or <a href="#" onClick="gtag('event','download_zipball'); window.location.href='http://www.tractor-mri.org.uk/tractor.zip'">tractor.zip</a>.</p>
</div>

Full source code is included in the download. TractoR is developed according to good software engineering practice, and release numbering follows a [clear and consistent pattern](http://semver.org):
  
- Point releases, e.g. from version 1.0.0 to 1.0.1, are for bug fixes and minor tweaks to existing functionality. They should be fully backwards-compatible, and are released as needed.
- Minor releases, e.g. from version 1.0.x to 1.1.0, add new features without fundamentally changing the behaviour of the package's user-visible functions. Substantial effort is made to keep them backwards-compatible, including keeping default behaviour the same, and any deviation from this is explicitly documented in the [changelog](changelog.html). Such releases are typically made every few months.
- Major releases, e.g. from version 1.x.0 to 2.0.0, may include changes which are incompatible with older versions, including different default behaviour, or substantial modifications to the architecture of the package. These are relatively rare: the time between the release of versions 1.0.0 and 2.0.0 was two-and-a-half years.

Earlier released versions of TractoR are available from the project's [GitHub pages](https://github.com/tractor/tractor/tags). The very latest version of the code is also available [through GitHub](https://github.com/tractor/tractor).

Users who prefer to access the source repository using Git can clone the project using the command

    git clone --recursive https://github.com/tractor/tractor.git

Alternatively, the project can be forked on [GitHub](https://github.com/tractor/tractor).

## Installation on Linux

Firstly, ensure that R and a C/C++ compiler are installed. It should be possible to do this using your distribution's package manager (`aptitude`, `yum`, etc.). For example, on Ubuntu,

    sudo apt-get install r-base-dev

should install everything required to build R packages. More specific information for various Linux distributions is available from [CRAN](https://cran.r-project.org/bin/linux/).

After downloading the TractoR tarball (above), installing the R packages should then just be a matter of typing the following into a terminal.

    tar -xzf tractor.tar.gz
    cd tractor
    make install

In most cases the installer will find R without any help, but if an error message reports "command not found" or similar, then please use `make install R=/path/to/R`, replacing `/path/to/R` with the actual path on your system. TractoR installs R packages into a library within its own directory structure, so it will not interfere with any other versions of those packages that you may have installed.

Unless you want to interact with TractoR exclusively through R (which is unlikely in most cases), you will also need to set up your environment so that you can use the `tractor` shell program and associated script files. To do this—assuming you use the bash shell—add the following lines to the `.bashrc` file in your home directory:

    export TRACTOR_HOME=/usr/local/tractor
    export PATH=${TRACTOR_HOME}/bin:$PATH
    export MANPATH=${TRACTOR_HOME}/share/man:$MANPATH

Of course, if you have unpacked the tarball somewhere other than `/usr/local/tractor`, you will need to alter the first line accordingly.

## Installation on macOS

The simplest way to install TractoR on macOS is to use the [Homebrew](https://brew.sh) package manager, support for which was added in TractoR version 3.1.0. **Note, however, that the CRAN build of R may not be compatible with Homebrew, so if you have already installed R from CRAN, it may be better to follow the instructions in the next paragraph.** Once Homebrew itself is installed, the command

    brew install tractor/tractor/tractor

should suffice to install R, TractoR and the necessary compilers. In this case the `TRACTOR_HOME` environment variable should generally be set to `/usr/local/opt/tractor`. Homebrew also makes it easy to update to new releases of R and TractoR later on.

The alternative is to install R from [CRAN](https://cran.r-project.org/bin/macosx/), in which case you may also need to obtain the compilers used for the CRAN build. Apple's own developer tools can be installed using the command

    xcode-select --install

but at the time of writing this is not sufficient to build TractoR against R from CRAN. Either way, once R is installed, you should download the TractoR tarball (above), uncompress it, run `make install` and set up the environment as described in the instructions for Linux.

## Installation on Windows

TractoR was developed for Unix-like systems, but installation and use on Windows is possible. If you are running Windows 10 or later, the best route might be to install the Windows Subsystem for Linux, and then install TractoR as if on Linux. Step-by-step instructions [are available for this route](https://www.flakery.org/tractor-on-windows-experience-with-the-subsystem-for-linux/).

The second option is to use the [Docker containerisation system](https://www.docker.com). A Docker container for the TractoR version you want can be downloaded and launched using commands like

    docker pull ghcr.io/tractor/tractor:v3.4.0
    docker run -it --rm ghcr.io/tractor/tractor:v3.4.0

This will drop you into a `bash` shell in a Linux-based container with R and TractoR already installed and set up for you. You can consult [Docker's documentation](https://docs.docker.com/engine/tutorials/dockervolumes/) for more information on giving the container access to your data. Containerised versions of TractoR older than v3.4.0 may be available from Docker Hub, labelled by minor version as in `jonclayden/tractor:3.0`.

The final and most heavyweight option is to run a full Linux distribution within a virtual machine environment such as [VirtualBox](http://www.virtualbox.org/) or [VMware](http://www.vmware.com), and then proceed as described above for Linux.

## Checking your installation

To test that the environment is set up correctly, try typing

    tractor platform

which should produce output listing information about your system and the available software on it.

If instead you get an error from the shell saying that it couldn't find the `tractor` executable, or from `tractor` itself reporting the script file not found, the installation has not been completed correctly. Check that you have set up your environment as shown above, and make sure that you have started a new shell or sourced your `.bashrc` file to pick up the changes (`source ~/.bashrc`). Running the command `man tractor` should show the `tractor` man page.

## Usage

The `tractor` command line interface program is a wrapper which obviates the need to interact with R directly in order to use TractoR. Many common tasks, including neighbourhood tractography (see "Next steps" below), can be performed in this way through short R scripts which are stored within the TractoR home directory.

A full list of the scripts provided with the distribution can be obtained by typing `tractor list`. Further information on a particular script, including a list of options that it supports, can be obtained using `tractor -o (script name)`. For more details on the usage of the `tractor` program, please see its man page (`man tractor`).

## Next steps

It is a good idea to read a little about TractoR's specific [conventions](conventions.html), which will make the rest of this documentation easier to follow. After that you may wish to explore TractoR's implementation of ["neighbourhood tractography"](PNT-tutorial.html), a robust and flexible method for consistent white matter tract segmentation in the brain.
