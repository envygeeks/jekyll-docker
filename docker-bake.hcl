variable "JEKYLL_VERSION" { default = "4.4.1" }
variable "PAGES_RUBY_VERSION" { default = "3.3.4" }
variable "PAGES_JEKYLL_VERSION" { default = "3.10.0" }
variable "GITHUB_PAGES_VERSION" { default = "232" }
variable "IMAGE_NAMESPACE" { default = "jekyll" }
variable "RUBY_VERSION" { default = "3.4" }

variable "COREPACK_PACKAGE_SPECS" {
  default = [
    "pnpm@10.34.4",
  ]
}

variable "PAGES_COREPACK_PACKAGE_SPECS" {
  default = []
}

variable "RUNTIME_APT_PACKAGES" {
  default = [
    "nodejs",
    "ca-certificates",
    "git",
  ]
}

variable "BUILD_APT_PACKAGES" {
  default = [
    "libffi-dev",
    "imagemagick",
    "libvips-dev",
    "build-essential",
    "libmagickwand-dev",
    "libsqlite3-dev",
    "libxml2-dev",
    "libxslt1-dev",
    "libyaml-dev",
    "pkg-config",
    "zlib1g-dev",
    "cmake",
  ]
}

variable "BUILDER_APT_PACKAGES" {
  default = [
    "lftp",
    "openssh-client",
    "rsync",
  ]
}

variable "JEKYLL_EXTRA_GEMS" {
  default = [
    "jemoji",
    "kramdown",
    "html-proofer",
    "jekyll-mentions",
    "jekyll-paginate",
    "jekyll-coffeescript",
    "jekyll-redirect-from",
    "jekyll-sass-converter",
    "jekyll-commonmark",
    "jekyll-compose",
    "jekyll-sitemap",
    "jekyll-feed",
    "RedCloth",
    "minima",
  ]
}

variable "BUILDER_EXTRA_GEMS" {
  default = [
    "RedCloth",
    "html-proofer",
    "jekyll-compose",
    "jekyll-mentions",
    "jekyll-coffeescript",
    "jekyll-redirect-from",
    "jekyll-sass-converter",
    "jekyll-paginate",
    "jekyll-sitemap",
    "jekyll-feed",
    "kramdown",
    "minima",
    "jemoji",
  ]
}

variable "MINIMAL_EXTRA_GEMS" {
  default = [
    "kramdown",
    "jekyll-coffeescript",
    "jekyll-sass-converter",
    "minima",
  ]
}

group "default" {
  targets = [
    "jekyll",
    "builder",
    "minimal",
    "pages",
  ]
}

target "_common" {
  context = "."
  dockerfile = "Dockerfile"
  args = {
    APT_PACKAGES = join(" ", concat(RUNTIME_APT_PACKAGES, BUILD_APT_PACKAGES))
    APT_PURGE_PACKAGES = ""
    COREPACK_PACKAGE_SPECS = join(" ", COREPACK_PACKAGE_SPECS)
  }
  labels = {
    "org.opencontainers.image.source" = "https://github.com/envygeeks/jekyll-docker"
    "org.opencontainers.image.licenses" = "MIT"
  }
}

target "jekyll" {
  inherits = ["_common"]
  tags = [
    "${IMAGE_NAMESPACE}/jekyll:latest",
    "${IMAGE_NAMESPACE}/jekyll:${JEKYLL_VERSION}",
    "${IMAGE_NAMESPACE}/jekyll:4.4",
    "${IMAGE_NAMESPACE}/jekyll:4",
  ]
  args = {
    BASE_IMAGE = "ruby:${RUBY_VERSION}"
    EXTRA_GEMS = join(" ", JEKYLL_EXTRA_GEMS)
    JEKYLL_GEM_VERSION = "${JEKYLL_VERSION}"
    JEKYLL_VERSION = "${JEKYLL_VERSION}"
  }
}

target "builder" {
  inherits = ["_common"]
  tags = [
    "${IMAGE_NAMESPACE}/builder:latest",
    "${IMAGE_NAMESPACE}/builder:${JEKYLL_VERSION}",
    "${IMAGE_NAMESPACE}/builder:4.4",
    "${IMAGE_NAMESPACE}/builder:4",
  ]
  args = {
    BASE_IMAGE = "ruby:${RUBY_VERSION}"
    APT_PACKAGES = join(" ", concat(RUNTIME_APT_PACKAGES, BUILD_APT_PACKAGES, BUILDER_APT_PACKAGES))
    EXTRA_GEMS = join(" ", BUILDER_EXTRA_GEMS)
    JEKYLL_GEM_VERSION = "${JEKYLL_VERSION}"
    JEKYLL_VERSION = "${JEKYLL_VERSION}"
    JEKYLL_ENV = "production"
  }
}

target "minimal" {
  inherits = ["_common"]
  tags = [
    "${IMAGE_NAMESPACE}/minimal:latest",
    "${IMAGE_NAMESPACE}/minimal:${JEKYLL_VERSION}",
    "${IMAGE_NAMESPACE}/minimal:4.4",
    "${IMAGE_NAMESPACE}/minimal:4",
  ]
  args = {
    BASE_IMAGE = "ruby:${RUBY_VERSION}"
    APT_PURGE_PACKAGES = join(" ", BUILD_APT_PACKAGES)
    EXTRA_GEMS = join(" ", MINIMAL_EXTRA_GEMS)
    JEKYLL_GEM_VERSION = "${JEKYLL_VERSION}"
    JEKYLL_VERSION = "${JEKYLL_VERSION}"
  }
}

target "pages" {
  inherits = ["_common"]
  tags = [
    "${IMAGE_NAMESPACE}/jekyll:pages",
  ]
  args = {
    BASE_IMAGE = "ruby:${PAGES_RUBY_VERSION}"
    APT_PURGE_PACKAGES = join(" ", BUILD_APT_PACKAGES)
    COREPACK_PACKAGE_SPECS = join(" ", PAGES_COREPACK_PACKAGE_SPECS)
    JEKYLL_GEM_VERSION = "${GITHUB_PAGES_VERSION}"
    JEKYLL_VERSION = "${PAGES_JEKYLL_VERSION}"
    JEKYLL_GEM = "github-pages"
  }
}
