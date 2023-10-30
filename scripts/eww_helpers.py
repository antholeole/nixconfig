from argparse import ArgumentParser
from dataclasses import asdict, dataclass
import json
import subprocess
from typing import List


@dataclass
class Program:
    index: int
    id: int
    volume: int
    name: str

VOLUME_INDEX_EWW_VAR = "volIndex"

parser = ArgumentParser()

parser.add_argument("action")

parser.add_argument("--eww", required = True)
parser.add_argument("--pactl", required = True)

args = parser.parse_args()

sh = lambda pgm: subprocess.check_output(pgm.split(' ')).decode('utf-8')

def get_programs() -> List[Program]:
    lines = sh(f"{args.pactl} list sink-inputs").splitlines()

    programs = []
    for line in lines:
        if "Sink Input" in line:
            programs.append({
                "id": int(line.split("#")[-1]),
                "index": len(programs)
            })
        elif "application.name" in line:
            programs[-1]["name"] = line.split("\"")[-2]
        elif "Volume" in line:
            programs[-1]["volume"] = int(line.split("/")[1].replace("%", "").strip())

    return map(lambda program: Program(**program), programs)


curr_vol_index = sh(f"{args.eww} get {VOLUME_INDEX_EWW_VAR}")
programs = get_programs()

if args.action == "list": 
    print(json.dumps(list(map(asdict, programs))))
