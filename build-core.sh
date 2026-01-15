core_tag() {
  local VERSION="$1"
  
  if [[ "${DO_TAG:-}" != "true" ]] || git rev-parse "$VERSION" >/dev/null 2>&1; then
    return 0
  fi

  echo "tagging version $VERSION..."
  
  local GIT_ARGS=(
    -c "user.email=bot@bluebirdtechnology.com"
    -c "user.name=Bluebird Bot"
  )

  if [[ -n "${GIT_ACCESS_TOKEN:-}" ]]; then
    local AUTH
    AUTH=$(echo -n "x-access-token:${GIT_ACCESS_TOKEN}" | base64)
    GIT_ARGS+=(-c "http.extraheader=AUTHORIZATION: basic ${AUTH}")
  fi

  git "${GIT_ARGS[@]}" tag -a "$VERSION" -m "$VERSION"
  
  if git "${GIT_ARGS[@]}" push --quiet origin "$VERSION"; then
    echo "Successfully pushed tag $VERSION"
  else
    echo "Failed to push tag $VERSION" >&2
    return 1
  fi
}