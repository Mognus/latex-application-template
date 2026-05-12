# LaTeX Cheatsheet

## Document structure

```latex
\documentclass[a4paper, 12pt]{article}
% Preamble: packages & settings

\begin{document}
  % content here
\end{document}
```

Common document classes: `article` · `report` · `letter`  
Options: `10pt` / `11pt` / `12pt`, `a4paper`, `twocolumn`

---

## Useful packages

| Package | Purpose |
|---|---|
| `geometry` | Page margins: `[top=2cm, left=2.5cm, ...]` |
| `babel` | Language: `[ngerman]` / `[english]` |
| `inputenc` | UTF-8 input: `[utf8]` |
| `fontenc` | Font encoding: `[T1]` |
| `graphicx` | Include images |
| `hyperref` | Clickable links + PDF metadata |
| `enumitem` | Customize lists |
| `xcolor` | Colors: `\textcolor{red}{text}` |
| `fancyhdr` | Custom header/footer |

---

## Text formatting

```latex
\textbf{bold}
\textit{italic}
\underline{underlined}
\texttt{monospace}

% Sizes (small to large):
\tiny  \small  \normalsize  \large  \Large  \LARGE  \huge  \Huge
```

Special characters must be escaped: `\& \% \$ \# \_ \{ \}`

---

## Spacing & alignment

```latex
\vspace{1cm}      % vertical space
\hspace{1cm}      % horizontal space
\hfill            % push content to the right
\vfill            % push content to the bottom
\noindent         % suppress indentation
\\                % line break (inside paragraphs/tables)
\\[0.5cm]         % line break + extra space
\newpage          % new page
```

A blank line in source = new paragraph.

---

## Lists

```latex
\begin{itemize}         % bullet list
  \item First
  \item Second
\end{itemize}

\begin{enumerate}       % numbered list
  \item First
  \item Second
\end{enumerate}

\begin{description}     % definition list
  \item[Term] Explanation
\end{description}
```

Adjust spacing with `enumitem`:
```latex
\setlist{noitemsep, topsep=2pt, leftmargin=1em}
```

---

## Tables

```latex
\begin{tabular}{l c r}        % l=left, c=center, r=right
  Col 1 & Col 2 & Col 3 \\
  \hline
  A     & B     & C \\
\end{tabular}
```

- `|` between column types → vertical line
- `@{}` → remove automatic side padding
- `\hline` → horizontal line

---

## Images

```latex
\usepackage{graphicx}

\includegraphics[width=5cm]{image.jpg}
\includegraphics[width=0.8\linewidth]{image.png}
\includegraphics[scale=0.5]{image.pdf}
```

---

## Custom commands (`\newcommand`)

```latex
% Variable (no argument):
\newcommand{\MyName}{Magnus Eschrich}
% Usage: \MyName

% With one argument:
\newcommand{\bold}[1]{\textbf{#1}}
% Usage: \bold{text}

% With two arguments:
\newcommand{\cvjob}[2]{\textbf{#1} \hfill \textit{#2}}
% Usage: \cvjob{Company}{2023--2025}
```

---

## Useful environments

```latex
% Side by side (manual two columns):
\begin{minipage}[t]{0.48\linewidth}
  Left content
\end{minipage}
\hfill
\begin{minipage}[t]{0.48\linewidth}
  Right content
\end{minipage}

% Centered:
\begin{center}
  Centered text or image
\end{center}
```

`[t]` on minipage = align top, `[b]` = bottom, `[c]` = center

---

## Math

```latex
% Inline:
$a^2 + b^2 = c^2$

% Block (centered on its own line):
\[ E = mc^2 \]

% Superscript and subscript:
x^{2}    x_{i}    x^{2}_{i}

% Fraction and square root:
\frac{numerator}{denominator}    \sqrt{x}    \sqrt[3]{x}

% Greek letters:
\alpha  \beta  \gamma  \delta  \pi  \sigma  \omega
```

---

## Compiling

```bash
# Single pass:
pdflatex file.tex

# With custom output directory:
pdflatex -output-directory=out file.tex

# Two passes (for table of contents / cross-references):
pdflatex file.tex && pdflatex file.tex
```

Generated files:
- `.pdf` — the result
- `.log` — compiler log (errors are here)
- `.aux` — auxiliary data for cross-references
- `.toc` — table of contents data

---

## Common errors

| Error | Cause |
|---|---|
| `! LaTeX Error: File 'xyz.sty' not found` | Package not installed |
| `! Undefined control sequence` | Typo in command, or missing package |
| `! Missing $ inserted` | Math symbol used outside `$...$` |
| `Overfull \hbox` | Text too wide for the line (warning only) |
| `Unknown option 'ngerman'` | `texlive-langgerman` not installed |
