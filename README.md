# Hardware-Friendly-Fast-and-Low-Power-Spiking-Neuron-Network-Variational-AutoEncoder
FPGA-based SNN-VAE processor for real-time image generation and classification. Features a hardware-friendly Integer-LIF neuron model and multiplier-less architecture using bit-shift operations for extreme low-power edge AI.

## Key Features
- Bio-inspired Architecture: Implements an end-to-end SNN-VAE that leverages temporal dynamics for efficient data representation.
- Integer LIF Neuron: Uses a custom-designed Integer Leaky Integrate-and-Fire model to eliminate floating-point overhead and save hardware resources.
- Multiplier-less Design: Utilizes Quantization-Aware Training (QAT) to restrict weights to powers of two, enabling energy-efficient bit-shift operations instead of traditional multipliers.
- Dual-Functionality: Integrated support for both image generation and classification tasks on a single FPGA platform.

## Performance & Verification
- Bit-Accurate Validation: Confirmed 100% consistency between software models and RTL simulation
- Hardware Efficiency: Successfully deployed on a Xilinx FPGA, demonstrating significantly lower power consumption and latency compared to traditional ANN-based VAEs.

## Authors
- Chiang, Cheng-Han (江承瀚), Yang, Ming-Yan (楊明諺), Tsao, Shu-Wei (曹書瑋)
- *Advisor: Prof. Kuei-Chung Chang*
- *Department of Electrical Engineering, National Tsing Hua University (NTHU)*
