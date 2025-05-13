import serial
import time

# Serial port configuration
serial_port = "/dev/ttyUSB1"  # Replace with your UART port (e.g., COMx on Windows)
baud_rate = 115200
parity = serial.PARITY_NONE
stopbits = serial.STOPBITS_ONE

def load_machine_code(filename):
    """Read machine code file and return a list of payload bytes."""
    payload = []
    with open(filename, 'r') as f:
        for line in f:
            instruction = line.strip()
            if not instruction:
                continue  # Skip empty lines
            if instruction.lower().startswith("0x"):
                instruction = instruction[2:]
            if len(instruction) < 8:
                continue  # Skip if not a full instruction
            # Convert 8 hex digits into 4 bytes in little-endian order.
            for i in range(6, -1, -2):
                byte = int(instruction[i:i+2], 16)
                payload.append(byte)
    return payload

def write_echoed_payload(echoed_payload):
    """Write echoed payload bytes to machine_received.hex.
       If payload length is a multiple of 4, group bytes as 32-bit instructions.
    """
    filename = "machine_received.hex"
    with open(filename, "w") as f:
        if len(echoed_payload) % 4 == 0:
            # Group into 4-byte instructions; reverse back to big-endian format
            for i in range(0, len(echoed_payload), 4):
                group = echoed_payload[i:i+4]
                # Reverse the little-endian order back to big-endian hex string
                instr = "".join(f"{b:02X}" for b in group[::-1])
                f.write(f"0x{instr}\n")
        else:
            # Write each byte on a new line
            for b in echoed_payload:
                f.write(f"0x{b:02X}\n")
    print(f"Echoed payload written to {filename}")

def send_program(filename):
    try:
        # Load payload bytes from file
        payload = load_machine_code(filename)
        payload_length = len(payload)
        print(f"Payload length: {payload_length} bytes.")

        # Open serial port with a base timeout
        ser = serial.Serial(
            port=serial_port,
            baudrate=baud_rate,
            parity=parity,
            stopbits=stopbits,
            bytesize=serial.EIGHTBITS,
            timeout=2  # Base timeout for each read call
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
            # Optionally, insert a short delay between bytes if needed:
            # time.sleep(0.001)
        print("Payload sent.")

        # --- Optional delay to allow the bootloader to start processing ---
        time.sleep(2)  # Adjust if needed

        # --- Receive Echoed Payload for Verification ---
        print("Waiting for payload echo from bootloader...")

        echoed_payload = bytearray()
        overall_timeout = 30  # Maximum overall seconds to wait
        inactivity_timeout = 3  # Wait for 3 seconds of no new data before assuming done
        start_time = time.time()
        last_data_time = time.time()
        last_count = 0

        while True:
            # Read all available bytes
            if ser.in_waiting:
                data = ser.read(ser.in_waiting)
                echoed_payload.extend(data)
                last_data_time = time.time()
            else:
                # If no new data for inactivity_timeout, assume transmission is done
                if time.time() - last_data_time > inactivity_timeout:
                    print("No new data for a while; assuming echo is complete.")
                    break

            # Optionally print progress if new bytes have been received
            if len(echoed_payload) != last_count:
                print(f"Received {len(echoed_payload)} of {payload_length} bytes...")
                last_count = len(echoed_payload)

            # If we've received the full payload, break
            if len(echoed_payload) >= payload_length:
                break

            # If overall timeout reached, exit the loop
            if time.time() - start_time > overall_timeout:
                print("Overall extended timeout reached, breaking out of read loop.")
                break

            time.sleep(0.01)  # Short delay to prevent busy waiting

        print(f"Total echoed bytes received: {len(echoed_payload)}")

        if len(echoed_payload) != payload_length:
            print(f"Error: Expected {payload_length} echoed bytes, but received {len(echoed_payload)}.")
        else:
            print("Echo received successfully.")

        # Write the echoed payload to a file for inspection.
        write_echoed_payload(list(echoed_payload))

        # Verify echoed payload matches the original
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
