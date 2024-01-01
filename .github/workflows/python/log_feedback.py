
def log(checkName: str, filePath: str, lineNumber: int, line: str):
    print("Found " + checkName + ":")
    print("\tFilepath: " + filePath.replace("game/", ""))
    print("\tLine: " + str(lineNumber+1))
    print("\t" + line.strip())
    print("")