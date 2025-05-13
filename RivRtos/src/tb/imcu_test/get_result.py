import serial
import time

# Serial port configuration
serial_port = "/dev/ttyUSB1"  # Change as needed
baud_rate = 115200
parity = serial.PARITY_NONE
stopbits = serial.STOPBITS_ONE

# Trigger byte (can be any agreed value with the SoC)
TRIGGER_BYTE = 0xAA  # Example: 0xAA as trigger

def send_trigger_and_receive_result():
    try:
        ser = serial.Serial(
            port=serial_port,
            baudrate=baud_rate,
            parity=parity,
            stopbits=stopbits,
            bytesize=serial.EIGHTBITS,
            timeout=0.5
        )
        print(f"Opened serial port {serial_port}. Ready to send trigger and receive results...")

        while True:
            # --- Step 1: Send the trigger byte ---
            print(f"Sending trigger byte: 0x{TRIGGER_BYTE:02X}")
            ser.write(bytes([TRIGGER_BYTE]))

            # --- Step 2: Wait for 4 bytes (LSB first) ---
            received = bytearray()
            start_time = time.time()
            timeout = 10  # seconds

            while len(received) < 4:
                if ser.in_waiting:
                    data = ser.read(ser.in_waiting)
                    received.extend(data)

                if time.time() - start_time > timeout:
                    if len(received) > 0:
                        print(f"Timeout: partial data received ({len(received)} bytes), discarding.")
                        received.clear()
                    else:
                        print("No response from SoC, still waiting...")
                    start_time = time.time()  # Restart timeout
                time.sleep(0.01)

            # --- Step 3: Display the received 4 bytes ---
            result = (received[3] << 24) | (received[2] << 16) | (received[1] << 8) | received[0]
            print(f"Received 4 bytes: {received.hex().upper()} => Value: {result} (0x{result:08X})\n")

            # Optional small delay before sending next trigger
            time.sleep(0.5)

    except Exception as e:
        print(f"Error: {e}")
    finally:
        if 'ser' in locals() and ser.is_open:
            ser.close()
            print("Closed serial port.")

if __name__ == "__main__":
    send_trigger_and_receive_result()
