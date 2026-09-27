# latex-application-template

LaTeX template for job applications — cover letter and CV.

## Structure

```
application-LaTeX/
├── tex/                        # LaTeX templates and shared components
│   ├── cv.tex                  # German CV source (also cv-en.tex)
│   ├── cover-letter.tex        # German cover letter (also cover-letter-en.tex)
│   ├── ability-sheet.tex       # German skills profile (also ability-sheet-en.tex)
│   ├── header.tex              # CV header (name, title, photo)
│   ├── sidebar.tex             # cover letter sidebar
│   └── footer.tex              # shared footer
├── gen/                        # generated PDFs (gitignored)
├── companies/                  # local JSON files per application (gitignored)
│   └── .gitkeep
├── img/                        # profile photo
├── personal-data.json          # your personal info (name, contact, photo)
├── personal-data-template.json # copy this to get started
└── build.sh
```

## Setup

Copy the template and fill in your details:

```bash
cp personal-data-template.json personal-data.json
```

## Usage

```bash
# Cover letter only (uses personal-data.json by default)
./build.sh --json=companies/example.json

# Cover letter + CV
./build.sh --json=companies/example.json --cv

# English cover letter + CV
./build.sh --json=companies/example.json --cv --lang=en

# Custom output name
./build.sh --json=companies/example.json --output=my-application

# Different personal data file
./build.sh --json=companies/example.json --personal=other-person.json
```

Generated PDFs are written to:

- `gen/cover-letter/cover-letter-<slug>.pdf`
- `gen/cover-letter/cover-letter-en-<slug>.pdf` when using `--lang=en`
- `gen/cv/cv.pdf` or `gen/cv/cv-en.pdf` when using `--cv`
- `gen/ability-sheet/ability-sheet.pdf` or `ability-sheet-en.pdf` when using `--abilities`

The slug is the JSON filename or the value passed via `--output`.

## Adding a new application

Create a local JSON file in `companies/`. Company JSON files are ignored by Git so application specific data stays local.

```json
{
  "company": "Acme Corp",
  "job_title": "Backend Developer",
  "salutation": "Dear Hiring Team,",
  "content": "Your letter text here.\n\n\\vspace{0.4cm}\n\nSecond paragraph."
}
```

Content is raw LaTeX — use `\\vspace{0.4cm}` between paragraphs. The `--lang` option only selects the LaTeX template, so create separate JSON files when the letter content itself needs another language.

## Personal data

Edit `personal-data.json` to update your name, contact info, and photo path:

```json
{
  "name":    "Your Name",
  "title":   "Your Job Title",
  "phone":   "+49 000 0000000",
  "email":   "you@example.com",
  "address": "Street 1, 12345 City",
  "github":  "github.com/yourhandle",
  "web":     "yourwebsite.com",
  "photo":   "../img/profile.png"
}
```
