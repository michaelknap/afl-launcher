# afl-launcher

The afl-launcher script automates the setup and execution of multiple AFL (American Fuzzy Lop) instances. It utilizes `afl-cmin` to minimize the corpus before launching the fuzzing campaign and employs various power schedule options to maximize coverage. This script is designed for personal use and launches each instance in a separate `screen` session. Modify it as necessary to fit your own setup.

## Quick Start
- Ensure you have afl/afl++ installed.
- `screen` must be installed to manage multiple sessions. Install `screen` using your package manager, for example:
  ```bash
  sudo apt-get install screen  # Ubuntu/Debian
  ```
- Prepare your input directory with seed files for fuzzing.
- Set up your fuzzing binary that AFL will use.

Run the script with the path to your binary as an argument:
```bash
./start.sh /path/to/your/fuzzing/binary [path/to/seeds/dir] [path/to/output/dir]
```

# Parameters:
- The first argument is mandatory and must be the path to the fuzzing binary.
- The second argument (optional) is the path to the directory containing seed files. If not specified, a default (seeds) will be used.
- The third argument (optional) specifies the output directory where results should be stored. If omitted, a default (output) directory will be used.

# Important Notes
This script will attempt to use all available CPUs, minus one to keep the system responsive.
Each fuzzing instance is launched in a separate screen session.

## Managing Screen Sessions
To reattach to any session, use `screen -r session_name` (eg. `screen -r afl-master`).
To detach from any screen session, press `Ctrl-A followed by D`. This will keep the session running in the background.

## Closing All Screen Sessions
If you need to close all screen sessions started by the script, you can run the following command:
```bash
pkill screen
```
