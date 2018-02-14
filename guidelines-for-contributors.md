# Guidelines for contributors

This page is intended only for people who are currently contributing code to TractoR, or who may in the future. It covers topics such as the coding conventions used by TractoR and the procedures applied for quality assurance. Those who wish to use TractoR within R, but not necessarily to contribute to the project itself, should see the page on [TractoR for R users](TractoR-for-R-users.html).

## Coding conventions

TractoR is primarily written in a mixture of [R](http://www.r-project.org) and C++. The first of these may not be familiar to many developers. R is a high-level, interpreted, multiparadigm language with particular strengths in statistics. It is vectorised, like [Matlab](http://www.mathworks.com), and therefore encourages an array-based programming style which can perform complex transformations on substantial amounts of data very concisely. It has a simple mechanism for interfacing to compiled C or C++ code. Further details on R itself can be found in [the manuals](http://cran.r-project.org/manuals.html) on its web site (more readable mirror [here](http://r-manuals.flakery.org)).

### General philosophy and style

- Descriptive function and variable names are strongly favoured, so as to make code as self-documenting as possible. Variables with meaningful names make understanding the effect of a line more obvious, as in <code class="language-r">spatialUnitCode <- packBits(intToBits(from@xyzt_units) & intToBits(7), "integer")</code>. It may not be clear what the right hand side of the assignment is doing, but the result is a spatial unit code. This would be much less obvious if the variable was just named `s`, for example.
- Use of vectorised functions, `apply()` and similar, is almost always preferable to extensive use of `for` loops, for reasons of both speed and conciseness. R's functional programming features are very powerful, and full advantage should be taken of them.
- TractoR aims to follow the ["don't repeat yourself"](http://en.wikipedia.org/wiki/Don%27t_Repeat_Yourself) principle. Constants and other key pieces of information are stored in one place whenever practical, and there is usually a single point of contact between the code and external software or data. Code duplication should be avoided, except where a large penalty to clarity or speed would result.
- Extensive commenting is not currently required, but counterintuitive or very obscure operations should be explained just before they occur.

### Data types and naming

- Since version 2.0, TractoR makes extensive use of the [reference classes](http://stat.ethz.ch/R-manual/R-devel/library/methods/html/refClass.html) introduced in R 2.12.0, and much deeper use of methods in key classes was adopted in version 3.0. All such classes defined within TractoR packages should be named using upper [camel case](http://en.wikipedia.org/wiki/CamelCase) convention, downcasing standard acronyms (as in `MriImage`) if necessary. Classes that do not inherit from any other class should use `SerialisableObject` (defined in the `tractor.base` package) as their superclass, unless they are transient by nature. Files defining such classes in a package should include a number at the beginning of their name, to ensure that the classes are not created before types upon which they depend (files will be loaded by R in name order).
- Reference class fields and methods should be named using lower camel case convention (as in `dataOffset`). Temporary fields, which will not be serialised, should have names ending with a period. (Of course, it must be possible to reconstruct them for a deserialised object.) Methods should be provided for accessing all public fields, and should be named "get" followed by the field name (as in `getDataOffset()`). These accessor methods should be used in code outside the class's methods, rather than accessing the fields directly.
- Very simple data structures which contain only small data elements, and are unlikely to be modified after creation, can be simply constructed using an R `list` with a simple (["S3"](https://github.com/hadley/devtools/wiki/S3)) class attribute. The probability distributions defined in `tractor.nt/R/distns.R` are good examples.
- Constants for internal use should be named using upper camel case, with a leading period, in a file called `00_constants.R` in the relevant package.
- Standard local variables and functions should be named using lower camel case.

## Functions versus methods

TractoR has historically used top-level functions for creating and manipulating objects. Names of these functions tend to reflect the class being created, and a hint of their effect, as in `newMriImageByMasking()`, which creates an `MriImage` object from two other images, a base image and a mask. However, such functions will result in a new object being created, which may be wasteful for large objects such as images. There has therefore been a gradual shift towards using reference class methods to manipulate existing objects where appropriate, and in TractoR 3.0 that function has been deprecated in favour of <code class="language-r">image$mask()</code>, which modifies the original image object. (The image can duplicated first when necessary, using <code class="language-r">image$copy()$mask()</code>.) This style should be favoured for new classes.

## Tests and quality assurance

TractoR provides a small test data set and associated set of self-tests to ensure that the package is installed and working properly. These are simple shell scripts with a short self-description, which run one or more TractoR scripts. The output is compared to a stored reference output, and the test fails if they do not match. See `tests/Makefile` for the exact mechanism, and the contents of `tests/00_Basics` for example test files. Significant additions to TractoR should be accompanied with one or more new tests, which can be added to the relevant subdirectory of `tests`, followed by running

    cd tests
    make create-tests

Before the release of a new version of the package, it should be possible to run all of the tests cleanly, without any failures. Since the `tractor.base` R package is released on [CRAN](http://cran.r-project.org), it should also be possible to run

    R CMD check --as-cran tractor.base

without generating any warnings or errors. Any issues raised by any of these quality assurance processes need to be addressed before release. Typical issues are changes in the output of a particular script, which may result in failure of one of the tests; or changes to the arguments of a function exported from the `tractor.base` package, which will require a corresponding change to the package documentation.

If a test is failing for reasons which are definitely benign, such as an intended change to the output of a script, the reference output may be regenerated using, for example,

    cd tests
    make -B 00_Basics/005_hello.save

The updated file(s) will then need to be checked in with `git`.
