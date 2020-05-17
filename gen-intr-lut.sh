#!/usr/bin/env bash
# Generate a lookup table function for interrupts of all supported chips
set -e

echo     "// Autogenerated.  Do not edit."
echo     "pub fn lookup_vector(chip: &str, intr: &str) -> Option<usize> {"
echo     "    match chip {"

for intr_path in "$@"; do
    chip="$(basename "$(dirname "$intr_path")")"
    echo "        \"$chip\" => match intr {"

    sed '/=> Ok(Interrupt::.\+),$/!d
    s/ \+\(.\+\) => Ok(Interrupt::\(.\+\)),$/            "\2" => Some(\1),/' "$intr_path"

    echo "            _ => None,"
    echo "        },"
done

echo     "        _ => None,"
echo     "    }"
echo     "}"
