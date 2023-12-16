
import re

def hasCamelCase(line: str):
    keyWordsToSearch = ['func', 'var', 'const']
    words = line.split(" ")
    for i in range(len(words)):
        if words[i] in keyWordsToSearch:
            if re.search(r"[a-z][A-Z]", words[i+1]) is not None:
                return True
    return False

maxIndent = 3
def hasDeepIndentaion(line: str):
    return line.startswith("\t" * maxIndent)

def usesAutoType(line: str):
    hasAutoType = re.search(r":=", line) is not None
    hasNoType = any([keyWord in line for keyWord in ["var", "const"]]) and re.search(r":", line) is None
    return hasAutoType or hasNoType

checks = {
    "camelCase": hasCamelCase,
    "deepIndent": hasDeepIndentaion,
    "no explicit type": usesAutoType
}

def checkCodeStyle(lines: list[str], filePath: str):
    print("Checking file: " + filePath)
    numberOfIssues = 0
    for lineNumber in range(len(lines)):
        line = lines[lineNumber]
        for checkName in checks:
            if checks[checkName](line):
                print("Found " + checkName + ":")
                print("\tFilepath: " + filePath)
                print("\tLine: " + str(lineNumber))
                print("\t" + line.strip())
                print("")
                numberOfIssues += 1

    return numberOfIssues
