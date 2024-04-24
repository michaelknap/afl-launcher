#!/bin/bash

# Ensure script is run with necessary parameters
if [ $# -lt 1 ]; then
    echo "Usage: $0 <path-to-harness> [input-directory] [output-directory]"
    exit 1
fi

# Configuration
HARNESS_PATH="$1"                # First parameter: Path to the harness binary
INPUT_DIR="${2:-seeds}"          # Second parameter (optional): Input directory, default to 'seeds'
OUTPUT_DIR="${3:-output}"        # Third parameter (optional): Output directory, default to 'output'
MINIMIZED_DIR="${INPUT_DIR}_minimized"

# Ensure required directories are available and input directory is not empty
mkdir -p "$INPUT_DIR" "$OUTPUT_DIR" "$MINIMIZED_DIR"
if [ ! -d "$INPUT_DIR" ] || [ -z "$(ls -A "$INPUT_DIR")" ]; then
    echo "Error: Input directory '$INPUT_DIR' is empty or does not exist."
    exit 1
fi

# Minimize the corpus with afl-cmin
echo "Minimizing corpus..."
afl-cmin -i "$INPUT_DIR" -o "$MINIMIZED_DIR" -- "$HARNESS_PATH" @@ -o /dev/null

# Dynamically determine the number of available processing units
NUM_SLAVES=$(nproc --ignore=1)  # Ignore 1 core

# Define power schedules to cycle through
declare -a POWER_SCHEDULES=("fast" "coe" "exploit" "lin" "quad" "explore" "seek" "rare" "mmopt")

# Start the master instance in a new screen session with the -D flag
echo "Starting master instance..."
screen -dmS afl-master bash -c "afl-fuzz -D -i '$MINIMIZED_DIR' -o '$OUTPUT_DIR' -M master -- '$HARNESS_PATH' @@; exec bash"

# Wait a bit to ensure the master instance initializes properly
sleep 10

# Check if the master process is still running using screen session list
if ! screen -list | grep -q "afl-master"; then
    echo "Master instance did not start properly or crashed. Check for errors."
    exit 1
fi

# Start slave instances in separate screen sessions
echo "Starting slave instances..."
for (( i=1; i<NUM_SLAVES; i++ )); do  # Start one less slave than cores to leave one core free for system tasks
    POWER=${POWER_SCHEDULES[$(( (i-1) % ${#POWER_SCHEDULES[@]} ))]}
    screen -dmS afl-slave$i bash -c "afl-fuzz -D -i '$MINIMIZED_DIR' -o '$OUTPUT_DIR' -S slave$i -p $POWER -- '$HARNESS_PATH' @@; exec bash"
done

echo "Fuzzing campaign started. Use 'screen -r afl-master' to attach to the master session or 'screen -r afl-slaveX' for slave sessions."
