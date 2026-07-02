# Jekyll Docker

Docker images for running [Jekyll](https://jekyllrb.com/) with the
official Ruby image family and Docker Buildx Bake. The images keep the
long-standing `/srv/jekyll` workdir, expose Jekyll's default
development ports, and follow the official Ruby image
pattern of running as root by default.

## Images

| Image | Purpose |
| --- | --- |
| `jekyll/jekyll` | Default image with Jekyll and common community gems. |
| `jekyll/builder` | Default image plus deployment tools such as `rsync`, `lftp`, and `openssh-client`. |
| `jekyll/minimal` | Smaller image with Jekyll and a minimal gem set. |
| `jekyll/jekyll:pages` | GitHub Pages-compatible image using versions from `docker-bake.hcl`. |

## Usage

Build a site in the current directory:

```sh
docker run --rm \
  --volume "$PWD:/srv/jekyll" \
  jekyll/jekyll \
  jekyll build
```

Serve a site locally:

```sh
docker run --rm \
  --volume "$PWD:/srv/jekyll" \
  --publish 4000:4000 \
  --publish 35729:35729 \
  jekyll/jekyll \
  jekyll serve --host 0.0.0.0 --livereload
```

On Docker Desktop for Windows or other bind mount setups
where host file changes do not trigger rebuilds, use
Jekyll's polling watcher:

```sh
docker run --rm \
  --volume "$PWD:/srv/jekyll" \
  --publish 4000:4000 \
  --publish 35729:35729 \
  jekyll/jekyll \
  jekyll serve --host 0.0.0.0 --livereload --force_polling
```

Run Bundler explicitly when your project has a `Gemfile`:

```sh
docker run --rm \
  --volume "$PWD:/srv/jekyll" \
  jekyll/jekyll \
  bundle install

docker run --rm \
  --volume "$PWD:/srv/jekyll" \
  jekyll/jekyll \
  bundle exec jekyll build
```

For Linux bind mounts, use Docker's standard `--user`
flag when you want generated files to be owned by your
host user:

```sh
docker run --rm \
  --user "$(id -u):$(id -g)" \
  --volume "$PWD:/srv/jekyll" \
  jekyll/jekyll \
  jekyll build
```

## Custom System Packages

The images do not install operating-system packages at
runtime. Build a project-specific image when your site needs
additional Debian packages:

```Dockerfile
FROM jekyll/jekyll

RUN apt-get update \
  && apt-get install -y --no-install-recommends graphviz \
  && rm -rf /var/lib/apt/lists/*
```

The images include Node.js. Corepack package managers
are configured per target in `docker-bake.hcl`; the default,
builder, and minimal targets currently include pnpm.

## Local Development

Build every image target:

```sh
docker buildx bake
```

Build and load a single target locally:

```sh
docker buildx bake --load jekyll
docker buildx bake --load builder
docker buildx bake --load minimal
docker buildx bake --load pages
```

Run the smoke test suite:

```sh
script/test
```

Refresh GitHub Pages versions in `docker-bake.hcl`:

```sh
script/update
```

## GitHub Pages Versions

`script/update` downloads
`https://pages.github.com/versions.json`
and updates the Pages-related Bake
variables:

- `PAGES_RUBY_VERSION`
- `PAGES_JEKYLL_VERSION`
- `GITHUB_PAGES_VERSION`
