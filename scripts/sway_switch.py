import argparse
from collections import namedtuple
import json
import subprocess

WORKSPACES = ["",  "", ""]

def get_outputs():
    Monitor = namedtuple("Monitor", "index name focused")
    
    return [Monitor(index, output["name"], output["focused"]) for (index, output) in enumerate(
        json.loads(subprocess.check_output(["swaymsg", "-t", "get_outputs"]))
    )]

parser = argparse.ArgumentParser(
    prog="sway_switch",
    description="a helper script for sequential access to workspaces",
)

parser.add_argument("-d", "--direction", choices=["l", "r"])
parser.add_argument("-s", "--swap-monitor", action="store_true")
parser.add_argument("-t", "--take", action="store_true")

args = parser.parse_args()

if args.swap_monitor:
    outputs = get_outputs()

    focused_index = next(filter(lambda output: output.focused, outputs)).index
    desired_output = outputs[(focused_index + 1) % len(outputs)].name


    if args.take:
        subprocess.call(["swaymsg", "move", "container", "to", "output", desired_output])
    subprocess.call(["swaymsg", "focus", "output", desired_output])
    
elif args.direction:
    focused_output = next(filter(lambda output: output.focused, get_outputs())).name

    current_workspace = next(filter(
        lambda workspace: workspace['focused'], json.loads(subprocess.check_output(["swaymsg", "-t", "get_workspaces"]))
    ))['name'].split(' ')[0]

    desired_index = WORKSPACES.index(current_workspace) + (-1 if args.direction == 'l' else 1)
    
    if desired_index == len(WORKSPACES):
        desired_index = 0
    elif desired_index < 0:
        desired_index = len(WORKSPACES) - 1


    desired_workspace = f'{WORKSPACES[desired_index]} ({focused_output})'

    if args.take:
        subprocess.call(["swaymsg", "move", "container", "to", "workspace", desired_workspace])
    subprocess.call(["swaymsg", "workspace", desired_workspace])






