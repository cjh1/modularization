#!/usr/bin/env python2

import fileinput, glob, string, sys, os, re

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

modules = ["Common/Core", "Common/DataModel", "Common/Transforms", \
  "Common/Math", "Common/ComputationalGeometry", "Common/Misc", \
  "Common/System", "Common/Transforms"]

modules += ["Filters/Core", "Filters/Extraction", "Filters/General", "Filters/Geometry", \
  "Filters/ParallelStatistics", "Filters/Sources", "Filters/Statistics"]
modules += ["IO/Core", "IO/Geometry", "IO/Image", "IO/Infovis", "IO/NetCDF", \
  "IO/SQL", "IO/XML"]

modules += ["Parallel/Core"]
modules += ["Infovis/Core"]
modules += ["Imaging/Core"]
modules += ["Rendering/Core", "Rendering/OpenGL"]

for module in modules:
  moduleName = "vtk" + module.replace("/", "")
  exportName = moduleName.upper() + "_EXPORT"
  searchReplace(module, searchText, exportName, moduleName + "Export.h")

#searchReplace("Common/Core", searchText, replaceText)