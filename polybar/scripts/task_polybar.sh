#!/bin/bash
# Modified from https://github.com/dakuten/taskwarrior-polybar
# Looks at the most urgent task
desc=`task rc.verbose: rc.report.next.columns:description rc.report.next.labels:1 limit:1 next`
proj=`task rc.verbose: rc.report.next.columns:project rc.report.next.labels:1 limit:1 next`
id=`task rc.verbose: rc.report.next.columns:id rc.report.next.labels:1 limit:1 next`
due=`task rc.verbose: rc.report.next.columns:due.relative rc.report.next.labels:1 limit:1 next`

echo "$id" > /tmp/tw_polybar_id
output="$desc"

if [ ! -z "$proj" ]; then output="[${proj}] ${desc}"; fi
if [ ! -z "$due" ]; then output="${output} · ${due}"; fi

#echo "$desc · $due"
echo "$output"

