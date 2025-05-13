import serial
import time

# Configure the serial port
serial_port = "/dev/ttyUSB1"  # Replace with your UART port (e.g., COMx on Windows)
baud_rate = 115200             # Set the baud rate of your UART
parity = serial.PARITY_NONE    # No parity
stopbits = serial.STOPBITS_ONE # One stop bit

# Function to read machine instructions from the file and send them byte-by-byte
def send_machine_code(filename):
    try:
        # Open the machine.hex file to read machine instructions
        with open(filename, 'r') as file:
            lines = file.readlines()  # Read all lines

        # Open the UART port
        ser = serial.Serial(
            port=serial_port,
            baudrate=baud_rate,
            parity=parity,
            stopbits=stopbits,
            bytesize=serial.EIGHTBITS,  # 8 data bits
            timeout=1
        )
        print(f"Opened {serial_port} at {baud_rate} baud, parity: {parity}, stop bits: {stopbits}.")

        # Prepare data to send
        data_to_send = []

        # Process each line in the file
        for line in lines:
            # Remove whitespace or newlines and get the instruction in hex format
            instruction = line.strip()

            # Remove the '0x' prefix if present
            if instruction.startswith('0x'):
                instruction = instruction[2:]

            # Convert the 32-bit instruction to bytes (little-endian byte order)
            # The instruction is in the form of 8 hex digits, 4 bytes
            for i in range(6, -1, -2):  # Start from the least significant byte (LSB)
                byte = int(instruction[i:i+2], 16)
                data_to_send.append(byte)

        # If the total data is less than 512 bytes, pad with 0x00
        while len(data_to_send) < 512:
            data_to_send.append(0x00)

        # Now send all the data (should be exactly 512 bytes)
        print(f"Sending {len(data_to_send)} bytes...")

        # Send the data byte-by-byte with a 15-second delay
        for byte in data_to_send:
            ser.write(bytes([byte]))  # Send the byte
            print(f"Sent: 0x{byte:02X}")  # Display the byte being sent in hex format
            # time.sleep(4)  # Wait for 15 seconds before sending the next byte

        print("All bytes sent.")
    
    except Exception as e:
        print(f"Error during transmission: {e}")
    
    finally:
        # Close the UART port
        ser.close()
        print(f"Closed {serial_port}.")

# Call the function to send data from 'machine.hex'
send_machine_code('machine.hex')
