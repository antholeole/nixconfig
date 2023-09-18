import os
import re
import argparse
import tempfile
import subprocess

NEW_FILE_NAME = "NEW"
NOTES_PATH = "~/Notes"
INLINE_LINK_RE = re.compile(r'\[([^\]]+)\]\(([^)]+)\)')
class bcolors:
    FAIL = '\033[91m'
    OKGREEN = '\033[92m'
    ENDC = '\033[0m'

parser = argparse.ArgumentParser()

tools = ["gum", "kakoune"]
for tool in tools:
    parser.add_argument(f"--{tool}", required=True, type=str)
args = parser.parse_args()

linked_paths = {}
for root, dirs, files in os.walk(os.path.expanduser(NOTES_PATH)):
  for file in files:
    file = os.path.join(root, file)
    current_path = os.path.dirname(file)
    linked_paths[file] = True

    with open(file, "r") as f:
        file_content = f.read()

        matches = re.findall(INLINE_LINK_RE, file_content)
        links = list(map(
           lambda match: os.path.join(current_path, match[1]), matches
        ))

        for link in links:
           linked_paths[link] = os.path.exists(link)

def generate_temp_file():
  with tempfile.NamedTemporaryFile(mode='w', delete=False) as f:
    for (full_path, exists) in linked_paths.items():
      path = os.sep.join(full_path.split(os.sep)[4:])
      if not exists:
        f.write(f"{bcolors.FAIL}{path}{bcolors.ENDC}\n")
      else:
         f.write(f"{path}\n")
    f.write(f"{bcolors.OKGREEN}{NEW_FILE_NAME}{bcolors.ENDC}")
    return f.name
options = generate_temp_file()

result_bytes = subprocess.check_output(f"cat {options} | {args.gum} filter", shell=True)
result = result_bytes.decode('utf-8')

if result.strip() == NEW_FILE_NAME:
   new_file = subprocess.check_output([args.gum, "input", "--placeholder", "Enter the new file name (include path, include .md)"])
   result = new_file.decode('utf-8')

result = os.path.expanduser(os.path.join(NOTES_PATH, result))
os.makedirs(os.path.dirname(result), exist_ok=True)
os.system(f"touch {result}")
os.system(f"{args.kakoune} {result}")




