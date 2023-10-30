from argparse import ArgumentParser
import json
import subprocess
from typing import List

parser = ArgumentParser()

parser.add_argument("transform")
parser.add_argument("widget")

parser.add_argument("--eww", required = True)
parser.add_argument("--all", action="store_true", default=False)

args = parser.parse_args()

# pipe to tee to force json
def get_monitor_letters() -> List[str]:
    monitors = json.loads(
        subprocess.check_output("swaymsg -t get_outputs | tee".split())
    )

    return [chr(97 + idx) for idx, monitor in enumerate(monitors) if monitor['focused'] or args.all]


for monitor_letter in get_monitor_letters():
    cmd = f"{args.eww} {args.transform} {args.widget}-{monitor_letter}"
    try:
        subprocess.check_call(
            cmd.split()
        )
    except: 
        print(f"got an error processing '{cmd}'. continuing")
