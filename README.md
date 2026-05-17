# latex-application-template

LaTeX template for job applications — cover letter and CV.

## Structure

```
application-LaTeX/
├── tex/                        # shared LaTeX components
│   ├── header.tex              # CV header (name, title, photo)
│   ├── sidebar.tex             # cover letter sidebar
│   └── footer.tex              # shared footer
├── cv/
│   ├── cv.tex                  # German CV source
│   ├── cv-en.tex               # English CV source
│   └── gen/                    # generated CV PDFs (gitignored, .gitkeep tracked)
├── cover-letter/
│   ├── cover-letter.tex        # German cover letter source
│   ├── cover-letter-en.tex     # English cover letter source
│   └── gen/                    # generated cover letter PDFs (gitignored, .gitkeep tracked)
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

- `cover-letter/gen/cover-letter-<slug>.pdf`
- `cover-letter/gen/cover-letter-en-<slug>.pdf` when using `--lang=en`
- `cv/gen/cv.pdf` or `cv/gen/cv-en.pdf` when using `--cv`

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

Content is raw LaTeX — use `\\vspace{0.4cm}` between paragraphs.

For bilingual application data, add language-specific fields:

```json
{
  "company": "Acme Corp",
  "job_title": "Backend Developer",
  "job_title_en": "Backend Developer",
  "salutation": "Sehr geehrte Damen und Herren,",
  "salutation_en": "Dear Hiring Team,",
  "content": "German letter text.",
  "content_en": "English letter text."
}
```

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
