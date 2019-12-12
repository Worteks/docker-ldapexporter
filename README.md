# Sweet LDAPExporter

Forked from https://github.com/jcollie/openldap_exporter

Build with:

```
$ make build
```

If you want to try it quickly on your local machine after make, run:

```
$ make run
```

Start Demo in OpenShift:

```
$ make ocdemo
```

Cleanup OpenShift assets:

```
$ make ocpurge
```

Environment variables and volumes
----------------------------------

The image recognizes the following environment variables that you can set during
initialization by passing `-e VAR=VALUE` to the Docker `run` command.

|    Variable name                 |    Description                            | Default                             |
| :------------------------------- | ----------------------------------------- | ----------------------------------- |
|  `DSTYPE`                        | LDAP Type                                 | `OpenLDAP`                          |
|  `EXPORTER_PORT`                 | LDAP Exporter Bind Port                   | `9113`                              |
|  `LDAP_BASE`                     | LDAP Base                                 | `dc=demo,dc=local`, from DOMAIN     |
|  `LDAP_BIND_DN_PREFIX`           | LDAP Monitor Service Account DN Prefix    | `cn=monitor,ou=services`            |
|  `LDAP_BIND_PW`                  | LDAP Monitor Service Account Bind PW      | `secret`                            |
|  `LDAP_DOMAIN`                   | LDAP Domain                               | `demo.local`                        |
|  `LDAP_HOST`                     | LDAP Remote                               | `127.0.0.1`                         |
|  `LDAP_PORT`                     | LDAP Port                                 | `389`                               |
|  `LDAP_PROTO`                    | LDAP Proto                                | `ldap`                              |
