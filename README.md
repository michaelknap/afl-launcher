# afl-launcher

The afl-launcher script automates the setup and execution of multiple AFL (American Fuzzy Lop) instances. It utilizes `afl-cmin` to minimize the corpus before launching fuzzing campaign and employs various power schedule options to maximize coverage. This script is designed for personal use and launches each instance in a `gnome-terminal` tab. Please modify it as necessary to fit your own setup.

## Quick Start
- Ensure you have afl/afl++ installed.
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

## Important
This script will attempt to use all available CPUs.