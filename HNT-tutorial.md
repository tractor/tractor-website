# HNT tutorial

## Overview

This tutorial describes how to use TractoR to perform neighbourhood tractography using the heuristic method described in Ref. (1). Heuristic neighbourhood tractography (HNT) uses a reference tract as a guide to the topology of the white matter structure that needs to be segmented. The method works with the native output of the ProbTrack algorithm (2), which represents a tract as a field of connection probabilities.

**Note**: The alternative [probabilistic approach](PNT-tutorial.html) to neighbourhood tractography is generally recommended in preference to the heuristic approach described here, due to its greater flexibility and considerably improved robustness, although the heuristic method is quicker and simpler to run. If you do use this method in your studies please cite Ref. (1). Details of the underlying methods can be found there.

TractoR experiment scripts that may be used in a typical HNT-based study are `hnt-eval` (to evaluate a series of tracts for similarity to the reference tract), `hnt-viz` (to visualise the best-matching tract from each session directory), `hnt-interpret` (to display the seed point or similarity score for the best-matching tract in each subject), and `mean` or `gmean` (to calculate the mean anisotropy along the best-matching tracts).

## Requirements

The prerequisites for HNT are some [fully preprocessed](diffusion-processing.html) diffusion MR data and a [reference tract](reference-tracts.html) representing the pathway we wish to segment in those data. The latter may be a custom reference tract, or one of the standard references provided with the software. TractoR is set up to process groups of subjects' data using very few commands.

## Segmenting in novel data

Once a suitable reference tract is chosen and available, segmenting a similar tract in another brain volume is a matter of identifying the appropriate session directory (we'll use /data/testsubject for the sake of example) and the size of the search neighbourhood. These parameters are passed to `hnt-eval`, along with the tract name:

    tractor hnt-eval SessionList:/data/testsubject TractName:genu SearchWidth:7

Here we use a search neighbourhood of 7 x 7 x 7 voxels, as in Ref. (1). The larger the `SearchWidth`, the more likely a good match will be found, but the longer the process will take to complete. There is an anisotropy (FA) threshold of 0.2 imposed on the neighbourhood by default, so that seed points with FA lower than 0.2 will not be used to generate candidate tracts. The level of this threshold can be set with the `AnisotropyThreshold` option.

Note that the preceding example uses a [standard reference tract](reference-tracts.html) (the genu), so TractoR knows where to find it. However, if a custom reference tract is used, it must be copied into the working directory before running `hnt-eval`. An error will be produced if no reference tract of the specified name can be found.

The `hnt-eval` script will generate a results file, which can be used to generate an Analyze/NIfTI volume and/or PNG projection images of the best matching tract from the test subject, with `hnt-viz`:

    tractor hnt-viz SessionList:/data/testsubject TractName:genu ResultsName:results CreateVolumes:true

The location of the final seed point, or the similarity score of the associated tract, can be displayed using `hnt-interpret`:

    tractor hnt-interpret SessionList:/data/testsubject TractName:genu ResultsName:results Mode:location

Finally, the mean FA along the selected tract can be calculated using the `mean` script, as in

    tractor mean genu_session1 /data/testsubject Metric:FA

where "genu_session1" is the tract volume created by `hnt-viz` for our test session.

## Using a design file

Since the various HNT scripts have a number of options in common, which are typically repeated from one to the other, it is often convenient to store these options in a file, rather than specifying them on the command line. Moreover, since any given script will simply ignore any options which it does not use, the entire experiment's parameters can be stored in a single configuration file, or design file. For example, if we place into a file called "design.yaml" the following

    SessionList: /data/testsubject
    TractName: genu
    SearchWidth: 7
    ResultsName: results

then our calls to the HNT scripts can be simpler and less repetitive. We can now use

    tractor -c design.yaml hnt-eval

to do the same job that our earlier `hnt-eval` command did, but with less command-line clutter. Note that the `-c` flag, which must come *before* the script name, tells TractoR to look in the file "design.yaml" for configuration parameters. (See the `tractor` man page for more details.) Any further parameters needed by specific scripts can still be given as part of a command, as in

    tractor -c design.yaml hnt-viz CreateVolumes:true

Another advantage of using a design file is that it gives more flexibility. Note that, unlike on the command line, space is allowed between parameter names and their values. More importantly, one can specify multiple values for a parameter, which cannot be done from the command line. For HNT experiments, the most important use for this is in the `SessionList` parameter, which as its name suggests, will accept a list of sessions for which a tract segmentation is required. Thus, our design can be broadened to find matching tracts in a group of subjects:

    SessionList: [ /data/testsubject1,
                   /data/testsubject2,
                   /data/testsubject3 ]
    TractName: genu
    SearchWidth: 7
    ResultsName: results

Note that the list of test sessions is enclosed by square brackets and separated by commas (and optionally whitespace, which may include newlines as in this example). When multiple sessions are specified in this way, `hnt-viz` will produce volumes or images for each session separately. If you want to find the FA along the best-matching tract in each subject, you can use the `gmean` script, as in

    tractor -c design.yaml gmean genu_session

where "genu_session" is the prefix (excluding session numbers) of the set of tract volumes created by `hnt-viz`.

## Summary

This tutorial has demonstrated the stages involved in using heuristic neighbourhood tractography for tract segmentation, following the process described in Ref. (1). We used a reference tract as a guide for candidate tract selection in a test data set of one or more subjects.

## References

1. J.D. Clayden et al., *Neuroimage* **33**(2):482-492, 2006.
2. T.E.J. Behrens et al., *Magnetic Resonance in Medicine* **50**(5):1077-1088, 2003.