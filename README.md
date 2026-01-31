# Thesis

MATLAB implementation of a weighted graph partitioning method using the spectral normalized cut criterion. Part of my [master's thesis](https://repozitorij.pmf.unizg.hr/en/object/pmf:4602) (in Croatian).

## Table of Contents

- [Implementation](#implementation)
- [Requirements](#requirements)
- [Usage](#usage)
- [Examples](#examples)
- [License](#license)

## Implementation

First we redefine the partitioning problem as an optimization problem that we then relax. The solutions to the relaxed optimization problem are given by orthogonal transformations of the first few eigenvectors of a symmetric matrix.

In the next step we try to find a solution to the original discrete problem that is closest to the obtained set of continuous optima. We can achieve this in an iterative fashion by alternately applying two procedures:

1. Using non-maximum suppression we find the discrete solution closest to a continuous one.
2. By solving the orthogonal Procrustes problem, we obtain the continuous optimum that is a good approximation of a discrete one.

## Requirements

To use this project, you need MATLAB or GNU Octave.

## Usage

Function `ncut` takes two inputs: the similarity matrix `W`, and the number of partitions `k`. It outputs the eingenvalues `s` and the partition matrix`X*`.

## Examples

### Points in the Euclidean plane

The similarity matrix for a set of points can be defined with the formula $w_{ij} \coloneqq e^{-\frac{d(x_i,x_j)}{\sigma^2}}$, where $d$ is the square of the Euclidean distance, and $\sigma$ is a parameter for controlling the amount of variation of distances from a point.

We present two examples in `examplePoints.m` and `exampleGauss.m`. In the first example, the points are partitioned correctly ($\sigma = 0.02$). 

<img width="1443" height="732" alt="new_circle" src="https://github.com/user-attachments/assets/073ca9a2-b058-4c9a-867d-f0fc38b046f4" />

In the second example, we have two overlapping datasets: data sampled from a uniform distribution forming a rectangular strip, and data sampled from a Gaussian distribution forming a disk.
The points are not partitioned correctly ($\sigma = 0.04$). 
Since the overlap between the disk and the strip is larger than the width of the strip, a cut that separates them has a higher penalty than a cut somewhere along the thin strip.
This presents a fundamental limitation of spectral clustering.

<img width="1093" height="248" alt="rec" src="https://github.com/user-attachments/assets/395eeea0-60ef-4a3e-991c-44e1ef2461f9" />

### Images

For an image, the similarity matrix can be defined using the formula

$$
w_{ij}
\coloneqq
\begin{cases}
\ e^{-\frac{d_1(P_i,P_j)}{\sigma_1^2}-\frac{d_2(P_i,P_j)}{\sigma_2^2}}, & d_2(P_i,P_j) < r^2, \\ 
\ 0, & \text{otherwise},
\end{cases}
$$

where $d_1$ measures the similary of pixels by color, $d_2$ is the distance between pixels in space, and $\sigma_1$, $\sigma_2$, and $r$ are parameters that can be tuned.

We segmented images of dimensions 100 × 200 pixels. The number of partitions k was picked by hand. These are the results for $\sigma_1 = 0.1$, $\sigma_2 = 3.4$, and $r = 10$:

<img width="571" height="312" alt="img" src="https://github.com/user-attachments/assets/997d7f59-f336-4967-bead-70d3129516e3" />

