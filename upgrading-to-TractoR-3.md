# Upgrading to TractoR 3

As with the step up from the 1.x series to TractoR version 2.0, the 3.0 release makes substantial, incompatible changes to the package and its interface. The aims of these changes are to improve the efficiency, flexibility and scope of the package further. Work on consolidating functionality and avoiding repetition has actually resulted in a *reduction* in the number of experiment scripts, from 79 in TractoR 2.6 to 68 in version 3.0.

The key changes are to

- [tractography](#tractography), where the infrastructure has been completely rewritten to be more memory efficient and faster;
- [parallelisation](#parallelisation), which is now much more widely applicable;
- [visualisation](#visualisation), which is both more capable and more focussed;
- [transformations](#transformations), which are stored differently; and
- [multishell support](#multishell-support), and compatibility with FSL's `topup` and `eddy` commands.

These topics are discussed in more detail below. [Parallel installation](#parallel-installation) of TractoR 2.x and 3.x is discussed at the end.

## Tractography

The biggest single change in the 3.0 release is the complete rewriting of the tractography infrastructure. There is now one key `track` script, rather than five variants (`track`, `mtrack`, `rtrack`, `xtrack` and `ptrack`) with different subsets of features. It is now much more efficient, and able to generate millions of streamlines without running into memory problems. More work is done in compiled (C++) code, which makes tasks such as [probabilistic neighbourhood tractography](PNT-tutorial.html) much faster than before. Streamlines are labelled internally when they pass through target regions of interest, which makes region-to-region tracking more robust. And TrackVis .trk format is now used as TractoR's native format for streamlines, which allows for easy visualisation.

Typical usages of each of TractoR 2.x's tractography scripts are shown below, along with the closest equivalent TractoR 3.0 command. We begin with the simple case of single-seed tractography with 1000 streamlines.

    # TractoR 2.x
    tractor track /data/subject1 50,48,33 PointType:R NumberOfSamples:1000
    
    # TractoR 3.x
    tractor track /data/subject1 50,48,33 Streamlines:1000 JitterSeeds:false

The differences are small here, but the "NumberOfSamples" option has been renamed to "Streamlines", "PointType" no longer needs to be specified (since the R voxel convention is now assumed), and TractoR 3.0 will jitter seeds within a voxel by default, so we disable that for consistency.

Next, we have the mask-based tractography approaches. We'll create a small region of interest and then seed 100 streamlines from each voxel within it, first combining the results into one output and second splitting it by seed point.

    # TractoR 2.x
    tractor mkroi /data/subject1 50,48,33 PointType:R Width:3
    tractor mtrack /data/subject1 SeedMaskFile:roi NumberOfSamples:100
    tractor rtrack /data/subject1 SeedMaskFile:roi NumberOfSamples:100
    
    # TractoR 3.x
    tractor mkroi /data/subject1@FA 50,48,33 Width:3
    tractor track /data/subject1 roi Streamlines:100x JitterSeeds:false
    tractor track /data/subject1 roi Streamlines:100x JitterSeeds:false Strategy:voxelwise

Here things get a bit more interesting. Firstly, the `mkroi` script used to assume that you wanted an ROI in a session's diffusion space, which was too strong an assumption, so now instead it takes an image as its first argument, which is used to form a reference space. Note the use of the syntax `/data/subject1@FA`, which is new to TractoR 3.0 and means "the FA map within the session whose base directory is `/data/subject1`". This saves you from having to type the full path, and works properly with session maps. In TractoR 3.0 the ROI image is simply passed to `track` as the second argument rather than a point, and it will behave like the old `mtrack`. Note also that we specify `100x` as the number of streamlines, which means 100 per seed point. Without the "x", only 100 streamlines in total would be generated, with each seed chosen randomly from within the ROI.

We finally consider parcellation-based tractography with targets, the domain of the old `xtrack` script. A typical example would be seeding from white matter voxels and tracking until reaching a cortical grey matter region.

    # TractoR 2.x
    tractor xtrack /data/subject1 SeedRegions:white_matter TargetRegions:cerebral_cortex NumberOfSamples:100
    
    # TractoR 3.x
    tractor track /data/subject1 white_matter TargetRegions:cerebral_cortex TerminateAtTargets:true MinTargetHits:1 Streamlines:100x RequireMap:false RequirePaths:true

Once again, the seed region is specified as the second argument in TractoR 3.0. For consistency with `xtrack` we specify that we want to stop when we get to any of the target regions, and that streamlines that do not hit at least one of them will be discarded. (For corticocortical connections this can be increased to 2.) We don't want a visitation map (`RequireMap:false`) but we do want the streamline paths (`RequirePaths:true`).

## Parallelisation

Support for parallelisation in prior versions of TractoR was very patchy. Some individual scripts supported running in parallel on multiple cores using the '-p' flag, and the special case of `pnt-data-sge` supported parallelisation using the Sun Grid Engine high-performance computing platform. Moreover, some script worked with one dataset while others expected group data, and `mean` and `gmean` differed only in this regard.

In TractoR 3.0, support for both multicore and grid engine parallelisation is fully pervasive, and scripts are much more consistent about working with one object or dataset at a time. The core tool for this purpose is a new top-level program called `plough`, which allows an experiment script to be called multiple times but with different sets of arguments.

The `pnt-data` script serves as a good illustrative example. In typical previous use one might create a design file, let's say "design.yaml", with contents like

```yaml
TractName: genu
SessionList: [ /data/subject1, /data/subject2 ]
SearchWidth: 7
DatasetName: genu_data
```

The "SessionList" variable, expected by `pnt-data` in TractoR 2.x, tells the script where to find several datasets, which it would work through sequentially, in parallel across cores, or using a grid engine, using one of the commands

    tractor -c design.yaml pnt-data                       # Sequential
    tractor -c design.yaml -p 2 pnt-data                  # Locally parallelised
    tractor -c design.yaml pnt-data-sge QueueName:myq     # Grid engine

This worked well enough, for `pnt-data` in particular, but few other scripts worked with the '-p' option, and *no* other scripts had an option to use a grid engine. By contrast, these options are available to every script in TractoR 3.0. The syntax for the above commands would now be

    plough -C design.yaml pnt-data %SessionList           # Sequential
    plough -C design.yaml -P 2 pnt-data %SessionList      # Locally parallelised
    plough -C design.yaml -G -Q myq pnt-data %SessionList # Grid engine

There are a few things to note here. Firstly, `pnt-data` now takes a session directory as an argument, because it works on one session at a time. Since this differs for each call to the script, we use the `plough`-specific notation with a percent sign, `%SessionList`, to mean "the value of the 'SessionList' variable on this iteration of the loop". Note that using the grid engine is specified with the '-G' flag, with the queue name passed using '-Q'. Note also that in general, flags to `plough` use upper-case letters, to avoid confusing them with the lower-case flags of `tractor`, which can be mixed in as required.

Using `plough` not only opens up parallelisation to all the package's scripts, but it also allows for some more complex commands. Let's say we want to run `pnt-data` for multiple tracts and sessions, all at once. We update our design file first:

```yaml
TractName: [ genu, splenium ]
Session: [ /data/subject1, /data/subject2 ]
SearchWidth: 7
```

Now, we can construct a more complex call to `plough`, such as

    plough -C design.yaml -X -P 3 -w %TractName pnt-data %Session DatasetName:%TractName_data

Here, we use the '-X' flag, which means "apply every combination of all variables whose length is greater than one", so we run `pnt-data` four times, for each combination of tract and subject. We collate data from each tract in a separate working directory ('-w'), and name the dataset according to the tract (`DatasetName:%TractName_data`). Of course, there is no obligation to get as complex as this, but this should give a sense of what is possible with relatively little effort.

## Visualisation

Visualisation is another area in which TractoR 3.0 has improved and consolidated on previous versions. The interactive viewer, accessible through the `view` script, has received some refinements, for example by now showing the name of a selected region in parcellation images. However, the biggest changes are elsewhere. The old `proj` and `contact` scripts have been removed, as has the ability of many other scripts to produce PNG graphics files. Instead, there is a much more capable `slice` script, which can visualise and overlay multiple images, show multiple slices or planes in a single PNG graphic, and so on. There are some examples of its usage in the output of `tractor -o slice`.

## Transformations

Transformations are now stored in folders with an .xfmb extension, rather than in flat .Rdata files. This change was partially forced by upstream changes to nonlinear transform representation by NiftyReg, but it does have the advantage of being more transparent and exposing the transformation information more directly. The `reg-info` script can be used to get information about them, and the new `reg-check` script can be used to check coregistration.

## Multishell support

TractoR is now more aware of "multishell" diffusion-weighted acquisitions, in which more than one nonzero b-value is used. The output of the `status` script has been updated accordingly, and suitable options are used by the `bedpost` wrapper script. The `dpreproc` script now also interfaces to FSL's [`topup`](http://fsl.fmrib.ox.ac.uk/fsl/fslwiki/TOPUP) and [`eddy`](http://fsl.fmrib.ox.ac.uk/fsl/fslwiki/EDDY) commands for correcting artefacts due to susceptibility effects and eddy currents, respectively. Supporting these is an awareness of reverse phase-encode acquisitions, and the ability to read information on echo separation from Siemens ASCII headers, a manufacturer-specific extension to DICOM files.

## Parallel installation

Parallel installation of versions 2.x and 3.x of TractoR is perfectly possible, since each version's packages can be easily stored in a different library. For the purpose of these instructions, we assume that you are using the "bash" shell, and that you already have TractoR 2.x set up.

**Note**: TractoR 3.x will update certain data structures to newer formats, so you would be well advised to duplicate any data that you may wish to continue to use with TractoR 2.x. In general mixing versions within a study is not recommended.

First, navigate to wherever TractoR 2.x is installed; let's say `/usr/local/tractor`. Then install the packages *locally*.

    cd /usr/local/tractor
    make install-local

The `install-local` target will install TractoR 2.x's R packages within `/usr/local/tractor/lib/R`, where they won't interfere with other TractoR versions. All of your TractoR commands will continue to work just as before.

Next, navigate to wherever you have unpacked TractoR 3.x; let's say `/usr/local/tractor3`. There we do the same thing, but installs are now local by default, so

    cd /usr/local/tractor3
    make install

is sufficient.

Finally, we need to create an alias for TractoR 3, which sets the `TRACTOR_HOME` environment variable appropriately. For example, you could add the line

    alias tractor3='TRACTOR_HOME=/usr/local/tractor3 /usr/local/tractor3/bin/tractor'

to the ".bashrc" file in your home directory. (Note that this is a hidden file and may not be visible from a file browser.) You can then run `tractor3` instead of `tractor` from the command line when you want to use the new version:

    tractor3 platform
    # Starting TractoR environment...
    #                Machine : x86_64
    #                OS name : Darwin
    #             OS release : 15.4.0
    # TractoR home directory : /usr/local/tractor3
    #        TractoR version : 3.0.0
    #              R version : 3.3.0
    #       R build platform : x86_64-apple-darwin15.4.0
    #      R package library : /usr/local/tractor3/lib/R
    #            FSL version : 5.0.9
    # Experiment completed with 0 warning(s) and 0 error(s)
