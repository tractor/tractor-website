# PNT tutorial

## Overview

This tutorial covers the use of TractoR to perform model-based tract segmentation as described in [Ref. (1)](#references) below. Like the simpler [heuristic approach](HNT-tutorial.html), probabilistic neighbourhood tractography (PNT) is based on the idea of using a reference tract as a topological guide to the tract required. The model-based approach is considerably more robust but takes longer to run. If you use this method in your studies please cite [Ref. (1)](#references).

TractoR experiment scripts that may be used in a typical PNT-based study generally start with the prefix "pnt-", but there are other, more general purpose scripts which are often used, such as `mean` or `gmean`. Details of the relevant scripts are given in each section below.

## Reference tracts and matching models

As with the heuristic approach to NT, the probabilistic approach requires some [fully preprocessed](diffusion-processing.html) diffusion MR data and a [reference tract](reference-tracts.html) representing the pathway we wish to segment in those data.

In addition, however, PNT makes use of a *matching model*, which must be "trained" from the data. The model captures information about the typical deviations that acceptable tract segmentations make from the reference tract. The easiest way to create the model is to use the `pnt-em` script, which uses a single data set and fits the model while simultaneously finding suitable tracts. This approach, which is described in [Ref. (2)](#references) and was introduced in TractoR version 1.0.0, is now the recommended one for most purposes. It also requires less work from the user than the alternative, which is to split your data set into a training set and a testing set, and use `pnt-train` and `pnt-eval`, respectively, to first train the model and then use it for tract matching.

Whether `pnt-train` and `pnt-eval` or `pnt-em` are used to produce results, the results themselves take essentially the same form. Both routes are outlined below.

## Training and segmenting in one step

Using a so-called "unsupervised" approach, the matching model can be trained and applied iteratively using a single data set. The `pnt-em` experiment script is available to perform this function. We begin by creating a [design file](HNT-tutorial.html#using-a-design-file), which tells TractoR where to find our data, and sets the tract of interest. For this tutorial we assume the data are in subdirectories of /data. The design file, "design.yaml", will therefore look something like this:

```yaml
TractName: genu
Session: [ /data/subject1, /data/subject2 ]
SearchWidth: 7
DatasetName: genu_data
ResultsName: genu_results
```

Note that we use only two subjects to keep the example short, but in practice more will be required to train the model correctly (see also the next section).

With the design file created, we can run PNT using the commands

    plough -C design.yaml pnt-data %Session
    tractor -c design.yaml pnt-em

The first of these will take longer than the second to run, since the tracts have to be generated and important characteristics extracted. Using default settings, run time on a standard PC is a few minutes per subject for `pnt-data`, although the code is easily parallelisable if you have many subjects (see `man plough` for information on how `plough` facilitates this). The result of these commands will be a text file called "genu_data.txt", plus model and results files with an .Rdata extension.

Results can be visualised and interpreted [as described below](#visualising-and-interpreting-results).

## Manual training

To create a matching model manually, it is necessary to select a number of additional tracts which represent suitable segmentations of the tract of interest. These will be used to train the model. The training tracts can be generated using the same combination of the `mkroi` and `rtrack` scripts as a [custom reference tract](reference-tracts.html), or they could even be selected using the HNT method. Either way, the data used for training should be checked by hand, and kept separate from the data that will be used for testing later.

Once a number of training tracts have been identified and the corresponding test sessions and seed points are known, they can be put into a design file for use with the `pnt-train` script. The design file (say "training.yaml") will look something like the following:

```yaml
TractName: genu
Session: [ /data/trainingsubject1, /data/trainingsubject2 ]
Seed: [ "41,38,23", "39,41,22" ]
DatasetName: training
```

This design will involve seeding at voxel location 41,38,23 in the session rooted at /data/trainingsubject1, and at 39,41,22 in /data/trainingsubject2.

**Note**: We use only two training tracts to keep the example short, but in practice two is too few. The exact number of training tracts required is hard to estimate. Five may be sufficient in some cases, but more is better, and ten or more may well be needed to capture the variability most effectively.

Training the model is then a matter of running the commands

    plough -C training.yaml pnt-data %Session %Seed
    tractor -c training.yaml pnt-train

This will create a file called "training_model.Rdata", which represents the trained model. This name is always based on the "DatasetName" specified in your design file.

With the reference tract and model in place, we can move on to segmenting the genu in novel brain data. Note that the reference and model are reusable between studies, as long as the reference continues to represent the tract required and the training tracts cover a suitable range of acceptable tract trajectories.

## Segmenting in novel data

Using the model for segmentation of the tract of interest in another subject requires a pair of commands, following a similar pattern to the ones used for training. Our aim is now to generate a series of candidate tracts in the diffusion space of the test subject, calculate the shape characteristics of each tract, and evaluate a likelihood for each under the model. We first need to create another design file, design.yaml. Its contents will be something like the following:

```yaml
TractName: genu
SearchWidth: 7
DatasetName: testing
ResultsName: genu_results
```

Note that in this case no seed points are specified. (To do so is possible, but there is rarely any need to, since a centre point can be established automatically by registering the test brain to the reference brain and transforming the reference tract seed point accordingly.) The "SearchWidth" is the width of the search neighbourhood, in voxels, along each dimension. In this case we use a 7 x 7 x 7 voxel region.

Running the commands

    tractor -c design.yaml pnt-data /data/testsubject
    tractor -c design.yaml pnt-eval ModelName:training_model

will then create the test data set (in "testing.txt"), and the final results file ("genu_results.Rdata"). Note that the "ModelName" given must match the model file created by `pnt-train`. Since we are testing on just one subject we use `tractor` rather than `plough` as the interface to `pnt-data` in this case.

## Visualising and interpreting results

The results can be visualised using the `pnt-viz` script, which is analogous to the `hnt-viz` script used by the [HNT process](HNT-tutorial.html), and can be used in the same way. For example, we can use

    plough -C design.yaml pnt-viz

to create Analyze/NIfTI volumes representing the best matching tract in the test brain. An alternative, introduced in TractoR version 1.3.0, is the `pnt-prune` script, which uses the tract shape model to remove false positive pathways from the final segmentations, thereby producing much cleaner output. The command in this case is

    plough -C design.yaml pnt-prune

If you use this method, please cite [Ref. (3)](#references) below. Further details on the theory and implementation of this method can be found in that paper.

Various pieces of information about the results, including the likelihood log-ratio, a measure of goodness-of-fit for each segmentation, can be calculated using the `pnt-interpret` script:

    plough -C design.yaml pnt-interpret Mode:ratio

The mean FA along the selected tract can then be calculated using the `mean` script, as in

    plough -C design.yaml mean %Session@FA genu.%%

## Summary

This tutorial has demonstrated how to fit a probabilistic model for tract matching, and segment a similar tract in novel data using that model. We have followed the processes laid out in the references below.

## References

1. J.D. Clayden et al., *IEEE Transactions on Medical Imaging* **26**(11):1555-1561, 2007.
2. J.D. Clayden et al., *Neuroimage* **45**(2):377-385, 2009.
3. J.D. Clayden et al., *Lecture Notes in Computer Science*, **5762**:150-157, 2009.