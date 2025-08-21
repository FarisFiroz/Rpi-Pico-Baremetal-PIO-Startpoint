import json
from pathlib import Path

path = Path("build_garbage/program1.json")
with open("build_garbage/program1.json", "r") as f:
    data = json.load(f)

instructions_list_dicts = data["programs"][0]["instructions"]

final_output = ""
for i, item in enumerate(instructions_list_dicts):
    instruction_hex = next(iter(item.values()))
    prefix = ".hword 0x"
    if i > 0:
        final_output += "\n"
    final_output += (prefix + instruction_hex)

print("program name: " + data["programs"][0]["name"])
with open("build_garbage/" + data["programs"][0]["name"] + ".s", 'w') as f:
    f.write(final_output)
