for VERSION in "/opt/hostedtoolcache/Python/$PYTHON_VERSION"*; do
    export PATH="$VERSION/x64/bin:$PATH"
    echo "$VERSION/x64/bin" >> $GITHUB_PATH
done

if [ -f "poetry.lock" ]; then
    python3 -m pip install --user pipx
    pipx install poetry==2.1.1
    pipx inject poetry poetry-dotenv-plugin