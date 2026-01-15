tag_version() (
  local VERSION="$1"
  
  if [[ "${DO_TAG:-}" != "true" ]] || git rev-parse "$VERSION" >/dev/null 2>&1; then
    return 0
  fi

  echo "tagging version $VERSION..."

  git config user.email "bot@bluebirdtechnology.com"
  git config user.name "Bluebird Bot"

  if [[ -n "${GIT_ACCESS_TOKEN:-}" ]]; then
    local AUTH
    AUTH=$(echo -n "x-access-token:${GIT_ACCESS_TOKEN}" | base64)
    git config http.extraheader "AUTHORIZATION: basic ${AUTH}"
  fi

  git tag -a "$VERSION" -m "$VERSION"
  git push --quiet origin "$VERSION"
)
