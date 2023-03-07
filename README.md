# 210Pb dating CFCS SERAC test
The exponential fit in this model is done on linearized profile, using linear fit. However, because 210Pb_xs is a value calculated from two measurements, at the lower activity profile where the excess activity nears 0, ofen times negative values are present. These are the ignored by the fit and not included in calculated parameters.
![scatch](https://github.com/Danapit/210Pb_dating_CFCS_SERAC_test/blob/main/Figs/Scatch.png)

I wonder if this can have an systematic effect on the fit result.

I though of this experiment:
* define an "ideal" profile with sedimentation rate, initial activity, constant supported lead value a "calibration factor"
* create a random scattered profile based on the initial conditions
* calculate a sedimentation rate using CFCS model included in the [serac package](https://github.com/rosalieb/serac) (Bruel and Sabatier, 2020)
* do this many times and evaluate if in case of negative values in the profile this will have a systematic effect on the calculated sedimentation rate

The R code for this is included in [synthetic.R](https://github.com/Danapit/210Pb_dating_CFCS_SERAC_test/blob/main/synthetic.R).
The results of the individual runs are written in the directory [/Results/](https://github.com/Danapit/210Pb_dating_CFCS_SERAC_test/tree/main/Results) and are analyred graphically (and hopefully also statistcially) in the same code: [synthetic.R](https://github.com/Danapit/210Pb_dating_CFCS_SERAC_test/blob/main/synthetic.R).

## References
Bruel, Rosalie and Sabatier, Pierre (2020): serac: an R package for ShortlivEd RAdionuclide chronology of recent sediment cores,
Journal of Environmental Radioactivity, 225, [doi:10.1016/j.jenvrad.2020.106449](https://doi.org/10.1016/j.jenvrad.2020.106449)
