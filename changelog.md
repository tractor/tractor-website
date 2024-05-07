# Changelog

The significant user-visible changes in each release of TractoR are documented below.

## 3.4.2 (2024-03-01)

* Package unit tests have been moved from the `testthat` to the `tinytest` framework.
* Several tweaks have been made to improve compatibility with R 4.3.x and the upcoming R 4.4.0, as well as `divest` 1.0 and `igraph` 2.0.
* The minimum required version of R has been updated in the documentation to 3.5.0. This was already the case, but the documentation was out of date. TractoR's continuous integration tests now also run on old versions of R to help ensure the minimum version specified is accurate.
* Two spurious errors that could arise during an interactive run of the `dpreproc` script have been corrected.

## 3.4.1 (2023-06-30)

* Several tweaks have been made to better support paths containing spaces, particularly for session paths in workflows. In support of this, two small new features have been added: the new `TRACTOR_WORKING_DIR` environment variable is now used as a default working directory by `tractor`, `plough` and `furrow`, if it is set, and `furrow` gains a `-r` flag to request relative paths be substituted rather than absolute ones. This is used in certain workflows to work around third-party tools' own difficulties with paths containing spaces.
* When writing an image to file, any existing "tags" file with the corresponding name is now always overwritten, to avoid the auxiliary file getting out of sync with the image file.
* Relative paths should now be correct when the reference path is a directory.
* The working directory should no longer be erroneously prepended to image paths beginning with a tilde (`~`), which indicates a home directory on Unix-like systems.
* The `bids` script would sometimes attempt to copy an image file with no extension, leading to an error. This has been corrected.
* Decomposition applied to a transformation object containing only one transform now works as expected.

## 3.4.0 (2023-05-17)

