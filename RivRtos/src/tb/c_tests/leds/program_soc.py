import serial
import time

# Serial port configuration
serial_port = "/dev/ttyUSB1"  # Replace with your UART port (e.g., COMx on Windows)
baud_rate = 115200
parity = serial.PARITY_NONE
stopbits = serial.STOPBITS_ONE

def load_machine_code(filename):
    """
    Read a machine code file with address markers and return a list of payload bytes.
    
    The file format supports blocks starting with an address marker (e.g., "@10000000")
    followed by one or more lines of hex bytes (separated by spaces). If there is a gap
    between addresses, the gap will be filled with 0s to create a contiguous payload.
    """
    payload = []
    expected_address = None
    with open(filename, 'r') as f:
        for line in f:
            line = line.strip()
            if not line:
                continue  # Skip empty lines
            if line.startswith('@'):
                # New data block: get the starting address.
                current_address = int(line[1:], 16)
                if expected_address is None:
                    expected_address = current_address
                elif current_address > expected_address:
                    # If there's a gap, fill with zeros.
                    gap = current_address - expected_address
                    payload.extend([0] * gap)
                    expected_address = current_address
                else:
                    # If addresses are out-of-order or overlap, reset expected_address.
                    expected_address = current_address
            else:
                # Process the hex bytes in the line.
                parts = line.split()
                for part in parts:
                    if part == '':
                        continue
                    byte = int(part, 16)
                    payload.append(byte)
                    expected_address += 1
    return payload

def write_echoed_payload(echoed_payload):
    """
    Write echoed payload bytes to machine_received.hex.
    If payload length is a multiple of 4, group bytes as 32-bit instructions (big-endian).
    """
    filename = "machine_received.hex"
    with open(filename, "w") as f:
        if len(echoed_payload) % 4 == 0:
            # Group into 4-byte instructions; reverse back to big-endian hex string.
            for i in range(0, len(echoed_payload), 4):
                group = echoed_payload[i:i+4]
                instr = "".join(f"{b:02X}" for b in group[::-1])
                f.write(f"0x{instr}\n")
        else:
            # Write each byte on a new line.
            for b in echoed_payload:
                f.write(f"0x{b:02X}\n")
    print(f"Echoed payload written to {filename}")

def send_program(filename):
    try:
        # Load payload bytes from file (in the new address-marker format)
        payload = load_machine_code(filename)
        payload_length = len(payload)
        print(f"Payload length: {payload_length} bytes.")

        # Open serial port.
        ser = serial.Serial(
            port=serial_port,
            baudrate=baud_rate,
            parity=parity,
            stopbits=stopbits,
            bytesize=serial.EIGHTBITS,
            timeout=2
        )
        print(f"Opened serial port: {serial_port} at {baud_rate} baud.")

        # --- Handshake ---
        handshake_byte = 0x55
        ser.write(bytes([handshake_byte]))
        print(f"Sent handshake byte: 0x{handshake_byte:02X}")
        echoed = ser.read(1)
        if len(echoed) == 0 or echoed[0] != handshake_byte:
            print("Handshake failed: did not receive correct echo.")
            return
        print("Handshake successful.")

        # --- Send Payload Length (2 bytes, little-endian) ---
        low_byte = payload_length & 0xFF
        high_byte = (payload_length >> 8) & 0xFF
        ser.write(bytes([low_byte, high_byte]))
        print(f"Sent payload length: 0x{low_byte:02X} 0x{high_byte:02X}")

        # --- Send Payload Bytes ---
        print("Sending payload bytes...")
        for b in payload:
            ser.write(bytes([b]))
            # Optionally insert a short delay:
            # time.sleep(0.001)
        print("Payload sent.")

        # --- Receive Echoed Payload for Verification ---
        print("Waiting for payload echo from bootloader...")
        echoed_payload = ser.read(payload_length)
        if len(echoed_payload) != payload_length:
            print(f"Error: Expected {payload_length} echoed bytes, but received {len(echoed_payload)}.")
        else:
            print("Echo received successfully.")

        # Write the echoed payload to a file for inspection.
        write_echoed_payload(list(echoed_payload))

        # Verify echoed payload matches the original.
        if list(echoed_payload) == payload:
            print("Programming Successful: Echoed payload matches.")
        else:
            print("Programming Failed: Echoed payload does not match.")

    except Exception as e:
        print(f"Error during transmission: {e}")
    finally:
        ser.close()
        print("Closed serial port.")

if __name__ == '__main__':
    send_program('machine.hex')
