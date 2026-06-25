if [ $CACHE_HIT != 'true' ]; then
    corepack enable
    corepack prepare "pnpm@${PNPM_VERSION:-10.4.1}" --activate
    pnpm install --frozen-lockfile
fi
