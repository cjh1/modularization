#!/usr/bin/env python2

import fileinput, glob, string, sys, os, re, fnmatch

# Build up a list of all export macros to replace.

pattern = re.compile("VTK_[A-Z]*_EXPORT")
searchText = "VTK_COMMON_EXPORT"
replaceText = "VTKCOMMONCORE_EXPORT"

def searchReplace(path, search, replace, headerName):
  files = glob.glob(path + "/*.h*")
  if files is not []:
    for file in files:
      if os.path.isfile(file) and file != "Common/Core/vtkWin32Header.h" and file != "Common/Core/vtkSystemIncludes.h" and file != "Common/Core/vtkABI.h":
        firstInclude = True
        lines = []
        exportUpdated = False
        with open(file, 'r') as fp:
            lines = fp.readlines()

        for index, line in enumerate(lines):
          lineNumber = pattern.search(line)
          if lineNumber >= 0 and line.find("VTK_INFORMATION_EXPORT") < 0:
            #print "Found a line to replace: " + line
            line = pattern.sub(replace, line)
            lines[index] = line.rstrip() + "\n"
            exportUpdated = True

        if exportUpdated:
          includeLine = "#include \"" + headerName + "\" // For export macro\n"
          addExportHeaderInclude(lines, includeLine)
          with open(file, 'w') as fp:
            for line in lines:
              fp.write(line)

def addExportHeaderInclude(lines, includeLine):
  for index, line in enumerate(lines):
    pos = string.find(line, "#include")

    if pos >= 0:
      lines[index] = includeLine + line
      break

  return lines

def getModules():
  modules = []
  for root, dirnames, filenames in os.walk('.'):
    for filename in fnmatch.filter(filenames, 'module.cmake'):
      modules.append(root[2:])
  return modules

modules = getModules()

for module in modules:
  moduleName = "vtk" + module.replace("/", "")
  exportName = moduleName.upper() + "_EXPORT"
  searchReplace(module, searchText, exportName, moduleName + "Export.h")

#searchReplace("Common/Core", searchText, replaceText)
