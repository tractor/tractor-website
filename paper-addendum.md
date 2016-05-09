# Paper addendum

The [main TractoR paper](http://www.jstatsoft.org/v44/i08/), published in the Journal of Statistical Software in 2011, was written prior to the release of TractoR 2.0. This page lists changes to the example code given in the paper, which need to be made for it to work under TractoR 2.x. **This page has not yet been updated for TractoR 3.0.**

## Section 3: The MriImage class

    ## TractoR 1.x
    # Print a list of accessor functions for image object "i"
    names(i)
    # Get the description associated with a specific DICOM tag
    getDescriptionForDicomTag(0x0018, 0x0087)
    
    ## TractoR 2.x
    # Print a list of accessor functions for image object "i"
    i$methods()
    # Get the description associated with a specific DICOM tag
    tractor.base:::getDescriptionForDicomTag(0x0018, 0x0087)

## Section 4: Modelling the diffusion-weighted signal

    ## TractoR 1.x
    # Get the location of a session's FA map
    s$getImageFileNameByType("FA")
    
    ## TractoR 2.x
    # Get the location of a session's FA map
    s$getImageFileNameByType("FA", "diffusion")

## Section 5: Fibre tracking

    ## TractoR 1.x
    # Get a session's FA map
    f <- s$getImageByType("FA")
    
    ## TractoR 2.x
    # Get a session's FA map
    f <- s$getImageByType("FA", "diffusion")