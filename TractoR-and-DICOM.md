# TractoR and DICOM

TractoR provides some facilities for working with DICOM files, but the [DICOM standard](http://dicom.nema.org/) is extremely complex, and TractoR's support for the DICOM file format cannot be said to be complete. Due to the varying conventions of the different scanner manufacturers, there can be several subtleties to correctly interpreting a given DICOM file. TractoR tries to follow best practices, and has been tested on files from a range of scanners from different vendors, but the accuracy of the results is not guaranteed.

**Please remember that TractoR is provided with no warranty. It is always advisable to check that your files are being correctly interpreted, for example with regard to orientation, before using these facilities on a regular basis.**

The `dicomtags` TractoR script allows you to list all of the DICOM tags in a particular file, along with their values. For example,

    tractor dicomtags $TRACTOR_HOME/tests/data/dicom/01.dcm
    # Starting TractoR environment...
    # DESCRIPTION                   VALUE
    #  Group 0002 Length             188
    #  Media Stored SOP Class UID    1.2.840.10008.5.1.4.1.1.4
    #  Media Stored SOP Instance U   1.3.12.2.1107.5.2.30.25471.30000008091010241767100006233
    #  Transfer Syntax UID           1.2.840.10008.1.2.1
    #  Implementation Class UID      1.3.12.2.1107.5.2
    #  Implementation Version Name   MR_2004V_VB11A
    #  Specific Character Set        ISO_IR 100
    #  Image Type                    ORIGINAL, PRIMARY, M, ND, NORM
    #  SOP Class UID                 1.2.840.10008.5.1.4.1.1.4
    #  SOP Instance UID              1.3.12.2.1107.5.2.30.25471.30000008091010241767100006233
    #  Study Date                    00000000
    #  Series Date                   00000000
    #  Acquisition Date              00000000
    #  Image Date                    00000000
    #  Study Time                    000000.000000
    #  Series Time                   000000.000000
    #  Acquisition Time              000000.000000
    #  Image Time                    000000.000000
    #  Accession Number              NA
    #  Modality                      MR
    #  Manufacturer                   
    #  Referring Physician's Name    NA
    #  Station Name                   
    #  Study Description              
    #  Series Description            fl3D_t1_sag
    # [...]
    # Experiment completed with 0 warning(s) and 0 error(s)</code>

For files from a Siemens scanner which contain an embedded, proprietary ASCII header, this can be extracted by setting the "SiemensAscii" option:

    tractor dicomtags $TRACTOR_HOME/tests/data/dicom/01.dcm SiemensAscii:true
    # Starting TractoR environment...
    # ulVersion                                = 0x1421cf5
    # tSequenceFileName                        = "%SiemensSeq%\gre"
    # tProtocolName                            = "fl3D+AF8-t1+AF8-sag"
    # tReferenceImage0                         = "1.3.12.2.1107.5.2.30.25471.30000008091010241767100000032"
    # tReferenceImage1                         = "1.3.12.2.1107.5.2.30.25471.30000008091010241767100000031"
    # tReferenceImage2                         = "1.3.12.2.1107.5.2.30.25471.30000008091010241767100000030"
    # ucScanRegionPosValid                     = 0x1
    # sProtConsistencyInfo.flNominalB0         = 1.494
    # sProtConsistencyInfo.flGMax              = 28
    # sProtConsistencyInfo.flRiseTime          = 5.88
    # sProtConsistencyInfo.lMaximumMatrixMode  = 3
    # sProtConsistencyInfo.lMaximumNofRxReceiverChannels = 32
    # [...]
    # Experiment completed with 0 warning(s) and 0 error(s)

Different scans within a single session are often divided into different image "series", and these can be separated using the `dicomsort` script:

    tractor dicomsort $TRACTOR_HOME/tests/data/dicom
    # Starting TractoR environment...
    # * * INFO: Reading series identifiers from 4 files
    # * * INFO: Found series 8, 9; creating subdirectories
    # * * INFO: Series 8 includes 2 files; description is "DTIb3000s5"
    # * * INFO: Series 9 includes 2 files; description is "fl3D_t1_sag"
    # Experiment completed with 0 warning(s) and 0 error(s)

Finally, a directory of DICOM files can be converted to an Analyze/NIfTI/MGH image using the `dicomread` script:

    tractor dicomread $TRACTOR_HOME/tests/data/dicom/9_fl3D_t1_sag
    # Starting TractoR environment...
    # * * INFO: Looking for DICOM files in directory /usr/local/tractor/tests/data/dicom/9_fl3D_t1_sag
    # * * INFO: Reading image information from 2 files
    # INFO: [x2] Data matrix is transposed relative to acquisition matrix
    # * * INFO: Image orientation is PIR
    # * * INFO: Data set contains 1 volume(s); 2 slice(s) per volume
    #      Image source : /usr/local/tractor/tests/data/dicom/9_fl3D_t1_sag
    #  Image dimensions : 2 x 224 x 256 voxels
    #  Voxel dimensions : 1 x 1 x 1 mm
    # Coordinate origin : (19.25,95.05,134.78)
    #   Additional tags : (none)
    #        Sparseness : 0.84% (dense storage)
    # Experiment completed with 0 warning(s) and 0 error(s)

As of TractoR version 2.1.0, the `imageinfo` script can be used instead, if only information about the image formed from the DICOM directory is required.

## The divest back-end

In TractoR version 3.1.0 a new DICOM back-end based on [Chris Rorden's `dcm2niix`](https://github.com/rordenlab/dcm2niix) (via the [`divest` R package](https://github.com/jonclayden/divest)) was added. As well as being more robust and more extensively tested, this route handles multiple series at once and interactively, removing the need to pre-sort DICOM directories. (Sorting files using `divest` is possible as of TractoR 3.2.0, however.) It also extracts more metadata from the DICOM files, storing it in auxiliary .tags files. For example,

    tractor dicomread $TRACTOR_HOME/tests/data/dicom Method:divest FileNames:metadata
    # Starting TractoR environment...
    # * INFO: Looking for DICOM files in directory /usr/local/tractor/tests/data/dicom...
    # 
    # 1: Series 8 "DTIb3000s5", TE 112 ms, TR 4100 ms 
    # 2: Series 9 "fl3D_t1_sag", TE 4.94 ms, TR 11 ms
    # 
    # Type &lt;Enter&gt; for all series, 0 for none, or indices separated by spaces or commas
    # Selected series: 2
    # * INFO: Image _0_S009_fl3D_t1_sag appears to be T1-weighted
    # * INFO: Finalising images and writing them out...
    # Experiment completed with 0 warning(s) and 0 error(s)
    
    tractor imageinfo _0_S009_fl3D_t1_sag
    # Starting TractoR environment...
    #      Image source : /tmp/_0_S009_fl3D_t1_sag
    #  Image dimensions : 2 x 224 x 256 voxels
    #  Voxel dimensions : 1 x 1 x 1 mm
    # Coordinate origin : (19.25,95.05,134.78)
    #   Additional tags : imageType, fieldStrength, flipAngle, echoTime, repetitionTime, phaseEncodingDirection, phaseEncodingSign
    # Experiment completed with 0 warning(s) and 0 error(s)

Notice that the initial DICOM-to-NIfTI conversion is now interactive, giving you the chance to choose which series to convert. In addition, the converted image retains additional metadata such as the field strength used, the TE, TR and flip angle.

In addition to this, the `CreateSession:true` can be given, in which case a standard TractoR session directory structure is created, and heuristics are used to determine where to place each converted image.
