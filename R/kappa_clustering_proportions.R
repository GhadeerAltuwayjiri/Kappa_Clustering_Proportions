library(MASS)
library(flowClust)
library(latex2exp)

# Define the cov_sim variations
cov_sim_values <- c(0, 0.1, 0.2, 0.5, 0.7)
Kappa_vals <- c(0.1, 0.25, 0.5, 1, 2, 4, 10)

# Reference pi values (cluster proportions)
reference_pi <- c(0.20026012, 0.02872121, 0.04960577, 0.09722489, 0.01736141, 0.02033389, 0.41957629, 0.10913224, 0.05778417)

# Function to calculate average cluster proportions
average_cluster_proportions <- function(proportions_list) {
  avg_proportions <- rowMeans(do.call(cbind, proportions_list))
  return(avg_proportions)
}

# Calculate average cluster proportions without kappa
avg_proportions_no_kappa_list <- list()
for (cov_sim in cov_sim_values) {
  proportions_list <- simulated_data_lists[[paste("cov_sim", cov_sim, sep = "_")]]$pi
  avg_proportions_no_kappa_list[[paste("cov_sim", cov_sim, sep = "_")]] <- average_cluster_proportions(proportions_list)
}
avg_proportions_no_kappa <- rowMeans(do.call(cbind, avg_proportions_no_kappa_list))

# Function to calculate average cluster proportions with kappa for a given sample
average_proportions_with_kappa_sample <- function(sample_num) {
  avg_proportions_with_kappa_list <- list()
  for (cov_sim in cov_sim_values) {
    proportions_list <- list()
    for (kappa in Kappa_vals) {
      proportions_list[[paste("kappa", kappa, sep = "_")]] <- fit_list2[[paste("cov_sim", cov_sim, sep = "_")]][[which(Kappa_vals == kappa)]][[sample_num]]@w
    }
    avg_proportions_with_kappa_list[[paste("cov_sim", cov_sim, sep = "_")]] <- average_cluster_proportions(proportions_list)
  }
  avg_proportions_with_kappa <- rowMeans(do.call(cbind, avg_proportions_with_kappa_list))
  return(avg_proportions_with_kappa)
}

# Calculate average cluster proportions with kappa for each sample
avg_proportions_with_kappa_samples <- lapply(1:5, average_proportions_with_kappa_sample)

# Plotting the results
par(mfrow = c(1, 1))

# Plot the reference cluster proportions
plot(1:length(reference_pi), reference_pi, type = "b", col = "red", pch = 16, 
     xlab = "Clusters", ylab = "Cluster Proportions", 
     ylim = c(0, max(c(reference_pi, avg_proportions_no_kappa, unlist(avg_proportions_with_kappa_samples))) + 0.05), 
     main = TeX("Comparison of Cluster Proportions ($\\omega$ and $\\kappa$)"), 
     xaxt = "n", las = 1, cex.main = 2)
axis(1, at = 1:length(reference_pi), labels = 1:length(reference_pi))

# Add average cluster proportions without kappa
lines(1:length(reference_pi), avg_proportions_no_kappa, col = "blue", type = "b", pch = 17)

# Add average cluster proportions with kappa for each sample
colors <- c("green", "purple", "orange", "brown", "pink")
for (i in 1:5) {
  lines(1:length(reference_pi), avg_proportions_with_kappa_samples[[i]], col = colors[i], type = "b", pch = 18 + i)
}

# Adding a legend without a box
legend("topright", inset = .05, bty = "n", 
       legend = c("Reference Cluster Proportions", TeX("Avg $\\omega$ Proportions without $\\kappa$ applied"), 
                  TeX("Avg $\\omega$ Proportions with $\\kappa$ applied for Sample 1"), 
                  TeX("Avg $\\omega$ Proportions with $\\kappa$ applied for Sample 2"), 
                  TeX("Avg $\\omega$ Proportions with $\\kappa$ applied for Sample 3"), 
                  TeX("Avg $\\omega$ Proportions with $\\kappa$ applied for Sample 4"), 
                  TeX("Avg $\\omega$ Proportions with $\\kappa$ applied for Sample 5")), 
       col = c("red", "blue", "green", "purple", "orange", "brown", "pink"), 
       lty = 1, pch = c(16, 17, 18:22), cex = 0.8, pt.cex = 1.5)
