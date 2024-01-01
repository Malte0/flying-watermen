
def log(checkName: str, filePath: str, lineNumber: int, line: str):
    print("Found " + checkName + ":")
    print("      Filepath: " + filePath.replace("game/", ""))
    print("      Line: " + str(lineNumber+1))
    print("      " + line.strip())
    print("")