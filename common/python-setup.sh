for VERSION in "/opt/hostedtoolcache/Python/$PYTHON_VERSION"*; do
    export PATH="$VERSION/x64/bin:$PATH"
    echo "$VERSION/x64/bin" >> $GITHUB_PATH
done

if [ -f "uv.lock" ]; then
    if [ -n "$UV_VERSION" ]; then
        UV_INSTALLER="https://astral.sh/uv/$UV_VERSION/install.sh"
    else
        UV_INSTALLER="https://astral.sh/uv/install.sh"
    fi
    curl -LsSf "$UV_INSTALLER" | env UV_INSTALL_DIR="$HOME/.local/bin" sh
    echo "$HOME/.local/bin" >> $GITHUB_PATH
fi