* Heuristic neighbourhood tractography is defunct. All `hnt-` experiment scripts have been removed, along with the underlying functions. This approach has been deprecated since 2017, and has no remaining advantages compared to [probabilistic neighbourhood tractography](PNT-tutorial.html).
* There is new interoperability with [MRtrix3](https://www.mrtrix.org), including read support for the [`mif` image format and `tck` tractography format](https://mrtrix.readthedocs.io/en/latest/getting_started/image_data.html). These files can now be used as input to scripts like `image`, `trkinfo` and `graph-build`.
* TractoR's tractography functions have been substantially refactored for better generality, partly to accommodate MRtrix `tck` files as input. As a result it is no longer necessary for streamlines to be written to file before being further used – they can be generated and processed entirely in memory.
* MRtrix-format `tck` tractography files can be converted to TrackVis `trk` format using the new `tck2trk` script.
* The MRtrix viewer, MRView, is now available as an external viewer through the `view` script.
* The new `compare` script compares image values to check whether two images contain the same data.
* A history of the TractoR scripts used to generate a given image is now stored in the `commandHistory` tag, and merged with the equivalent from MRtrix where relevant.
* True RGB NIfTI files are now supported for reading and writing, and internal methods for the `tensorfit` script will now produce an RGB colour fractional anisotropy map. RGB images cannot yet be transformed between spaces, though.
* A colour fractional anisotropy map is now additionally produced by the internal diffusion tensor fitting code.
* Complex-valued images are also now supported internally.
* When interpreting file paths, `furrow` will now leave any that are explicitly given (without requiring an extension to be added) as they are. This is partly because `trk` and `tck` files with the same base name can currently coexist.
* It is now possible for more object types to be summarised by `peek`.
* Workflow prerequisites are now checked more carefully.
* The `apply` script is now much more memory-efficient when combining many images.
* Functions from `tractor.base` that were deprecated in the 3.0.0 release have now been removed.

## 3.3.5 (2021-04-30)

* The [eddy](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/eddy) workflow now adds the argument `--data_is_shelled` when calling the `eddy` executable, since the absence of this flag frequently caused confusion among users. This has no effect on the output from the workflow, except to silence an error from `eddy` which is often spurious.
* The `dpreproc` script now also checks for the `eddy_openmp` variant executable name before deciding not to run eddy.
* A mistake in the self-documentation of the `workflow` script has been corrected.

## 3.3.4 (2021-01-12)

* Small tweaks have been made for better compatibility with the Apple ARM64 platform (M1 chip). This is also the first release available through Homebrew for ARM64.
* Paths to images represented using the Windows Universal Naming Convention (e.g. `\\server\dir\image.nii.gz`) are now supported (issue #5).
* Offline documentation no longer contains Google Analytics code (issue #4).

## 3.3.3 (2020-05-14)

* Small corrections have been made for compatibility with R v4.0.0, which was recently released.
* The interface for selecting a T2-weighted reference volume in the `dpreproc` script mixed up volume indices in the original dataset and the low b-value subset, which could lead to spurious errors. This has been corrected.
* The `graph-viz` script should no longer ask repeatedly about copying the figure to a PDF file.
* Empty graphs are now summarised a little more clearly.

## 3.3.2 (2019-06-07)

* The `slice` script now additionally accepts "peak" as shorthand for the slice containing the peak image intensity. Clearances can now properly be specified per-axis, and trimming should no longer cause problems when slice locations are not specified literally.
* The internal DICOM reader could previously produce logically transposed diffusion gradient tables, for example in `dpreproc`, which would lead to spurious warnings and downstream errors. This has been corrected.
* Missing matrix values are now handled more robustly when merging images.
* The `pnt-interpret` script could give incorrect results when session directories are specified as arguments and Mode:ratio is given, due to a mistake in the indexing logic. This has been corrected.

## 3.3.1 (2019-04-08)

* The `gradcheck` script will now work with raw diffusion data, if there is no processed data in the specified session directory.
* The gradient cache now explicitly only stores the unrotated gradient vectors.
* FSL-compatible `bvals` and `bvecs` files should now always be created before the `dtifit` workflow is run.
* Workflow run-times are now reported.
* The self-documentation function called by `tractor -o` now works properly when the absolute path to a script is provided.

## 3.3.0 (2018-12-12)

* This release introduces "workflows" as the primary means by which TractoR calls third-party programs. These are small shell scripts, stored in `share/tractor/workflows`, which make heavy use of `furrow` to call external software in a way that is consistent with the TractoR session convention. They may be called implicitly or explicitly, the latter using the new `workflow` script.
* TractoR now uses the `RNifti` package for NIfTI file handling, which is backed by the NIfTI reference C library. This should provide some performance improvements, but more importantly it makes NIfTI support much more complete. Image "xforms" and other metadata should now be better preserved through read/write cycles.
* Diffusion gradient directions and b-values may now be included as image tags, and are more consistently written to .dirs auxiliary files.
* A new script, simply called `image`, allows images to be copied, moved or linked on the file system along with any auxiliary files. This is the first TractoR script to use a subcommand syntax, where the first argument specifies the operation required.
* The new `bids` script helps with creating [BIDS datasets](http://bids.neuroimaging.io).
* The `clone` script can now be called with `Map:true`, in which case the new session uses a map file to point to existing subdirectories within the old one, rather than copying their contents across. This functionally duplicates a session with almost no extra cost in terms of disk usage. Subdirectories that are subsequently added or replaced will cause the two sessions to diverge.
* The `age` script will now work with tagged NIfTI files, if patient birthdate or age information is stored with them.
* The `extract` script gains an option to exclude regions. This can be used, for example, to extract all grey matter apart from a particular subregion.
* `fsleyes`, the new viewer in recent FSL releases, is now supported by the `view` script.
* The `divest` DICOM back-end can now be used by the `import` script.
* There is now an option to write out the final face mask in the `deface` script.
* It is now possible to run multiple replications of an experiment, using `plough` with the new "-R" flag. Compatibility between SGE and `plough` has also been improved.
* Session subdirectories, and files not aliased by TractoR, can now be referenced through `furrow`.
* The `tractor.base` package now has a set of unit tests.
* The reason for terminating each streamline is now stored, as a numeric code, in .trk files produced by the `track` script.
* It is now possible to perform tractography in only one direction away from the seed point.
* Coloured output is now suppressed if the standard output or standard error streams appear not to be terminals (e.g. if the script's output is piped). It can also be suppressed by setting the `TRACTOR_NOCOLOUR` environment variable.
* The `TRACTOR_FILETYPE` environment variable is deprecated, as is writing to Analyze format. Output format will always be NIfTI-1, although this can subsequently be changed where needed using the `chfiletype` script.
* The "Context" option to the `bedpost` script is deprecated.
* The output from `tractor -o (script)` now reads "(no value)" instead of "NULL" for options with a null default value.
* Logical values such as "yes" and "no" are now accepted by scripts, in addition to "true" and "false".
* Support for the session format from TractoR 1.x has been removed. This was deprecated in v3.1.0.

## 3.2.5 (2018-08-07)

* Multiple image series read by `dpreproc` stage 1, with `DicomReader:divest`, will now be reoriented to a common orientation before merging.
* The `deface` script now checks whether the bottom edge of the face mask is within the image before trying to extend it downwards. In addition, slices containing no extended face mask voxels are now skipped over during subsequent processing. This should resolve some spurious errors.
* Reading a non-axial 2D image could produce an error. This has been corrected.
* Attempting to calculate clustering coefficients for directed, weighted graphs is now a warning rather than an error.
* Failure to find a binary called `fslview_deprecated` will no longer produce an error, restoring compatibility with older builds of FSL.
* The compatibility of `furrow` with external commands has been improved.

## 3.2.4 (2018-04-26)

* The `Rcpp` package has been updated for compatibility with the recently released R 3.5.0.
* Paths are now expanded by `dicomread`, so that filenames beginning with "._" are no longer created when reading from the current working directory. (Such files are generally invisible.)
* The code behind `plough` is now more careful to avoid spurious errors when non-loop variables have length greater than one.

## 3.2.3 (2018-04-10)

* Attempting to merge tags from more than two images, notably in `dpreproc`, should no longer produce an error.
* FSLview has been deprecated in recent FSL builds, and the binary renamed to `fslview_deprecated`. TractoR now checks for this name, and so running the `view` script with `Viewer:fslview` will work again. There is not yet any support for FSL's replacement viewer, `fsleyes`, although it can be invoked through `furrow`.
* The `gradread` script no longer requires a data image to be present if a *b*-value file is provided as the third argument.
* Calculation of graph modularity has been improved for the case where a node is in none of the communities.
* Further tweaks to unit tests have been made.

## 3.2.2 (2018-03-16)

* The `reg-apply` script would produce an error if given multiple transforms in .xfmb format. That has been corrected.
* Due to an oversight, vertex and principal network names disappeared from the output of `graph-decompose` in v3.2.0. They have now been reinstated.
* The Homebrew distribution of TractoR now declares a dependency on JasPer.
* An occasional failure in the `tractor.graph` package's unit tests has been addressed.

## 3.2.1 (2018-02-26)

* Running `dpreproc` with `DicomReader:divest` on a session directory containing DICOM files from different series will now also combine metadata from those series (where appropriate), and write it to an auxiliary .tags file.
* Recent minor updates to supporting packages `RNifti`, `RNiftyReg`, `mmand`, `yaml` and `corpcor` have now been incorporated.
* Infinite weights could rarely occur in `tensorfit`, when using the IWLS method. These are now detected and ignored.
* A spurious error in `dpreproc` due to a typo has been corrected.

## 3.2.0 (2018-02-14)

* The new `pnt-sample` script allows one to sample synthetic streamlines from a PNT model. There is [a new paper](http://dx.doi.org/10.3390/jimaging4010008) with the full details.
* There is now basic support for the [BIDS format](http://bids.neuroimaging.io), a session-like hierarchy structure for multimodal acquisitions.
* The new top-level command `furrow` can be used to call any third-party program after substituting TractoR's session path shorthand for the canonical image paths. This is useful for compatibility with other software.
* TractoR's graph-handling code has been substantially refactored, and detailed unit tests have been added.
* Streamline seed points and end points can now be mapped, using the new `trkmap` script.
* The new `trkinfo` script provides basic information on the streamlines stored in a .trk file.
* A new make target, `deeptest`, installs additional packages from CRAN and then runs package unit tests (currently only for `tractor.graph`) before running the main integration tests.
* The `dicomsort` script can now use the more robust `divest` back-end, and gains the ability to clean up empty subdirectories. Additional metadata is now extracted by `dicomread` with `Method:divest`.
* A partitioned graph object is now also produced by `graph-decompose`, which contains the original graph and information about the partition. This may also be used as a reference partition for new graphs.
* Generation of colour scales is now handled by the `shades` package. The `slice` script now additionally supports the "viridis" colour scale, which is perceptually uniform and interpretable by viewers with a colour vision deficiency (colour blindness).
* The `tensorfit` script now support FSL `dtifit`'s weighted-least squares option, as `Method:fsl-wls`.
* The `extract` script now accepts named regions, for extraction from parcellations.
* A file containing *b*-values may now be given as the third argument to the `gradread` script.
* It is now possible to create a .trk file containing the streamlines selected by `pnt-prune`.
* Streamlines stored in .trk files may now also be transformed between spaces by the `transform` script, although this is currently very slow for nonlinear transformations.
* The `list` script now arranges its output into categories.
* The `dicomtags` script now tries harder to read metadata from files using an unsupported transfer syntax.
* The `status` script now examines raw data files if processed ones are not yet available.
* A user-defined mask can now be passed to the `dirviz` script.
* The `slice` script now offers some control over the interpolation kernel used.
* The polar plots used by TractoR's internal image viewer for diffusion data now use different colour shades for each *b*-value shell.
* The loop-checking logic in the tractography code has been tweaked to correct the boundaries between logical blocks.
* Session paths stored in PNT data files should now always be interpreted as strings, avoiding potential errors.

## 3.1.4 (2017-11-09)

* The median streamline used by default in `pnt-prune` when all individual streamlines are rejected could be incorrect. This has been fixed.
* The `apply` script will no longer fail when used with more than 26 image arguments (although only the first 26 can be referred to in the function).
* Images with a data size of 2 GiB or more can now be written to file by TractoR.

## 3.1.3 (2017-09-27)

* The `graph-props` script should now properly respect the "DisconnectedVertices" option for all properties. The number of self-connections present in the graph is also reported separately for clarity.
* Scripts which perform an operation on a subset of streamlines stored in a .trk file, notably `pnt-prune`, would often include one additional streamline that should not be in the selection. This has been corrected.
* The slice script now fixes "Alpha" to "binary" for masking images that are themselves binary, to avoid masking out everything and producing an empty layer.
* The `view` script will no longer produce an error when multiple images from a session's diffusion directory are specified.

## 3.1.2 (2017-08-15)

* A warning about a namespace clash will no longer be seen when starting the TractoR console. A side effect of this change is that the `RNiftyReg` package's functions are no longer directly visible. The `tractor.reg` interface can be used instead.
* TractoR's diffusion tensor fitting routine, used by `tensorfit`, is now more robust. In particular, it will handle exact fits and impose a limit on the iteration count when using iterative weighted least-squares.
* The trivial case for `plough`, where the design file contains no variables of length greater than one, now works as expected.
* The `view` script will now use the time series plot type by default, for 4D volumes whose interpretation cannot be guessed.
* Scripts using tractography other than `track`, such as `pnt-data`, will no longer report the tractography run-time, to avoid producing overly verbose output.

## 3.1.1 (2017-07-03)

* Tractography results could previously be wrong if a session used a mixture of images stored in different orientations. This has been corrected.
* The `track` script now reports the time spent tracking.
* A disparity between TractoR and NiftyReg in the assumed orientation of ANALYZE-format files has been corrected. This should resolve failed registration of these files.
* Further package tests have been added, to check some recently added features.

## 3.1.0 (2017-06-14)

* A more robust alternative to TractoR's internal DICOM-handling code is now available in the form of `divest`, a new first-party R package wrapped around the popular tool [`dcm2niix`](https://github.com/rordenlab/dcm2niix). Although the internal method remains the default in `dicomread` for backwards compatibility, using `divest` offers several advantages, such as removal of the need to pre-sort DICOM directories, interactive selection of series, and semi-automatic session construction. The internal code is still used by `dicomtags`.
* Tags, representing general and extensible image metadata, may now be written to auxiliary .tags files in YAML format -- and key metadata from DICOM files is now written out in this way by `dicomread` with `Method:divest`. These will automatically be read back in with the associated image, allowing acquisition parameters and other useful information to be kept with images.
* A totally new set of [reference tracts](reference-tracts.html) have been added for use with [probabilistic neighbourhood tractography](PNT-tutorial.html), based on manual selection of tracts from 80 healthy adults aged 25–64. In addition, a series of pretrained models for each tract are available, based on the same cohort, to simplify usage in new datasets. Further details may be found in a paper at MIUA 2017. To use these reference tracts, the `TRACTOR_REFTRACT_SET` environment variable should be set to `miua2017`.
* Tractography may now be performed using the diffusion tensor as the underlying signal model. Although less sophisticated than FSL-BEDPOSTX, the tensor model is much quicker to fit, and may be of interest for comparison. The `track` script gains a "PreferredModel" option, which may be set to `dti` if required.
* The `track` script also gains "StepLength" and "MaxLength" options.
* The new `deface` script can be used to mask out the face area of high-resolution structural images to prevent face reconstruction and preserve anonymity.
* The internal viewer accessed through the `view` script gains a polar plot panel for orientational data, notably diffusion data. This will be used by default for viewing 4D diffusion-weighted images in a session. The viewer now also ignores infinite values when calculating the intensity window.
* The `slice` script now allows different colour scales to be used for each overlay, and allows out-of-window voxels to be masked out rather than clipped to the extremes. It is also less affected by nonfinite data values.
* TractoR is now aware of masked (i.e., brain-extracted) and unmasked reference images in each space, and when performing implicit registration, it will attempt to register masked images to masked images and unmasked images to unmasked images. This should improve registration accuracy.
* Voxels with zero variance will now be ignored when performing PCA in `graph-build`. There is also tentative support for nuisance regressors when calculating functional connectivity matrices.
* The `graph-props` script gains an option to normalise graph weights, fixing the maximum at 1 (as the [Brain Connectivity Toolbox](https://sites.google.com/site/bctnet/) does for certain properties). A correction to weighted clustering coefficients has been added, and two weighted generalisations of the mean clustering coefficient are now available.
* The `apply` script will now print out simple vectors as well as scalar results.
* The performance of `pnt-prune` has been substantially improved.
* The `platform` script now also lists the R packages installed in TractoR's package library, along with their version numbers.
* The `loder` package is now used instead of `png` for writing PNG files. As a result, no external `libpng` library is required.
* The third-party `yaml` package now handles reading and writing YAML files.
* TractoR may now be installed using [Homebrew](https://brew.sh). Partly to support this, the TractoR directory structure now more closely follows the [Filesystem Hierarchy Standard](https://en.wikipedia.org/wiki/Filesystem_Hierarchy_Standard).
* Each test is now run in a separate temporary directory, which allows them to be run in parallel. Tests requiring FSL will now be skipped if it is not installed, rather than failing.
* [Heuristic neighbourhood tractography](HNT-tutorial.html) is now deprecated in favour of [probabilistic neighbourhood tractography](PNT-tutorial.html).
* Support for the session directory format used in TractoR 1.x is now deprecated, and will be removed in a future release.

## 3.0.9 (2017-04-13)

* The `hnt-viz`, `pnt-viz` and `pnt-prune` scripts would previously number their output incorrectly, using the argument index rather than the data file index. When called through `plough`, this could lead to a single output file being repeatedly overwritten. This has been corrected.
* Spurious errors about non-numeric arguments should no longer arise when reading a DICOM series using an implicit VR transfer syntax.
* When reading from a .trk/.trkl file pair, the metadata is now checked to ensure that the two files agree on the number of streamlines present. This should avoid potential crashes when a .trk file is updated without its partner.
* The documentation has been updated to match the new style of the TractoR website.

## 3.0.8 (2017-02-17)

* Support has been added for containerised builds of TractoR using [Docker](https://hub.docker.com/r/jonclayden/tractor/).
* Tractography operations could produce "bad allocation" errors on some platforms. This should now be fixed.
* Tests requiring FSL will now be skipped if FSL doesn't seem to be installed, rather than producing an error.
* The `plough` self-test should no longer fail with an error about a missing executable if the `TRACTOR_HOME` environment variable is not set.

## 3.0.7 (2016-11-07)

* The 3.0.x series of releases introduced a bug in the implementation of principal networks (accessed via `graph-decompose`), which could result in nonsense output. This has now been corrected.
* Session map keys are now fully case-insensitive, as intended.
* The speed of the `dicomsort` script should now be a little better.

## 3.0.6 (2016-08-23)

* Sulcus labels are allocated to some grey matter voxels by FreeSurfer, so they have been reinstated into the Destrieux parcellation lookup table.
* TractoR's own image viewer (the `view` script) could sometimes use incorrect colours when some regions were missing from a parcellation. This has been fixed.
* The `dpreproc` script no longer produces errors when encountering DICOM files with no ASCII header.
* Merging multiple related DICOM series into one image could sometimes fail. This has been corrected.

## 3.0.5 (2016-08-03)

* The `compress` script previously interpreted all of its arguments as parts of a single file name. This has been corrected.
* The mean clustering coefficient reported by `graph-props` now properly respects the "DisconnectedVertices" option.
* Encountering an empty transform directory (with an .xfmb extension) should no longer lead to an error.
* A spurious error, arising when indexing into sparse images under certain conditions, has been fixed.

## 3.0.4 (2016-07-01)

* The new `TRACTOR_NOSYMLINKS` environment variable may be set to `true` to turn symlinking operations into copies. This uses more disk space, but is required on certain file systems, notably on some network mounts.
* A transformation strategy between T1-weighted structural space and FreeSurfer space has been added explicitly.
* A problem in the calculation of metadata when writing MGH/MGZ files has been fixed. This should address problems with the results of `freesurf`.
* The `peek` script now also works with CSV files representing graphs.
* Graphs without vertex names (notably CSV files from non-TractoR sources) should no longer be mislabelled when visualised using `graph-viz MatrixView:true`.
* Directories containing only a single DICOM file, and pertaining to a diffusion acquisition, should no longer cause errors.

## 3.0.3 (2016-06-21)

* The `dicomread` script now respects echo number when reconstructing images, thereby improving results from multiecho sequences.
* Tractography pipelines (notably within `track`) can now be interrupted, using the standard Ctrl-C command. This can be useful to cancel a long-running operation.
* The `track` and `graph-build` scripts are now consistent in their treatment of the "TargetRegions" option, allowing greater flexibility. Previously, `graph-build` would only accept parcellation labels; now, named image files may also be used.
* A mistake relating to internal indexing in sparse arrays has been corrected. This could previously have led to errors or incorrect results in `track` when target or seed regions overlapped, and possibly other scripts.
* Attempting to `peek` at graph objects could fail under certain circumstances. This has been corrected.

## 3.0.2 (2016-06-13)

* Guessing of phase-reversed volumes in `dpreproc` is now more robust. Reported volumes are also numbered relative to the whole series, not just the *b*=0 volumes, for consistency with the "ReversePEVolumes" option.
* Remapping subdirectories within a session could lead to problems finding images. This has been corrected.

## 3.0.1 (2016-05-18)

* The `dicomsort` script's ability to sort by series number or time has been reinstated, although sorting by UID remains the default.
* An updated version of the TractoR paper is now provided [online](http://www.tractor-mri.org.uk/paper/) and within the `share/doc/paper` subdirectory of the package. There is also a more extensive `README.md` file, and an updated `INSTALL.md` file.
* Building the `tractor` executable should no longer fail just because the `bin/exec` subdirectory does not exist.
* When running `make install` with the `TRACTOR_HOME` environment variable pointing to a different TractoR installation, the packages would previously be installed there in error. This has been corrected.
* Creating transformations on a different filesystem to the system's temporary directory should no longer fail.

## 3.0.0 (2016-05-09)

* The package's requirements and dependencies have been simplified somewhat. A Fortran compiler should no longer be required to install R packages, and ImageMagick is no longer needed to create images.
* The tractography systems have been completely overhauled to make them much more efficient, especially when working with large numbers of streamlines, as in connectomics. A pipeline approach is now taken to limit memory requirements, and more work is done in compiled code for speed. The interface has also been consolidated, with the old `track`, `rtrack`, `mtrack`, `ptrack` and `xtrack` scripts being replaced by a single, flexible `track` script, which also offers some new features such as random seeding and length thresholding. All support for tractography using FSL `probtrackx` has been removed.
* The [TrackVis file format](http://www.trackvis.org/docs/?subsect=fileformat) is now used as TractoR's native format for streamlines, which allows paths to be easily visualised. Consequently, the `streamlines2trk` script has been removed.
* A new top-level command, `plough`, allows a TractoR script to be called multiple times using different sets of arguments or configuration variables, optionally parallelising across cores or using a grid engine. This is a universal alternative to piecemeal vectorisation in a handful of specialised scripts such as `gmean` and `pnt-data-sge`. The latter two scripts have therefore been removed, while many others have been simplified by working on only one session or image at a time.
* TractoR can now work with "multishell" diffusion-weighted data, and tries to choose appropriate parameters when preprocessing and fitting such data. The `dpreproc` script also provides an interface to FSL's [`topup`](http://fsl.fmrib.ox.ac.uk/fsl/fslwiki/TOPUP) and [`eddy`](http://fsl.fmrib.ox.ac.uk/fsl/fslwiki/EDDY/) tools for correcting susceptibility and eddy current induced distortions, respectively.
* It is now possible to refer to standard images within a session directory using a shorthand that incorporates the `@` symbol, as in `/data/subject1@FA` for the FA map from session directory `subject1`, or `/data/subject2@functional/data` for the functional data series from `subject2`. Scripts such as `mean` and `mkroi` have been substantially generalised, without becoming more verbose, by taking advantage of this mechanism.
* The MNI space reference brain has been updated to a newer, higher resolution and much sharper image, based on nonlinear coregistration of 152 individuals.
* Noninteractive visualisation of images, including overlays, is now handled by the `slice` script, which can create visualisations in one or more planes, including multiple views within the same image. This much-improved script subsumes the functionality of the old `proj` and `contact` scripts, which have been removed.
* [Probabilistic neighbourhood tractography](PNT-tutorial.html) is now much faster, often by 90% or more, and is in fact now appreciably faster than the older and much less robust [heuristic neighbourhood tractography](HNT-tutorial.html) (although it typically involves more steps).
* Transformation information between images and spaces is now stored as a series of text matrices and NIfTI images within a directory with an .xfmb extension (for transform bundle), rather than a flat .Rdata file. This was necessary due to upstream changes in NiftyReg, but it also has the advantage of greater transparency. The new `reg-info` script can be used to obtain information about these directories.
* The accuracy of a registration can be visualised using the new `reg-check` script.
* The new `transform` script can be used to transform an image or point between named spaces as they relate to a particular session.
* The new `components` script can be used to find connected components in images.
* NIfTI files can be reduced in size, at the cost of some loss of precision, using the new `compress` script.
* The `mkroi` script can now generate ROIs of different shapes, and with different widths in each dimension.
* The [LEMON C++ library](https://lemon.cs.elte.hu) is now used rather than the rather complex "igraph" R package, for calculating graph metrics.
* The "MaskingMethod" option to `dpreproc` once again defaults to using FSL-BET, but will fall back to k-means if the `bet` executable is not found. The k-means method itself has been improved by first finding the largest connected component, which tends to result in the removal of more non-brain tissue.
* TractoR's image viewer now shows parcellation labels when a lookup table file (.lut) is found.
* Graphs can now be read from CSV files in all scripts, although .Rdata files contain more complete information.
* The `reg-apply` script can now apply composite and half transforms to images.
* Registration can now be initialised from a FLIRT transformation matrix file.
* The `apply` script gains a "Combine" mode which allows multiple images to be merged after applying the function to each in turn. This script, along with `transform`, can now do the job of `gmap`, which was very specialised and has been removed.
* The `plotcorrections` script now plots all modes on the same device, and allows correction values to be written to a CSV file. The sense of its decomposition is now a little different, so results will differ from those in TractoR 2.x.
* The `dicomsort` script now sorts by series UID by default.
* Configuration variables are now matched in a case-insensitive manner, and variables which are supplied on the command line but not used are reported in a warning.
* TractoR can now read and parse Siemens ASCII headers from DICOM files, and these can be shown using the `dicomtags` script.
* An improved method is now used for placing knot points along tracts in `pnt-data`. The output also contains the session path rather than an ID number, rendering the `identify` script unnecessary. Therefore, the results of this script are not completely consistent with TractoR 2.x. Old output files can be converted to the new format, but it is better not to mix output from the two versions in one study.
* Default session maps are now explicitly stored within the `etc/session` subdirectory, and these may be used as templates for more specialised maps.
* Diffusion directions read from DICOM files are now flipped along the Y-axis by default.
* Seed points for tractography are now jittered within the voxel by default.
* Voxels containing less than the required seven strictly positive values are now handled gracefully by `tensorfit`. In addition, an image called `dti_bad` is created, which maps the numbers of bad data points across the image volume.
* NiftyReg is now the default linear registration method.
* Image origins are now always three-dimensional.
* Camino-specific scripts `fsl2camino`, `camino2fsl` and `caminofiles` have been removed. They were poorly maintained, and largely redundant following Camino's support for NIfTI images.
* The "-r" flag to the main `tractor` program is defunct.
* Extensive low-level and upstream package improvements have been incorporated.

## 2.6.5 (2018-06-19)

* The `Rcpp` package has been updated for compatibility with R 3.5.0 (in line with TractoR version 3.2.4).
* An inconsistency between `pnt-data` and `pnt-data-sge` prevented the latter from working as expected for multiple sessions, when seed points were specified for each case. This has been corrected.
* The `pnt-interpret` script no longer strictly requires a session list, as long as subject and seed information are stored in the dataset.

## 2.6.4 (2016-11-07)

* The `pnt-data-sge` script will no longer specify the wrong number of array jobs to SGE when the `SessionNumbers` option is used.
* Some minor issues with the `RNiftyReg` package have been patched.

## 2.6.3 (2016-04-27)

* An error in the calculation of clustering coefficients has been corrected.
* Graphs containing only negative weights would previously be shown with an inverted colour scale. This has been corrected.
* A subtle difference between TrackVis's voxel grid and TractoR's is now corrected for in the `streamlines2trk` script.
* Run times are now reported for tests.

## 2.6.2 (2015-03-24)

* NIfTI format files which are endian-swapped, relative to the platform being used to read them, will now be handled correctly. Previously these would lead to a rather cryptic error.
* The `graph-build` script (with `Type:functional`) will now ignore voxels with totally flat time courses, rather than producing an error. These could arise as a result of masking during preprocessing.

## 2.6.1 (2015-03-10)

* Spurious errors should no longer be produced when overwriting a session subdirectory.
* Zero-length streamlines are now usually retained. Discarding these could violate the assumptions of other code, and would sometimes lead to a test failure.
* Failure to install optional packages `RcppArmadillo` and `mmand`, which generally require a Fortran compiler to build, no longer leads to outright failure to install TractoR. (More information on Fortran requirements has also been added to the documentation.)
* The TractoR distribution version is now printed alongside the `tractor` program version when `tractor -h` is run. This has been a recurring source of confusion.

## 2.6.0 (2015-03-06)

* TractoR now requires R version 3.0.0 (released April 2013) or later.
* TractoR now has support for handling functional (BOLD) data, including functional connectivity analysis. However, fMRI preprocessing must currently be performed using other tools.
* The `graph-build` script gains the ability to create functional connectivity graphs. Regionwise time courses may be obtained by simple averaging or principal components analysis, and connectivity is quantified in terms of correlation, partial correlation, covariance or precision. An optional shrinkage approach is available to regularise these measures when the number of time points is limited.
* Streamlines can now be ignored before they are stored if they do not reach targets of interest. This is used by the `xtrack` and `ptrack` scripts, and will also be used by `mtrack` if `TruncateUnterminated:true` is given. Streamline files can be much smaller, and memory usage less, as a result.
* Further DICOM improvements. A missing "pixel data" tag (0x7fe0, 0x0010) will no longer result in a DICOM file being treated as invalid. Slice gaps are now included in the through-plane voxel dimension. And the code tries to guess when a "mosaic" DICOM file contains the per-slice rather than per-volume TR (as some do), and correct to the latter.
* The new `graph-extract` script can be used to extract a subgraph containing some of the vertices from a larger graph.
* TractoR is now more cautious about overwriting existing directories, and in particular, a directory mapped outside the session directory should never be deleted.
* The `view` script gains a `TimeSeries` option, which can be used to visualise time series in 4D images.
* The `graph2csv` script now writes vertex attributes into the CSV file, as comments.
* The `graph-props` script gains an `IgnoreSign` option.
* Registration strategy files can now specify the use of FSL or NiftyReg for affine registration.
* Switching the `EddyCorrectionMethod` in `dpreproc` will now appropriately overwrite the result of a previous correction.
* Self-connection weights are no longer included in the default weight limits when plotting graphs with `graph-viz` and `MatrixView:false`. They are often large relative to other connections, but are not visible in these plots.
* A test for reading NIfTI-2 format files has been added (the code already passed it).
* Indexing into sparse arrays is now more reliable.

## 2.5.2 (2014-05-20)

* The `graph-build` script now accepts a comma-separated list of target regions, bringing it in line with `xtrack` and intended behaviour.
* Running `make check-md5` should no longer produce an error if no `tmp` directory exists.

## 2.5.1 (2014-03-19)

* A mistake in the install script, `tractor_Rinstall`, has been corrected.
* R's facilities for checking MD5 sums are now used in preference to system ones, for portability.
* The graph decomposition test has been made less stringent.
* Author and copyright information has been updated.

## 2.5.0 (2014-03-18)

* TractoR now has facilities for working with graph representations of brain connectivity, including a reference implementation of the Principal Networks approach to graph decomposition. A set of new scripts has been added to support this, including `graph-build`, `graph-reweight`, `graph-decompose`, `graph-props`, `graph-viz` and `graph2csv`. Please see the new [connectivity graphs tutorial](connectivity-graphs.html) for further information.
* In support of the new graph capabilities, TractoR can now work with structural (particularly T1-weighted) images, as well as diffusion data. It can also work with anatomical parcellations of the brain, and transform them between spaces. A wrapper script for Freesurfer's `recon-all` tool is also provided. New TractoR scripts relevant to structural data are `import`, `parcellate` and `freesurf`. Please see the new page on [working with structural data](structural.html) for more information.
* A new test data set, which includes structural data, has been introduced to replace the previous test data.
* Transformation strategies between different imaging spaces are now configurable, with defaults given by the `$TRACTOR_HOME/etc/session/transforms/strategy.yaml` file.
* The new `xtrack` script can be used for tracking between parcellated regions, specified by name or type.
* The `trim` script has been added for removing volumes from multivolume data sets.
* The new `apply` script can be used to apply an arbitrary R expression to the contents of one or more images.
* The `path` script has been added for identifying the path to an image within a managed session hierarchy.
* The `split` script can be used to split a serialised list of objects into its components.
* The `dpreproc` script now accepts `EddyCorrectionMethod:none` for data sets which are already well aligned and have minimal eddy current induced distortion.
* The `mtrack` script now allows seed points to be subjected to random jitter, to move them off the regular grid.
* The `tensorfit` script with `Method:ls` (the default) is now more statistically efficient in the presence of invalid or missing data.
* The `imagestats` script now handles missing values in images gracefully.
* The `dicomsort` script gains an option to use series time rather than series number as the identifier. This can be more reliable if DICOM files were acquired from multiple scan sessions.
* TractoR's internal image viewer now fixes the black and white point across a whole image for consistency.
* R's raster plotting functionality is now used when plotting images, for speed.
* Textual output and messages should now use the full width of the terminal screen more effectively.
* Running `make install` from the main TractoR installation directory is now equivalent to `make install-local` after the latter has been run once. In other words, the initial preference for a local install is maintained even if the `-local` suffix is missed in future invocations.
* The output format for `tractor -o` has been tweaked, and their is now support for examples.
* It should now be possible to coregister files stored in Freesurfer's MGH format with FSL-FLIRT.
* The first and last messages printed by the main `tractor` script are now output to the standard error stream.
* Checksums for each file in the distribution are now included and can be checked using `make check-md5`. This is mainly intended for checking whether local modifications have been made.

## 2.4.2 (2013-10-18)

* The binary front-end program should no longer misinterpret script arguments beginning with a dash (`-`). Previously it would try to interpret these as its own arguments, most likely leading to an error.
* The DICOM reading code is now more flexible with regard to the orientation of Siemens mosaic images. Credit goes to [Doug Greve](http://www.nmr.mgh.harvard.edu/~greve/dicom-unpack), among others, for information on the some of the subtleties, both in this release and in 2.4.0.
* The `streamlines2trk` script should no longer produce a "could not find function" error.
* The installation instructions have been updated to reflect the recent system requirement for a C/C++ compiler.
* There have been minor tweaks to the R documentation for the `tractor.base` package.

## 2.4.1 (2013-07-09)

* The native tracker is now used in scripts which do not have an explicit `Tracker` option, such as `hnt-ref`, `hnt-eval` and `pnt-viz`. This brings them into line with other scripts, and was the intention for TractoR 2.4 and above.
* The new TractoR interface is now compiled in a more portable way, and should build successfully on a more diverse range of platforms. A couple of small memory allocation problems have also been corrected.
* The linear registration test has been made less stringent.
* The wording of an error message in the `reshape` script has been clarified.

## 2.4.0 (2013-07-02)

* A C/C++ compiler, such as `gcc`/`g++`, is now required to install TractoR. A suitable compiler can be installed using an appropriate package manager (`aptitude`, `yum`, etc.) on Linux, or with Xcode (from the Mac App Store) on OS X. R handles all the details of actually compiling code.
* TractoR now offers tools for linear and nonlinear image registration, and the entire infrastructure for transforming images and points between different spaces has been totally reworked. A new family of scripts (`reg-linear`, `reg-nonlinear`, `reg-apply` and `reg-viz`) has been added for direct registration. Implicit registration, whereby points or images are transformed between spaces as part of another operation such as neighbourhood tractography, behaves as before by default, but the new NiftyReg back-end can be used by setting the `TRACTOR_REG_METHOD` environment variable to `niftyreg`. The new `tractor.reg` package supports all registration and transformation, and supporting packages `bitops`, `oro.nifti` and `RNiftyReg` have been added to the TractoR distribution.
* The `dpreproc` script gains a new `EddyCorrectionMethod` option, which allows NiftyReg to be used for volume-to-volume coregistration.
* TractoR now uses its own command-line front-end, rather than the standard R interface. This allows for greater flexibility, and removes the need for ugly hacks to get R to behave as required. The main user-visible effect of this change is that error and warning messages will now appear in colour, if supported by your terminal emulator.
* A new `console` script has been added, which starts an interactive R session using TractoR's front-end, in a context where all TractoR-related R packages have been loaded.
* The new `reshape` script can be used to reshape the data in an image.
* The `Tracker` option is deprecated everywhere it occurs. Now that a compiler is required, the internal tracker should always be available.
* The `tractor.native` package is now called `tractor.track`, to more specifically indicate its purpose.
* Calls to scripts whose function is purely informative (`dicomtags`, `imageinfo`, `view`, etc.) are no longer recorded in the "tractor-history.log" file.
* Further improvements have been made to DICOM processing. Transfer syntaxes, and slope and intercept values, are now respected; and image origins are now extracted from the metadata.
* TractoR R packages can now be installed within the TractoR file hierarchy using `make install-local`. This can be convenient to avoid permissions issues, or when running multiple versions of TractoR in parallel.
* The `platform` script now additionally reports the main R package library in use. This will differ between "local" and "nonlocal" installs.
* The main `tractor` program gains a "-f" option, which can be used to profile the performance of a script. Information on the time spent in each function will be written to a file named "(script name).Rprof" in the working directory. This is intended for advanced users only.
* The data type of an image file is no longer stored internally, and instead a suitable type is chosen when the image is written to a file. The `TypeCode` option in the `chfiletype` script is therefore defunct.
* The `cal_max` and `cal_min` fields of a NIfTI image are now written using appropriate values.
* Image data can now be stored without reordering to LAS internally, and writing non-LAS images is supported for NIfTI format (only).
* There have been significant changes to `MriImage`, one of TractoR's key internal data structures, but this should only affect those who use TractoR packages from within R.
* X11 should no longer be started as a side effect when a TractoR script is called on Mac OS X. This could cause a delay of several seconds.
* Voxel locations are now rounded after being converted to R indexing, rather than before, in the `slice` script.
* Handling of sparse images has been improved slightly.

## 2.3.2 (2013-05-02)

* The origin would sometimes be read incorrectly from MGH-format files. This has been corrected.
* The "dti_SSE" image created by `tensorfit` could sometimes contain large numbers of `NA` values. This has been corrected.
* Empty DICOM tags no longer cause spurious errors.
* The debug-level message describing the orientation of an image being read should now always be accurate.

## 2.3.1 (2013-02-12)

* The tests should no longer fail after a clean install of the package.

## 2.3.0 (2013-02-04)

* TractoR now includes a simple interactive image viewer, which is used by default unless the `TRACTOR_VIEWER` environment variable is set to `fslview` (for FSLview, as in earlier releases) or `freeview` (to use FreeSurfer's FreeView, for which a new interface has also been added). The new TractoR viewer remains work in progress, and FSLview is still favoured by scripts for showing 4D or vector-valued images.
* The `dicomsort` script's `SortBySubjectFirst` option has been replaced by a more general `SortOn` option, which allows the files to be sorted by series, subject and/or date in any order. The script is also more careful to avoid deleting files which are not moved because they are already in the right place.
* The `mtrack` script now allows the user to specify "termination" masks, which cause truncation of streamlines. It is possible to specify a single mask as both a waypoint and a termination mask. Likewise, `ptrack` gains a `TerminateAtTarget` option.
* TractoR's internal tractography algorithm is now the default for `rtrack` and `mtrack`.
* If the `gradrotate` script is applied to a session, the original (unrotated) gradient directions are first copied to the file `tractor/diffusion/directions-orig.txt`. This makes it much easier to tell whether rotation has been performed, and is used by the code to make sure that the gradients are not rotated twice.
* The `gmap` script gains a `UseReferencePlanes` option: if it is "false" then the plane of the maximum in the image is used for visualisation. In addition, the script should no longer produce an error when the reference seed point is not in the centre of a voxel.
* The `dirviz` script gains a `ScaleFactor` option to control the size of the PNG image produced.
* The `pnt-data-sge` script now captures SGE/OGE job numbers more robustly, thereby avoiding spurious errors.
* PNT reference tracts (including those provided with TractoR) should now have smaller file sizes.
* Code which reads from DICOM files should no longer produce an error while checking if a very small file is a DICOM file or not, or when handling oblique images.
* The PNT reference tract test has been tweaked to avoid spurious failures.
* Using the FSL tracker with FSL versions containing more than three parts (e.g. 5.0.2.1) no longer fails.

## 2.2.1 (2012-08-29)

* The `pnt-prune` script would sometimes misinterpret the median streamline which is used as a baseline, resulting in a far less tightly pruned final tract than expected for some data sets. This has now been corrected.

## 2.2.0 (2012-08-17)

* TractoR now has the ability to perform kernel-based image processing operations. The new `smooth` and `morph` scripts can be used to smooth an image, or to apply a mathematical morphology operation such as erosion or dilation.
* The masking stage of the `dpreproc` script (with `MaskingMethod:kmeans` only) now uses a morphological closing operation to remove small "holes" in the segmentation.
* The new `ptrack` script can be used to perform connectivity "profiling", generating a table of streamline counts connecting each voxel in a seed region to each of a set of target regions.
* The `mtrack` script now supports the use of so-called "exclusion masks" (using the internal tracker only). Streamlines passing through any such exclusion region will be removed from the result.
* The `track` and `mtrack` scripts now allow the set of streamlines that they generate to be stored in a binary file. This may be converted to the format used by [TrackVis](http://www.trackvis.org) for visualisation using the new `streamlines2trk` script.
* The new `imagestats` script can be used to obtain a series of statistics about part or all of an image, such as volume, intensity range and mean intensity.
* Experimental support for auto-updating a TractoR installation has been added, via the new `update` script. This attempts to check the project web site for new versions of the package. See `tractor -o update` for usage.
* The newly-added `upgrade` script can be used to convert objects stored in ".Rdata" files from TractoR 1.x formats to their TractoR 2.x equivalents.
* The code underlying the `dicomread` script has been substantially reworked to improve speed (in some cases substantially) and reliability in determining the orientation of the data. The script also gains an option to inhibit the untiling of DICOM files which appear to use the Siemens "mosaic" format.
* The `view` script no longer requires the user to press Enter to quit, and does not spend time converting images to Analyze format when not necessary.
* Substantial additions to the package's support for sparse images have been made, and the `values` script now takes advantage of these.
* The `TRACTOR_HOME` environment variable is now guessed if it is not set, although routine reliance on this mechanism is not advised.
* Support for scripts in `/etc/tractor` has been removed. These have been deprecated since TractoR 1.0.0.
* Interrelationships between the various TractoR packages have now been more explicitly declared. This may avoid occasional problems when using them within R.
* Marginally invalid quaternion parameters in NIfTI headers are now handled more gracefully.

## 2.1.2 (2012-05-03)

* The `dpreproc` script now warns if the *diffusion subdirectory* already exists within the session, rather than just if the session's root directory exists.
* Spurious errors, about images not having been created yet, should no longer occur when TractoR updates the structure of a session directory created with version 1.x.
* An issue with installing the "tractor.native" package on some Linux systems has been addressed. The package's "configure" process has been somewhat simplified at the same time. (Reported by Mark Bastin.)

## 2.1.1 (2012-03-23)

* A significant memory leak has been corrected in the new tracking code, which resulted in scripts which run lots of tractography (such as `pnt-data`) using very large amounts of memory.
* The `mtrack` script allows multiple waypoint masks to be specified from the command line, comma separated, in line with the syntax used in various other scripts. The `ShowSeedPoint` option is ignored when no seed mask is specified (i.e. when the seed region is the whole brain).
* The `mtrack` script with `Tracker:tractor` no longer produces an error if no streamlines pass through all of the waypoints.
* Occasional spurious errors, saying that "all seed points must be the same", should no longer be generated by the `pnt-data` script. (Reported by Clare Gibbard.)
* The `dicomread` script now correctly uses the TR as the fourth voxel dimension when individual files represent slices, rather than volumes.
* The HTML documentation has been updated to match the latest version of the TractoR web site. (This will be standard practice in future releases.)

## 2.1.0 (2012-03-09)

* The internal tracking code has been substantially reworked, and can now be used in the `rtrack` and `mtrack` scripts. (Results should, however, be comparable with previous versions.) The `mtrack` script can now also be used to perform whole-brain tractography.
* TractoR now properly handles temporal units in NIfTI files. The `dicomread` script will set the temporal resolution of a 4D image series to the repetition time (TR) stored in the DICOM metadata. (The voxel dimension for dimensions above three was previously fixed to 1, so this will result in some differences in output.)
* A full set of HTML-based documentation is now included in the TractoR distribution, and can be found at `share/doc/home.html`.
* HNT and PNT reference tracts for the ventral cingulum and inferior longitudinal fasciculus have been added.
* A top-level session directory map can now be used to redefine the location of subdirectories within the TractoR hierarchy. This mechanism can also be used to allow sessions to share some data. All session maps are now also cached internally.
* TractoR now tries harder to work with images stored in a rotated coordinate system (although warnings will be generated).
* The number of clusters used by the k-means algorithm in `dpreproc` can now be set using the new `KMeansClusters` option. This option can be refined interactively, or the user can switch to using BET if required.
* TractoR can now read only selected volumes from an image file. The `dpreproc` script takes advantage of this to reduce memory usage.
* Stage 2 of `dpreproc` will now only visualise *b*=0 volumes, rather than all data.
* The brain mask generated in stage 3 of `dpreproc` is now displayed semitransparently for ease of evaluation.
* The `dicomsort` script can now sort a directory by subject as well as series. It also handles missing identifiers better.
* The option to threshold seed points on metrics other than anisotropy in the `track` and `rtrack` scripts is deprecated (meaning that it will still work, but a warning will be generated).
* The `tensorfit` script now handles negative data values more gracefully. An sum of squared errors (SSE) image is now created irrespective of the fitting method used.
* The `imageinfo` script can now be used with a directory of DICOM files as well as an Analyze/NIfTI/MGH image file.
* The `gmap` script gains an option to create a colour bar.
* The `plotcorrections` script now allows `Mode:all` and can be run noninteractively. (Requested by Mark Bastin.)
* The "fslview" viewer is now run quietly to suppress spurious warnings.
* TractoR now uses the "quartz" R device by default on Mac OS X systems. This should result in smoother on-screen graphics.
* TractoR run in debug mode will now print stack traces for warnings as well as errors.

## 2.0.9 (2012-03-02)

* The `dicomsort` script now avoids copying files onto themselves.
* The `tensorfit` script now handles negative data values more gracefully.
* The `hnt-ref` test has been made a bit more robust (i.e. less likely to fail for spurious reasons).

## 2.0.8 (2011-11-16)

* Fixes to TractoR's handling of images stored using nondiagonal xforms (or the equivalent) have been made.
* Thread-safe temporary files are now used more widely.

## 2.0.7 (2011-11-10)

* Somewhat cryptic errors about an "incorrect number of dimensions" should no longer appear when performing tractography. These occurred rarely, when a tract was extremely short.
* An incompatibility between masks generated by `dpreproc` in its default mode and the internal tractography code has been corrected.
* Running the `mtrack` script with one or more waypoint masks should no longer fail.

## 2.0.6 (2011-10-24)

* The `mean` and `gmean` scripts now handle "NaN" more sensibly, giving useful output even when they occur.
* A bug related to reading Analyze-format image files has been fixed.
* The "reportr" R package has been upgraded to version 1.0.0.
* References to the [TractoR JSS paper](http://www.jstatsoft.org/v44/i08/) have been added in the package documentation.

## 2.0.5 (2011-10-11)

* An error about a missing "dti_eigval1" image should no longer appear when calling `mean` or `gmean` with `Metric:axialdiff` on data originally preprocessed with TractoR 1.x. (Reported by Mark Bastin.)
* Errors about "no loop to break from" should no longer be generated by `pnt-viz` or `pnt-prune` when a data set with no match data is encountered. (Reported by Michael Yoong.)
* The error "object 'nullPosterior' not found" should no longer appear when calling `pnt-interpret` with `Mode:null-posterior`.

## 2.0.4 (2011-10-07)

* Further refinements for the upcoming R 2.14.0 have been made. All tests now pass on that platform.
* The TractoR R packages are now byte-compiled on versions of R which support this (2.13.0 and later). This should provide a general speed-up that should be more substantial in R 2.14.0 and later, in which the core packages are also byte-compiled by default.
* The voxel unit of an image is now correctly set to "unknown" where appropriate.
* A bug, which could result in spurious "image not found" errors when working with tractography on datasets processed for two fibre populations per voxel, has now been fixed. (Reported by Mark Bastin.)

## 2.0.3 (2011-09-23)

* The `gradcheck` script gains an option to allow the user to circumvent use of the internal image viewer.
* The "objects" subdirectory of a session is now deleted when updating the hierarchy to TractoR 2.x format. This avoids errors of the form "X is not a defined class" which were previously occurring due to the lack of forward-compability between stored objects in TractoR 1.x and 2.x.
* The `FlipGradientAxes` option to `dpreproc` now expects comma-separated axis letters, rather than unseparated numbers, for consistency with `gradcheck`.
* The wrapper function for FSL `probtrackx` has been made more "thread-safe", making parallelised code which uses it (such as `pnt-data` with `Tracker:fsl`) more reliable.
* The session status report test has been updated and should no longer fail.
* R packages are now installed more cleanly, leaving fewer intermediate files lying around.
* Various corrections have been made to script descriptions.
* Several other R-level tweaks and fixes have also been made, including some changes to the semantics of indexing and replacement for `MriImage` objects.
* Support for changes upcoming in R 2.14.0 (expected 31 October 2011) has been added.

## 2.0.2 (2011-08-10)

* The third and fourth stages of the `dpreproc` script have been swapped around. This was the intended order for version 2.0.x.
* A test image file has been renamed for consistency with other similar files.

## 2.0.1 (2011-08-05)

* This is a major new release with many significant changes. The main intention has been to broaden the scope of the package and make it more flexible, laying the foundations for future development. The package's dependence on FSL has also been lessened substantially. It is not fully backwards compatible with TractoR 1.x, so it is recommended that the two not be mixed within a single study.
* TractoR's internals have changed substantially, and make use of features relatively recently added to R. Therefore, R 2.12.1 (released December 2010) or later is required to install TractoR 2.0.
* The session hierarchy has been revamped. The primary directory for diffusion-weighted data is now called "diffusion", although an "fdt" directory will still be created for interoperability with FSL if needed. The image file names within the "diffusion" directory are also different by default, although greater flexibility on these names is now available through so-called "session maps". TractoR 2.0 will automatically update a session hierarchy created with TractoR 1.x when it first encounters it, but the image file names in the new "diffusion" (old "fdt") directory will be left alone, and a map file will be created to allow TractoR 2.0 find what it needs. NB: Using TractoR 1.x with a session directory updated in this way is not guaranteed to work correctly, and is not recommended.
* Two scripts have been renamed in light of the broader scope of the new version: `mkbvecs` is now called `gradread`; and `preproc` is now called `dpreproc`, since it is specific to diffusion-weighted data.
* The functionality of the former `preproc` script (now `dpreproc`) has been split up for flexibility, and to avoid confusion. It now only handles functions which are truly preprocessing operations, so diffusion tensor fitting is now performed by the new `tensorfit` script, gradient direction checking (and flipping if necessary) by `gradcheck`, gradient rotation by `gradrotate`, and FSL-BEDPOSTX by `bedpost`. Run "tractor -o tensorfit", and so on, to see the options for these new scripts. DICOM to NIfTI conversion, eddy current distortion correction and brain extraction remain in `dpreproc`, and it now has four stages rather than five. The progress of that pipeline can be shown using the StatusOnly option.
* Some script options have new defaults, in line with current best practices, or to use TractoR-internal functionality where possible. For example, MaskingMethod in `dpreproc` now defaults to "kmeans", while BetIntensityThreshold defaults to 0.3 because experience has suggested that this value produces more successful results.
* The default value of any option in any script can now be overridden on a per-user basis by creating a config file corresponding to the script in ~/.tractor, and setting the default value there. For example, `dpreproc` will use FSL-BET for brain masking (as in TractoR 1.x) if you put the text "MaskingMethod: bet" into the file ~/.tractor/dpreproc.yaml. See the man page for details.
* TractoR can now read and write the MGH image file format used by the [FreeSurfer](http://surfer.nmr.mgh.harvard.edu/) package. These files have extension ".mgh" (uncompressed) or ".mgz" (compressed).
* An iterative weighted least-squares fitting process for diffusion tensors is now available through the `tensorfit` script.
* The `dicomsort` script now stops reading each file once the series number is encountered, producing a typical speedup of around 25%. Directory names created by this script now include leading zeroes to ensure that they are always displayed in the right order.
* The `platform` script now additionally prints the TractoR home directory.
* The `view` script now allows multiple files to be specified.
* The default verbosity level is now 1, rather than 0. Users may therefore see much more output than before. The default can be switched back by setting up ~/.tractor/config appropriately: see the man page for details.
* A warning is now raised if series descriptions are not consistent when reading a DICOM directory.
* The "-r" flag to the main `tractor` program is deprecated.
* The package installation process is now less verbose.
* Many R-level changes and enhancements have been made, including tweaks to support changes upcoming in R 2.14.0, due in October.

## 1.8.3 (2012-08-29)

* The `pnt-prune` script would sometimes misinterpret the median streamline which is used as a baseline, resulting in a far less tightly pruned final tract than expected for some data sets. This has now been corrected. (Back-ported from version 2.2.1.)
* A number of improvements have been made relating to TractoR's handling of very short tracts. (Partly back-ported from version 2.0.7.)

## 1.8.2 (2011-10-20)

* A number of fixes have been back-ported from TractoR 2.x, specifically relating to compatibility with R 2.14.0 and thread safety.
* Citations to the TractoR JSS paper have been added.
* A bug causing problems when reading 2D NIfTI files has been corrected.

## 1.8.1 (2011-06-24)

* A spurious warning was previously produced when reading a NIfTI file with more than 3 dimensions. This has been fixed.
* The simple "hello world" test should no longer fail on some platforms due to whitespace differences.
* The `platform` script now always displays its output, irrespective of the verbosity level set.

## 1.8.0 (2011-05-25)

* The NIfTI file reading code in TractoR is now substantially more flexible, and supports images stored using conventions other than the LAS arrangement which is used internally.
* Read support for the proposed new [NIfTI-2 file format](http://www.nitrc.org/forum/forum.php?thread_id=2148&forum_id=1941) has been added.
* Image origins are now adjusted appropriately when image data are flipped on reading, and negative and noninteger values are allowed for. The result of the `imageinfo` script may therefore differ from previous versions for some files, but the new output is more consistent with TractoR's conventions.
* Any gradient flip specified with the FlipGradientAxes option is now performed during stage 2 of the `preproc` script, to avoid problems with doing it after rotating the directions.

## 1.7.1 (2011-02-07)

* When installing the "tractor.native" package, a greater effort is now made to find "zlib" on the user's system. If it is not available, the package is compiled without support for reading gzipped NIfTI files. Previously the compilation would simply fail. (Reported by Mark Bastin.)

## 1.7.0 (2010-12-20)

* TractoR now contains its own tractography algorithm, provided in the new "tractor.native" R package. The bulk of the tracker is written in C for speed, so this package requires compilation. Use of this tracker is optional and currently only supported in scripts which use one seed point at a time (i.e. `track`, `pnt-data`, `pnt-data-sge`, `pnt-ref` and `pnt-prune`). However, the speed gains can be considerable: in testing, `track` ran up to 30% faster using the TractoR tracker, and `pnt-data` ran 50-70% faster. Results from the FSL and TractoR trackers should be similar but will not be identical, so it may be wise not to mix the two within studies. FSL remains the default for now.
* The main `tractor` program now supports a "-a" flag, which can be used to select between subarchitectures on R platforms that support them, such as Mac OS X. This allows users to select between, for example, 32-bit and 64-bit versions of R for running TractoR scripts.
* In TractoR version 1.5.0 and later, `pnt-data` no longer collated its output into a single file. This was unintentional and has now been corrected: collation will now happen automatically unless the SessionNumbers option is used to select a subgroup of sessions to process. (Reported by Ping-Hong Yeh.)
* The full data set image for the example session used by TractoR's self-tests is now included in the distribution.

## 1.6.0 (2010-10-22)

* The `preproc` script now offers two alternatives to BET for masking in the region for further processing. These are selected using the new MaskingMethod option. The "kmeans" option will apply k-means clustering, which is faster than BET and requires no parameters to be set, but will usually leave some non-brain voxels within the mask. The "fill" option will simply mask in the whole image region, and therefore all voxels will undergo all subsequent processing. These alternatives are particularly useful to simplify the preprocessing, or when FSL is not available, or when processing non-brain data.
* MNI standard space images representing the brain and regions of grey matter, white matter and CSF have been added to the distribution in the `share/mni` directory. TractoR therefore no longer relies on versions of these images supplied with FSL. We are grateful to the International Consortium for Brain Mapping (ICBM) for making these available.
* New scripts have been added for cloning session hierarchies (`clone`), extracting the voxel values of an image within a mask (`values`), and viewing an image in `fslview` in a way that avoids an incompatibility between that viewer and certain NIfTI data types (`view`).
* Mask-based tractography (using the `mtrack` script) now reports the number of nonzero voxels in the mask, and the number of streamlines retained after applying waypoint masks. (This output is produced at the "info" level, so `-v1` must be given to `tractor` to see it.)
* The `dicomsort` script will now handle data sets with duplicate file names within a series. In addition, this script's functionality is now available at the R level.
* The `dicomtags` script will now look in subdirectories for a DICOM file if its argument is a directory, rather than just in the directory itself.
* Tests that fail will now be rerun, rather than skipped, if `make test` is run again from the main TractoR directory.
* The way that diffusion encoding schemes are handled within the core code of TractoR has been changed to improve consistency and portability. However, this change should not have any effect for those using only the `tractor` program to perform standard tasks.
* 2D images written out to NIfTI files now have their "sform" and "qform" codes set to zero, since TractoR does not keep track of their orientations.
* An adjustment has been made to avoid problems with the gradient rotation part of the `preproc` script, which in some circumstances could try to read the brain-extracted b=0 image before it had been created.
* The `xfmconvert` script is now defunct and has been removed. The new transformation storage format has been in place since TractoR 1.0.
* A few other minor improvements and fixes have been implemented.

## 1.5.0 (2010-06-29)

* TractoR now offers a simple method for parallelising code, which uses the ["multicore" package](http://www.rforge.net/multicore/) for R by Simon Urbanek. Users can now take advantage of multicore systems by simply specifying the "-p" option (with a parallelisation factor) to the main "tractor" program. The man page has more details. This option is only supported by certain scripts: at present these are `hnt-eval`, `hnt-viz`, `pnt-data`, `pnt-viz` and `pnt-prune`.
* In addition to lightweight multicore parallelisation, there is now a version of the `pnt-data` script which supports parallelisation on a grid using the Sun Grid Engine (SGE). This version of the script is called `pnt-data-sge`, and can be used like `pnt-data`, with a few extra options specific to SGE. Another supporting script, `pnt-collate` has also been added.
* A new script, `dirviz`, can be used to visualise principal fibre orientations within each voxel of a data set.
* The new `platform` script reports various details of the software platform that TractoR is being run on.
* The `plotrotations` script has been replaced by the more general `plotcorrections`, which can display rotation angles, translations, scales or skews.
* The text files produced by `pnt-data` now include the seed point associated with each row, for greater flexibility downstream. Scripts are still compatible with the old format however.
* The DICOM reading code no longer immediately rejects non-MR images, although it has not been tested with CT or other data.
* The `preproc` script now lets the user know when the gradient cache has been updated. It also gains an option to force this update.
* An adjustment has been made to allow for some Siemens DICOM files which report zero image slices.
* The `pnt-viz` script gains a NumberOfSamples option.
* X11 libraries are no longer used to create images in the `pnt-viz` and `pnt-prune` scripts.
* The R package "tractor.base" has now been split into "tractor.base" and "tractor.utils".

## 1.4.4 (2010-06-14)

* Gradient caching code used by the `preproc` script will no longer fail if no ".tractor" directory exists in the user's home directory. The directory will now be created if it is missing.
* The TractoR NIfTI file reader now accepts files with negative qform elements, as intended.

## 1.4.3 (2010-05-28)

* An incompatibility with FSL 4.1.5, due to a change in the behaviour of FSL `probtrackx`, has been corrected.
* DICOM tests have been updated to work with the read code change introduced in TractoR version 1.4.2.
* The "tractor -o" test is now a bit more robust.

## 1.4.2 (2010-05-06)

* An internal problem in some HNT reference tracts has been corrected, so spurious errors should no longer be generated when running `hnt-eval`.
* An adjustment to the DICOM reading code has been made to avoid an incompatibility with the recently released R 2.11.0.

## 1.4.1 (2010-03-31)

* The "avscale" test previously failed on some Linux installations due to a slight platform dependence in the FSL program's output. This issue has been avoided in this release, so the tests should run successfully on these platforms.
* Unneeded files which were accidentally included in the version 1.4.0 release ("filter.R" and the "multicore" directory) have been removed.

## 1.4.0 (2010-03-11)

* TractoR now supports B-matrix/gradient vector rotation to compensate for the motion/eddy current distortion correction applied. Just set the RotateGradients option to "true" for stage 2 of the `preproc` script. The new experiment script `plotrotations` can be used to get a set of how big the effect will be for a particular data set.
* Gradient directions (before rotation) for diffusion MRI acquisitions are now cached in the user's ~/.tractor directory and automatically placed into a session directory if the series description matches and no gradient direction information is found in the DICOM files. This facility can save a lot of time manually copying bvals and bvecs files into session directories. Its use is determined by the UseGradientCache option to the `preproc` script.
* Group mapping, in particular of tracts produced by `hnt-viz`, `pnt-viz` and `pnt-prune`, is now available through the new `gmap` script. A set of images are transferred into standard (MNI) space and overlaid to visualise spatial consistency. Run "tractor -o gmap" for options.
* Contact sheet style visualisation is now available for Analyze/NIfTI volumes, wherein all slices of an image along a particular direction are shown in a grid. The new `contact` script is the interface to this functionality.
* The new `age` script can be used to determine a subject's age to the day from a DICOM file.
* The new `binarise` script can be used to binarise Analyze/NIfTI volumes, with an optional threshold.
* Options such as RunStages in `preproc` and SessionNumbers in `pnt-prune` now allow number ranges (e.g. 1-10) as input, for convenience and conciseness.
* The HowRunBedpost option in the `preproc` script now defaults to "fg" (running in the foreground). The use of "screen" was confusing for several users, but can be forced if required. The "auto" value is no longer used or supported.
* The `pnt-ref` script gains a MaximumAngle option, to avoid sharp turns near the ends of the created reference tract.
* The output file name in the `dicomread` script now defaults to the same as the name of the source directory.
* The window limits (black and white points) for images produced by the `proj`, `slice`, `contact` and `gmap` scripts can now be set using the new WindowLimits option.
* The `dicomsort` script now creates subdirectories containing the relevant series descriptions in their names, for greater clarity.
* Various improvements have been made to DICOM reading code for Philips and Siemens files, and for images acquired obliquely.
* The `rtrack` script unintentionally ignored the NumberOfSamples option. This has been corrected.
* Various other minor enhancements.

## 1.3.0 (2009-11-10)

* Support for a new approach to rejecting false positive connections in probabilistic neighbourhood tractography has been added through the `pnt-prune` experiment script. This script can be run instead of `pnt-viz`, and uses the PNT modelling framework to substantially clean up tract segmentations. Details can be found on the [PNT tutorial page](PNTTutorial.html)). Run "tractor -o pnt-prune" for options.
* A set of tests have been added to the package, to ensure that installation went successfully and everything is working as expected. These can be run from the main TractoR directory with the command "make test".
* A specific PNT model can now be specified directly for the `pnt-eval` and `pnt-interpret` scripts, allowing substantially greater flexibility.
* The `pnt-ref` and `hnt-eval` scripts now support a NumberOfSamples option, to set the number of streamlines used by the underlying tractography algorithm.
* The `track` and `mtrack` scripts now have a CreateVolumes option, for consistency with other similar scripts. The behaviour of the `rtrack` script has also been brought into line with other related scripts.
* The `chfiletype` script can now be used with multiple files.
* The `tractor` program now supports a "-i" flag to suppress the user's default configuration file.
* Running "tractor -o (script)" no longer requires `ruby`.
* The DICOM reading code should no longer incorrectly identify non-Siemens images as mosaic volumes.
* Duplicated stack traces were sometimes produced when `tractor` was run in debug mode. This has been corrected.
* The `extract` script no longer fails when the CreateImages option is on and the OverlayOnBrain option is off.
* Some minor adjustments to output messages have been made.

## 1.2.0 (2009-08-21)

* HNT and PNT reference tracts have been added for the corpus callosum splenium (forceps posterior), arcuate fasciculi, uncinate fasciculi and anterior thalamic radiations. (Credit to Dr Susana Muñoz Maniega.)
* Significant performance improvements have been made to the DICOM reading code, decreasing read times by up to 50%. Users should find that performance is even better with R 2.9.2, which is planned for release on 2009-08-24.
* A new mechanism is now behind "tractor -o (script)", and as a result the program displays the available options for those configuration variables, like "PointType", which can only take certain values. This change finally closes issue #2.
* The `status` script defaults to the current directory if none is specified. It will also no longer create an empty camino subdirectory.
* The `dicomtags` script now accepts a directory name instead of a file name, in which case it will look for a DICOM file in that directory and print the tags for that file. If nothing is specified, the current directory is used by default.
* If an experiment script is not found, the `tractor` program now prints the name of the missing file.
* Minor documentation changes.

## 1.1.0 (2009-06-15)

* The TractoR implementation of probabilistic neighbourhood tractography now supports "asymmetric" models, which have more degrees of freedom than normal symmetric models, but potentially fit the data better. Use of this option is now recommended in medium and large data sets.
* The `caminofiles` script now creates [version 2](http://web4.cs.ucl.ac.uk/research/medic/camino/pmwiki/pmwiki.php?n=Man.Camino#lbAE) Camino scheme files, and therefore there is no longer any need to specify a diffusion time. In addition, a spurious warning about an existing directory is no longer generated.
* The `mean` and `gmean` scripts now accept the new values "Lax" and "Lrad" for axial and radial diffusivity, respectively. These are passed to the "Metric" option.
* DICOM code now handles images whose slices are slightly oblique, with a warning. No reslicing is performed.
* Error messages for missing and multiple image files are now different, to avoid confusion.
* The FSLOUTPUTTYPE environment variable is no longer used to set the internal default file type for TractoR. If the TRACTOR_FILETYPE environment variable is not set, the file type defaults to NIFTI_GZ. (Given that TractoR now supports more file types than FSL, this synchronisation makes less sense than it used to.)
* The data preprocessing script, `preproc`, no longer returns information about the state of the session. This information (and more) can be obtained using the new `status` script.
* The `imageinfo` and `dicomtags` scripts now support filenames containing spaces (although these are generally *not* recommended).
* All messages, including warnings, are now reported in the order that they are raised by the code.
* The tractor.base R package is now fully documented at the R level.

## 1.0.1 (2009-03-16)

* The `dicomread` script now uses the FSLOUTPUTTYPE environment variable to decide on a file format to use if TRACTOR_FILETYPE is not set. This was always the intended behaviour.
* Fixing an issue that would produce an error when reading a 2D NIfTI image file.
* The `pnt-eval` script will now find standard reference tracts as intended.
* The `caminofiles` script would previously always ask for confirmation, even if the camino directory didn't previously exist.

## 1.0.0 (2009-02-13)

* A set of standard reference tracts for five major pathways are now included with the TractoR distribution.
* New neighbourhood tractography functionality has been added, for "unsupervised" tract segmentation (using the new `pnt-em` experiment) and extracting parameters of interest from NT results (`hnt-interpret` and `pnt-interpret`).
* The new `list` experiment lists all available TractoR experiment scripts.
* The new `dicomread` experiment has been added to convert any directory of DICOM files into an Analyze/NIfTI volume. DICOM read support is now more flexible, and can read images with nonaxial slices.
* The format and name of the file which stores the transform from MNI space to each session's diffusion space (in the tractor/objects directory) has changed. As a result the registration will be repeated the first time it is needed. The new `xfmconvert` script can be used to convert existing files to the new format (`tractor -o xfmconvert` for usage information).
* The `preproc` experiment now shows the principal directions of the diffusion tensor in FSLview during stage 4. It also interprets its DicomDirectory parameter as representing a full path if it begins with a "/" character.
* The `chfiletype` experiment can now be used to change the datatype of an image as well as the file format.
* Warning messages that occur multiple times are now generally shown only once -- along with the number of occurrences. Warnings from R core code are also reported in this way.
* Log files created with the "-l" flag are now named for the script that was run.
* Some scripts handle missing data or files more gracefully.
* The main `tractor` script now requires the `bash` shell specifically (not `sh`).

## Beta 3.1 (2008-08-18)

* A mistake in the `dicomsort` and `peek` experiment scripts meant that they produced errors about missing functions. This has been corrected.
* Following the dropping of support for the Analyze file format by FSL 4.1, this beta provides some extra tools for those who wish to continue using the format. Specifically, the environment variable TRACTOR_FILETYPE can be set to ANALYZE if the user wishes TractoR to output Analyze files by default. (This is no longer a legal value for FSL's environment variable FSLOUTPUTTYPE, which was previously used for TractoR's default.) The `chfiletype` script has also been created for converting between formats as required: please run `tractor -o chfiletype` for details.

## Beta 3.0 (2008-08-11)

* The way in which TractoR looks for its scripts has changed somewhat. This should make installation both simpler and more flexible in most cases.
* Three new utility scripts have been added. The `caminofiles` experiment converts a data set into file formats suitable for use with the Camino diffusion MRI toolkit; `mkbvecs` assists with the creation of valid "bvals" and "bvecs" files for use with FSL; and `dicomsort` sorts a directory of DICOM files into subdirectories by series number. The latter is useful for separating diffusion data from structural acquisitions.
* The time-consuming `pnt-data` experiment script now writes partial output as it goes and supports resuming a partially completed run. This makes interruptions to this process, such as major errors or power loss, far less painful in terms of the time lost. The script also allows a single seed point to be specified on the command line with the new SeedPoint option.
* The `preproc` experiment checks more robustly to make sure that its first stage has been completed properly. The script also more faithfully obeys its Interactive flag.
* TractoR will now use R's batch mode if requested. This is not that useful under most usual circumstances, but can occasionally be helpful.
* More minor tweaks and fixes.

## Beta 2.0 (2008-04-29)

* Entities which are stored in ".Rdata" files are now saved in a different way. This means that objects such as reference tracts created with beta 1.0 will not directly work with beta 2.0. However, this new arrangement should generally be forward-compatible with future releases. The new `peek` experiment script can be used to inspect these stored R objects.
* The main `tractor` script has had some tweaks. The log file, "tractor_output.log" will now receive output from the experiment script in real time rather than all at the end. Multiple configuration files (specified with the "-c" flag) are now permitted, and paths to these files are now relative to the current working directory rather than the experiment's working directory (which was a bit counterintuitive). `tractor -o` now reports "None" if no options are available.
* The user can set up default options for TractoR experiments using a ~/.tractor/config file. See the `tractor` man page for more details.
* History log files ("tractor_history.log") now include the date and time that the experiment script completed.
* Added the `gmean` experiment script, a companion to `mean` aimed at applying the same calculation to a group of images. Run `tractor -o gmean` for details.
* The interface of the `preproc` script has changed a little. It also supports a new option specifying a particular subdirectory to search for DICOM files.
* The `mkroi` experiment no longer returns the names of the files it created.
* The TractoR makefile now assumes that R is installed at /usr/local/bin/R by default.
* An adjustment to the NIfTI file reading code has been made for compatibility with R 2.7.0.
* Various minor changes and fixes.

## Beta 1.0 (2008-03-03)

* First public release.
