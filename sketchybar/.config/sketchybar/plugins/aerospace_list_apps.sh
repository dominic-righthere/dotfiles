#!/bin/bash

app_names_error="[ERROR]"
app_names_empty="[EMPTY]"

# Get the current workspace ID (if not specified)
current_workspace=$1
if [ -z "$current_workspace" ]; then
    current_workspace=$(aerospace list-workspaces --focused)
fi

# Get windows in the current workspace
windows=$(aerospace list-windows --workspace $current_workspace)

# Extract application names and sort them uniquely
if [ -n "$windows" ]; then
    current_window=$(aerospace list-windows --focused --json)
    current_app_name=$(echo "$current_window" | awk '{print $3}')
    app_names=$(echo "$windows" | awk '{print $3}' )
    # app_names=$(echo "$windows" | awk '{print $3}' | sort | uniq)


    # Display the apps
    if [ -n "$app_names" ]; then
        formatted_apps=$(echo "$app_names" | tr '\n' '|' | sed 's/|$//' | sed 's/|/ | /g')
        # sketchybar --set "$NAME" label="test1"
        sketchybar --set "$NAME" label="$formatted_apps"
    else
        sketchybar --set "$NAME" label="$app_names_error"
    fi
else
    sketchybar --set "$NAME" label="$app_names_empty"
fi
