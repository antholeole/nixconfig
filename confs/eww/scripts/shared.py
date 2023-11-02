import os
import subprocess

EWW = f"eww --config {os.path.dirname(os.path.realpath(__file__))}/.."
sh = lambda pgm: subprocess.check_output(pgm.split(' ')).decode('utf-8')
