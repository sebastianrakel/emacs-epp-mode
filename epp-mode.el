;;; epp-mode.el --- minor mode for OpenVox/Puppet epp (.epp) template files

;; Copyright (C) 2025 Sebastian Rakel

;; Author: Sebastian Rakel <sebastian@devunit.eu>
;; URL: https://github.com/sebastianrakel/emacs-epp-mode
;; Version: 0
;; Keywords: languages

;;; Commentary:
;;
;; This is an Emacs package with a minor mode for editing OpenVox/Puppet epp (.epp)
;; template files.
;;
;; Forked from https://github.com/petere/emacs-eruby-mode

;;; Code:

(defgroup epp-mode nil
  "Mode for epp template files"
  :group 'languages)

(defgroup epp-mode-faces nil
  "Faces for highlighting epp template files"
  :prefix "epp-mode-"
  :group 'epp-mode-
  :group 'faces)

(defface epp-standard-face
  '((t (:inherit font-lock-string-face)))
  "Face used to highlight epp template snippets"
  :group 'epp-mode-faces)

(defface epp-comment-face
  '((t (:inherit font-lock-comment-face)))
  "Face used to highlight epp template snippets"
  :group 'epp-mode-faces)

(defface epp-preprocessor-face
  '((t (:inherit font-lock-preprocessor-face)))
  "Face used to highlight epp template snippets"
  :group 'epp-mode-faces)

(defvar epp-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map "%" 'epp-mode-electric-percent)
    map)
  "Keymap for epp mode.")

(defun epp-mode-electric-percent ()
  "Called when % is pressed."
  (interactive)
  (if (and electric-pair-mode
           (equal (char-before) ?<))
      (progn
        (insert "% %>")
        (backward-char 3))
    (insert "%")))

(defvar epp-mode-font-lock-keywords
  '(("<%.*?%>" . '(0 'epp-standard-face t))
    ("<%=.*?%>" . '(0 'epp-comment-face t))
    ("<%[-=]\\s-*|\\(\\(?:.\\|\n\\)*?\\)|\\s-*[-=]?%>" . '(0 'epp-preprocessor-face t))))

;;;###autoload
(define-minor-mode epp-mode
  "Minor mode for epp templates"
  :lighter "EPP"
  :keymap epp-mode-map
  (if epp-mode
      (font-lock-add-keywords nil epp-mode-font-lock-keywords)
    (font-lock-remove-keywords nil epp-mode-font-lock-keywords)))

;;;###autoload
(defconst epp-mode-file-regexp "\\.epp\\'")

;;;###autoload
(add-to-list 'auto-mode-alist `(,epp-mode-file-regexp ignore t))

;;;###autoload
(defun epp-mode-auto-mode ()
  "Turn on epp mode for appropriate file extensions."
  (when buffer-file-name
    (when (string-match epp-mode-file-regexp buffer-file-name)
      (epp-mode 1))))

;;;###autoload
(add-hook 'find-file-hook #'epp-mode-auto-mode)

(provide 'epp-mode)
;;; epp-mode.el ends here
