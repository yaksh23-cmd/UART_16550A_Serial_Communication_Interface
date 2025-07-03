# UART_16550A_Serial_Communication_Interface
## Overview

### This project implements a UART 16550A module, a standard for asynchronous serial communication, designed for reliable data transfer in embedded systems. It features Tx/Rx logic, FIFOs, and a baud generator, with comprehensive register control for configuration and status monitoring.

![image](https://github.com/user-attachments/assets/0037ef9c-b37a-447a-9c91-3a671053b1d8)


# UART 16550 Module for KeyStone Devices

This project provides documentation and implementation guidance for the **Universal Asynchronous Receiver/Transmitter (UART)** module based on the industry-standard **TL16C550**. It is compatible with TI's **KeyStone architecture** and provides both legacy and enhanced FIFO-based UART support.

---

## 📜 Overview

The UART module provides:
- Serial-to-parallel and parallel-to-serial data conversion
- FIFO buffering to reduce CPU overhead
- Support for programmable baud rates
- Full interrupt support and optional DMA event triggering

---

## ⚙️ Features

- Based on **TL16C550** (backward compatible with TL16C450)
- **16-byte FIFO** support for transmit and receive
- Programmable **baud rate generator**
- **Optional autoflow control** using RTS/CTS
- **Interrupt and Polling Modes**
- Loopback test support
- Power management via `PWREMU_MGMT` register

---

## 🧱 Architecture

```
CPU <---> UART <---> Serial Device
         (TX/RX with FIFO, Baud Generator, Control Logic)
```

Functional Blocks:
- Transmitter Holding Register (THR)
- Receiver Buffer Register (RBR)
- Baud Rate Generator
- Line/Modem Control Registers
- FIFO Control
- Interrupt/Event Control
- Divisor Latch (DLL, DLH)

---

## 🔌 Signal Descriptions

| Signal       | Direction | Description                    |
|--------------|-----------|--------------------------------|
| UARTn_TXD    | Output    | Serial data transmit           |
| UARTn_RXD    | Input     | Serial data receive            |
| UARTn_CTS    | Input     | Clear-to-send (flow control)   |
| UARTn_RTS    | Output    | Request-to-send (flow control) |

> Note: RTS/CTS flow control is optional and not available on all UART instances.

---

## 🔄 Data Format

```
[START] + [5-8 Data Bits] + [Optional PARITY] + [1/1.5/2 STOP Bits]
```

---

## 🧪 Operating Modes

### Transmit
- THR holds data
- TSR shifts and transmits over `UARTn_TXD`
- Interrupt triggered when FIFO is empty (if enabled)

### Receive
- RSR receives serial data
- Data moved to RBR FIFO
- Interrupts on trigger level or timeout

---

## 📥 Initialization

1. Set divisor latches (DLL, DLH)
2. Configure line control (LCR)
3. Enable FIFOs via FCR
4. Optionally enable interrupts (IER)

---

## 🔁 Loopback Test

Enable loopback mode via the **MCR** register (`LOOP` bit) for self-test without external UART.

---

## 📦 Registers

- `RBR`, `THR`, `IER`, `IIR`, `FCR`, `LCR`, `MCR`
- `LSR`, `MSR`, `SCR`
- `DLL`, `DLH` (Baud Rate Divisors)
- `PWREMU_MGMT` (Reset & Power Control)
- `MDR` (Mode Select)

Refer to the [TI UART SPRUGP1 PDF](https://www.ti.com/lit/pdf/sprugp1) for detailed bit descriptions.

---

## 📚 References

- [TI SPRUGP1 UART User Guide (PDF)](https://www.ti.com/lit/pdf/sprugp1)
- [TL16C550 UART Datasheet](https://www.ti.com/product/TL16C550C)

---

## 🛠️ License

MIT License

---

## 🤝 Contributing

Feel free to fork this repo and submit PRs for bugfixes, test cases, or improvements!
