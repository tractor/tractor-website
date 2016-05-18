# References

If you use TractoR in your work, please cite the following paper, which describes the package in general:

> J.D. Clayden, S. Muñoz Maniega, A.J. Storkey, M.D. King, M.E. Bastin & C.A. Clark (2011). [TractoR: Magnetic resonance imaging and tractography with R](paper/index.html). _Journal of Statistical Software_ **44**(8):1-18.

Additionally, the table below outlines the relevant papers which should be cited when using various parts of the functionality provided by TractoR.

Script name(s)                                      | Reference(s)
--------------------------------------------------- | ------------------------------------------------
`dpreproc` (stage 2, with `UseTopup:true` only)     | Andersson J.L.R., Skare S. & Ashburner J. (2003). How to correct susceptibility distortions in spin-echo echo-planar images: Application to diffusion tensor imaging. _NeuroImage_ **20**(2):870–888.
`dpreproc` (stage 3, with `MaskingMethod:bet` only) | Smith S. (2002). Fast robust automated brain extraction. _Human Brain Mapping_ **17**(3):143-155.
`dpreproc` (stage 4, with `EddyCorrectionMethod:eddy` only) | Andersson J.L.R. & Sotiropoulos S.N. (2016). An integrated approach to correction for off-resonance effects and subject movement in diffusion MR imaging. _NeuroImage_ **125**:1063–1078.
`bedpost`                                           | Behrens T., Johansen-Berg H., Jbabdi S., Rushworth M. & Woolrich M. (2007). Probabilistic diffusion tractography with multiple fibre orientations: What can we gain? _NeuroImage_ **34**(1):144-155.
`track`, `mtrack`, `rtrack`                         | Behrens T., Johansen-Berg H., Jbabdi S., Rushworth M. & Woolrich M. (2007). Probabilistic diffusion tractography with multiple fibre orientations: What can we gain? _NeuroImage_ **34**(1):144-155.
`hnt-eval`, `hnt-interpret`, `hnt-ref`, `hnt-viz`   | Clayden J., Bastin M. & Storkey A. (2006). Improved segmentation reproducibility in group tractography using a quantitative tract similarity measure. _NeuroImage_ **33**(2):482-492.
`pnt-ref`, `pnt-train`, `pnt-eval`                  | Clayden J., Storkey A. & Bastin M. (2007). A probabilistic model-based approach to consistent white matter tract segmentation. _IEEE Transactions on Medical Imaging_ **26**(11):1555–1561.
`pnt-em`                                            | Clayden J., Storkey A., Muñoz Maniega S. & Bastin M. (2009). Reproducibility of tract segmentation between sessions using an unsupervised modelling-based approach. _NeuroImage_ **45**(2):377-385.
`pnt-prune`                                         | Clayden J., King M. & Clark C. (2009). Shape modelling for tract selection. In Yang G.-Z., Hawkes D., Rueckert D., Noble A. & Taylor C. (eds), _Proceedings of the 12th International Conference on Medical Image Computing and Computer Assisted Intervention_ (MICCAI). _Lecture Notes in Computer Science_, vol. 5762, pp. 150-157. Springer-Verlag.
`reg-linear` (with `Method:fsl`)                    | Jenkinson M., Bannister P., Brady J. & Smith S. (2002). Improved optimisation for the robust and accurate linear registration and motion correction of brain images. _NeuroImage_ **17**(2):825-841.
`reg-linear` (with `Method:niftyreg`)               | Modat M., Cash D.M., Daga P., Winston G.P, Duncan J.S & Ourselin S. (2014). Global image registration using a symmetric block-matching approach. _Journal of Medical Imaging_ **1**(2):024003.
`reg-nonlinear`                                     | Modat M., Ridgway G., Taylor Z., Lehmann M., Barnes J., Hawkes D., Fox N. & Ourselin S. (2010). Fast free-form deformation using graphics processing units. _Computer Methods and Programs in Biomedicine_ **98**(3):278-284.
`freesurf`                                          | Please see <http://surfer.nmr.mgh.harvard.edu/fswiki/FreeSurferMethodsCitation>.
`graph-build` (with `Type:functional` and `UseShrinkage:true`) | Schäfer J. & Strimmer K. (2005). A shrinkage approach to large-scale covariance matrix estimation and implications for functional genomics. _Statistical Applications in Genetics and Molecular Biology_ **4**(1):32.
                                                    | Opgen-Rhein R. & Strimmer K. (2007). Accurate ranking of differentially expressed genes by a distribution-free shrinkage approach. _Statistical Applications in Genetics and Molecular Biology_ **6**(1):9.
`graph-decompose` (with `Method:principal-networks`)| Clayden J., Dayan M. & Clark C. (2013). Principal networks. _PLoS ONE_ **8**(4):e60997.
`graph-decompose` (with `Method:modularity`)        | Newman M. (2006). Modularity and community structure in networks. _Proceedings of the National Academy of Sciences of the United States of America_ **103**:8577-8582.
