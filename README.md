# dataload_test - Modern FastAPI IoT sample data loading API

This is an extremely simple HTTP REST API to practice data uploading from an embedded device, for my IoT college course.
The API and data model itself are deliberately trivial (only storing temperature and humidity measurements), the focus is more around the architecture and infrastructure.

## Tech Stack

This project boasts the most modern and opinionated tech stack you could imagine:

- **FastAPI** For building the API itself. It offers much desired validation features while staying out of the way.
- **SQLModel** As a thin wrapper around both Pydantic and SQLAlchemy so we can have a single library for data modelling at both the endpoint and database layer.
- **Nix:** For providing a comfy isolated dev env (no more venv shenanigans), packaging and building a docker image for the service.
- **Arion:** A nix wrapper around docker compose to simplify container orchestation for local development.

## TODO

- Implement AWS RDS storage backend.
- Implement AWS S3 storage backend.
- Write delcarative cloud deployment using terraform.

## FAQ

**Q:** Why so much Nix?
**A:** Yeah, I basically brought what would've been your classic array of `pyproject.toml`, `docker-compose.yaml` and `Dockerfile`, three very different syntaxes, into a single, coherent language. Nix is intimidating at first but once you get used to it you really don't want to leave it. With a little bit of upfront effort, packaging your application is solved, forever.

**Q:** When will you write tests?
**A:** Whenever the domain grows large enough for tests to become worth the effort (In other words, never).

**Q:** Will there ever be a Rust rewrite?
**A:** Yeah why not.
