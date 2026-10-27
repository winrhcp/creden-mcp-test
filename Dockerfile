# syntax=docker/dockerfile:1

FROM python:3.12-slim-bookworm

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1 \
    CREDEN_SESSION_FILE=/data/.creden_session.json

WORKDIR /app

COPY pyproject.toml README.md LICENSE ./
COPY src ./src

RUN pip install . \
    && python -c 'from importlib.metadata import version; from creden_mcp.server import mcp; assert version("mcp").split(".", 1)[0] == "2", version("mcp")' \
    && useradd --create-home --uid 10001 --user-group creden \
    && install --directory --owner=creden --group=creden /data

USER creden

VOLUME ["/data"]

ENTRYPOINT ["creden-mcp"]
