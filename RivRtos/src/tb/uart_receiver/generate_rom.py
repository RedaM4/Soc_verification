import sys

def generate_rom(rom_hex_file, rom_sv_file, depth=128):
    with open(rom_hex_file, 'r') as f:
        lines = f.readlines()
    values = []
    for line in lines:
        line = line.strip()
        if not line:
            continue
        if line.lower().startswith("0x"):
            line = line[2:]
        hex_val = line.zfill(8)
        values.append(hex_val)
    while len(values) < depth:
        values.append("00000000")
    with open(rom_sv_file, 'w') as f:
        f.write("module rom (\n")
        f.write("    input logic [11:0] addr, \n")
        f.write("    output logic [31:0] inst\n")
        f.write(");\n\n")
        f.write("   logic [31:0] rom [0:" + str(depth - 1) + "];\n\n")
        for i in range(depth):
            f.write("         assign rom[" + str(i) + "]    = 32'h" + values[i] + ";\n")
        f.write("\n    assign inst = rom[addr >> 2];\n")
        f.write("endmodule\n")

if __name__ == "__main__":
    generate_rom("machine.hex", "../../soc/core/rom.sv")
