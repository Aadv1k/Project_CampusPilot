import re

std_div_match_pattern = re.compile(r"\b\d{1,2}[a-zA-Z]\b") 
std_div_extract_pattern = re.compile(r"(\d{1,2}|[a-zA-Z])")

def is_std_div_valid(std_div: str) -> bool:
    return std_div_match_pattern.match(std_div) is not None

def extract_std_div_from_str(std_div: str) -> tuple[str, str]:
    matches = std_div_extract_pattern.findall(std_div)
    assert len(matches) == 2
    
    return matches[0], matches[1]