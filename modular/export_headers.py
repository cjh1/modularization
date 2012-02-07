#!/usr/bin/env python2

import fileinput, glob, string, sys, os, re, fnmatch

# Build up a list of all export macros to replace.

pattern = re.compile("VTK_[A-Z]*_EXPORT")
searchText = "VTK_COMMON_EXPORT"
replaceText = "VTKCOMMONCORE_EXPORT"

def searchReplace(path, search, replace, headerName):
  files = glob.glob(path + "/*.h*")
  includeLine = "#include \"" + headerName + "\" // For export macro\n"
  if files is not []:
    for file in files:
      if os.path.isfile(file) and file != "Common/Core/vtkWin32Header.h" and file != "Common/Core/vtkSystemIncludes.h" and file != "Common/Core/vtkABI.h":
        firstInclude = True
        for line in fileinput.input(file, inplace=1):
          lineNumber = -1
          lineNumber = pattern.search(line)
          if lineNumber >= 0 and line.find("VTK_INFORMATION_EXPORT") < 0:
            #print "Found a line to replace: " + line
            line = pattern.sub(replace, line)
            line = line.rstrip() + "\n"
          lineNumber = -1
          lineNumber = string.find(line, "#include")
          if lineNumber >= 0 and firstInclude == True:
            line = includeLine + line
            firstInclude = False
          sys.stdout.write(line)

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
