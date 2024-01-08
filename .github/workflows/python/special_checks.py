
from log_feedback import log

def cleanLine(line: str):
    charsToRemove = ["\n", "\t", ":"]
    for char in charsToRemove:
        line = line.replace(char, "")
    return line

def findVariableNamesAndLineNumbers(lines: list[str]):
    variableNames = []
    for lineNumber in range(len(lines)):
        line = cleanLine(lines[lineNumber])
        words = line.split(" ")
        if "var" in words:
            variableName = words[words.index("var")+1]
            variableNames.append((variableName, lineNumber))
        if "const" in words:
            variableName = words[words.index("const")+1]
            variableNames.append((variableName, lineNumber))
    return variableNames

def isNotUsed(varAndLineNumber: list[tuple], lines: list[str]):
    for lineNumber in range(len(lines)):
        line = cleanLine(lines[lineNumber])
        words = line.split(" ")
        if any([varAndLineNumber[0] == w] for w in words) and lineNumber != varAndLineNumber[1]:
            return False
    return True

def lineNumber(variableName: str, lines: list[str]):
    for line in lines:
        if variableName in line:
            return lines.index(line)

def line(variableName: str, lines: list[str]):
    for line in lines:
        if variableName in line:
            return line

def hasUnusedVariable(lines: list[str], filePath: str):
    unusedVariables = 0
    varAndLineNumber: list[tuple] = findVariableNamesAndLineNumbers(lines)
    if len(varAndLineNumber) == 0:
        return unusedVariables
    for varAndLine in varAndLineNumber:
        if isNotUsed(varAndLine, lines):
            log("Unused variable", filePath, varAndLine[1], line(varAndLine[0], lines))
            unusedVariables += 1
    return unusedVariables