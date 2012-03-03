TractoR version 2.0 introduced some significant changes, aimed broadly at generalising the package and providing a better platform for future development. Part of this process was to remove the focus of the package on diffusion-weighted data, and on using FSL tools to (pre)process it.

The update has also provided an opportunity to use internally new features of the R language. These changes will not be seen by most users, but they do mean that a relatively recent version of R (v2.12.1 or later) is required before installing.

Details on specific changes to [preprocessing](#preprocessing), [overriding defaults](#overriding_defaults) and [session status reporting](#session_status) are outlined below, plus [miscellaneous changes](#misc). [Parallel installation](#parallel-installation) of TractoR 1.x and 2.x is discussed at the end.

<a name="preprocessing" />
## Preprocessing

The most visible changes for most users will be the changes to preprocessing. The old `preproc` script was becoming quite unwieldy, and tried to perform too many functions, only some of which were strictly preprocessing operations. It also used FSL tools for everything by default. The script still exists, although it has been renamed to `dpreproc` to reflect the fact that it is specific to preprocessing *diffusion* data; some of its defaults have changed; and some of its functions have been devolved to other (new) scripts. Hence, while you previously may have run simply

    tractor preproc

from a session directory, you will now need several commands to perform the same operations. The closest equivalent to the old five stages would be achieved by running the following commands (in this order).

    tractor dpreproc MaskingMethod:bet BetIntensityThreshold:0.5
    tractor gradcheck
    tractor gradrotate  # Only if you previously used RotateGradients:true
    tractor tensorfit Method:fsl
    tractor bedpost

The first of these commands runs the old stages 1-3, now split into four stages, with the order of eddy-current distortion correction and brain extraction reversed. `MaskingMethod` now defaults to `kmeans`, so if you wish to use BET (the old default), you must specify this explicitly. Likewise, the default value of `BetIntensityThreshold` is now 0.3, so again you may want to explicitly revert to the old default of 0.5 -- although this is not recommended because experience suggests that 0.3 gives more reliable results.

The second command gives you the opportunity to check interactively that your gradient directions have the correct sign. If you know that this is the case, then you can skip this altogether. The third command rotates the diffusion gradient directions to compensate for eddy-current distortion correction, as `preproc` did with the option `RotateGradients:true`, and is optional. The fourth command fits diffusion tensors to the data, which is optional but recommended. In this case the FSL `dtifit` program is used, but TractoR's own fitter can be used instead, in particular if you want to use an iterative weighted least-squares approach for robustness. Lastly, `tractor bedpost` performs the old `preproc` stage 5. This is currently required for tractography, but may not remain so in the future.

Most of these scripts have options that you can see using `tractor -o (script_name)` in the usual way.

<a name="overriding_defaults" />
## Overriding defaults

The default options for several scripts have changed, as noted for `dpreproc` above. However, TractoR now provides a mechanism for overriding defaults on a per-user basis, so if you liked things the way they were, you can do something about it! The mechanism is to create a YAML file in `~/.tractor` which is named for the script in question, and placing new defaults there. For example, if you create a file called `~/.tractor/dpreproc.yaml` and put in it the line

    MaskingMethod: bet

then BET will be used by default in `dpreproc`, as in TractoR 1.x.

<a name="session_status" />
## Session status

The `status` script is now both more general and more informative. Example output as of TractoR v2.0.2 is below.

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

Note that this script is not diffusion-specific. If you simply want to know which stages of `dpreproc` have been run, you need the command

    tractor dpreproc StatusOnly:true

<a name="misc" />
## Miscellaneous changes

* The `mkbvecs` script is now called `gradread`.
* Scripts that use a `Tracker` option now default to `tractor` (the internal tracker, which is usually faster but requires the tractor.native package). PNT scripts that have an `AsymmetricModel` option default to `TRUE`, while those with a `NumberOfSamples` option default to 1000, again for speed.
* The default verbosity level is now 1, rather than 0. Users may therefore see much more output than before. The default can be switched back by setting up `~/.tractor/config` appropriately: see the man page for details.

<a name="parallel-installation" />
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

    $ tractor2 -z platform
    Starting TractoR environment...
                   Machine : x86_64
                   OS name : Darwin
                OS release : 11.1.0
    TractoR home directory : /usr/local/tractor2
           TractoR version : 2.0.2
                 R version : 2.13.0
          R build platform : x86_64-apple-darwin9.8.0
               FSL version : 4.1.8
       ImageMagick version : 6.7.1-1
    Experiment completed with 0 warning(s) and 0 error(s)