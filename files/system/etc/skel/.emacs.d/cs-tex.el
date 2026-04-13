;; cs-tex.el -*- lexical-binding: t; -*-

(defconst cs-tex--prettify-extra-alist
  (mapcar (lambda (e)
            (cons (car e)
                  (decode-char 'ucs (cdr e))))
          '(("^" . #x02C6)
  	    ("_" . #x02CD)
  	    ("\\div" . #x00F7)
  	    ("\\lor" . #x2228)
  	    ("\\land" . #x2227)
  	    ("\\circ" . #x2218)
  	    ("\\bigodot" . #x2A00)
  	    ("\\bigsqcup" . #x2A06)
  	    ("\\bigoplus" . #x2A01)
  	    ("\\biguplus" . #x2A04)
  	    ("\\bigotimes" . #x2A02)
  	    ("\\leftsquigarrow" . #x21DC)
  	    ("\\rightsquigarrow" . #x21DD)
  	    ("\\mathrm{i}" . #x2148)
  	    ("\\mathbb{A}" . #x1D538)
  	    ("\\mathbb{B}" . #x1D539)
  	    ("\\mathbb{C}" . #x2102)
  	    ("\\mathbb{D}" . #x1D53B)
  	    ("\\mathbb{E}" . #x1D53C)
  	    ("\\mathbb{F}" . #x1D53D)
  	    ("\\mathbb{G}" . #x1D53E)
  	    ("\\mathbb{H}" . #x210D)
  	    ("\\mathbb{I}" . #x1D540)
  	    ("\\mathbb{J}" . #x1D541)
  	    ("\\mathbb{K}" . #x1D542)
  	    ("\\mathbb{L}" . #x1D543)
  	    ("\\mathbb{M}" . #x1D544)
  	    ("\\mathbb{N}" . #x2115)
  	    ("\\mathbb{O}" . #x1D546)
  	    ("\\mathbb{P}" . #x2119)
  	    ("\\mathbb{Q}" . #x211A)
  	    ("\\mathbb{R}" . #x211D)
  	    ("\\mathbb{S}" . #x1D54A)
  	    ("\\mathbb{T}" . #x1D54B)
  	    ("\\mathbb{U}" . #x1D54C)
  	    ("\\mathbb{V}" . #x1D54D)
  	    ("\\mathbb{W}" . #x1D54E)
  	    ("\\mathbb{X}" . #x1D54F)
  	    ("\\mathbb{Y}" . #x1D550)
  	    ("\\mathbb{Z}" . #x2124)
  	    ("\\mathscr{A}" . #x1D49C)
  	    ("\\mathscr{B}" . #x212C)
  	    ("\\mathscr{C}" . #x1D49E)
  	    ("\\mathscr{D}" . #x1D49F)
  	    ("\\mathscr{E}" . #x2130)
  	    ("\\mathscr{F}" . #x2131)
  	    ("\\mathscr{G}" . #x1D4A2)
  	    ("\\mathscr{H}" . #x210B)
  	    ("\\mathscr{I}" . #x2110)
  	    ("\\mathscr{J}" . #x1D4A5)
  	    ("\\mathscr{K}" . #x1D4A6)
  	    ("\\mathscr{L}" . #x2112)
  	    ("\\mathscr{M}" . #x2133)
  	    ("\\mathscr{N}" . #x1D4A9)
  	    ("\\mathscr{O}" . #x1D4AA)
  	    ("\\mathscr{P}" . #x1D4AB)
  	    ("\\mathscr{Q}" . #x1D4AC)
  	    ("\\mathscr{R}" . #x211B)
  	    ("\\mathscr{S}" . #x1D4AE)
  	    ("\\mathscr{T}" . #x1D4AF)
  	    ("\\mathscr{U}" . #x1D4B0)
  	    ("\\mathscr{V}" . #x1D4B1)
  	    ("\\mathscr{W}" . #x1D4B2)
  	    ("\\mathscr{X}" . #x1D4B3)
  	    ("\\mathscr{Y}" . #x1D4B4)
  	    ("\\mathscr{Z}" . #x1D4B5)))
  "Extra symbols for LaTeX math.")

(defun cs-tex--prettify-extra ()
  (setq-local prettify-symbols-alist
              (cl-union cs-tex--prettify-extra-alist
                        prettify-symbols-alist
                        :test (lambda (x y)
  				(equal (car x) (car y)))))
  (setq prettify-symbols-unprettify-at-point 'right-edge)
  (prettify-symbols-mode 1)
  (font-lock-flush)
  (font-lock-ensure))
(add-hook 'TeX-update-style-hook #'cs-tex--prettify-extra)

(use-package tex
  :straight auctex
  :defer t
  :hook
  ((LaTeX-mode . visual-line-mode)
   (LaTeX-mode . TeX-source-correlate-mode)
   (LaTeX-mode . cs-tex--prettify-extra))
  :custom
  ;; AUCTeX general
  (TeX-auto-save t)
  (TeX-parse-self t)
  (TeX-save-query nil)

  ;; SyncTeX activation
  (TeX-source-correlate-method 'synctex)
  (TeX-source-correlate-start-server t)

  ;; Engine & default command
  (TeX-engine 'default)
  (TeX-command-default "LaTeX")

  ;; PDF Viewer
  ;; Zathura
  (TeX-view-program-selection '((output-pdf "Zathura")))
  (TeX-view-program-list
   '(("Zathura"
      ("zathura --synctex-forward %n:1:%b -x \"emacsclient --no-wait +%{line} %{input}\" %o"))))
  ;; ;; PDF-tools
  ;; (TeX-view-program-selection '((output-pdf "PDF Tools")))
  ;; (TeX-view-program-list
  ;;  '(("PDF Tools" TeX-pdf-tools-sync-view)))
  
  ;; ;; Extra compiler flags
  ;; (TeX-command-extra-options
  ;;  "-shell-escape -file-line-error -interaction=nonstopmode -synctex=1")

  :config
  (setq TeX-command-list
        (remove (assoc "LaTeX" TeX-command-list)
                TeX-command-list))
  (add-to-list 'TeX-command-list
               '("LaTeX"
                 ;; "latexmk -xelatex %(-PDF)%S %(mode) %t"
		 "latexmk -xelatex -interaction=nonstopmode -synctex=1 -shell-escape %t"
                 TeX-run-TeX nil t
                 :help "Run LatexMk"))

  )

(setq completion-ignored-extensions
      '(".aux" ".bcf" ".bbl" ".blg" ".brf"
        ".dvi" ".fdb_latexmk" ".fls"
        ".lof" ".log" ".lot"
        ".nav" ".out" ".pdfsync" ".run.xml"
        ".snm" ".synctex(busy)" ".synctex.gz"
        ".toc" ".vrb" ".xdv" ".asy" ".pre"))

(provide 'cs-tex)
