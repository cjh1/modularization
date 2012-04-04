;;;; -*- Mode: Lisp; indent-tabs-mode: nil -*-
;;;; ==========================================================================
;;;; modularizeCxxTests.lisp --- Lisp functions used in modularizing projects dependent
;;;;                     on VTK
;;;;
;;;; Copyright (c) 2011, Nikhil Shetty <nikhil.j.shetty@gmail.com>
;;;;   All rights reserved.
;;;;
;;;; Redistribution and use in source and binary forms, with or without
;;;; modification, are permitted provided that the following conditions
;;;; are met:
;;;;
;;;;  o Redistributions of source code must retain the above copyright
;;;;    notice, this list of conditions and the following disclaimer.
;;;;  o Redistributions in binary form must reproduce the above copyright
;;;;    notice, this list of conditions and the following disclaimer in the
;;;;    documentation and/or other materials provided with the distribution.
;;;;  o Neither the name of the author nor the names of the contributors may
;;;;    be used to endorse or promote products derived from this software
;;;;    without specific prior written permission.
;;;;
;;;; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
;;;; "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
;;;; LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
;;;; A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT
;;;; OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
;;;; SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
;;;; LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
;;;; DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
;;;; THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
;;;; (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
;;;; OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
;;;; ==========================================================================

(require 'cl-ppcre)
(use-package 'ppcre)
;; (load "shelisp.lisp")

;; ;; ------------------------------------------------------------------------data
;; (defun probably-a-source-file-p (filename)
;;   (and (not (cl-fad:directory-pathname-p filename))
;;        (or (= (length (pathname-type filename)) 0)
;; 	   (not (member (pathname-type filename)
;;                         '("cxx" "h" "cmake" "txt")
;;                         :test #'string-equal)))))


;; ----------------------------------------------------------------------parser
;; This parser doesnt seem necessary now (SKIPPING)
(defun read-lines-as-list (file)
  "Make list of tokens by reading the text file"
  (with-open-file (stream file)
    (loop
       for line = (read-line stream nil 'eof)
       until (eq line 'eof)
       collect line)))

(defun concat-list-to-string (list)
  "A non-recursive function that concatenates a list of strings."
  (if (listp list)
      (with-output-to-string (s)
         (dolist (item list)
           (if (stringp item)
             (format s "~a" item))))))

;; ---------------------------------------------------------extract-module-name
(defparameter VTK_MODULE (ppcre:create-scanner "\\s*(vtk|titan)_module\\s*\\(\\s*(\\w*)\\s*"))

(defun vtk-module? (str)
  "Check if vtk_module( pattern is found"
    (if (ppcre:scan VTK_MODULE str)
        t
        nil))

(defun module-name (str)
  "Gets the vtk module name from vtk_modular(... string"
  (register-groups-bind (first second) (VTK_MODULE str :sharedp t)
    second))

;; ----------------------------------------------------------------------------
(defparameter VTK-ROOT "/home/nikhil/modules/vtk-modular/vtkmodular/")
(defparameter MODULE-FILE-PATTERN "module.cmake")

(defun gather-files-recursively(root-path pattern)
  (mapcar 'namestring
          (directory (concatenate 'string root-path "/**/" pattern))))

(defparameter MODULE-FILES-LIST (gather-files-recursively VTK-ROOT MODULE-FILE-PATTERN))

;; (defun modules (files-list)
;;   "extract the list of modules given files list"
;;   (let ((collection nil))
;;     (dolist (file files-list)
;;       (with-open-file (stream file)
;;         (loop
;;            for line = (read-line stream nil 'foo)
;;            until (eq line 'foo)
;;            do (when (vtk-module? line)
;;                   (push (module-name line) collection)))))
;;         (reverse collection)))

(defun extract-from-file(pattern-fn files-list)
  "extract the list of modules given files list"
  (let ((collection nil))
    (dolist (file files-list)
      (with-open-file (stream file)
        (loop
           for line = (read-line stream nil 'foo)
           until (eq line 'foo)
           do (let ((value (funcall pattern-fn line)))
                (when value
                  (push value collection))))))
        (reverse collection)))

(defparameter MODULE-NAMES-LIST (extract-from-file  #'module-name
                                                    MODULE-FILES-LIST))
(defparameter HEADER-PATTERN "*.h")

(defun gather-files-from-list(file-list pattern fn)
  "Extract header files from directories infered from the file-list"
  (let ((collection nil))
    (dolist (file file-list)
      (push (mapcar fn
              (directory (concatenate 'string
                                      (directory-namestring file)
                                      pattern)))
            collection))
    (reverse collection)))

(defparameter MODULE-HEADERS-LIST (gather-files-from-list MODULE-FILES-LIST
                                                          HEADER-PATTERN
                                                          #'file-namestring))

;; -------------------------------------------------------extract-relative-path
(defun remove-list (list-to-remove target-list)
  (remove-if (lambda (element)
               (member element list-to-remove
                       :test #'equal))
             target-list))

(defun extract-relative-path(root-path root+relative-path)
  "This function removes the root-path from the root+relative-path to give just
the relative path
:in root-path = '/home/test/foo'
:in root+relative-path = '/home/test/foo/bar/can/a.txt'
:out 'bar/can/a.txt' "
  (make-pathname :directory (cons :relative
                                  (remove-list
                                   (pathname-directory (pathname root-path))
                                   (pathname-directory (pathname root+relative-path))))
                 :name (pathname-name (pathname root+relative-path))
                 :type (pathname-type (pathname root+relative-path))))

(defun extract-relative-path-no-file(root-path root+relative-path)
  "This function removes the root-path from the root+relative-path to give just
the relative path
:in root-path = '/home/test/foo'
:in root+relative-path = '/home/test/foo/bar/can/a.txt'
:out 'bar/can' "
  (make-pathname :directory (cons :relative
                                  (remove-list
                                   (pathname-directory (pathname root-path))
                                   (pathname-directory (pathname root+relative-path))))))

;; --------------------------------------------------------------vtk-module-map
(defparameter *VTK-MODULE-MAP* (make-hash-table :test #'equal))

(defun vtk-set-map (header module-name)
  (setf (gethash header *VTK-MODULE-MAP*) module-name))

(defun vtk-get-module(header)
  (gethash header *VTK-MODULE-MAP*))

(defun map-headers-to-module (module-name headers-list)
  (dolist (header headers-list)
    (vtk-set-map header module-name)))

(defun make-vtk-module-map (name-list header-list)
    (mapcar #'map-headers-to-module name-list header-list))

(make-vtk-module-map MODULE-NAMES-LIST MODULE-HEADERS-LIST)

;; =============================================================================
(defparameter VTK-OLD-ROOT "/home/nikhil/modules/vtk/VTK/")
(defparameter VTK-OLD-TESTING/CXX (gather-files-recursively VTK-OLD-ROOT "/Testing/Cxx/*.cxx"))
(defparameter VTK-OLD-TESTING/H (gather-files-recursively VTK-OLD-ROOT "/Testing/Cxx/*.h"))

(defparameter VTK-OLD-FILES
  (mapcar #'(lambda (x)
              (namestring (extract-relative-path VTK-OLD-ROOT x)))
          VTK-OLD-TESTING/CXX))

;; -------------------------------------------------------------headers-per-file
(defparameter VTK_INCLUDE (ppcre:create-scanner
                           "(//)*.*#\\s*include\\s*[<\"](vtk.*)[>\"]"))

(defun get-include (str)
  " Given a string get the included file from #include <file.h>"
  (register-groups-bind (first second) (VTK_INCLUDE str :sharedp t)
    (progn
      (if (not first)
        second
        nil))))

(defun extract-includes-from-file (file)
  (let ((collection nil))
    (with-open-file (stream file :direction :input)
      (loop
         for line = (read-line stream nil 'foo)
         until (eq line 'foo)
         do (progn
              (let ((value (get-include line)))
              (when value
                (push value collection))))))
    (reverse collection)))

(defun extract-includes-from-file-list(file-list)
  (mapcar #'extract-includes-from-file file-list))

(defparameter VTK-INCLUDES-PER-TEST (extract-includes-from-file-list
                                     VTK-OLD-TESTING/CXX))

(defun extract-modules (list-of-lists)
  (mapcar #'(lambda (x)
              (remove-duplicates (sort x #'string<) :test #'string=))
          (mapcar #'(lambda (x)
                      (mapcar #'vtk-get-module x))
                  list-of-lists)))

(defun extract-headers-no-modules (list-of-lists)
  (mapcar #'(lambda (x)
              (remove-duplicates (sort x #'string<) :test #'string=))
          (mapcar #'(lambda (x)
                      (mapcar #'(lambda (y)
                                  (let ((val (vtk-get-module y)))
                                    (if val
                                        nil
                                        y)))
                              x))
                  list-of-lists)))
(defparameter VTK-TEST-MODULES (extract-modules VTK-INCLUDES-PER-TEST))
(defparameter VTK-TEST-LEFTOVERS (extract-headers-no-modules VTK-INCLUDES-PER-TEST))

(defparameter *vtk-cxx-tests-module-list* 
  (mapcar #'(lambda (x y z) (list :file x :modules y :module "" :leftover z)) 
          VTK-OLD-FILES
          VTK-TEST-MODULES
          VTK-TEST-LEFTOVERS))

(defparameter *vtk-cxx-tests-print-list* 
  (mapcar #'(lambda (x y z) (list x y "" z))
          VTK-OLD-FILES
          VTK-TEST-MODULES
          VTK-TEST-LEFTOVERS))

(defun dump-cxx-into(file)
  (let ((*print-pretty* nil))
    (with-open-file (stream file
                            :direction :output
                            :if-exists :supersede )
      (dolist (cd *vtk-cxx-tests-print-list*)
        (format stream "~:_~{~s~^:~}~%" cd)))))

(defun dump(lst)
  (dolist (cd lst)
    (format t "~{~a:~10t~a~%~}~%" cd)))

;; --------------------------------------------------------------------------tcl
(defparameter VTK-OLD-TESTING/TCL (gather-files-recursively VTK-OLD-ROOT "/Testing/Tcl/*.tcl"))

(defparameter VTK-TCL-INCLUDE (ppcre:create-scanner
                           "(#)*.*(vtk\\w*)"))

(defparameter VTK-OLD-TCL-FILES
  (mapcar #'(lambda (x)
              (namestring (extract-relative-path VTK-OLD-ROOT x)))
          VTK-OLD-TESTING/TCL))

(defun get-vtk-tcl-include (str)
  " Given a string get the included file from #include <file.h>"
  (register-groups-bind (first second) (VTK-TCL-INCLUDE str :sharedp t)
    (progn
      (if (not first)
        second
        nil))))

(defun extract-includes-from-tcl-file (file)
  (let ((collection nil))
    (with-open-file (stream file :direction :input)
      (loop
         for line = (read-line stream nil 'foo)
         until (eq line 'foo)
         do (progn
              (let ((value (get-vtk-tcl-include line)))
              (when value
                (push value collection))))))
    (reverse collection)))

(defun extract-includes-from-tcl-file-list(file-list)
  (mapcar #'extract-includes-from-tcl-file file-list))

(defparameter VTK-INCLUDES-PER-TCL-TEST (extract-includes-from-tcl-file-list
                                         VTK-OLD-TESTING/TCL))

(defun strcat.h (list)
  (mapcar (lambda (x)
            (concatenate 'string x ".h"))
          list))

(defun extract-modules-tcl (list-of-lists)
  (mapcar #'(lambda (x)
              (remove-duplicates (sort x #'string<) :test #'string=))
          (mapcar #'(lambda (x)
                      (mapcar #'vtk-get-module (strcat.h x)))
                  list-of-lists)))

(defun extract-includes-no-modules-tcl (list-of-lists)
  (mapcar #'(lambda (x)
              (remove-duplicates (sort x #'string<) :test #'string=))
          (mapcar #'(lambda (x)
                      (mapcar #'(lambda (y)
                                  (let ((val (vtk-get-module (concatenate 'string y
                                                                          ".h"))))
                                    (if val
                                        nil
                                        y)))
                              x))
                  list-of-lists)))

(defparameter VTK-TCL-TEST-MODULES (extract-modules-tcl VTK-INCLUDES-PER-TCL-TEST))
(defparameter VTK-TCL-TEST-LEFTOVERS (extract-includes-no-modules-tcl VTK-INCLUDES-PER-TCL-TEST))

(defparameter *vtk-tcl-tests-module-list* 
  (mapcar #'(lambda (x y z) (list :file x :modules y :module "" :leftover z)) 
          VTK-OLD-TCL-FILES
          VTK-TCL-TEST-MODULES
          VTK-TCL-TEST-LEFTOVERS))

(defparameter *vtk-tcl-tests-print-list* 
  (mapcar #'(lambda (x y z) (list x y "" z))
          VTK-OLD-TCL-FILES
          VTK-TCL-TEST-MODULES
          VTK-TCL-TEST-LEFTOVERS))

(defun dump-tcl-into(file)
  (let ((*print-pretty* nil))
    (with-open-file (stream file
                            :direction :output
                            :if-exists :supersede )
      (dolist (cd *vtk-tcl-tests-print-list*)
        (format stream "~:_~{~s~^:~}~%" cd)))))








