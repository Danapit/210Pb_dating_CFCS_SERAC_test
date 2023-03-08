library(SciViews)
library(dplyr)
library(serac)

# some initial assumptions ------------------------------------------------
sedrate <- 0.2
activity_ini <- 100
supported <- 20
supported.sd <- 4
count.factor <- 6

# initiate results data frame, where the model calculated Sed Rates will be written
results <- data.frame()

# generating random scattered depth profiles and applying the model
for (i in 1:500) {
  
# initiate profile
synth_profile <- data.frame("depth" = c(0.5:24.5),
                            "depth.min" = c(0:24),
                            "depth.max" = c(1:25))
#total lead activity
synth_profile$activity<- supported + activity_ini*exp(-ln(2)/22.2*synth_profile$depth/sedrate)
plot(synth_profile$depth, synth_profile$activity, type="l", col = "blue",
     xlim = c(0,25), ylim = c(-10,150) )

#excess lead activity
synth_profile$xs <- activity_ini*exp(-ln(2)/22.2*synth_profile$depth/sedrate)
points(synth_profile$depth, synth_profile$xs, type="l", col = "green")

# adding some random errors
# for total count (using some random factor which I find reaslistic to get a count instead of activity,
# and form that calculate counting error)
synth_profile$counts <- count.factor*(synth_profile$activity)
synth_profile$error <- sqrt(synth_profile$counts)
synth_profile$counts.scatter <- rnorm(mean = synth_profile$counts, sd = synth_profile$error, 25)

# back to activity - scatter of total activity
synth_profile$activity.scatter <- synth_profile$counts.scatter/count.factor
synth_profile$activity.scatter.e <- synth_profile$error/count.factor
points(synth_profile$depth, synth_profile$activity.scatter, type="p", col = "blue")

# adding scatter for supported lead
synth_profile$supported.scatter <- rnorm(mean = supported, sd = supported.sd, 25)
synth_profile$supported.scatter.e <- supported.sd <- 4
points(synth_profile$depth, synth_profile$supported.scatter, type="p", pch = 3, col = "blue")

#scattered excess lead when calculated as subtraction
synth_profile$xs.scatter <- synth_profile$activity.scatter - synth_profile$supported.scatter
synth_profile$xs.scatter.e <- sqrt(synth_profile$activity.scatter.e^2 + synth_profile$supported.scatter.e^2)
points(synth_profile$depth, synth_profile$xs.scatter, type="p", col = "green")

#plot 0 line
points(c(0,25), c(0,0), type="l", lwd = 1, col = "red", lty = 3)

#export
artif <- synth_profile[,c(2,3,5, 14)]
names(artif) <- c("depth_min", "depth_max", "Pb210ex", "Pb210ex_er")
artif.random <- synth_profile[,c(2,3,13,14)]
names(artif.random) <- c("depth_min", "depth_max", "Pb210ex", "Pb210ex_er")


#write.table(artif, "Cores/ARTIF/ARTIF.txt", sep = "\t", row.names = FALSE, quote = FALSE) #just once (not in a loop), to create the ideal profile
write.table(artif.random, "Cores/ARTIF_RANDOM/ARTIF_RANDOM.txt", sep = "\t", row.names = FALSE, quote = FALSE)

ARTIF_RANDOM <- serac(name="ARTIF_RANDOM",coring_yr=2020, mass_depth = FALSE, save_code=FALSE,  plot_Cs=F )  #do not include 'save_code' if you're working outside a Rmarkdown document

modelresult <- data.frame(SR = c(-ARTIF_RANDOM[["CFCS sediment accumulation rate"]][["SAR_mm.yr.1"]]),
                              SRsd = c(-ARTIF_RANDOM[["CFCS sediment accumulation rate"]][["error_mm.yr.1"]]),
                              Rsq = c(ARTIF_RANDOM[["CFCS sediment accumulation rate"]][["R2"]]),
                              negative_points = c(nrow(filter(artif.random, Pb210ex < 0))
))
results <- rbind(results, modelresult)

}

#sometime the loop is stipped by "Error in file(file, "rt") : invalid 'description' argument"
plot(results$negative_points, results$SR)

# once in a while (after the loop or after several errors) saving the results in a file, will be used for stats later
write.table(results, "Results/results_2023-03-04T1757.txt", sep = "\t", row.names = FALSE, quote = FALSE)


# analyze results ---------------------------------------------------------
library(ggplot2)

path_in = paste0(getwd(),"/Results/")

#list of tab files in the directory
files_data <- list.files(path = path_in, pattern = "results_")

all_results <- data.frame()
i=1
for (i in 1:length(files_data)) {
  df <- read.table(paste0(path_in,files_data[i]), header = TRUE, sep = "\t")
  all_results <- rbind(all_results, df) 
}

plot(all_results$negative_points, all_results$SR)
all_results$negative_points <- as.factor(all_results$negative_points)
summary(all_results$negative_points)

p <- ggplot(all_results, aes(negative_points, SR))
p + geom_boxplot()

# export the plot as SR_vs_negpoints.png

# calcucate and summarize mean, sd and number of data pints for each level on # of negative values
results_summary <- data_frame(
  aggregate(all_results$SR, list(all_results$negative_points), FUN=mean)
)
results_summary$sd <- aggregate(all_results$SR, list(all_results$negative_points), FUN=sd)[,2]
results_summary$L <- aggregate(all_results$SR, list(all_results$negative_points), FUN=length)[,2]
names(results_summary) <- c("number of negative", "mean", "std dev", "N")



