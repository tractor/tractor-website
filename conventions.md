# Conventions

This page discusses certain conventions specific to TractoR.

## Sessions

TractoR is designed to work with MRI data sets, each consisting of a series of magnetic resonance images, potentially including structural, diffusion-weighted and functional images. The package stores all images and other files within a managed file hierarchy called a session. The overall layout of a session directory is shown below.

    session......................top-level session directory
      /tractor...................main managed directory
        /transforms..............stored transformations between different spaces
        /diffusion...............diffusion-weighted images and their derivatives (e.g. diffusion tensor components)
        /fdt.....................images and other files used by FSL's diffusion toolbox
        /fdt.bedpostX............images and other files produced by FSL BEDPOSTX
        /structural..............structural (e.g. T1-weighted) images
        /freesurfer..............output from the Freesurfer pipeline
        /functional..............functional (generally T2*-weighted BOLD) images
      [other subdirectories].....unmanaged files, such as DICOM-format files

TractoR maintains this structure and expects to find the files it uses in these places. This is arranged by the package itself if the session hierarchy is set up using TractoR preprocessing scripts, but if the preprocessing steps are carried out independently then the hierarchy must be arranged in this way manually.

The reason for using a managed file hierarchy is to avoid the need to specify the locations of several standard image files when using TractoR's core functionality. By establishing standard locations for all such files, only the top-level session directory needs to be specified, since everything else can be found by the code. TractoR therefore favours [convention over configuration](http://en.wikipedia.org/wiki/Convention_over_configuration), but if the names of specific images within a managed directory are not in keeping with the default, there is a mechanism for telling TractoR about this, through so-called "session maps". For example, the default map for the `diffusion` subdirectory, as of TractoR v3.0.0, is

    rawdata: rawdata
    data: data
    refb0: refb0
    mask: mask
    maskedb0: maskedb0
    s0: dti_S0
    fa: dti_FA
    md: dti_MD
    eigenvalue: dti_eigval%
    eigenvector: dti_eigvec%
    axialdiff: dti_eigval1
    radialdiff: dti_radial
    sse: dti_SSE
    parcellation: parcellation

This map is stored at `$TRACTOR_HOME/etc/session/diffusion/map.yaml`, and any or all of the default names can be overridden by placing a file called `map.yaml` in the `diffusion` subdirectory of a given session, using the format above. Note that the `%` symbol is used to indicate an index, so the first eigenvalue image will be called `dti_eigval1`, the second `dti_eigval2`, and so on. No image format suffix (e.g. `.nii`) should be given.

The `path` script (added in TractoR v2.5.0) can be used to obtain the actual full path to the image of a particular type. For example,

<pre>
<code>$ </code><kbd>tractor -q path /data/subject1 FA</kbd>
<code>/data/subject1/tractor/diffusion/dti_FA</code>
</pre>

Similarly, the names of the subdirectories within the main `tractor` directory can be specified in a top-level session map. This mechanism can be used to point to data outside the session directory as well, and this can be useful, for example, when processing a single data set in several different ways. For example, say we want to process the data from a single subject using `bedpost`, with both 2 and 3 fibre options. We could process the 2 fibres case, and then create a new session, say `/data/subject1_3fibres`, which points to the same diffusion data. The `/data/subject1_3fibres/tractor/map.yaml` file would then contain

    diffusion: /data/subject1_2fibres/tractor/diffusion

It should, however, be borne in mind that this will make the session less portable. The full default map can be found at `$TRACTOR_HOME/etc/session/map.yaml`.

## File types

TractoR's preferred file format for images is the [NIfTI-1](http://nifti.nimh.nih.gov/nifti-1) format, although NIfTI-2, the legacy Analyze format and Freesurfer's [MGH/MGZ](https://surfer.nmr.mgh.harvard.edu/fswiki/FsTutorial/MghFormat) format are also supported. Compression with gzip is fully supported, and recommended to save disk space, although it does incur a modest computational overhead. Reading from DICOM files [is supported](TractoR-and-DICOM.html), but due to the complexity of the format, support is by no means comprehensive.

Tractography streamlines are stored in [TrackVis **.trk** format](http://www.trackvis.org/docs/?subsect=fileformat), which makes it easy to visualise them using the popular TrackVis program. However, TractoR additionally uses an auxiliary file format, with a **.trkl** extension, which stores information about "labels", named regions that individual streamlines pass through. The beginning of this file is formatted as follows.

    struct trkl_header {
        char    magic_number[8];        // The string "TRKLABEL" (hex 54 52 4b 4c 41 42 45 4c)
        int32_t version;                // Version number; currently 1
        int32_t n_streamlines;          // Number of streamlines; should match the .trk file
        int32_t n_labels;               // Number of labels stored
        char    unused[12];             // Padding bytes, currently unused
    };

There then follows a dictionary of names, consisting of a (32-bit signed) integer index value and then a zero-terminated string containing the name, for each label in turn. Indices do not have to be sequential, nor in any particular order. Finally, the mapping from streamlines to labels is given. For each streamline, in the same order as the .trk file, the number of labels associated with it is written as a (32-bit signed) integer, followed by the appropriate number of (32-bit signed) integers giving the indices of each of those labels.

Transformations, containing information on how to move images and points between different spaces, are encapsulated in folders with an **.xfmb** extension. In each case these contain the "source" and "target" images for the transformation (which may be symbolic links), a file "method.txt" identifying the registration method used, and forward and reverse transform files for each registration performed. The latter are plain-text affine matrices with a **.mat** extension for linear transforms, and compressed NIfTI-1 images for nonlinear transforms.

Other files generated by TractoR typically have an **.Rdata** extension. This is a R-native binary format which captures the data fields in an R reference object. Information on such files, and the object they contain, can be obtained using the `peek` script. The object can be recovered from within R using the `deserialiseReferenceObject` function.
