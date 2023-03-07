# 210Pb dating CFCS SERAC test
The exponential fit in this model is done on linearized profile, using linear fit. However, because 210Pb_xs is a value calculated from two measurements, at the lower activity profile where the excess activity nears 0, ofen times negative values are present. These are the ignored by the fit and not included in calculated parameters.
![scatch](https://github.com/Danapit/210Pb_dating_CFCS_SERAC_test/blob/main/Figs/Scatch.png)

I wonder if this can have an systematic effect on the fit result.

I though of this experiment:
* define an "ideal" profile with sedimentation rate, initial activity, constant supported lead value a "calibration factor"
* create a random scattered profile based on the initial conditions
* calculate a sedimentation rate using CFCS model included in the serac package
* do this many times and evaluate if in case of negative values in the profile this will have a systematic effect on the calculated sedimentation rate

