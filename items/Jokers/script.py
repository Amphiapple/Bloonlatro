from pathlib import Path
import re

folder = Path(__file__).parent
excluded = {"legendary.lua", "other.lua", "atlas.lua"}

def get_path_tier(x):
    if x == 0:
        return 0, 0

    return (x - 1) // 5 + 1, (x - 1) % 5 + 1

for file in folder.glob("*.lua"):
    if file.name.lower() in excluded:
        continue

    text = file.read_text(encoding="utf-8")

    def update(match):
        block = match.group(0)
        pos = re.search(r"pos\s*=\s*\{\s*x\s*=\s*(\d+)", block)
        if not pos:
            return block

        x = int(pos.group(1))
        path, tier = get_path_tier(x)

        pattern = r"(tower_info\s*=\s*\{[^}]*?)(\s*\},?)"
        replacement = rf"\1, path = {path}, tier = {tier}\2"

        return re.sub(pattern, replacement, block, count=1)

    updated = re.sub(
        r"SMODS\.Joker\s*\{.*?(?=\nSMODS\.Joker\s*\{|\Z)",
        update,
        text,
        flags=re.S,
    )

    file.write_text(updated, encoding="utf-8")
    print(f"Updated {file.name}")