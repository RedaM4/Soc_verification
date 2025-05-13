import serial
import time

# Serial port configuration
serial_port = "/dev/ttyUSB1"  # Replace with your UART port (e.g., COMx on Windows)
baud_rate = 115200
parity = serial.PARITY_NONE
stopbits = serial.STOPBITS_ONE

def receive_data():
    # Total expected bytes: 512 numbers * 2 bytes each = 1024 bytes
    expected_bytes = 1024

    try:
        ser = serial.Serial(
            port=serial_port,
            baudrate=baud_rate,
            parity=parity,
            stopbits=stopbits,
            bytesize=serial.EIGHTBITS,
            timeout=5  # Wait up to 5 seconds for data
        )
        print(f"Opened serial port: {serial_port} at {baud_rate} baud.")

        # Read the expected number of bytes
        received = bytearray()
        start_time = time.time()
        while len(received) < expected_bytes and time.time() - start_time < 5:
            chunk = ser.read(expected_bytes - len(received))
            if chunk:
                received.extend(chunk)
        ser.close()

        if len(received) != expected_bytes:
            print(f"Error: Expected {expected_bytes} bytes, but received {len(received)} bytes.")
        else:
            print("Received 1024 bytes successfully.")

        # Convert every 2 bytes (little-endian) into an integer
        numbers = []
        for i in range(0, len(received), 2):
            # Little-endian conversion: lower byte + (upper byte << 8)
            num = received[i] | (received[i+1] << 8)
            numbers.append(num)

        # Display the received numbers
        print("Received numbers:")
        for num in numbers:
            print(num)

    except Exception as e:
        print(f"Error: {e}")

if __name__ == '__main__':
    receive_data()
