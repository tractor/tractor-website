# Home

<img class="graphic" src="logo.png" alt="TractoR logo" />

The TractoR (Tractography with R) project includes R packages for reading, writing and visualising magnetic resonance images stored in Analyze, NIfTI and DICOM file formats (DICOM support is read only). It also contains functions specifically designed for working with diffusion MRI and tractography, including a standard implementation of the neighbourhood tractography approach to white matter tract segmentation. A shell script is also provided to run experiments with TractoR without interacting with R. Using TractoR you can easily

* Convert DICOM files from your MR scanner to Analyze/NIfTI format.
* Preprocess diffusion MR data to calculate tensor metrics including fractional anisotropy (FA), mean diffusivity (MD), and principal directions (see [diffusion preprocessing](diffusion-preprocessing.html)).
* Run probabilistic tractography using single seed points or one or more masks.
* Segment specific tracts in groups automatically using neighbourhood tractography (see [PNT tutorial](PNT-tutorial.html) and [HNT tutorial](HNT-tutorial.html)).
* Remove false positive tracts using a model of tract shape variability.
* Create graphics to visualise image slices or maximum-intensity projections.

If you use TractoR in your work, please cite Ref. (1) below. For details of research papers underlying the methods implemented in the package, please see the [references page](references.html).

**Please note that TractoR is research software and has not been approved for clinical use. The software is provided in the hope that it will be useful, but comes with no warranty whatsoever.**

