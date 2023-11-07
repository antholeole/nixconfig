from argparse import ArgumentParser
from dataclasses import asdict, dataclass
import json
from shared import EWW, amount_arg, sh, eww_arg
from typing import List


@dataclass
class Program:
    index: int
    id: int
    volume: int
    name: str

VOLUME_INDEX_EWW_VAR = "volIndex"

parser = ArgumentParser()

get_amount_arg = amount_arg(parser)
get_eww = eww_arg(parser)

parser.add_argument("action")

args = parser.parse_args()
eww = get_eww(args)


def get_programs() -> List[Program]:
    inputs = json.loads(sh(f"pactl --format=json list sink-inputs"))
    programs = []
    for idx, input in enumerate(inputs):
        programs.append(Program(
            index=idx,
            id=input['index'],
            volume=int(input['volume']['front-left']['value_percent'].replace("%", "")),
            name=input['properties']['node.name']
        ))
    return programs



curr_vol_index = int(sh(f"{eww} get {VOLUME_INDEX_EWW_VAR}"))
programs = get_programs()

def bound_vol_index(offset: int = 0):
    set_vol_index = lambda new_idx: sh(f"{eww} update {VOLUME_INDEX_EWW_VAR}={new_idx}")

    new_idx = curr_vol_index + offset
    new_idx = max(0, min(len(programs) - 1, new_idx))

    set_vol_index(new_idx)

def inc_volume(mult):
    program = programs[curr_vol_index]
    new_vol = (mult * get_amount_arg(args)) + program.volume

    sh(f"pactl set-sink-input-volume {program.id} {new_vol}%")



if args.action == "list":
    bound_vol_index()
    print(json.dumps(list(map(asdict, programs))))
elif args.action == "idx_inc": 
    bound_vol_index(offset = 1)
elif args.action == "idx_dec":
    bound_vol_index(offset = -1)
elif args.action == "vol_inc":
    inc_volume(1)
elif args.action == "vol_dec":
    inc_volume(-1)
