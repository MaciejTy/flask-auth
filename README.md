# Flask Authentication Demo

A minimal Flask app demonstrating user registration, login/logout, protected routes, and protected file download. Uses Flask-Login for session management and Flask-SQLAlchemy (SQLAlchemy 2.x style) for persistence.

## Features
- User registration with salted+hashed passwords (Werkzeug `pbkdf2:sha256`)
- Login and logout with Flask-Login
- Protected pages via `@login_required`
- Protected file download (`/download`)
- Bootstrap 4 styling

## Tech Stack
- Flask 3.x
- Flask-Login 0.6.x
- Flask-SQLAlchemy 3.x (SQLAlchemy 2.0)
- Werkzeug 3.x
- SQLite (file-backed DB)

## Project Structure
```
.
├── main.py
├── requirements.txt
├── instance/
│   └── users.db              # created automatically on first run if absent
├── static/
│   └── files/cheat_sheet.pdf # protected download
└── templates/
    ├── base.html
    ├── index.html
    ├── login.html
    ├── register.html
    └── secrets.html
```

## Getting Started
1) Create and activate a virtual environment
```bash
python3 -m venv .venv
source .venv/bin/activate  # Windows: .venv\Scripts\activate
```

2) Install dependencies
```bash
pip install -r requirements.txt
```

3) (Optional) Configure environment variables
- `SECRET_KEY` (used to sign session cookies). A development default is provided, but you should set your own:
```bash
export SECRET_KEY='replace-with-a-strong-random-secret'
```

4) Run the app
```bash
python main.py
```
The app starts in debug mode at http://127.0.0.1:5000.

## Database
- SQLite database path: `instance/users.db` (Flask instance folder)
- Tables are created on first run via `db.create_all()`.
- To reset the DB (development only):
```bash
rm instance/users.db
```
Restart the app to recreate the schema.

## Key Routes
- `GET /` — Home. Shows Login/Register buttons only when logged out.
- `GET|POST /register` — Create a new account. Prevents duplicate emails.
- `GET|POST /login` — Authenticate an existing user. Displays flash messages on error.
- `GET /logout` — Log out (requires being logged in).
- `GET /secrets` — Protected page showing the current user’s name.
- `GET /download` — Protected file download (sends `static/files/cheat_sheet.pdf`).

## Security Notes
- Passwords are hashed with `pbkdf2:sha256` via Werkzeug. For production, consider Argon2 (`argon2-cffi`) or increasing PBKDF2 iterations.
- Use a strong `SECRET_KEY` in production and run behind HTTPS.
- CSRF protection is recommended for forms (e.g., Flask-WTF) but not included by default here.
- For schema changes, prefer proper migrations (Alembic) over dropping the SQLite file.

## Troubleshooting
- If you get redirected to `/login` when accessing protected routes, ensure you’re authenticated.
- If download fails, verify the file exists at `static/files/cheat_sheet.pdf`.
- If templates error on `current_user`, ensure Flask-Login is properly initialized.

## License
No license specified.


## Docker

### Build and run with Docker Compose (recommended)
```bash
docker compose build
docker compose up -d
docker compose logs -f web
```
The app will be available at http://localhost:5000.

Compose passes `SECRET_KEY` from your shell or `.env` file if present. If not set, it will use the default value from `docker-compose.yml`.

Persisted data: the SQLite database is stored in `./instance` on the host via a bind mount.

### Build and run with plain Docker
```bash
docker build -t flask-auth-app .
docker run --name flask-auth \
  -p 5000:5000 \
  -e SECRET_KEY='replace-with-a-strong-random-secret' \
  -v "$(pwd)/instance:/app/instance" \
  -d flask-auth-app
```


