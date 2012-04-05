#!/usr/bin/env python2

import fileinput, glob, string, sys, os, re, fnmatch

# Build up a list of all export macros to replace.
patterns =  [ re.compile("VTK_[A-Z]*_EXPORT"),
              re.compile("VTK_GENERIC_FILTERING_EXPORT"),
              re.compile("QVTK_EXPORT") ]

excludes = [ "GUISupport/Qt/QVTKWin32Header.h",
             "Common/Core/vtkWin32Header.h",
             "Common/Core/vtkSystemIncludes.h",
             "Common/Core/vtkABI.h"]

def searchReplace(path, replace, headerName):
  files = glob.glob(path + "/*.h*")
  if files is not []:
    for file in files:

      if os.path.isfile(file) and (file not in excludes):
        firstInclude = True
        lines = []
        exportUpdated = False
        with open(file, 'r') as fp:
            lines = fp.readlines()

        for index, line in enumerate(lines):
          for pattern in patterns:
            lineNumber = pattern.search(line)
            if (lineNumber >= 0 and line.find("VTK_INFORMATION_EXPORT") < 0):
              line = pattern.sub(replace, line)
              lines[index] = line.rstrip() + "\n"
              exportUpdated = True
              break

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

print modules

# exclude non-VTK modules from export headers
modules = [m for m in modules if not m.startswith(('ThirdParty','Utilities'))]

for module in modules:
  moduleName = "vtk" + module.replace("/", "")
  exportName = moduleName.upper() + "_EXPORT"
  print moduleName + " " + exportName
  searchReplace(module, exportName, moduleName + "Module.h")

#searchReplace("Common/Core", searchText, replaceText)
