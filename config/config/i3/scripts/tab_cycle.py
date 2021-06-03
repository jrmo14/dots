#!/usr/bin/env python3
from i3ipc import Connection

# Lil util to flatten 2d list
flatten = lambda t: [item for sublist in t for item in sublist]

i3 = Connection()

visible_workspaces = list(filter(lambda ws: ws.visible, i3.get_workspaces()))
focused_workspace = list(filter(lambda ws: ws.focused, visible_workspaces))[0]
named_workspace = i3.get_tree().find_named(focused_workspace.name)
workspace_index = list(map(lambda ws: ws.name, named_workspace)).index(focused_workspace.name)

floating_windows = list(filter(lambda window: window.floating == 'user_on', named_workspace[workspace_index].leaves()))
floating_index = list(map(lambda win: win.focused, floating_windows)).index(True)

next_win = floating_windows[(floating_index + 1) % len(floating_windows)]
next_win.command('focus')
