# Working with structural data

This tutorial covers TractoR's facilities for working with structural T1-weighted or T2-weighted MRI images. These are presently limited to importing files from DICOM and parcellating the brain into anatomical regions.

## Importing data

Structural images relevant to a particular [session](conventions.html), say `/data/subject1`, may be imported using a command like

    tractor import /data/subject1 /data/dicom/subject1/T1W_sequence ImageWeighting:t1

The `ImageWeighting` option tells TractoR that this is a T1-weighted volume. This option may also be set to `t2` for T2-weighted data, `pd` for proton density weighted data, or `diffusion` for diffusion-weighted data (although the `dpreproc` script is [usually preferable](diffusion-processing.html) for the latter).

If multiple T1-weighted images are given then by default TractoR will coregister them and create a median image. This is then used as the standard registration target for structural imaging space for the session. An alternative is to let Freesurfer perform this coregistration operation later, in which case `Coregister:false` can be given to the `import` script.

## Parcellation

Anatomical parcellation of a structural image is a prerequisite for some kinds of analysis, and must be performed before the parcellation can be propagated to any other space, such as diffusion. The key script for this is `parcellate`. It is passed a parcellated image, of the same dimensions as the averaged reference T1-weighted image but with coherent regions labelled with an integer index. A lookup table is required to convert between numerical indices and region names, and some examples for typical atlases are included in `$TRACTOR_HOME/share/tractor/parcellations`.

For example, to run FSL-FLIRT on the reference T1 image for a session and import the parcellation created by it, you might run

    cd /data/subject1
    run_first_all -i `tractor -q path . refT1` -o first
    tractor parcellate . first_all_fast_firstseg Types:first

Note that TractoR does not provide a wrapper script for FIRST, but the `path` script can be used to get the path to the relevant input file for the FIRST command line tool, `run_first_all`. The TractoR `parcellate` script then needs to be told that the parcellation was performed by FIRST, and since there is a standard parcellation lookup table for this type of parcellation, it will use it automatically.

Another alternative is to use Freesurfer, and in this case TractoR does provide a wrapper script, viz.

    tractor freesurf /data/subject1 Parcellation:destrieux

The `parcellate` script can also handle merging multiple parcellations together: for example, you can run `freesurf` first to obtain a parcellation from Freesurfer, and then run FIRST and pass the result to `parcellate`. In that case regions which appear in both parcellations will be overwritten by the FIRST parcellation. A merged parcellation image and lookup table gets written into the session directory.
