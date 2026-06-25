#!/usr/bin/env bash

# SketchyBar plugin to display current Apple Music lyrics
# Fetches synchronized lyrics from LRCLIB.net API
# Dynamically adjusts update frequency based on BPM
# Shows prev (subtle) | current (text) | next (subtle)

source "$CONFIG_DIR/colors.sh"

CACHE_DIR="/tmp/sketchybar_lyrics"
mkdir -p "$CACHE_DIR"

# Get current track info from Apple Music including BPM
get_current_track() {
    osascript <<EOF
if application "Music" is running then
    tell application "Music"
        if player state is playing then
            set trackName to name of current track
            set artistName to artist of current track
            set trackPosition to player position
            set trackBPM to bpm of current track
            return trackName & "|" & artistName & "|" & trackPosition & "|" & trackBPM
        else
            return ""
        end if
    end tell
else
    return ""
end if
EOF
}

# Calculate optimal update frequency based on BPM
# Returns update interval in seconds
calculate_update_freq() {
    local bpm="$1"

    # Default to 1 second if no BPM data
    if [ -z "$bpm" ] || [ "$bpm" = "0" ] || [ "$bpm" = "missing value" ]; then
        echo "1"
        return
    fi

    # For high BPM songs (>140), update more frequently (0.5s)
    # For medium BPM (80-140), update every 0.75s
    # For slow songs (<80), update every 1s
    if (( $(echo "$bpm > 140" | bc -l) )); then
        echo "0.5"
    elif (( $(echo "$bpm >= 80" | bc -l) )); then
        echo "0.75"
    else
        echo "1"
    fi
}

# Fetch lyrics from LRCLIB API
fetch_lyrics() {
    local track="$1"
    local artist="$2"
    local cache_file="$CACHE_DIR/$(echo -n "${artist}_${track}" | md5).json"

    # Check cache first (lyrics for current song)
    if [ -f "$cache_file" ]; then
        cat "$cache_file"
        return
    fi

    # URL encode parameters
    local encoded_track=$(echo -n "$track" | jq -sRr @uri)
    local encoded_artist=$(echo -n "$artist" | jq -sRr @uri)

    # Fetch from LRCLIB API
    local response=$(curl -s -A "SketchyBar-Lyrics/1.0" \
        "https://lrclib.net/api/get?track_name=${encoded_track}&artist_name=${encoded_artist}")

    # Cache the response
    echo "$response" > "$cache_file"
    echo "$response"
}

# Parse LRC format and get prev/current/next lines based on playback position
# Returns: previous|current|next
get_lyric_lines() {
    local lyrics="$1"
    local position="$2"  # Position in seconds

    # Convert position to milliseconds for comparison
    local pos_ms=$(echo "$position * 1000" | bc | cut -d. -f1)

    # Arrays to store all lyric lines with timestamps
    declare -a times=()
    declare -a texts=()

    # Parse all LRC lines
    while IFS= read -r line; do
        if [[ $line =~ ^\[([0-9]{2}):([0-9]{2})\.([0-9]{2})\](.*) ]]; then
            local minutes="${BASH_REMATCH[1]}"
            local seconds="${BASH_REMATCH[2]}"
            local centiseconds="${BASH_REMATCH[3]}"
            local lyric_text="${BASH_REMATCH[4]}"

            # Convert to milliseconds
            local line_time=$((10#$minutes * 60000 + 10#$seconds * 1000 + 10#$centiseconds * 10))

            times+=("$line_time")
            texts+=("$lyric_text")
        fi
    done <<< "$lyrics"

    # Find current line index
    local current_idx=-1
    local current_time=0

    for i in "${!times[@]}"; do
        if [ "${times[$i]}" -le "$pos_ms" ]; then
            if [ "${times[$i]}" -ge "$current_time" ]; then
                current_time="${times[$i]}"
                current_idx=$i
            fi
        fi
    done

    # Get prev, current, next
    local prev_line=""
    local current_line=""
    local next_line=""

    if [ $current_idx -ge 0 ]; then
        current_line="${texts[$current_idx]}"

        # Get previous line if it exists
        if [ $current_idx -gt 0 ]; then
            prev_line="${texts[$((current_idx - 1))]}"
        fi

        # Get next line if it exists
        if [ $current_idx -lt $((${#texts[@]} - 1)) ]; then
            next_line="${texts[$((current_idx + 1))]}"
        fi
    fi

    echo "${prev_line}|${current_line}|${next_line}"
}

# Main execution
track_info=$(get_current_track)

if [ -z "$track_info" ]; then
    # Music not playing - hide all lyrics items
    sketchybar --set lyrics.prev label="" 2>/dev/null
    sketchybar --set lyrics.current label="" 2>/dev/null
    sketchybar --set lyrics.next label="" 2>/dev/null
    sketchybar --set "$NAME" label="" icon="" 2>/dev/null
    exit 0
fi

# Parse track info (now includes BPM)
IFS='|' read -r track artist position bpm <<< "$track_info"

# Calculate and set optimal update frequency based on BPM
update_freq=$(calculate_update_freq "$bpm")
sketchybar --set "$NAME" update_freq="$update_freq"

# Fetch lyrics
lyrics_data=$(fetch_lyrics "$track" "$artist")

# Check if we have synced lyrics
synced_lyrics=$(echo "$lyrics_data" | jq -r '.syncedLyrics // empty')

if [ -n "$synced_lyrics" ] && [ "$synced_lyrics" != "null" ]; then
    # Get prev/current/next lines based on playback position
    lyric_lines=$(get_lyric_lines "$synced_lyrics" "$position")
    IFS='|' read -r prev_line current_line next_line <<< "$lyric_lines"

    # Check if we actually have meaningful lyrics (not empty/whitespace only)
    # Some songs return lyrics data but with empty lines
    if [ -n "$current_line" ] && [ -n "$(echo "$current_line" | tr -d '[:space:]')" ]; then
        # Trim lines to reasonable lengths
        prev_trimmed="${prev_line:0:25}"
        current_trimmed="${current_line:0:60}"
        next_trimmed="${next_line:0:25}"

        # Update three separate items with different colors
        # Subtle for prev/next, bright text for the current line

        # Previous line
        sketchybar --set lyrics.prev label="$prev_trimmed" label.color=$SUBTLE

        # Current line (highlighted)
        sketchybar --set lyrics.current label="$current_trimmed" label.color=$TEXT

        # Next line
        sketchybar --set lyrics.next label="$next_trimmed" label.color=$SUBTLE

        # Icon on main item
        sketchybar --set "$NAME" icon="♪" label=""
    else
        # No meaningful lyrics (empty or whitespace only), show track info
        sketchybar --set "$NAME" icon="♪" label="$track - $artist"
        sketchybar --set lyrics.prev label="" 2>/dev/null
        sketchybar --set lyrics.current label="" 2>/dev/null
        sketchybar --set lyrics.next label="" 2>/dev/null
    fi
else
    # No synced lyrics available, show track info
    sketchybar --set "$NAME" icon="♪" label="$track - $artist"
    sketchybar --set lyrics.prev label="" 2>/dev/null
    sketchybar --set lyrics.current label="" 2>/dev/null
    sketchybar --set lyrics.next label="" 2>/dev/null
fi
