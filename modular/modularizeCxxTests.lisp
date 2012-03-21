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
:in root+relative-path = '/home/test/foo/bar/can'
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

;; ;; -------------------------------------------------------extract-titan-headers
;; (defparameter TITAN-LIB-ROOT "/home/nikhil/modules/titan/Titan/Libraries/")
;; (defparameter TITAN-LIB-CMakeLists.txt (gather-files-recursively TITAN-LIB-ROOT "CMakeLists.txt"))
;; (defparameter TITAN-LIB-DIRS
;;   (mapcar #'(lambda (x)
;;               (namestring (extract-relative-path TITAN-LIB-ROOT x)))
;;           TITAN-LIB-CMAKELISTS.TXT))
;; (defparameter CXX-PATTERN "*.cxx")
;; (defparameter TITAN-LIB-HEADER-FILES-LIST (gather-files-from-list TITAN-LIB-CMakeLists.txt
;;                                                                   HEADER-PATTERN
;;                                                                   #'namestring))
;; (defparameter TITAN-LIB-CXX-FILES-LIST (gather-files-from-list TITAN-LIB-CMakeLists.txt
;;                                                                CXX-PATTERN
;;                                                                #'namestring))


;; ;; -------------------------------------------------------------------headers-per-dir
;; (defparameter VTK_INCLUDE (ppcre:create-scanner
;;                            "(//)*.*#\\s*include\\s*[<\"](vtk.*)[>\"]"))

;; (defun get-include (str)
;;   " Given a string get the included file from #include <file.h>"
;;   (register-groups-bind (first second) (VTK_INCLUDE str :sharedp t)
;;     (progn
;;       (if (not first)
;;         second
;;         nil))))

;; (defun extract-includes-from-file (file)
;;   (let ((collection nil))
;;     (with-open-file (stream file)
;;       (loop
;;          for line = (read-line stream nil 'foo)
;;          until (eq line 'foo)
;;          do (progn
;;               (let ((value (get-include line)))
;;               (when value
;;                 (push value collection))))))
;;     (reverse collection)))

;; (defun extract-includes-from-file-list(file-list)
;;   (mapcar #'extract-includes-from-file file-list))

;; (defun extract-includes-from-list-of-file-list(list-of-file-list)
;;   (mapcar #'extract-includes-from-file-list list-of-file-list))

;; (defun extract-nonduplicate-headers (list-of-list-of-headers)
;;   (mapcar #'(lambda (x)
;;               (remove-duplicates (reduce #'append x) :test #'string=))
;;           list-of-list-of-headers))

;; (defparameter TITAN-LIB-CXX-INCLUDES-PER-DIR
;;   (extract-nonduplicate-headers
;;    (extract-includes-from-list-of-file-list TITAN-LIB-CXX-FILES-LIST)))

;; (defparameter TITAN-LIB-HEADER-INCLUDES-PER-DIR
;;   (extract-nonduplicate-headers
;;    (extract-includes-from-list-of-file-list TITAN-LIB-HEADER-FILES-LIST)))

;; (defparameter TITAN-LIB-INCLUDES-PER-DIR
;;   (mapcar #'remove-duplicates
;;           (mapcar #'append
;;                   TITAN-LIB-CXX-INCLUDES-PER-DIR
;;                   TITAN-LIB-HEADER-INCLUDES-PER-DIR)
;;           :test #'string=))

;; (defun extract-modules (list-of-lists)
;;   (mapcar #'(lambda (x)
;;               (remove-duplicates (sort x #'string<) :test #'string=))
;;           (mapcar #'(lambda (x)
;;                       (mapcar #'vtk-get-module x))
;;                   list-of-lists)))

;; (defun extract-headers-no-modules (list-of-lists)
;;   (mapcar #'(lambda (x)
;;               (remove-duplicates (sort x #'string<) :test #'string=))
;;           (mapcar #'(lambda (x)
;;                       (mapcar #'(lambda (y)
;;                                   (let ((val (vtk-get-module y)))
;;                                     (if val
;;                                         nil
;;                                         y)))
;;                               x))
;;                   list-of-lists)))

;; (defparameter TITAN-VTK-MODULES
;;   (extract-modules TITAN-LIB-INCLUDES-PER-DIR))

;; (defparameter TITAN-VTK-LEFTOVERS
;;   (extract-headers-no-modules TITAN-LIB-INCLUDES-PER-DIR))


;; ;; (mapcar #'(lambda (file) (with-open-file (stream file)
;; ;;                            (loop
;; ;;                               for line = (read-line stream nil 'foo)
;; ;;                               until (eq line 'foo)
;; ;;                               do (format t "~a~%" line)))) (first TITAN-LIB-CXX-FILES-LIST))

;; (defparameter *titan-module-list* 
;;   (mapcar #'(lambda (x y z) (list :directory x :modules y :leftover z)) 
;;           TITAN-LIB-DIRS 
;;           TITAN-VTK-MODULES
;;           TITAN-VTK-LEFTOVERS))

;; (defparameter *titan-print-list* 
;;   (mapcar #'(lambda (x y z) (list x y z))
;;           TITAN-LIB-DIRS 
;;           TITAN-VTK-MODULES
;;           TITAN-VTK-LEFTOVERS))

;; (defun dump-into(file)
;;   (let ((*print-pretty* nil))
;;     (with-open-file (stream file
;;                             :direction :output
;;                             :if-exists :supersede )
;;       (dolist (cd *titan-print-list*)
;;         (format stream "~:_~{~s~^:~}~%" cd)))))

;; (defun dump(lst)
;;   (dolist (cd lst)
;;     (format t "~{~a:~10t~a~%~}~%" cd)))
