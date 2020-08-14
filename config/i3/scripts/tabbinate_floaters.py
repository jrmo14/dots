#!/usr/bin/env python3
from i3ipc import Connection

i3  = Connection()
focused_window = list(filter(lambda w: w.focused, i3.get_workspaces()))[0].name
named_windows = i3.get_tree().find_named(focused_window)
window_index = list(map(lambda x: x.name, named_windows)).index(focused_window)
floating_leaves = list(filter(lambda l: l.floating == 'user_on', named_windows[window_index].leaves()))
floating_index = list(map(lambda x: x.focused, floating_leaves)).index(True)
next_con = floating_leaves[(floating_index + 1) % len(floating_leaves)]
next_con.command('focus')
