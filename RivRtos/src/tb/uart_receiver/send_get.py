import serial
import time
import sys

# Serial port configuration
serial_port = "/dev/ttyUSB1"  # Change to your port
baud_rate = 115200
parity = serial.PARITY_NONE
stopbits = serial.STOPBITS_ONE

def load_input_file(filename):
    """Load input.hex (each line is 32-bit instruction)."""
    bytes_list = []
    try:
        with open(filename, 'r') as f:
            for line in f:
                line = line.strip()
                if not line:
                    continue
                if line.lower().startswith("0x"):
                    line = line[2:]
                if len(line) != 8:
                    print(f"Skipping invalid line (must be 8 hex characters): {line}")
                    continue
                try:
                    # Convert each 8 hex digits (32 bits) into 4 bytes (little-endian)
                    word_bytes = []
                    for i in range(6, -2, -2):
                        byte = int(line[i:i+2], 16)
                        word_bytes.append(byte)
                    bytes_list.extend(word_bytes)
                except ValueError:
                    print(f"Invalid hex data: {line}")
                    continue
    except FileNotFoundError:
        print(f"Input file '{filename}' not found!")
        sys.exit(1)

    # Group all into a single 16-byte block
    if len(bytes_list) != 16:
        print(f"Error: Total bytes must be exactly 16 bytes (got {len(bytes_list)} bytes).")
        sys.exit(1)

    return bytes_list

def write_output_file(filename, block):
    """Write the received 16 bytes into output.hex."""
    with open(filename, 'w') as f:
        hex_line = "".join(f"{b:02X}" for b in reversed(block))  # Big-endian output
        f.write(f"0x{hex_line}\n")
    print(f"Output written to {filename}")

def send_and_receive(input_file, output_file):
    try:
        block = load_input_file(input_file)
        print(f"Loaded 1 block of 16 bytes from {input_file}.")

        ser = serial.Serial(
            port=serial_port,
            baudrate=baud_rate,
            parity=parity,
            stopbits=stopbits,
            bytesize=serial.EIGHTBITS,
            timeout=0.5
        )
        print(f"Opened serial port {serial_port}.")

        # Clear the input buffer before sending
        ser.reset_input_buffer()

        # Send the entire 16 bytes at once
        print("Sending 16-byte block...")
        ser.write(bytes(block))

        # Now wait for 16 bytes back
        echoed_block = bytearray()
        start_time = time.time()
        timeout = 5  # seconds max to wait

        while len(echoed_block) < 16:
            if ser.in_waiting:
                data = ser.read(ser.in_waiting)
                echoed_block.extend(data)

            if time.time() - start_time > timeout:
                print(f"Timeout while waiting for echoed block.")
                sys.exit(1)

            time.sleep(0.01)

        if len(echoed_block) != 16:
            print(f"Error: Expected 16 bytes, received {len(echoed_block)} bytes.")
            sys.exit(1)

        print("Received processed 16 bytes.")

        # Save the received block
        write_output_file(output_file, list(echoed_block))

    except Exception as e:
        print(f"Error: {e}")
    finally:
        if 'ser' in locals() and ser.is_open:
            ser.close()
            print("Closed serial port.")

if __name__ == "__main__":
    send_and_receive('input.hex', 'output.hex')
