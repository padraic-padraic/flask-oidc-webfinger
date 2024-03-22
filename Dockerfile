FROM docker.io/python:3.12-slim-bookworm

ARG WHEEL_NAME

RUN addgroup --system ts-webfinger \
    && adduser --system --ingroup ts-webfinger ts-webfinger


ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

RUN --mount=type=cache,target=/pip-cache \
    pip install --cache-dir /pip-cache gunicorn

RUN --mount=type=bind,source="README.md",target="/src/README.md" \
    --mount=type=bind,source="pyproject.toml",target="/src/pyproject.toml" \
    --mount=type=bind,source="tailscale_webfinger",target="/src/tailscale_webfinger" \
    # --mount=type=cache,target=/pip-cache \
    cd /src && ls && pip install .       

USER ts-webfinger
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

EXPOSE 8000

ENTRYPOINT ["gunicorn", "-b", "0.0.0.0", "tailscale_webfinger:app"]

