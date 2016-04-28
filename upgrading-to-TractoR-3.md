# Upgrading to TractoR 3

As with the step up from the 1.x series to TractoR version 2.0, the 3.0 release makes substantial, breaking changes to the package and its interface. The aims of these changes are to improve the efficiency, flexibility and scope of the package further. Work on consolidating functionality and avoiding repetition has actually resulted in a *reduction* in the number of experiment scripts, from 79 in TractoR 2.6 to 67 in version 3.0.

The key changes are to

- [tractography](#tractography), where the infrastructure has been completely rewritten to be more memory efficient and faster;
- [parallelisation](#parallelisation), which is now much more widely applicable;
- [visualisation](#visualisation), which is both more capable and more focussed; and
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

## Parallel installation

Parallel installation of versions 1.x and 2.x of TractoR is possible, although not totally straightforward. (This is partly because R itself does not allow multiple versions of a single package to be installed at once.) However, if you do need to do this, the following instructions should help. They assume that you are using the "bash" shell, and that you already have TractoR 1.x set up.

**Note**: TractoR 2.x will (minimally) update any session directories that it touches to the updated format, which is not backwards compatible with TractoR 1.x, so you would be well advised to duplicate any data that you may wish to continue to use with TractoR 1.x.

Firstly, create a directory for storing the installed TractoR 2.x R packages. For example,

    mkdir ~/tractor2libs

Then navigate to the unpacked "tractor" directory for TractoR 2.x, and install the packages using

    R_LIBS_USER=~/tractor2libs make install
    R_LIBS_USER=~/tractor2libs make install-native  # if native packages are required

Now, the standard `TRACTOR_HOME` variable cannot be set up as usual, because it is in use by TractoR 1.x. So instead, we set up an alias to allow us to be able to pick up the new version. In your `~/.bashrc` file, add the line

    alias tractor2='TRACTOR_HOME=/usr/local/tractor2 R_LIBS_USER=~/tractor2libs /usr/local/tractor2/bin/tractor'

where `/usr/local/tractor2` is the directory containing the TractoR 2.x installation. You can then run `tractor2` instead of `tractor` from the command line when you want to use the new version:

<pre>
<code>$ </code><kbd>tractor2 -z platform</kbd>
<code>Starting TractoR environment...
               Machine : x86_64
               OS name : Darwin
            OS release : 11.1.0
TractoR home directory : /usr/local/tractor2
       TractoR version : 2.0.2
             R version : 2.13.0
      R build platform : x86_64-apple-darwin9.8.0
           FSL version : 4.1.8
   ImageMagick version : 6.7.1-1
Experiment completed with 0 warning(s) and 0 error(s)</code>
</pre>
