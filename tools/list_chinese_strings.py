import re
import sys
from pathlib import Path


def _decode(raw: str) -> str:
    return bytes(raw, "utf-8").decode("unicode_escape") if "\\" in raw else raw


def main() -> None:
    args = sys.argv[1:]
    raw_output = False
    target_path = "lib/screens/home_screen.dart"
    for arg in args:
        if arg == "--raw":
            raw_output = True
        else:
            target_path = arg

    path = Path(target_path)
    if not path.exists():
        raise SystemExit(f"file not found: {target_path}")

    lines = path.read_text(encoding="utf-8").splitlines()
    pattern = re.compile(r"'([^'\\]*(?:\\.[^'\\]*)*)'|\"([^\"\\]*(?:\\.[^\"\\]*)*)\"")
    found: dict[str, list[int]] = {}
    for idx, line in enumerate(lines, 1):
        for match in pattern.finditer(line):
            groups = match.groups()
            raw = next(group for group in groups if group is not None)
            value = _decode(raw)
            if any(ord(ch) > 127 for ch in value):
                found.setdefault(value, []).append(idx)

    for text, idxs in sorted(found.items()):
        line_info = ", ".join(str(i) for i in idxs)
        output_value = text if raw_output else text.encode("unicode_escape").decode()
        print(f"{output_value}: {line_info}")


if __name__ == "__main__":
    main()
