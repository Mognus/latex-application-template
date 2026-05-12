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
│   ├── cv.tex                  # CV source
│   └── cv.pdf                  # generated (gitignored)
├── cover-letter/
│   ├── cover-letter.tex        # cover letter source
│   └── cover-letter-<slug>.pdf # generated (gitignored)
├── companies/                  # one JSON file per application
│   └── example.json
├── img/                        # profile photo
├── personal-data.json          # your personal info (name, contact, photo)
├── personal-data-template.json # copy this to get started
├── build.sh
└── cheatsheet.md
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

# Custom output name
./build.sh --json=companies/example.json --output=my-application

# Different personal data file
./build.sh --json=companies/example.json --personal=other-person.json
```

Output PDF is named `cover-letter-<slug>.pdf` where slug is the JSON filename (or `--output` if specified).

## Adding a new application

Create a JSON file in `companies/`:

```json
{
  "company": "Acme Corp",
  "job_title": "Backend Developer",
  "salutation": "Dear Hiring Team,",
  "content": "Your letter text here.\n\n\\vspace{0.4cm}\n\nSecond paragraph."
}
```

Content is raw LaTeX — use `\\vspace{0.4cm}` between paragraphs.

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
