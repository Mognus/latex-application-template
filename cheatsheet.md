# LaTeX Cheatsheet

## Dokumentstruktur

```latex
\documentclass[a4paper, 12pt]{article}
% Präambel: Pakete & Einstellungen

\begin{document}
  % Inhalt hier
\end{document}
```

`article` · `report` · `letter` — häufige Dokumenttypen  
Optionen: `10pt` / `11pt` / `12pt`, `a4paper`, `twocolumn`

---

## Wichtige Pakete

| Paket | Zweck |
|---|---|
| `geometry` | Seitenränder: `[top=2cm, left=2.5cm, ...]` |
| `babel` | Sprache: `[ngerman]` |
| `inputenc` | UTF-8 Input: `[utf8]` |
| `fontenc` | Schrift-Encoding: `[T1]` |
| `graphicx` | Bilder einbinden |
| `hyperref` | Klickbare Links + PDF-Metadaten |
| `enumitem` | Listen anpassen |
| `xcolor` | Farben: `\textcolor{red}{Text}` |
| `multicol` | Mehrspaltenlayout |

---

## Textformatierung

```latex
\textbf{fett}
\textit{kursiv}
\underline{unterstrichen}
\texttt{monospace}

% Größen (von klein nach groß):
\tiny  \small  \normalsize  \large  \Large  \LARGE  \huge  \Huge
```

Sonderzeichen müssen escaped werden: `\& \% \$ \# \_ \{ \}`

---

## Abstände & Ausrichtung

```latex
\vspace{1cm}      % vertikaler Abstand
\hspace{1cm}      % horizontaler Abstand
\hfill            % füllt bis zum rechten Rand
\vfill            % füllt bis zum Seitenende
\noindent         % keine Einrückung
\\                % Zeilenumbruch (nur innerhalb von Absätzen/Tabellen)
\\[0.5cm]         % Zeilenumbruch + extra Abstand
\newpage          % neue Seite
```

Leerzeile im Code = neuer Absatz.

---

## Listen

```latex
\begin{itemize}         % Aufzählung
  \item Erster Punkt
  \item Zweiter Punkt
\end{itemize}

\begin{enumerate}       % Nummerierte Liste
  \item Erster
  \item Zweiter
\end{enumerate}

\begin{description}     % Begriffsliste
  \item[Begriff] Erklärung
\end{description}
```

Mit `enumitem` Abstände anpassen:
```latex
\setlist{noitemsep, topsep=2pt, leftmargin=1em}
```

---

## Tabellen

```latex
\begin{tabular}{l c r}        % l=links, c=mitte, r=rechts
  Spalte 1 & Spalte 2 & Spalte 3 \\
  \hline
  A        & B        & C \\
\end{tabular}
```

- `|` zwischen Spaltentypen → vertikale Linie
- `@{}` → kein automatischer Abstand an der Seite
- `\hline` → horizontale Linie

---

## Bilder

```latex
\usepackage{graphicx}

\includegraphics[width=5cm]{bild.jpg}
\includegraphics[width=0.8\linewidth]{bild.png}
\includegraphics[scale=0.5]{bild.pdf}
```

---

## Eigene Befehle (`\newcommand`)

```latex
% Variable (kein Argument):
\newcommand{\MeinName}{Magnus Eschrich}
% Aufruf: \MeinName

% Mit einem Argument:
\newcommand{\fett}[1]{\textbf{#1}}
% Aufruf: \fett{Text}

% Mit zwei Argumenten:
\newcommand{\cvjob}[2]{\textbf{#1} \hfill \textit{#2}}
% Aufruf: \cvjob{Firma}{2023-2025}
```

---

## Nützliche Umgebungen

```latex
% Nebeneinander (zwei Spalten manuell):
\begin{minipage}[t]{0.48\linewidth}
  Linker Inhalt
\end{minipage}
\hfill
\begin{minipage}[t]{0.48\linewidth}
  Rechter Inhalt
\end{minipage}

% Mehrspaltenlayout (braucht multicol):
\begin{multicols}{3}
  Inhalt wird automatisch auf 3 Spalten verteilt
\end{multicols}

% Zentriert:
\begin{center}
  Zentrierter Text oder Bild
\end{center}
```

`[t]` bei minipage = oben ausrichten (top), `[b]` = unten (bottom), `[c]` = mitte

---

## Mathe

```latex
% Inline (im Fließtext):
$a^2 + b^2 = c^2$

% Block (eigene Zeile, zentriert):
\[ E = mc^2 \]

% Hoch- und tiefgestellt:
x^{2}    x_{i}    x^{2}_{i}

% Bruch und Wurzel:
\frac{Zähler}{Nenner}    \sqrt{x}    \sqrt[3]{x}

% Griechische Buchstaben:
\alpha  \beta  \gamma  \delta  \pi  \sigma  \omega
```

---

## Kompilieren

```bash
# Einmal kompilieren:
pdflatex datei.tex

# Mit eigenem Ausgabeverzeichnis:
pdflatex -output-directory=gen datei.tex

# 2x für Inhaltsverzeichnis / Querverweise:
pdflatex datei.tex && pdflatex datei.tex
```

Erzeugte Dateien:
- `.pdf` — das Ergebnis
- `.log` — Compiler-Log (Fehler stehen hier drin)
- `.aux` — Hilfsdaten für Querverweise
- `.toc` — Inhaltsverzeichnis-Daten

---

## Häufige Fehler

| Fehler | Ursache |
|---|---|
| `! LaTeX Error: File 'xyz.sty' not found` | Paket nicht installiert |
| `! Undefined control sequence` | Tippfehler im Befehl, oder Paket fehlt |
| `! Missing $ inserted` | Mathe-Symbol außerhalb von `$...$` |
| `Overfull \hbox` | Text zu breit für die Zeile (kein Fehler, nur Warnung) |
| `Unknown option 'ngerman'` | `texlive-langgerman` fehlt |
