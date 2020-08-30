from subprocess import run
from itertools import takewhile
import sys

args = ' '.join(takewhile(lambda x: x != '-m', sys.argv))
cmd = f"sshpass -p 'alarm' ssh 10.0.0.6 -t \"bash -i -c '/home/alarm/.espressif/python_env/idf4.3_py3.8_env/bin/python {args}'\""

run(cmd, shell=True)
