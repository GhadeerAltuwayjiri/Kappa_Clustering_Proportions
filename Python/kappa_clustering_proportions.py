import numpy as np
import matplotlib.pyplot as plt

# Define the cov_sim variations
cov_sim_values = [0, 0.1, 0.2, 0.5, 0.7]
Kappa_vals = [0.1, 0.25, 0.5, 1, 2, 4, 10]

# Reference pi values (cluster proportions)
reference_pi = [0.20026012, 0.02872121, 0.04960577, 0.09722489, 0.01736141, 0.02033389, 0.41957629, 0.10913224, 0.05778417]

# Function to calculate average cluster proportions
def average_cluster_proportions(proportions_list):
    avg_proportions = np.mean(np.column_stack(proportions_list), axis=1)
    return avg_proportions

# Calculate average cluster proportions without kappa
avg_proportions_no_kappa_list = {}
for cov_sim in cov_sim_values:
    proportions_list = simulated_data_lists[f"cov_sim_{cov_sim}"]['pi']
    avg_proportions_no_kappa_list[f"cov_sim_{cov_sim}"] = average_cluster_proportions(proportions_list)
avg_proportions_no_kappa = np.mean(np.column_stack(list(avg_proportions_no_kappa_list.values())), axis=1)

# Function to calculate average cluster proportions with kappa for a given sample
def average_proportions_with_kappa_sample(sample_num):
    avg_proportions_with_kappa_list = {}
    for cov_sim in cov_sim_values:
        proportions_list = []
        for kappa in Kappa_vals:
            proportions_list.append(fit_list2[f"cov_sim_{cov_sim}"][Kappa_vals.index(kappa)][sample_num].weights_)
        avg_proportions_with_kappa_list[f"cov_sim_{cov_sim}"] = average_cluster_proportions(proportions_list)
    avg_proportions_with_kappa = np.mean(np.column_stack(list(avg_proportions_with_kappa_list.values())), axis=1)
    return avg_proportions_with_kappa

# Calculate average cluster proportions with kappa for each sample
avg_proportions_with_kappa_samples = [average_proportions_with_kappa_sample(i) for i in range(5)]

# Plotting the results
plt.figure(figsize=(10, 6))

# Plot the reference cluster proportions
plt.plot(range(1, len(reference_pi) + 1), reference_pi, 'ro-', label='Reference Cluster Proportions', markersize=8)

# Add average cluster proportions without kappa
plt.plot(range(1, len(reference_pi) + 1), avg_proportions_no_kappa, 'bo-', label='Avg ω Proportions without κ applied', markersize=8)

# Add average cluster proportions with kappa for each sample
colors = ['green', 'purple', 'orange', 'brown', 'pink']
for i in range(5):
    plt.plot(range(1, len(reference_pi) + 1), avg_proportions_with_kappa_samples[i], marker='o', color=colors[i], linestyle='-', label=f'Avg ω Proportions with κ applied for Sample {i+1}', markersize=8)

plt.xlabel('Clusters')
plt.ylabel('Cluster Proportions')
plt.title('Comparison of Cluster Proportions (ω and κ)')
plt.xticks(range(1, len(reference_pi) + 1), range(1, len(reference_pi) + 1))
plt.legend(loc='upper right', bbox_to_anchor=(1.25, 1), ncol=1, frameon=False)
plt.tight_layout()
plt.show()
