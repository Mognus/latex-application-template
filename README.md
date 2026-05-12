# latex-application-template

LaTeX template for job applications — cover letter and CV.

## Structure

```
application-LaTeX/
├── tex/                  # shared components
│   ├── data.tex          # personal information
│   ├── header.tex        # CV header (name, title, photo)
│   ├── sidebar.tex       # cover letter sidebar
│   └── footer.tex        # shared footer
├── cv/
│   ├── cv.tex            # CV source
│   └── cv.pdf            # generated (gitignored)
├── cover-letter/
│   ├── cover-letter.tex  # cover letter source
│   └── cover-letter-<company>.pdf
├── companies/            # one JSON per application
│   └── example.json
├── img/                  # profile photo
├── log/                  # compiler logs (gitignored)
├── build.sh
└── cheatsheet.md
```

## Usage

```bash
# Cover letter only
./build.sh --json companies/example.json

# Cover letter + CV
./build.sh --json companies/example.json --cv
```

The output PDF is named after the JSON file: `cover-letter-example.pdf`.

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

Edit `tex/data.tex` to update your name, contact info, and photo.
