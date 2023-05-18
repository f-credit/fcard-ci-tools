for VERSION in "/opt/hostedtoolcache/Python/$PYTHON_VERSION"*; do
    export PATH="$VERSION/x64/bin:$PATH"
    echo "$VERSION/x64/bin" >> $GITHUB_PATH
done

pip3 install -q poetry==1.3.2