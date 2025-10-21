import json
import pathlib
import re

def _read_text(path: pathlib.Path) -> str:
    try:
        return path.read_text(encoding="utf-8")
    except UnicodeDecodeError:
        return path.read_text(encoding="gbk")


def extract_strings(path: pathlib.Path) -> list[str]:
    text = _read_text(path)
    pattern = re.compile(r"'([^'\\\\]*(?:\\\\.[^'\\\\]*)*)'")
    strings: set[str] = set()
    for match in pattern.finditer(text):
        raw = match.group(1)
        value = bytes(raw, "utf-8").decode("unicode_escape") if "\\" in raw else raw
        if any(ord(ch) > 127 for ch in value):
            strings.add(value)
    pattern_double = re.compile(r"\"([^\"\\\\]*(?:\\\\.[^\"\\\\]*)*)\"")
    for match in pattern_double.finditer(text):
        raw = match.group(1)
        value = bytes(raw, "utf-8").decode("unicode_escape") if "\\" in raw else raw
        if any(ord(ch) > 127 for ch in value):
            strings.add(value)
    return sorted(strings)


def main() -> None:
    base = pathlib.Path("lib/screens/home_screen.dart")
    if not base.exists():
        raise SystemExit("file not found")
    strings = extract_strings(base)
    printable = [s.encode("unicode_escape").decode() for s in strings]
    print(json.dumps(printable, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
