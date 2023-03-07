# 210Pb dating CFCS SERAC test
The fitting in this model in order to calculate sedimentation rate and initial activity parameters is done on a linearized profile (using log(Activity)), with a linear fit. However, because 210Pb_xs is a value calculated from two measurements, at the lower activity profile where the excess activity nears 0, often times negative values are present. These are then ignored by the fit and not included in calculation of parameters. I wondered if this can have an systematic effect on the fit result.
![scatch](https://github.com/Danapit/210Pb_dating_CFCS_SERAC_test/blob/main/Figs/Scatch.png)

I though of this experiment:
* define an "ideal" profile with sedimentation rate, initial activity, constant supported lead value a "calibration factor"
* create a random scattered profile based on the initial conditions
* calculate a sedimentation rate using CFCS model included in the [serac package](https://github.com/rosalieb/serac) (Bruel and Sabatier, 2020)
* do this many times and evaluate if in case of negative values in the profile this will have a systematic effect on the calculated sedimentation rate

The R code for this is included in [synthetic.R](https://github.com/Danapit/210Pb_dating_CFCS_SERAC_test/blob/main/synthetic.R).
The results of the individual runs are written in the directory [/Results/](https://github.com/Danapit/210Pb_dating_CFCS_SERAC_test/tree/main/Results) and are analyzed graphically (and also statistcially) in the same code: [synthetic.R](https://github.com/Danapit/210Pb_dating_CFCS_SERAC_test/blob/main/synthetic.R).

## References
Bruel, Rosalie and Sabatier, Pierre (2020): [serac](https://github.com/rosalieb/serac): an R package for ShortlivEd RAdionuclide chronology of recent sediment cores, Journal of Environmental Radioactivity, 225, [doi:10.1016/j.jenvrad.2020.106449](https://doi.org/10.1016/j.jenvrad.2020.106449)
