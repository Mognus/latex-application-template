# LaTeX Applications

Bewerbungsunterlagen in LaTeX.

## Struktur

```
applications/
├── tex/            # Quelldateien
│   ├── anschreiben.tex
│   └── lebenslauf.tex
├── cover-letter/   # generierte PDFs (Anschreiben)
├── cv/             # generierte PDFs (Lebenslauf)
├── log/            # Compiler-Logs
├── build.sh        # Build-Script
├── cheatsheet.md   # LaTeX Referenz
└── README.md
```

## Bauen

```bash
./build.sh
```

Kompiliert alle `.tex`-Dateien und legt die PDFs in die jeweiligen Ordner:
- `tex/anschreiben.tex` → `cover-letter/anschreiben.pdf`
- `tex/lebenslauf.tex`  → `cv/lebenslauf.pdf`

Logs landen in `log/`.

## Neue Datei hinzufügen

1. `.tex`-Datei in `tex/` erstellen
2. In `build.sh` eine neue `compile`-Zeile ergänzen:
   ```bash
   compile "$TEX/meinedatei.tex" "$ROOT/zielordner"
   ```
