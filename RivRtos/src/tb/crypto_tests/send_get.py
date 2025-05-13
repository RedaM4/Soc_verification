#!/usr/bin/env python3
import serial
import time
import sys
import os

# Serial port configuration
serial_port = "/dev/ttyUSB1"  # Replace with your UART port (e.g., COMx on Windows)
baud_rate   = 115200
parity      = serial.PARITY_NONE
stopbits    = serial.STOPBITS_ONE
bytesize    = serial.EIGHTBITS
timeout_s   = 2.0            # generous timeout for full transfer

# Your firmware expects exactly 352 bytes in, then will echo back 352 bytes
BLOCK_SIZE = 352

def load_input_file(filename):
    """Load input.hex (each line is 32-bit word → 4 bytes)."""
    if not os.path.exists(filename):
        print(f"Input file '{filename}' not found!")
        sys.exit(1)

    bytes_list = []
    with open(filename, 'r') as f:
        for line in f:
            line = line.strip()
            if not line.lower().startswith("0x"):
                continue
            hexstr = line[2:]
            if len(hexstr) != 8:
                print(f"Skipping invalid line (must be 8 hex chars): {line}")
                continue
            # convert 8-hex digits → 4 little-endian bytes
            for i in (6,4,2,0):
                bytes_list.append(int(hexstr[i:i+2], 16))

    return bytes_list

def write_output_file(filename, all_bytes):
    """Write the received bytes back as 0xXXXXXXXX words (big-endian)."""
    with open(filename, 'w') as f:
        for i in range(0, len(all_bytes), 4):
            word = all_bytes[i:i+4][::-1]  # reverse to big-endian
            f.write("0x" + "".join(f"{b:02X}" for b in word) + "\n")
    print(f"Output written to {filename} ({len(all_bytes)} bytes)")

def main():
    data = load_input_file("in.hex")
    total = len(data)
    if total == 0:
        print("No data to send.")
        sys.exit(1)

    # pad or trim to exactly BLOCK_SIZE
    if total < BLOCK_SIZE:
        print(f"Padding input from {total} → {BLOCK_SIZE} bytes")
        data += [0] * (BLOCK_SIZE - total)
    elif total > BLOCK_SIZE:
        print(f"Warning: input is {total} bytes, trimming to {BLOCK_SIZE}")
        data = data[:BLOCK_SIZE]

    # Open serial port
    try:
        ser = serial.Serial(
            port=serial_port,
            baudrate=baud_rate,
            parity=parity,
            stopbits=stopbits,
            bytesize=bytesize,
            timeout=0  # non-blocking read
        )
    except serial.SerialException as e:
        print(f"Failed to open {serial_port}: {e}")
        sys.exit(1)

    print(f"Opened {serial_port} @ {baud_rate} bps, sending {BLOCK_SIZE} bytes…")
    ser.reset_input_buffer()
    ser.write(bytes(data))

    # Now read exactly BLOCK_SIZE bytes back
    received = bytearray()
    start = time.time()
    while len(received) < BLOCK_SIZE:
        chunk = ser.read(BLOCK_SIZE - len(received))
        if chunk:
            received.extend(chunk)
        if time.time() - start > timeout_s:
            print(f"⨯ Timeout: only received {len(received)}/{BLOCK_SIZE} bytes back")
            ser.close()
            sys.exit(2)

    ser.close()
    print("✓ Received full echo back.")

    write_output_file("out.hex", received)

if __name__ == "__main__":
    main()