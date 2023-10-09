from argparse import ArgumentParser
import json
import subprocess
from typing import List

CHOICES = [
    "inputs"
]

parser = ArgumentParser()

parser.add_argument("device_type", choices = CHOICES)
parser.add_argument("--pw-cli", required = True)

args = parser.parse_args()

if args.device_type == "inputs":


