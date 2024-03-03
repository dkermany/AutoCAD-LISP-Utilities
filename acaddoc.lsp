(defun str->list (str delim / pos list)
  (setq pos (vl-string-search delim str)
        list '()
  )
  (while pos
    (setq list (cons (substr str 1 pos) list)
          str (substr str (+ pos (strlen delim) 1))
          pos (vl-string-search delim str)
    )
  )
  (if (/= str "") (setq list (cons str list)))
  (reverse list)
)

(defun matches-pattern (dir)
  (or (wcmatch dir "[0-9][0-9][0-9]-[0-9][0-9][0-9]*")
      (wcmatch dir "[0-9][0-9][0-9][0-9][0-9][0-9]*"))
)

(setq pdfPath "")
(defun c:PPATH ()
   ;;(command "PlotToFilePath" (getvar "DWGPREFIX"))
   ;;(princ "\nPlot path now matches Drawing path.")
   ;;(princ)
   (setq dwgPath (getvar "DWGPREFIX"))
   (princ "\ndwgPath")
   (princ dwgPath)
   (princ "\n")
   ;; Split the path into a list of directories
   (setq pathList (str->list dwgPath "\\"))
   (princ "\npathList")
   (princ pathList)
   (princ "\n")
   ;; Initialize a variable to build the root path
   (setq rootPath "")
   
   ;; Initialize found flag
   (setq found nil)
   ;; Iterate through the path list to find the project root directory
   (foreach dir pathList
     ;; Check if the directory matches the pattern (simplified check)
     (if (and (matches-pattern dir)
              (not found))
	   (progn
	      (setq found t)
	      (setq rootDir dir)
	   )
     )
     ;; Append the directory to the root path if we haven't found the project root yet
     (if (not found)
	   ;;(princ "\nNot Found t")
       (setq rootPath (strcat rootPath dir "\\"))
     )
   )

   ;; Construct the PDF path
   (setq pdfPath (strcat rootPath rootDir "\\PDF\\Check Print\\"))
   (princ "\npdfPath")
   (princ pdfPath)
   ;;(command "PlotToFilePath" pdfPath)
   pdfPath
)
(setq result (c:PPATH))
(princ "\nresult")
(princ result)
(command "PlotToFilePath" result)