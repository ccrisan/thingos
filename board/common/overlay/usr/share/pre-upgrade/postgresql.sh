#!/bin/bash

# Prepare a PostgreSQL dump to help migrating to new version

OLD_PG_CTL=/usr/bin/pg_ctl
NEW_PG_CTL=${TMP_ROOT_DIR}/usr/bin/pg_ctl
USER=postgres
DB_DIR=/var/lib/postgresql
DUMP_FILE=/var/lib/postgresql-dump.sql.gz

test -x ${OLD_PG_CTL} || exit 0
test -x ${NEW_PG_CTL} || exit 0
cd /tmp
su ${USER} -c "pg_ctl status -D ${DB_DIR}" > /dev/null || exit 0

old_version=$(${OLD_PG_CTL} -V | cut -d ' ' -f 3 | cut -d . -f 1)
# Treat any errors from new pg_ctl as version mismatch/upgrade
new_version=$(${NEW_PG_CTL} -V 2>/dev/null | cut -d ' ' -f 3 | cut -d . -f 1)
test "${old_version}" != "${new_version}" || exit 0

echo "dumping postgresql data"
pg_dumpall -U ${USER} --quote-all-identifiers | gzip > ${DUMP_FILE}
