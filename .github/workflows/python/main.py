import os
from pathlib import Path
from style_checks import checkCodeStyle

# functions in dictionary:
# arguments:
# lines of the file as list[str] 
# path to the file as str
# returns:
# number of issues found as int
checksToRun = { "codeStyle": checkCodeStyle }

godotLocation = "../../../game" if "python" in os.getcwd() else "./game"
ignoreFolders = [".godot", "addons"]

def run_checks():
  numberOfIssues = 0
  for checkName in checksToRun:
    print("Running check: " + checkName)
    pathlist = Path(godotLocation).rglob('*.gd')
    for path in pathlist:
      if any([ignoreFolder in str(path) for ignoreFolder in ignoreFolders]):
        continue
      with open(path, "r") as rf:
        fileConents = rf.readlines()
        numberOfIssues += checksToRun[checkName](fileConents, str(path))
  
  print("Total issues found: " + str(numberOfIssues))
  return numberOfIssues

if __name__== "__main__":
  numberOfIssues = run_checks()
  if numberOfIssues > 0:
    exit(1)