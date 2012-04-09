(require 'cl)

(global-set-key [(control h)] 'delete-backward-char)

;;; --------------------------------------------------------------------------

(setf mac-command-key-is-meta nil)

(setq debug-on-error t)

;;; --------------------------------------------------------------------------
;;; Disallow annoying startup message
;;; --------------------------------------------------------------------------

(setq inhibit-startup-message t)

;;; --------------------------------------------------------------------------
;;; My location for external packages.
;;; --------------------------------------------------------------------------

(add-to-list 'load-path (expand-file-name "~/.emacs.d/site-lisp"))


;;; --------------------------------------------------------------------------
;;; Font Lock mode is a minor mode, always local to a particular
;;; buffer, which highlights (or 'fontifies') the buffer contents
;;; according to the syntax of the text you are editing. It can
;;; recognize comments and strings in most languages; in several
;;; languages, it can also recognize and properly highlight various
;;; other important constructs - for example, names of functions being
;;; defined or reserved keywords. Some special modes, such as Occur
;;; mode and Info mode, have completely specialized ways of assigning
;;; fonts for Font Lock mode.
;;; --------------------------------------------------------------------------

(global-font-lock-mode t)

;;; --------------------------------------------------------------------------
;;; useful stuff
;;; --------------------------------------------------------------------------

(setq column-number-mode t)
(setq line-number-mode t)

(setq default-major-mode 'text-mode)
(add-hook 'text-mode-hook 'turn-on-auto-fill)

;;; --------------------------------------------------------------------------
;;; Use spaces for tabs. REQUIRED!
;;; --------------------------------------------------------------------------

(setq-default indent-tabs-mode nil)

;;; --------------------------------------------------------------------------
;;; turn off backups for files under version control
;;; --------------------------------------------------------------------------

(setq vc-make-backup-files nil)

;;; --------------------------------------------------------------------------
;;; turn off backups for files - dangerous!!!!
;;; --------------------------------------------------------------------------
;(setq make-backup-files nil)

;;; --------------------------------------------------------------------------
;;; put the backup files in a central location - safer!!!
;;; --------------------------------------------------------------------------

(setq backup-directory-alist '(("." . "~/.emacs-backups"))) 

;;; --------------------------------------------------------------------------
;;; stop forcing to spell out "yes"
;;; --------------------------------------------------------------------------

(fset 'yes-or-no-p 'y-or-n-p) 

;;; --------------------------------------------------------------------------
;;; fred like previous command in the shell mode
;;; --------------------------------------------------------------------------

(add-hook
 'shell-mode-hook
 (lambda ()
   (local-set-key [(control p)] 'comint-previous-input)))

;;; --------------------------------------------------------------------------
;;; force buffers to be opened in new windows
;;; --------------------------------------------------------------------------

;; this should be optional (as set by the actual properties)
;;(global-set-key [(control x) (b)] 'switch-to-buffer-other-window)

;;; --------------------------------------------------------------------------
;;; tramp
;;; /username@host:reote_path edit a remote file
;;;  C-x C-f /sudo::/path/to/file open a file as root
;;; --------------------------------------------------------------------------
;(require 'tramp)
;;; ---------------------------------------------------------------------------
;;; slime
;;; ---------------------------------------------------------------------------

;; (add-to-list 'load-path "/usr/local/slime")

;; (require 'slime-autoloads)
;; (require 'slime)

;; (setf lisp-indent-function 'common-lisp-indent-function)

;; (setq slime-repl-enable-presentations nil)

(defvar *lisp-program* nil)

;;;---------------------------------------------------------------------------
;;; OpenMCL
;;;---------------------------------------------------------------------------

(defun ccl ()
  (interactive)
  (setf inferior-lisp-program "/usr/local/ccl/scripts/ccl64")
  (setf *lisp-program* "openmcl")
  (slime))

(defun openmcl ()
  (interactive)
  (setf inferior-lisp-program "/usr/local/ccl/scripts/openmcl")
  (setf *lisp-program* "openmcl")
  (slime))

(defun openmcl64 ()
  (interactive)
  (setf inferior-lisp-program "/usr/local/ccl/scripts/openmcl64")
  (setf *lisp-program* "openmcl")
  (slime))

;;;---------------------------------------------------------------------------
;;; allegro
;;;---------------------------------------------------------------------------

(defun alisp ()
  (interactive)
  (setf inferior-lisp-program "/usr/local/acl/alisp")
  (setf *lisp-program* "allegro")
  (slime))

;;; --------------------------------------------------------------------------

(defun mlisp ()
  (interactive)
  (setf inferior-lisp-program "/usr/local/acl/mlisp")
  (setf *lisp-program* "allegro")
  (slime))

;;; --------------------------------------------------------------------------

(defun alisp64 ()
  (interactive)
  (setf inferior-lisp-program "/usr/local/acl64/alisp")
  (setf *lisp-program* "allegro")
  (slime))

;;; --------------------------------------------------------------------------

(defun mlisp64 ()
  (interactive)
  (setf inferior-lisp-program "/usr/local/acl64/mlisp")
  (setf *lisp-program* "allegro")
  (slime))


;;; --------------------------------------------------------------------------
;;; ecl
;;; --------------------------------------------------------------------------

(defun ecl ()
  (interactive)
  (setf inferior-lisp-program "/usr/local/bin/ecl")
  (setf *lisp-program* "ECL")
  (slime))

;;;---------------------------------------------------------------------------
;;; clisp
;;;---------------------------------------------------------------------------

(defun clisp ()
  (interactive)
  (setf inferior-lisp-program "/usr/local/bin/clisp -E ISO-8859-1")
  (setf *lisp-program* "clisp")
  (slime))

;;;---------------------------------------------------------------------------
;;; sbcl
;;;---------------------------------------------------------------------------

(defun sbcl ()
  (interactive)
  (setf inferior-lisp-program "/usr/local/bin/sbcl")
  (setf *lisp-program* "sbcl")
  (slime))

;;;---------------------------------------------------------------------------
;;; lispworks
;;;---------------------------------------------------------------------------

(defun lispworks ()
  (interactive)
  (shell-command "~/Library/Scripts/lw-start.app&"))


;;;---------------------------------------------------------------------------
;;; this could be cleaned up
;;;---------------------------------------------------------------------------

(add-hook 'lisp-mode-hook
          (lambda ()
            (slime-mode t)))

(add-hook 'inferior-lisp-mode-hook
          (lambda () 
            (inferior-slime-mode t)))

;;;---------------------------------------------------------------------------
;;; bind .system and .asdf to slime/lisp-modes
;;;---------------------------------------------------------------------------

(setq auto-mode-alist
      (append '(("\\.system$" . lisp-mode))
              '(("\\.asdf$" . lisp-mode))
              '(("\\.asd$" . lisp-mode))
              '(("\\.cl$" . lisp-mode))
              '(("\\.lsp$" . lisp-mode))
              '(("\\.plm$" . lisp-mode))
              auto-mode-alist))

;;;---------------------------------------------------------------------------
;;; commenting
;;;---------------------------------------------------------------------------

(global-set-key [(control c) (control c)] 'comment-region)

(global-set-key [(control c) (control x)] 'uncomment-region)


;;;---------------------------------------------------------------------------
;;; Comment line insertion.  Could use some work here
;;;---------------------------------------------------------------------------

(defun leading-comment-for-mode ()
  (let ((current-mode major-mode))
    (cond ((or (eq current-mode 'emacs-lisp-mode)
               (eq current-mode 'lisp-mode))
           ";;;")
          ((eq current-mode 'sh-mode)
           "###")
          (t "///"))))

    
;;; --------------------------------------------------------------------------

(defun insert-comment-line ()
  (interactive)
  (princ (format "%s --------------------------------------------------------------------------\n"
                 (leading-comment-for-mode)) (current-buffer)))

;;; --------------------------------------------------------------------------

(defun insert-comment-block ()
  (interactive)
  (insert-comment-line)
  (princ (format "%s " (leading-comment-for-mode)) (current-buffer))
  (save-excursion 
    (princ "\n" (current-buffer))
    (insert-comment-line)))

;;; --------------------------------------------------------------------------

(defun insert-end-of-file-comment ()
  (interactive)
  (princ (format "%s ***************************************************************************\n"
                 (leading-comment-for-mode)) (current-buffer))
  (princ (format "%s *                              End of File                                *\n"
                 (leading-comment-for-mode)) (current-buffer))

  (princ (format "%s ***************************************************************************\n"
                 (leading-comment-for-mode)) (current-buffer)))
                                   
;;; -------------------------------------------------------------------------- 
;;; c-; does not work on some terminals, so we provide an alternative 
;;; -------------------------------------------------------------------------- 

(global-set-key [(control \;)] 'insert-comment-line)

(global-set-key [(control c) (control l)] 'insert-comment-line)

;;; -------------------------------------------------------------------------- 
;;; for symmetry we provide c-c m-l 
;;; -------------------------------------------------------------------------- 

(global-set-key [(meta \;)] 'insert-comment-block)

(global-set-key [(control c) (meta l)] 'insert-comment-line)

;;; -------------------------------------------------------------------------- 
;;; again, c-; does not work on some terminals 
;;; -------------------------------------------------------------------------- 

(global-set-key [(meta control \;)] 'insert-end-of-file-comment)

(global-set-key [(control c) (meta \;)] 'insert-end-of-file-comment)

;;; --------------------------------------------------------------------------
;;; fred like previous input grabbing
;;; --------------------------------------------------------------------------
(add-hook
 'slime-mode-hook
 (lambda ()
   (local-set-key [(control p)] 'slime-repl-previous-input)))

;;; --------------------------------------------------------------------------
;;; slime interrupt
;;; --------------------------------------------------------------------------

(add-hook
 'slime-mode-hook
 (lambda ()
   (local-set-key [(control ,)] 'slime-interrupt)))

;;; --------------------------------------------------------------------------
;;; switching slime frames
;;; this can be done with slime-selector, but prefer these
;;; for information on slime selectors:
;;; http://common-lisp.net/project/slime/doc/html/slime_37.html#SEC37
;;; --------------------------------------------------------------------------

;;;---------------------------------------------------------------------------
;;; Switch to slime listener frame.  
;;;---------------------------------------------------------------------------

(defun goto-listener ()
  (interactive)
  (let ((listener (get-buffer (format "*slime-repl %s*" *lisp-program*))))
    (if listener
        (switch-to-buffer listener)
        ;; there is a bug in slime w.r.t. G5 towers
        (let ((alt-listener (get-buffer "*slime-repl nil*")))
          (if alt-listener
              (switch-to-buffer alt-listener)
              (princ "There is no listener"))))))

(global-set-key [(meta l)] 'goto-listener)

;;;---------------------------------------------------------------------------
;;; goto inferior-lisp buffer
;;;---------------------------------------------------------------------------

(defun goto-inferior-lisp ()
  (interactive)
  (let ((inferior-lisp (get-buffer "*inferior-lisp*")))
    (if inferior-lisp
        (switch-to-buffer-other-frame inferior-lisp)
        (princ "There is no *inferior-lisp*"))))

(global-set-key [(meta i)] 'goto-inferior-lisp)


;;;---------------------------------------------------------------------------
;;; goto sldb buffer
;;;---------------------------------------------------------------------------

(defun goto-sldb ()
  (interactive)
  (let ((sldb (sldb-get-default-buffer)))
    (if sldb
        (switch-to-buffer sldb)
        (princ "There is no sldb"))))

(global-set-key [(meta d)] 'goto-sldb)


;;; --------------------------------------------------------------------------
;;; symbol completion - fred style
;;; --------------------------------------------------------------------------

(add-hook
 'slime-mode-hook
 (lambda ()
  (local-set-key [(control tab)] 'slime-complete-symbol)))

(add-hook
 'lisp-mode-hook
 (lambda ()
  (local-set-key [(control tab)] 'lisp-complete-symbol)))

;;;---------------------------------------------------------------------------
;;; In fred I liked meta . and meta p to also be bound to control . and 
;;; control p 
;;;---------------------------------------------------------------------------

(add-hook
  'slime-mode-hook 
  (lambda ()
    (local-set-key [(control .)] 'slime-edit-definition)))

;; (add-hook
;;  'lisp-mode-hook
;;  (lambda ()
;;    (local-set-key [(control p)] 'slime-repl-previous-input)))

;;;---------------------------------------------------------------------------
;;; control shift defun selection
;;;---------------------------------------------------------------------------

(add-hook
 'emacs-lisp-mode-hook
 (lambda ()
   (local-set-key [(control shift left)]  'backward-sexp-mark)))

(add-hook
 'lisp-mode-hook
 (lambda ()
   (local-set-key [(control shift left)]  'backward-sexp-mark)))

(add-hook
 'slime-mode-hook
 (lambda ()
   (local-set-key [(control shift left)]  'backward-sexp-mark)))

(add-hook
 'emacs-lisp-mode-hook
 (lambda ()
   (local-set-key [(control shift right)]  'forward-sexp-mark)))

(add-hook
 'lisp-mode-hook
 (lambda ()
   (local-set-key [(control shift right)]  'forward-sexp-mark)))

(add-hook
 'slime-mode-hook
 (lambda ()
   (local-set-key [(control shift right)]  'forward-sexp-mark)))

;;; --------------------------------------------------------------------------
;;; experimental
;;; --------------------------------------------------------------------------

;(add-hook
; 'lisp-mode-hook
; (lambda ()
;   (local-set-key [(shift down)] 'set-mark-command)))


;(add-hook
; 'slime-mode-hook
; (lambda ()
;   (local-set-key [(shift down)] 'set-mark-command)))

;;;---------------------------------------------------------------------------
;;; control shift defun traversal
;;;---------------------------------------------------------------------------

(add-hook
 'emacs-lisp-mode-hook
 (lambda ()
   (local-set-key [(control left)]  'backward-sexp-nomark)))

(add-hook
 'lisp-mode-hook
 (lambda ()
   (local-set-key [(control left)]  'backward-sexp-nomark)))

(add-hook
 'slime-mode-hook
 (lambda ()
   (local-set-key [(control left)]  'backward-sexp-nomark)))

(add-hook
 'emacs-lisp-mode-hook
 (lambda ()
   (local-set-key [(control right)]  'forward-sexp-nomark)))

(add-hook
 'lisp-mode-hook
 (lambda ()
   (local-set-key [(control right)]  'forward-sexp-nomark)))

(add-hook
 'slime-mode-hook
 (lambda ()
   (local-set-key [(control right)]  'forward-sexp-nomark)))

;;;---------------------------------------------------------------------------
;;; Fred like evaluation
;;;---------------------------------------------------------------------------

(add-hook
 'emacs-lisp-mode-hook
 (lambda ()
   (local-set-key [(A e)] 'eval-last-expression)))

(add-hook
 'lisp-mode-hook
 (lambda ()
   (local-set-key [(A e)] 'eval-last-expression)))

(add-hook
 'slime-mode-hook
 (lambda ()
   (local-set-key [(A e)] 'slime-eval-last-expression)))

;;;---------------------------------------------------------------------------
;;; Dangerous!  Overides c-x c-c quit.
;;;---------------------------------------------------------------------------

;(add-hook
; 'slime-mode-hook
; (lambda ()
;   (local-set-key [(control x) (control c)] 'slime-eval-defun)))

;;;---------------------------------------------------------------------------
;;; eval-buffer
;;;---------------------------------------------------------------------------

(add-hook
 'emac-lisp-mode-hook
 (lambda ()
   (local-set-key [(shift A e)] 'eval-buffer)))

(add-hook
 'lisp-mode-hook
 (lambda ()
   (local-set-key [(shift A e)] 'eval-buffer)))

(add-hook
 'slime-mode-hook
 (lambda ()
   (local-set-key [(shift A e)] 'slime-eval-buffer)))


(add-hook
 'slime-mode-hook
 (lambda ()
   (local-set-key [(shift A c)] 'slime-compile-file)))

;;;---------------------------------------------------------------------------
;;; File headers.
;;;---------------------------------------------------------------------------

(defvar *asterisk-line*
 ";;;; **************************************************************************")

(defvar *asterisk-line-with-empty-space*
  ";;;; *                                                                        *")

;;;---------------------------------------------------------------------------

(defun evenp (number)
  (when (= 0 (mod number 2))
    t))

;;;---------------------------------------------------------------------------

(defun oddp (number)
  (not (evenp number)))

;;;---------------------------------------------------------------------------

(defvar *lab-name* "LEARN")

;;;---------------------------------------------------------------------------

(defvar *address* ";;; UA Department of Computer Science\n;;; PO Box 210077\n;;; Tucson, AZ 85721-0077\n")

;;;---------------------------------------------------------------------------

(defvar *first-paragraph*
  (format ";;; Permission to use, copy, modify and distribute this software and its\n;;; documentation is hereby granted without fee, provided that the above\n;;; copyright notice of the %s, this paragraph and the one following\n;;; appear in all copies and in supporting documentation.\n" *lab-name*))

;;;---------------------------------------------------------------------------

(defvar *second-paragraph*
  (format ";;; The %s makes no representation about the suitability of this software\n;;; for any purposes.  It is provided \"AS IS\", without express or implied\n;;; warranties including (but not limited to) all implied warranties of\n;;; merchantability and fitness for a particular purpose, and notwithstanding\n;;; any other provision contained herein.  In no event shall the %s be\n;;; liable for any special, indirect or consequential damages whatsoever\n;;; resulting from loss of use, data or profits, whether in an action of\n;;; contract,  negligence or other tortuous action, arising out of or in\n;;; connection with the use or performance of this software, even if the\n;;; %s is advised of the possiblity of such damages.\n" *lab-name* *lab-name* *lab-name*))

;;;---------------------------------------------------------------------------

(defun insert-lab-header () 
  (interactive)
  (let* ((package-name (read-from-minibuffer "package-name:  ")))
    (princ (format ";;; -**- $Id: dotemacs.el,v 1.18 2009-02-15 21:59:06 wkerr Exp $ -**-\
\n") (current-buffer))
    (princ (format "%s\n" *asterisk-line*) (current-buffer))
    (princ (format "%s\n" *asterisk-line-with-empty-space*) (current-buffer))
    (princ (format "%s\n" *asterisk-line*) (current-buffer))
    (princ (format ";;; Written by: %s\n" (user-login-name)) (current-buffer))
    (princ *address* (current-buffer))
    (princ (format-time-string ";;; Copyright (c) %Y CS Dept. UA\n" (current-time))
           (current-buffer))
    (princ (format ";;;\n") (current-buffer))
    (princ (format ";;; %s\n" *lab-name*) (current-buffer))
    (princ ";;; Professor Paul Cohen, Director.\n" (current-buffer))
    (princ ";;; All rights reserved.\n" (current-buffer))
    (princ ";;;\n" (current-buffer))
    (princ *first-paragraph* (current-buffer))
    (princ ";;;\n" (current-buffer))
    (princ *second-paragraph* (current-buffer))
    (princ ";;;" (current-buffer))
    (princ "\n" (current-buffer))
    (princ (format "%s\n" *asterisk-line*) (current-buffer))
    (princ (format "\n(in-package #:%s)\n\n" package-name) (current-buffer))
    (insert-comment-line)
    (princ (format ";;; ") (current-buffer))
    (save-excursion
      (princ (format "\n") (current-buffer))
      (insert-comment-line)
      (princ "\n\n\n\n\n" (current-buffer))
      (insert-end-of-file-comment)))
  ;;; um, I don't know what to do here.
  (unless (or (lisp-mode) (slime-mode) (emacs-lisp-mode))
    (emacs-lisp-mode)
    (lisp-mode)
    (slime-mode t)))

;;;---------------------------------------------------------------------------

(defun insert-brief-lab-header ()
  (interactive)
  (let ((package-name (read-from-minibuffer "package-name:  "))
        (file-name (read-from-minibuffer "file-name:  "))
        (user-name (read-from-minibuffer "user-name:  ")))
     ;;(princ (format ";;;; -*- Mode: Common-Lisp; Package: %s; Base: 10 -*-\n" package-name)
     ;;       (current-buffer))
     (princ (format ";;;; -**- $Id: dotemacs.el,v 1.18 2009-02-15 21:59:06 wkerr Exp $ -**-\
\n") (current-buffer))
     (princ (format "#|\n") (current-buffer))
     (princ (format "\n") (current-buffer))
     (princ (format "%s\n" file-name) (current-buffer))
     (princ (format-time-string "Copyright (c) %Y CS Dept. UA\n" (current-time))
            (current-buffer))
     (princ (format "%s\n" *lab-name*) (current-buffer))
     (princ "Professor Paul Cohen, Director.\n" (current-buffer))
     (princ "All rights reserved.\n" (current-buffer))
     (princ (format "\nAuthor: %s\n\n" user-name) (current-buffer))
     (princ (format "DISCUSSION\n\n") (current-buffer))
     (save-excursion
       (princ (format "\n\n") (current-buffer))
       (princ (format "|#\n\n(in-package #:%s)" package-name) (current-buffer)))))

;;;---------------------------------------------------------------------------
;;; key bindings for headers
;;;---------------------------------------------------------------------------

(global-set-key [(shift control meta h)] 'insert-lab-header)

(global-set-key [(control meta h)] 'insert-brief-lab-header)

;;; ***************************************************************************
;;; *                              End of File                                *
;;; ***************************************************************************
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(cua-highlight-region-shift-only t)
 '(cua-mode t nil (cua-base))
 '(ecb-auto-activate t)
 '(ecb-options-version "2.32")
 '(ecb-primary-secondary-mouse-buttons (quote mouse-1--mouse-2))
 '(ecb-source-path (quote ("/Users/wkerr/research/")))
 '(ecb-tip-of-the-day nil)
 '(mac-command-modifier nil)
 '(mac-option-modifier (quote meta))
 '(mac-print-mode t)
 '(transient-mark-mode t))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )
