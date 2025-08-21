import json
from pathlib import Path

path = Path("build_garbage/program1.json")
with open("build_garbage/program1.json", "r") as f:
    data = json.load(f)

for program in data["programs"]:
    final_output = ""
    for i, item in enumerate(program["instructions"]):
        instruction_hex = next(iter(item.values()))
        prefix = ".hword 0x"
        if i > 0:
            final_output += "\n"
        final_output += (prefix + instruction_hex)
    
    print("program name: " + program["name"])
    with open("build_garbage/" + program["name"] + ".s", 'w') as f:
        f.write(final_output)
