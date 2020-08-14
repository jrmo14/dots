#!/usr/bin/env python3
import random
from i3ipc import Connection
import time
import sys

# TODO properly tile

i3 = Connection()

term_names = [term.name for term in i3.get_tree().find_named('floating_term*')]

args = ""

if len(sys.argv) > 1:
    args = " ".join(sys.argv[1:])
    args = f'{"-e " + args}'

if len(term_names) == 0:
    # No terminals exist
    i3.command(f'exec alacritty  --title floating_term_0 {args}')
else:
    # Find the index of the last created floating term
    term_names = sorted(term_names, key=lambda name: int(name.split('_')[-1]) if len(name.split('_')) > 2 else -1)
    term_num = int(term_names[-1].split('_')[-1])+1 if len(term_names[-1].split('_')) > 2 else 0
    # Make a new one
    i3.command(f'exec alacritty  --title floating_term_{term_num} {args}')
    # Wait for it to initialize into the tree
    time.sleep(0.1)
    print(f"TERM NUM IS {term_num}")
    term = i3.get_tree().find_named(f'floating_term_{term_num}')[-1]

    val = 150

    x_shift = random.randrange(-val, val)
    y_shift = random.randrange(-val, val)
    side = 'left' if x_shift < 0 else 'right'
    vert = 'up' if y_shift < 0 else 'down'

    x_shift = abs(x_shift)
    y_shift = abs(y_shift)

    term.command(f'move {side} {x_shift}px')
    term.command(f'move {vert} {y_shift}px')

