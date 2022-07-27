# Bitonic Sorting In Verilog

Sorting is one of the fundamental computational challenges for data center applications. 
Many relational database system operations such as order by, group by and sort-merge join rely on high-performance sorting. 
In the era of data explosion, large-scale sorting is becoming a non-trivial performance bottleneck in data centers. As a result, designing an efﬁcient large-scale sorting solution is crucial for the data center system architects.

## Bitonic Sort:
- The algorithm was devised by Ken Batcher. 
- It is a parallel sorting algorithm. 
- It follows divide and conquer approach.
- Bitonic Sort involves Two stages - Bitonic Sort and Bitonic Merge.
    - Stage 1: Bitonic Sort is forming a bitonic sequence. A sequence is called Bitonic if it is first increasing, then decreasing.
    - Stage 2: Bitonic Merge is creating one sorted sequence from bitonic sequence.


## Advantages of Bitonic Sort in hardware:
- Bitonic sort has been used widely because of its regular structure, which makes it considerably simpler to implement than an odd-even sorting network. It requires O(n log2(n)^2) comparators with a delay of O(log2(n)^2)
- Number of parallel comparisons is q(q+1)/2 where q = log2(n) with n/2 comparators at each stage.
- The bitonic sort and bitonic merge are both recursive calls to themselves. 
- Once there's a base case of swapping two elements in the desired order, the only problem would be how to reach this base case by cutting the pieces down(divide and conquer approach).
- A compare-swap element usually contains a comparator and a 2-input multiplexer, which is suitable to be implemented using the Look-Up Tables (LUTs) on the FPGAs.

## Drawbacks of Bitonic Sort:
- Number of comparisons done by Bitonic sort(O(n Log 2n) are more compared to other popular sorting algorithms. Eg. Merge Sort(O(n Log 2n))
- Inputs must be a power of two.

## Use cases:
- Kernels in High-Performance Computing (HPC) are algorithms involving the computation of sparse data structures. Sparse applications are difficult to accelerate due to their memory-bound nature, which means that the data is not accessed contiguously in memory. That implies many scatter and gather accesses to the comparatively slow memory. Consequently, dedicated hardware components capable of accelerating the scatter/gather instructions, are a key to improve the performance of sparse applications.

- Sorting is one of the fundamental computational challenges for data center applications. For example, many relational database system operations such as order by, group by and sort-merge join rely on high-performance sorting. In the era of data explosion, large-scale sorting is becoming a non-trivial performance bottleneck in data centers.

## EDA Playground link:
- Simple 8-bit bitonic sort: https://www.edaplayground.com/x/CaJi
- Scalable bitonic sort    : https://www.edaplayground.com/x/w2b7
