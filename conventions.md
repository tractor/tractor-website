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
        /fdt.track...............FSL tractography output
        /camino..................images and other files used by the Camino toolkit
        /structural..............structural (e.g. T1-weighted) images
        /freesurfer..............output from the Freesurfer pipeline
      [other subdirectories].....unmanaged files, such as DICOM-format files

TractoR maintains this structure and expects to find the files it uses in these places. This is arranged by the package itself if the session hierarchy is set up using TractoR preprocessing scripts, but if the preprocessing steps are carried out independently then the hierarchy must be arranged in this way manually.

The reason for using a managed file hierarchy is to avoid the need to specify the locations of several standard image files when using TractoR's core functionality. By establishing standard locations for all such files, only the top-level session directory needs to be specified, since everything else can be found by the code. TractoR therefore favours [convention over configuration](http://en.wikipedia.org/wiki/Convention_over_configuration), but if the names of specific images within a managed directory are not in keeping with the default, there is a mechanism for telling TractoR about this, through so-called "session maps". For example, the default map for the `diffusion` subdirectory, as of TractoR v2.0.2, is

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

Any or all of these default names can be overridden by placing a file called `map.yaml` in the `diffusion` subdirectory, using the format above. Note that the `%` symbol is used to indicate an index, so the first eigenvalue image will be called `dti_eigval1`, the second `dti_eigval2`, and so on. No image format suffix (e.g. `.nii`) should be given.

The `path` script (added in TractoR v2.5.0) can be used to obtain the actual full path to the image of a particular type. For example,

<pre>
<code>$ </code><kbd>tractor -q path /data/subject1 FA</kbd>
<code>/data/subject1/tractor/diffusion/dti_FA</code>
</pre>

Similarly, the names of the subdirectories within the main `tractor` directory can be specified in a top-level session map. This mechanism can be used to point to data outside the session directory as well, and this can be useful, for example, when processing a single data set in several different ways. For example, say we want to process the data from a single subject using `bedpost`, with both 2 and 3 fibre options. We could process the 2 fibres case, and then create a new session, say `/data/subject1_3fibres`, which points to the same diffusion data. The `/data/subject1_3fibres/tractor/map.yaml` file would then contain

    diffusion: /data/subject1_2fibres/tractor/diffusion

It should, however, be bourne in mind that this will make the session less portable. The full default map, as of TractoR v2.5.0, is

    transforms: transforms
    diffusion: diffusion
    fdt: fdt
    bedpost: fdt.bedpostX
    probtrack: fdt.track
    camino: camino
    structural: structural
    freesurfer: freesurfer

## Point types

Whenever a location within a brain volume needs to be specified, for example as a seed point for tractography, it is necessary to specify the meaning of the numerical value given. Locations may be specified in world coordinates, in mm, or as a voxel location. The latter case needs to be further disambiguated, since FSL uses the C convention of indexing voxels from zero, whereas TractoR uses the R (and Matlab) convention of indexing from one. The first voxel in the corner of a brain volume is therefore (1,1,1) in the R convention. Therefore experiment scripts, such as `track`, which take a point as an argument require the `PointType` parameter to be set to one of "fsl", "r" or "mm" to indicate the meaning of the point. So in the command

    tractor track /data/subject1 34,23,17 PointType:fsl

the `track` script is run using "/data/subject1" as the relevant session directory and "34,23,17" as a seed point using the FSL convention. This would be appropriate if the seed point had been selected using the FSLview data viewer.
