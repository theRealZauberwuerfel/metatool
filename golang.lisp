(defstruct go-package
  (name (error "Specify name.") :type symbol))

(defmethod print-object ((obj go-package) stream)
  (format stream "package ~(~a~)" (go-package-name obj)))

(defmethod print-object :after ((obj go-package) stream)
  (format stream "~2%"))

(defstruct go-import
  (pkg nil :type symbol))

(defmethod print-object ((obj go-import) stream)
  (format stream "\"~(~a~)\"" (go-import-pkg obj)))

(defstruct go-imports
  (list nil :type list))
