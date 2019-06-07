The TractoR (Tractography with R) project includes R packages for reading, writing and visualising magnetic resonance images stored in Analyze, NIfTI and DICOM file formats (DICOM support is read only). It also contains functions specifically designed for working with diffusion MRI and tractography, including a standard implementation of the neighbourhood tractography approach to white matter tract segmentation. A shell script is also provided to run experiments with TractoR without interacting with R. Using TractoR you can easily

* Convert [DICOM files](TractoR-and-DICOM.html) from your MR scanner to Analyze/NIfTI format.
* Apply image processing operations of many types to medical image data.
* Perform linear and nonlinear [image registration](registration.html).
* Preprocess diffusion MR data and calculate tensor metrics including fractional anisotropy (FA), mean diffusivity (MD), and principal directions (see [diffusion processing](diffusion-processing.html)).
* Run [probabilistic tractography](tractography.html) using single seed points or one or more masks.
* Segment specific tracts in groups automatically using neighbourhood tractography (see [PNT tutorial](PNT-tutorial.html)).
* Remove false positive tracts using a model of tract shape variability.
* Import and manipulate anatomical parcellations of [structural data](structural.html).
* Create, manipulate, visualise and decompose abstract [graphs representing brain connectivity](connectivity-graphs.html), either structural or functional.
* Create graphics to visualise image slices or maximum-intensity projections.

If you use TractoR in your work, please cite [the reference below](#reference). For details of research papers underlying the methods implemented in the package, please see the [references page](references.html). If you would like to hear about new releases and other TractoR-related news, we would suggest joining the [users' mailing list](https://www.jiscmail.ac.uk/cgi-bin/webadmin?A0=TRACTOR). General queries or problems may also be raised there, while bugs and other specific issues may be reported using the [GitHub issue tracker](https://github.com/jonclayden/tractor/issues). Please describe any problem as fully as possible.

TractoR is developed primarily by [Jon Clayden](http://www.homepages.ucl.ac.uk/~sejjjd2/) and colleagues at [University College London](http://www.ucl.ac.uk), with contributions and collaborations from other groups.

**Please note that TractoR is research software and has not been approved for clinical use. The software is provided in the hope that it will be useful, but comes with no warranty whatsoever.**

## Site contents

- The [getting started](getting-started.html) page is the place to find out about downloading and installing TractoR. Details of the major user-visible changes in each release can be found in the [changelog](changelog.html).
- Users of TractoR 2.x may find the information on [upgrading to TractoR 3](upgrading-to-TractoR-3.html) helpful.
- An [updated version](paper/index.html) of the original TractoR paper is available for reference.
- There is specific information on [TractoR for R users](TractoR-for-R-users.html), and additional [detailed information](guidelines-for-contributors.html) for anyone actually contributing to the project.
- Useful information about TractoR-specific conventions can be found on the aptly-named [conventions](conventions.html) page.
- A specific page covers TractoR's [image registration](registration.html) capabilities.
- The [diffusion processing](diffusion-processing.html) page covers the processing of diffusion-weighted MR images using TractoR, and there is also a specific page on [working with structural data](structural.html).
- As well as [conventional tractography](tractography.html), TractoR provides reference implementations of various [neighbourhood tractography](http://www.homepages.ucl.ac.uk/~sejjjd2/research.html#finding-specific-brain-structures) methods for segmenting specific white matter structures. A [PNT tutorial](PNT-tutorial.html) using TractoR is available, as well as information on the [reference tracts](reference-tracts.html) used by the method.
- Various tools exist for creating and working with [connectivity graphs](connectivity-graphs.html), including a reference implementation of the "principal networks" method. TractoR's facilities for working with functional data are also currently outlined there.
- There is a specific page about the [facilities in TractoR for handling DICOM files](TractoR-and-DICOM.html) and, importantly, their limitations.
- Finally, there is a list of [references](references.html) for the methods available through TractoR.

## Reference

J.D. Clayden, S. Muñoz Maniega, A.J. Storkey, M.D. King, M.E. Bastin & C.A. Clark (2011). [TractoR: Magnetic resonance imaging and tractography with R](paper/index.html). _Journal of Statistical Software_ **44**(8):1–18.

[![NITRC logo](nitrc.png)](http://www.nitrc.org/projects/tractor)
