# HNT tutorial

**Please note that heuristic neighbourhood tractography is now deprecated. For new projects, please use the much more sophisticated and flexible [probabilistic neighbourhood tractography](PNT-tutorial.html).**

## Overview

This tutorial describes how to use TractoR to perform neighbourhood tractography using the heuristic method described in [Ref. (1)](#reference). Heuristic neighbourhood tractography (HNT) uses a reference tract as a guide to the topology of the white matter structure that needs to be segmented.

**Note**: The alternative [probabilistic approach](PNT-tutorial.html) to neighbourhood tractography is recommended in preference to the heuristic approach described here, due to its greater flexibility and considerably improved robustness, although the heuristic method is slightly simpler to run. If you do use this method in your studies please cite [Ref. (1)](#reference). Details of the underlying methods can be found there.

TractoR experiment scripts that may be used in a typical HNT-based study are `hnt-eval` (to evaluate a series of tracts for similarity to the reference tract), `hnt-viz` (to visualise the best-matching tract from each session directory), `hnt-interpret` (to display the seed point or similarity score for the best-matching tract in each subject), and `mean` or `gmean` (to calculate the mean anisotropy along the best-matching tracts).

## Requirements

The prerequisites for HNT are some [fully preprocessed](diffusion-processing.html) diffusion MR data and a [reference tract](reference-tracts.html) representing the pathway we wish to segment in those data. The latter may be a custom reference tract, or one of the standard references provided with the software.

## Segmenting in novel data

Once a suitable reference tract is chosen and available, segmenting a similar tract in another brain volume is a matter of identifying the appropriate session directory (we'll use /data/testsubject for the sake of example) and the size of the search neighbourhood. These parameters are passed to `hnt-eval`, along with the tract name:

    tractor hnt-eval /data/testsubject TractName:genu SearchWidth:7 ResultsName:genu_results

Here we use a search neighbourhood of 7 x 7 x 7 voxels, as in [Ref. (1)](#reference). The larger the "SearchWidth", the more likely a good match will be found, but the longer the process will take to complete. There is an anisotropy (FA) threshold of 0.2 imposed on the neighbourhood by default, so that seed points with FA lower than 0.2 will not be used to generate candidate tracts. The level of this threshold can be set with the "AnisotropyThreshold" option.

Note that the preceding example uses a [standard reference tract](reference-tracts.html) (the genu), so TractoR knows where to find it. However, if a custom reference tract is used, it must be copied into the working directory before running `hnt-eval`. An error will be produced if no reference tract of the specified name can be found.

The `hnt-eval` script will generate a results file, which can be used to generate an Analyze/NIfTI volume and/or PNG projection images of the best matching tract from the test subject, with `hnt-viz`:

    tractor hnt-viz /data/testsubject TractName:genu ResultsName:genu_results

(The `slice` script can be used to convertThe location of the final seed point, or the similarity score of the associated tract, can be displayed using `hnt-interpret`:

    tractor hnt-interpret /data/testsubject ResultsName:genu_results Mode:location

Finally, the mean FA along the selected tract can be calculated using the `mean` script, as in

    tractor mean /data/testsubject@FA genu.1

where "genu.1" is the tract volume created by `hnt-viz` for our test session.

## Using a design file

Since the various HNT scripts have a number of options in common, which are typically repeated from one to the other, it is often convenient to store these options in a file, rather than specifying them on the command line. Moreover, since any given script will simply ignore any options which it does not use, the entire experiment's parameters can be stored in a single configuration file, or design file. For example, if we place into a file called "design.yaml" the following

```yaml
TractName: genu
SearchWidth: 7
ResultsName: genu_results
```

then our calls to the HNT scripts can be simpler and less repetitive. We can now use

    tractor -c design.yaml hnt-eval /data/testsubject

to do the same job that our earlier `hnt-eval` command did, but with less command-line clutter. Note that the `-c` flag, which must come *before* the script name, tells TractoR to look in the file "design.yaml" for configuration parameters. (See the `tractor` man page for more details.) Any further parameters needed by specific scripts can still be given as part of a command, as in

    tractor -c design.yaml hnt-viz /data/testsubject

Another advantage of using a design file is that it allows us to easily process multiple data sets, potentially in parallel, in one command. Thus, our design can be broadened to find matching tracts in a group of subjects:

```yaml
Session: [ /data/testsubject1,
           /data/testsubject2,
           /data/testsubject3 ]
TractName: genu
SearchWidth: 7
ResultsName: genu_results
```

Note that the list of test sessions is enclosed by square brackets and separated by commas (and optionally whitespace, which may include newlines as in this example). Now, we need to switch to using the `plough` program from the command line, which is designed to call a TractoR script with different sets of arguments. The commands above become

    plough -C design.yaml hnt-eval %Session
    plough -C design.yaml hnt-viz %Session
    plough -C design.yaml hnt-interpret %Session Mode:location
    plough -C design.yaml mean %Session@FA genu.%%

Note the syntax `%Session`, which will be expanded by `plough` to use each value of the "Session" variable specified in the design file, in turn. In the final command, `%%` is also used, which is replaced by the number of the iteration being performed: 1, 2 or 3.

## Summary

This tutorial has demonstrated the stages involved in using heuristic neighbourhood tractography for tract segmentation, following the process described in the reference below. We used a reference tract as a guide for candidate tract selection in a test data set of one or more subjects.

## Reference

1. J.D. Clayden et al., *Neuroimage* **33**(2):482-492, 2006.
