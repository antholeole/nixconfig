import os
import subprocess
from argparse import Namespace, ArgumentParser
from typing import Callable

EWW = f"eww --config {os.path.dirname(os.path.realpath(__file__))}/.."
sh = lambda pgm: subprocess.check_output(pgm.split(' ')).decode('utf-8')

def bound_index(
        var_name: str, 
        curr_idx: int, 
        programs_len: int,
        offset: int = 0
    ) -> int:
    set_idx = lambda new_idx: sh(f"eww update {var_name}={new_idx}")

    new_idx = curr_idx + offset
    new_idx = max(0, min(programs_len - 1, new_idx))

    set_idx(new_idx)

def amount_arg(parser: ArgumentParser) -> Callable[[Namespace], int]:
    # idk how to do it but this is only for inc / dec action
    parser.add_argument("--amount", required = False, type=int)

    return lambda args: args.amount


def eww_arg(parser: ArgumentParser) -> Callable[[Namespace], str]:
    parser.add_argument("--eww", required = False, type=str, default="eww")

    return lambda args: args.eww
