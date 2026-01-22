# Frigate-OS

**Frigate-OS** is a comprehensive RISC-V System-on-Chip (SoC) platform designed for the chipIgnite MPW (Multi-Project Wafer) solution from ChipFoundry, featuring advanced machine learning acceleration capabilities. The SoC integrates the Hazard3 RISC-V CPU core with extensive analog/mixed-signal blocks, rich peripheral interfaces, and hardware-accelerated neural network processing.

## Overview

Frigate-OS is part of the [chipIgnite ML program](https://chipfoundry.io/ml), providing a complete SoC solution optimized for edge AI and machine learning applications. The platform combines:

- **RISC-V CPU**: Hazard3 32-bit processor with debug support
- **ML Acceleration**: Hardware Conv2D accelerator for neural network inference
- **Analog Processing**: Comprehensive analog signal processing blocks
- **Rich Peripherals**: GPIO, UART, SPI, I2C, I2S, USB CDC, CAN, ADC, DAC, and more
- **Memory System**: Configurable SRAM, Flash XIP support, and external memory interfaces

## Key Features

### CPU & Core
- **Hazard3 RISC-V CPU** (RV32IMC)
  - 32-bit RISC-V instruction set with M and C extensions
  - JTAG Debug Module Interface (DMI) support
  - Configurable extensions (ZBA, ZBB, ZBC, ZBS, ZBKB)
  - Power management and clock gating support
- **Memory**: Configurable SRAM (default 32K words = 128KB)
- **Bus Architecture**: AHB-Lite for high-speed, APB for low-speed peripherals

### Machine Learning Acceleration
- **Conv2D Hardware Accelerator** (mapped at `0x4900_0000`)
  - 2D convolution operations with configurable kernel sizes
  - ReLU activation support
  - Max pooling operations
  - Optimized for neural network inference workloads
- **NNOM Library Integration**
  - Full neural network inference framework
  - Support for CNN, RNN, and dense layers
  - Quantized (int8) model support
  - MFCC (Mel-frequency cepstral coefficients) for audio processing
- **ML Workloads**: Optimized for keyword spotting (KWS), image classification, and other edge AI applications

### Analog & Mixed-Signal
- **ADCs**: Dual 12-bit ADCs with configurable routing
- **DACs**: 16-bit sigma-delta DAC and 12-bit RDACs
- **Operational Amplifiers**: High gain-bandwidth and low-power op-amps
- **Comparators**: Precision and ultra-low-power comparators
- **Instrumentation Amplifiers**: Programmable gain amplifiers
- **Analog Routing**: Extensive switch matrix for signal routing

### Peripherals
- **GPIO**: Multiple ports (A-I) with configurable modes
- **Communication**: 
  - 4x UART interfaces
  - 2x SPI controllers
  - 2x I2C controllers
  - I2S audio interface
  - USB CDC (Device)
  - CAN controller (CTU CAN)
- **Timing**: 
  - 6x 32-bit timers
  - Watchdog timer
  - RISC-V timer
- **Storage**: QSPI Flash controller with XIP support
- **DMA**: Direct Memory Access controller

### Clock & Reset
- Multiple clock sources:
  - External clock (xclk)
  - Internal RC oscillators (500kHz, 16MHz)
  - High-speed crystal oscillator (HSXO)
  - Low-speed crystal oscillator (32.768kHz)
- Flexible clock routing and gating
- Power-on-reset and external reset support

## Documentation

- **Datasheet**: See `docs/frigate_datasheet.pdf` for complete hardware specifications
- **ChipIgnite Overview**: See `docs/chipIgnite Frigate Overview (1).pdf` for program details
- **Web Resources**: [chipIgnite ML Platform](https://chipfoundry.io/ml)

## Project Structure

```
frigate-os/
├── verilog/
│   ├── rtl/              # RTL source code
│   │   ├── frigate_soc.v # Main SoC integration
│   │   ├── frigate_core.v# Core wrapper
│   │   ├── hazard3/      # RISC-V CPU core
│   │   ├── ahbl_*/       # AHB bus infrastructure
│   │   └── ...
│   ├── gl/               # Gate-level netlists
│   ├── dv/               # Design verification
│   │   └── firmware/     # Firmware and APIs
│   │       ├── APIs/      # Peripheral driver APIs
│   │       │   ├── nnom/ # Neural network library
│   │       │   ├── conv2d.h # Conv2D accelerator API
│   │       │   └── ...
│   │       └── ...
│   └── vip/              # Verification IP
├── mag/                  # Magic layout files
├── scripts/               # Build and configuration scripts
├── ip/                   # IP dependencies
└── docs/                 # Documentation
```

## Memory Map

### AHB Bus 0 (CPU Instruction/Data)
- `0x0000_0000` - `0x3FFF_FFFF`: Flash XIP region
- `0x4000_0000` - `0x4FFF_FFFF`: AHB Bus 1 (peripherals)

### AHB Bus 1 (Peripherals)
- `0x4000_0000` - `0x400F_FFFF`: APB0 Peripherals
  - `0x4000_0000`: GPIO Port A
  - `0x4001_0000`: GPIO Port B
  - `0x4002_0000`: GPIO Port C
  - `0x4003_0000`: GPIO Port D
  - `0x4004_0000`: GPIO Port E
  - `0x4005_0000`: GPIO Port F
  - `0x4006_0000`: GPIO Port G
  - `0x4007_0000`: GPIO Port H
  - `0x4008_0000`: GPIO Port I
  - `0x4009_0000`: I2S0
  - `0x400A_0000`: I2S1
  - `0x400B_0000`: ADC0
  - `0x400C_0000`: DAC0
  - `0x400D_0000`: RISC-V Timer
- `0x4200_0000` - `0x42FF_FFFF`: APB1 Peripherals
  - `0x4200_0000`: UART0
  - `0x4201_0000`: UART1
  - `0x4202_0000`: UART2
  - `0x4203_0000`: UART3
  - `0x4204_0000`: TMR0
  - `0x4205_0000`: TMR1
  - `0x4206_0000`: TMR2
  - `0x4207_0000`: TMR3
  - `0x4208_0000`: TMR4
  - `0x4209_0000`: TMR5
  - `0x420A_0000`: Watchdog Timer
  - `0x420B_0000`: SPI0
  - `0x420C_0000`: SPI1
  - `0x420D_0000`: I2C0
  - `0x420E_0000`: I2C1
- `0x4800_0000`: 4KB SRAM
- `0x4900_0000`: **ML Registers (Conv2D Accelerator)**
- `0x4A00_0000`: USB CDC

## Building the Project

### Prerequisites

- Python 3.6+
- Make
- Git
- Docker (for precheck)
- PDK installation (sky130A/B or gf180mcuC)

### Setup

1. **Clone the repository**:
   ```bash
   git clone <repository-url>
   cd frigate-os
   ```

2. **Install dependencies**:
   ```bash
   make install-repos
   ```
   This will install:
   - Management SoC (caravel_mgmt_soc)
   - Panamax
   - Analog blocks (frigate_analog)
   - IP dependencies

3. **Install IP packages**:
   ```bash
   make install-ips
   ```

4. **Set up PDK** (if using volare):
   ```bash
   make pdk-with-volare
   ```

### Build Targets

- `make install-repos`: Install all repository dependencies
- `make install-ips`: Install IP packages
- `make precheck`: Install MPW precheck tools
- `make run-precheck`: Run design precheck validation
- `make clean`: Clean build artifacts

### Environment Variables

- `PDK_ROOT`: Path to PDK installation
- `PDK`: PDK variant (sky130A, sky130B, or gf180mcuC)
- `MGMT_ROOT`: Path to management SoC
- `ANALOG_ROOT`: Path to analog blocks
- `PANAMAX_ROOT`: Path to Panamax

## Firmware Development

### Using the ML Accelerator

The Conv2D accelerator is accessible via the API in `verilog/dv/firmware/APIs/conv2d.h`:

```c
#include "conv2d.h"

#define CONV2D_BASE 0x49000000

// Configure convolution parameters
CONV2D_setDataSize(CONV2D_BASE, width, height);
CONV2D_setKernelSize(CONV2D_BASE, kernel_w, kernel_h);
CONV2D_setStrideSize(CONV2D_BASE, stride_x, stride_y);
CONV2D_setReluEnable(CONV2D_BASE, 1);

// Start convolution
CONV2D_Start(CONV2D_BASE, 1);
```

### Using NNOM Library

The NNOM (Neural Network on Microcontroller) library provides a complete framework for running neural networks:

```c
#include "nnom/nnom.h"

// Create and configure model
nnom_model_t *model = nnom_model_create();
// ... configure layers ...

// Run inference
nnom_predict(model, &label, &probability);
```

See `verilog/dv/firmware/APIs/nnom/` for complete API documentation.

## GPIO Configuration

GPIO pins can be configured via `verilog/rtl/user_defines.v`. The configuration is applied using:

```bash
python3 scripts/gen_gpio_defaults.py
```

This script generates the necessary layout files and gate-level netlists based on GPIO configuration.

## Testing

### Simulation

RTL simulation can be performed using the testbenches in `verilog/dv/`. The project includes:

- Firmware test suites
- Peripheral driver tests
- ML workload examples

### Precheck Validation

Before tapeout, run the MPW precheck:

```bash
make run-precheck
```

This validates the design against MPW requirements.

## License

Licensed under the Apache License, Version 2.0. See `LICENSE` file for details.

## References

- [chipIgnite ML Platform](https://chipfoundry.io/ml)
- [chipIgnite MPW Solution from ChipFoundry](https://chipfoundry.io)
- [Hazard3 RISC-V CPU](https://github.com/Wren6991/hazard3)
- [NNOM Library](https://github.com/majianjia/nnom)

## Contributing

Contributions are welcome! Please ensure:

1. Code follows the existing style
2. All files include proper SPDX license headers
3. Changes are tested and validated
4. Documentation is updated as needed

## Support

For questions and support:
- Check the documentation in `docs/`
- Review the ChipIgnite resources at [chipfoundry.io](https://chipfoundry.io)
- Consult the ChipFoundry community forums

## Acknowledgments

- ChipFoundry for the chipIgnite MPW solution and infrastructure
- chipIgnite program for ML platform support
- Hazard3 CPU developers
- NNOM library contributors

---

**Note**: This is an active development project. Specifications and features may change. Refer to the datasheet and ChipIgnite documentation for the latest information.
