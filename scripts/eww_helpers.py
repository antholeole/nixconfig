from argparse import ArgumentParser
import json
import subprocess

parser = ArgumentParser()

parser.add_argument("--eww", required = True)
parser.add_argument("--pactl", required = True)

args = parser.parse_args()

sh = lambda pgm: subprocess.check_output(pgm.split(' ')).decode('utf-8')

def get_programs():
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
    return programs

print(json.dumps(get_programs()))