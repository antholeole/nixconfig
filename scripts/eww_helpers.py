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

# idk how to do it but this is only for inc / dec action
parser.add_argument("--amount", required = False)

args = parser.parse_args()

sh = lambda pgm: subprocess.check_output(pgm.split(' ')).decode('utf-8')

def get_programs() -> List[Program]:
    inputs = json.loads(sh(f"{args.pactl} --format=json list sink-inputs"))
    programs = []
    for idx, input in enumerate(inputs):
        programs.append(Program(
            index=idx,
            id=input['index'],
            volume=int(input['volume']['front-left']['value_percent'].replace("%", "")),
            name=input['properties']['node.name']
        ))
    return programs



curr_vol_index = int(sh(f"{args.eww} get {VOLUME_INDEX_EWW_VAR}"))
programs = get_programs()

def bound_vol_index(offset: int = 0):
    set_vol_index = lambda new_idx: sh(f"eww update {VOLUME_INDEX_EWW_VAR}={new_idx}")

    new_idx = curr_vol_index + offset
    new_idx = max(0, min(len(programs) - 1, new_idx))

    set_vol_index(new_idx)

def inc_volume_for(inc: int = 0):
    program = programs[curr_vol_index]
    new_vol = inc + program.volume

    sh(f"{args.pactl} set-sink-input-volume {program.id} {new_vol}%")



if args.action == "list":
    bound_vol_index()
    print(json.dumps(list(map(asdict, programs))))
elif args.action == "idx_inc": 
    bound_vol_index(offset = 1)
elif args.action == "idx_dec":
    bound_vol_index(offset = -1)
elif args.action == "s"
