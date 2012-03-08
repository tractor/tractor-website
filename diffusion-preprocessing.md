# Diffusion preprocessing

This page discusses the preprocessing steps required to prepare a diffusion-weighted dataset for analysis using TractoR, as well as subsequent operations that can be performed to [manipulate diffusion gradient directions](#gradients) and [fit models](#model-fitting) to the data.

## The pipeline

The preprocessing steps required to run neighbourhood tractography or other analysis on a diffusion-weighted data set using TractoR are the same as those required by the [FSL diffusion toolbox](http://www.fmrib.ox.ac.uk/fsl/fdt/index.html), FDT, for tractography. It is therefore quite possible to perform all of these steps independently of TractoR, and the user may decide to use the relevant FSL tools, or their equivalents from another package. However, reasons to use TractoR might include the following:

* The [[session hierarchy|Conventions]] will be arranged as TractoR expects it, automatically. This saves the user from having to arrange the hierarchy herself. It also means that TractoR can give correct parameters to any external programs without further input from the user.
* The pipeline is run interactively but tries to minimise user input.
* TractoR can establish which stage of the pipeline has been reached, and continue partly completed preprocessing pipelines where necessary.

Whichever method is used to perform them, the requisite steps are as follows.

1. Convert DICOM files from an MR scanner into a 4D data set file in Analyze or NIfTI format. TractoR can perform this conversion for a number of types of DICOM files, but users may prefer to use their own site tools for this step. The result is an image called `rawdata` (with appropriate suffix depending on the file type) in the `diffusion` subdirectory of the TractoR session hierarchy. The file `directions.txt`, which describes the diffusion weighting applied to the images, will also be created if possible. **If the relevant information is not available, this latter file must be created manually**--if this is the case then TractoR will produce a warning.
2. Identify an image volume with little or no diffusion weighting, to be used as an anatomical reference. By default this file will be called `refb0` and stored in the `diffusion` subdirectory.
3. Create a mask which covers only that part of the `refb0` volume which is within the brain. Skull and other nonbrain tissue is left outside this mask. The image file `mask` is created in the `diffusion` subdirectory, as well as a masked version of the anatomical reference image, called `maskedb0`.
4. Correct for eddy current-induced distortion effects in the data, using the anatomical reference volume as a registration target. This step currently uses the FSL tool `eddy_correct`, and produces a file called `data` in the `diffusion` subdirectory.

In addition to these steps, some kind of diffusion model fitting is a prerequisite for most subsequent analysis. Steps for performing such fits, and other common data manipulations, are laid out below.

## Using the dpreproc script

Assuming for present purposes that data sets are stored as subdirectories of `/data`, running the preprocessing pipeline for a single session directory is a matter of typing something like

    cd /data/subject1
    tractor dpreproc

By default, TractoR will assume that all DICOM files it finds under the main session directory, `/data/subject1`, relate to your DTI acquisition. If in fact your diffusion DICOM files are stored in some subdirectory, perhaps `/data/subject1/dicom/dti`, you should tell TractoR this by instead using

    tractor dpreproc DicomDirectory:dicom/dti

(The `dicomsort` script can be used to sort a directory of DICOM files into series if required, thereby separating diffusion data from other scans.)

The preprocessing can be completed noninteractively by setting the `Interactive` option to `false`:

    tractor dpreproc Interactive:false

(Note, however, that in this case default parameters will be used, without the chance to check that the results are appropriate. Some parameters can, however, be adjusted using other options to the `dpreproc` script: run `tractor -o dpreproc` for details.) By default, TractoR will run all four stages, but will miss out any stage that has already been successfully completed. To run every stage except the final one, type

    tractor dpreproc RunStages:1-3

or to start from the beginning again even if some stages have already been done, use

    tractor dpreproc SkipCompletedStages:false

If you want to find out which stages have already been run, simply give

    tractor dpreproc StatusOnly:true

<h2 id="gradients">Checking and rotating gradient directions</h2>

The directions of applied diffusion-weighting gradients are determined from the DICOM files if possible, during stage 1 of the `dpreproc` script. However, if `dpreproc` is not used, or the gradient directions cannot be found, it may be necessary to specify them manually. To do so, the directions should be put into a plain text file, arranged either one-per-column or one-per-row, normalised or unnormalised, and with or without zeroes for *b*=0 measurements. The `gradread` script can then be called, passing the session directory, gradients file and the big and little *b*-values:

    tractor gradread /data/subject1 /data/directions.txt 1000 0

This should normally only be necessary once for a given sequence, since a cache is automatically used to store gradient directions for use with other data sets acquired the same way.

Whichever way the gradients are initially obtained, it is a good idea to check that the signs of the directions are correct. The `gradcheck` script assists with this by showing the principal directions of diffusion in three representative slices of the brain, for checking against the user's expectations. It can be run from the session directory with

    tractor gradcheck

Another step which is commonly performed is gradient rotation, to compensate for the registration performed to correct for eddy current effects in `dpreproc` stage 4. If required, this **should be the last step** performed on the directions. It is run with simply

    tractor gradrotate

The `plotcorrections` script can be used to see how big the effect of this step will be: run `tractor -o plotcorrections` for more information.

<h2 id="model-fitting">Model fitting</h2>

Fitting diffusion tensors is a standard processing step for diffusion-weighted data, and results in the creation of a range of derivative images, including maps of fractional anisotropy and mean diffusivity. This fitting can be performed using

    tractor tensorfit

There are three alternative approaches to fitting the tensors available, but standard least-squares fitting is the default: see `tractor -o tensorfit` for details. The [Camino toolkit](http://www.camino.org.uk) offers many more methods.

The tractography that TractoR and FSL use is probabilistic, however, and does not use the diffusion tensor. Instead, the FSL BEDPOSTX algorithm (Ref. 1) is used to fit a "ball-and-sticks" model and generate samples for probabilistic tractography. This typically takes several hours. The command for running this is

    tractor bedpost

The underlying FSL `bedpostx` program takes a parameter which determines the maximum number of fibre populations which may be represented for each voxel. The larger this value, the longer `bedpostx` will take to run, but if set to 1 then no crossing fibre information will be available. The default value is 2, and this can be changed (to 1 or 3) using the `NumberOfFibres` option:

    tractor bedpost NumberOfFibres:1

It is important to note that the number of fibres fitted is *a property of the session*, and so once set it cannot be changed without processing the data again. If you wish to try different values of this option on a single data set, you will need to duplicate the session hierarchy, since these would be considered two distinct preprocessing pipelines, producing two different data sets.

## Creating files for use with Camino

Once the standard preprocessing pipeline has been completed, you can create files for use with the [Camino diffusion MRI toolkit](http://www.camino.org.uk), including a representation of the data in Camino format and a scheme file, using a command like the following. These files are created in the "camino" subdirectory of the session hierarchy.

    cd /data/subject1
    tractor caminofiles

## The status script

To find out information about a particular session directory and the data stored within it, you can use the `status` script, which produces output like the following:

    GENERAL:
      Session directory        : /usr/local/tractor/tests/data/session-12dir
      Working directory exists : TRUE
    
    DIFFUSION:
      Preprocessing complete        : TRUE
      Data dimensions               : 96 x 96 x 25 x 13 voxels
      Voxel dimensions              : 2.5 x 2.5 x 5 x 1 mm
      Diffusion b-values            : 0, 1000 s/mm^2
      Number of gradient directions : 1, 12
      Diffusion tensors fitted      : TRUE
      FSL BEDPOST run               : TRUE (1 fibre(s) per voxel)
      Camino files created          : FALSE

## References

1. T.E.J. Behrens et al., *Neuroimage* **34**(1):144-155, 2007.