General queries or problems may be sent to the [users' mailing list](http://groups.google.com/group/tractor-users), while bugs and other specific issues may be reported using the Issues tab above. Please describe any problem as fully as possible.

![Diffusion principal directions](principal-directions.png)

<h2 id="contents">Web site contents</h2>

- The [getting started](getting-started.html) page is the place to find out about downloading and installing TractoR. Details of the major user-visible changes can be found in the [changelog](changelog.html), and news on releases and TractoR-related publications appears below.
- Users of TractoR 1.x may find the information on [upgrading to TractoR 2](upgrading-to-TractoR-2.html) helpful, and an [addendum](paper-addendum.html) to the [TractoR paper](http://www.jstatsoft.org/v44/i08/) for version 2 is also available.
- There is specific information on [TractoR for R users](TractoR-for-R-users.html).
- Useful information about TractoR-specific conventions can be found on the aptly-named [conventions](conventions.html) page.
- The [diffusion preprocessing](diffusion-preprocessing.html) page covers the preprocessing of diffusion-weighted MR images using TractoR.
- TractoR provides reference implementations of various [neighbourhood tractography](http://www.homepages.ucl.ac.uk/~sejjjd2/research/#neighbourhood-tractography) methods, both "heuristic" and "probabilistic", for segmenting specific white matter structures. An [HNT tutorial](HNT-tutorial.html) and a [PNT tutorial](PNT-tutorial.html) using TractoR are available, as well as information on the [reference tracts](reference-tracts.html) used by both methods.
- Finally, there is a list of [references](references.html) for the methods available through TractoR.

<h2 id="news">News</h2>

**(2011-11-02)** A paper on the TractoR package, outlining its interfaces and the methods implemented in it, has just been published in the [Journal of Statistical Software](http://www.jstatsoft.org/v44/i08/). This will be key reference for the package in future.

**(2011-08-05)** With the release of TractoR 2.0, source code management is switching to [GitHub](https://github.com). Please feel free to check the [TractoR page on GitHub](https://github.com/jonclayden/tractor), and to fork the project if you want to play around with it.

**(2011-08-05)** TractoR version 2.0.1 is now available. (Version 2.0.0 was not publicly released due to a minor flaw which was corrected for 2.0.1.) This is a major new release which generalises the package and lays the foundations for future development. It also offers several new features of its own, including the ability to read and write MGH format image files. TractoR 2.0 requires R 2.12.1 or later, and is not perfectly backwards compatible with TractoR 1.x. Full details are in the [changelog](changelog.html) as usual.

**(2011-05-25)** TractoR version 1.8.0 has been released today. This release adds more flexible read support for NIfTI files, including the proposed [NIfTI-2 format](http://www.nitrc.org/forum/forum.php?thread_id=2148&forum_id=1941). Details are in the [changelog](changelog.html). This is planned to be the last major release in the 1.x series.

**(2011-01-31)** A paper outlining the various tools and packages available in R for neuroimaging analysis, including TractoR, is currently in press at [NeuroImage](http://dx.doi.org/10.1016/j.neuroimage.2011.01.013).

**(2010-12-20)** TractoR version 1.7.0 has just been released. The main addition in this release is a built-in tractography algorithm, which can improve the performance of tracking-based tasks significantly. Full details are in the [changelog](changelog.html), as usual.

**(2010-10-22)** Version 1.6.0 of TractoR is available today. This version provides a number of new scripts, options and capabilities; and reduces TractoR's direct dependence on FSL to some extent. It includes four MNI space standard brain images, which are used by various parts of the code. These have been kindly provided by the International Consortium for Brain Mapping (ICBM) -- please see Ref. (2) below. The [changelog](changelog.html) has more details.

**(2010-06-29)** Tractor version 1.5.0 has been released today. New features include support for parallelisation on multicore systems and (to a lesser extent) grids running the Sun Grid Engine; as well as visualisation of diffusion principal directions, as shown above. The [changelog](changelog.html) has all the details.

**(2010-03-11)** TractoR version 1.4.0. is now available. New features include automatic B-matrix/gradient vector rotation to compensate for subject motion, gradient scheme caching, group mapping and new visualisations. Full details are in the [changelog](changelog.html).

**(2009-11-10)** Version 1.3.0 of TractoR is now available. This version adds a new method for rejecting false positive streamlines using a [PNT model](PNT-tutorial.html), which substantially improves tract segmentation; and includes a set of tests to ensure that TractoR is functioning properly on your system. There are also various minor enhancements, as usual, and these are documented in the [changelog](changelog.html).

**(2009-08-21)** TractoR version 1.2.0 has just been released. It includes seven new reference tracts for both HNT and PNT, as well as DICOM performance improvements and various other minor enhancements. As ever, details are in the [changelog](changelog.html).

**(2009-07-03)** Documentation aimed at existing R users, which describes the R packages provided by TractoR, as well as how to write new TractoR-compatible R scripts for use with the command line `tractor` shell script, is [now available](TractoR-for-R-users.html).

**(2009-06-15)** TractoR version 1.1.0 has been released. This version contains a number of improvements to various aspects of the software, including support for a more general variant of the standard PNT tract model. Full details are in the [changelog](changelog.html).

**(2009-05-29)** Updates to the documentation, particularly the HNT and PNT tutorials, have been made to reflect the current state of the software. Additional information about [reference tracts](reference-tracts.html) has also been added.

**(2009-05-14)** The "tractor.base" R package is now available on the Comprehensive R Archive Network (CRAN). It can be found [here](http://cran.r-project.org/web/packages/tractor.base/index.html), or through your favourite CRAN mirror (once updated). This allows R developers to use the TractoR functions for reading, writing, manipulating and visualising magnetic resonance images in their own code. A short introduction to TractoR for R users will be made available here soon.

**(2009-02-18)** The [tractor-users mailing list](http://groups.google.com/group/tractor-users) can now be joined by anyone. This list/group is for any discussion relating to the software. Announcements of new versions of TractoR are also made to the list.

**(2009-02-13)** TractoR version 1.0.0 has been released. New features in this version include "unsupervised" neighbourhood tractography (NT), a set of standard reference tracts for both heuristic and probabilistic NT, and more flexible conversion of DICOM-format files. As usual, the [changelog](changelog.html) has full details on the changes since the last beta version. Although this is no longer a beta version, please remember that TractoR is research software and comes with no warranty. Dropping the "beta" label reflects mainly that the structure of the package has stabilised somewhat.

## References

(1) J.D. Clayden, S. Muñoz Maniega, A.J. Storkey, M.D. King, M.E. Bastin & C.A. Clark (2011). TractoR: Magnetic resonance imaging and tractography with R. _Journal of Statistical Software_ **44**(8):1-18.

(2) A. Evans, M. Kamber, D.L. Collins & D. MacDonald (1994). _An MRI-based probabilistic atlas of neuroanatomy_. In S. Shorvon, D. Fish, F. Andermann, G.M. Bydder & H. Stefan (eds), _Magnetic resonance scanning and epilepsy_, **NATO ASI Series A, Life Sciences**, vol. 264, pp. 263-274. Plenum Press.

[![NITRC logo](nitrc.png)](http://www.nitrc.org/projects/tractor)
