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
                    # Convert each 8 hex digits into 4 bytes (little endian)
                    for i in range(6, -2, -2):
                        byte = int(line[i:i+2], 16)
                        bytes_list.append(byte)
                except ValueError:
                    print(f"Invalid hex data: {line}")
                    continue
    except FileNotFoundError:
        print(f"Input file '{filename}' not found!")
        sys.exit(1)

    return bytes_list

def write_output_file(filename, bytes_received):
    """Write the received bytes into output.hex."""
    with open(filename, 'w') as f:
        # Write as 32-bit words (4 bytes) in big-endian
        for i in range(0, len(bytes_received), 4):
            word = bytes_received[i:i+4]
            while len(word) < 4:
                word.append(0x00)  # Padding if needed
            hex_line = "".join(f"{b:02X}" for b in reversed(word))
            f.write(f"0x{hex_line}\n")
    print(f"Output written to {filename}")

def send_and_receive_byte_by_byte(input_file, output_file):
    try:
        bytes_to_send = load_input_file(input_file)
        if not bytes_to_send:
            print(f"No valid data found in {input_file}. Exiting.")
            sys.exit(1)
        print(f"Loaded {len(bytes_to_send)} bytes from {input_file}.")

        ser = serial.Serial(
            port=serial_port,
            baudrate=baud_rate,
            parity=parity,
            stopbits=stopbits,
            bytesize=serial.EIGHTBITS,
            timeout=1  # 1 second timeout for each byte
        )
        print(f"Opened serial port {serial_port}.")

        received_bytes = []

        for idx, b in enumerate(bytes_to_send):
            print(f"Sending byte {idx+1}/{len(bytes_to_send)}: 0x{b:02X}")
            ser.write(bytes([b]))

            start_time = time.time()
            timeout = 2  # wait up to 2 seconds per byte

            received = None

            while received is None:
                if ser.in_waiting:
                    received_data = ser.read(1)
                    if received_data:
                        received = received_data[0]
                        received_bytes.append(received)
                        print(f"Received processed byte: 0x{received:02X}")
                        break

                if time.time() - start_time > timeout:
                    print(f"Timeout waiting for response for byte {idx+1}.")
                    sys.exit(1)

                time.sleep(0.01)

            # Optional short delay between bytes
            time.sleep(0.01)

        # Save all received bytes
        write_output_file(output_file, received_bytes)

    except Exception as e:
        print(f"Error: {e}")
    finally:
        if 'ser' in locals() and ser.is_open:
            ser.close()
            print("Closed serial port.")

if __name__ == "__main__":
    send_and_receive_byte_by_byte('input.hex', 'output.hex')
