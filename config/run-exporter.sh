#!/bin/sh

EXPORTER_PORT=${EXPORTER_PORT:-9113}
LDAP_HOST=${LDAP_HOST:-'127.0.0.1'}
LDAP_PORT=${LDAP_PORT:-389}
LDAP_DOMAIN=${LDAP_DOMAIN:-'demo.local'}
LDAP_BIND_DN_PREFIX=${LDAP_BIND_DN_PREFIX:-'cn=monitor,ou=services'}
LDAP_BIND_PW=${LDAP_BIND_PW:-'secret'}
LDAP_PROTO=${LDAP_PROTO:-ldap}
DSTYPE=${DSTYPE:-'OpenLDAP'}

if test "$DEBUG"; then
    set -x
fi

if test -z "$LDAP_BASE"; then
    LDAP_BASE=`echo "dc=$LDAP_DOMAIN" | sed 's|\.|,dc=|g'`
fi
if test -z "$LDAP_PORT" -a "$LDAP_PROTO" = ldaps; then
    LDAP_PORT=636
elif test -z "$LDAP_PORT"; then
    LDAP_PORT=389
fi

if test $DSTYPE = 'OpenLDAP'; then

cat <<EOF >/config/ldap_exporter.yml
---
server: tcp:port=${EXPORTER_PORT}
client: tcp:host=${LDAP_HOST}:port=${LDAP_PORT}
binddn: ${LDAP_BIND_DN_PREFIX},${LDAP_BASE}
bindpw: ${LDAP_BIND_PW}
basedn: 'cn=Monitor'
basedn_ops: 'cn=Operations,cn=Monitor'
query: '(|(objectClass=monitorCounterObject)(objectClass=monitoredObject))'
query_ops: '(objectClass=monitorOperation)'
EOF

elif test $DSTYPE = '389DS'; then

cat <<EOF >/config/ldap_exporter.yml
---
server: tcp:port=${EXPORTER_PORT}
client: tcp:host=${LDAP_HOST}:port=${LDAP_PORT}
binddn: ${LDAP_BIND_DN_PREFIX},${LDAP_BASE}
bindpw: ${LDAP_BIND_PW}
basedn: 'cn=Monitor'
query: '(objectClass=*)'
EOF
fi

unset EXPORTER_PORT LDAP_HOST LDAP_PORT LDAP_DOMAIN
unset LDAP_BIND_DN_PREFIX LDAP_BIND_PW LDAP_PROTO

exec python /usr/src/app/ldap_exporter.py --config /config/ldap_exporter.yml
