---
title: "Ldap basics for go developers"
date: 2020-04-06
draft: false
---

Recently I needed to prepare a Go application to accept LDAP as a form of authentication. Knowing absolutely nothing about LDAP, I researched the topic a bit first and I thought it would be helpful to summarize my findings so far.<!-- more -->

* [Minimal LDAP background](#minimal-ldap-background)
* [Trying it out on the command line](#trying-it-out-on-the-command-line)
* [Authenticating with a Go program](#authenticating-with-a-go-program)

## Minimal LDAP background

If you are like me, then you know that LDAP is used for authentication and authorization but not much more. As it turns out, you can do a lot more with it than just store users and permissions. One can put the whole company inventory in it. In fact, I think it is best to view an LDAP server as a kind of weird database. The weird part is dat the data is not stored in tables, like in an SQL database, but in a tree.

Like a database, you cannot go out and just fire some queries at it. You have to know the schema first.

### Entries

Every entry in the tree has at least three components:

* A distinguished name (DN)
* A collection of attributes
* A collection of object classes

The distinguished name is the unique name and the location of the entry in the tree. For instance:

```
cn=admin,dc=example,dc=org
```

could be the DN of the adminstrator of the example.org company. It is a list of comma separated key-value pairs with the most specific pair (`cn=admin`) on the left and the most common one, the top of the tree, on the right (`dc=org`).

The `cn` and `dn` describe the type of the value. `cn` means 'common name', `dc` is 'domain component'. Other ones are `ou` (organisational unit) and `uid` (user id).

The complete entry for this administrator coulde be:

```
dn: cn=admin,dc=example,dc=org
objectClass: simpleSecurityObject
objectClass: organizationalRole
cn: admin
description: LDAP administrator
userPassword:: e1NTSEF9ZGdKR1g1YTBKQ2twZkZLY1J5cHB0LzYwZmMwVWNReW4=
```

### Binding

LDAP does not really use the term 'authentication'. Instead one speaks of 'binding' a user. This binding is done to a BindDN, the distinguished name of a branch in the tree. Subsequent requests will be performed in the scope of that branch. That is, this user will only be able to 'see' the subbranches and leave nodes of this BindDN.

## Trying it out on the command line

LDAP servers require some work to setup. For the purposes of just testing things out, there are free online servers that kind people have set up and maintain. But a better solution is to find a good Docker image and run things on your local machine. The public servers will not let you modify data, for obvious reasons. The `osixia/openldap` worked for me:

```
docker run -p 389:389 -p 636:636 osixia/openldap
```

Port `389` is a plain `ldap://` connection, port `636` is used for a secure `ldaps://` one.

This image has a minimal set of data in it. Let's see what it contains by running a search:
```
$ ldapsearch -x -H ldap://localhost -b dc=example,dc=org -D "cn=admin,dc=example,dc=org" -w admin
```
* `-x` to use simple authentication and no SASL
* `-H ldap://localhost` to point the program to the uri of our server
* `-b` specifies the scope, the branch under which we want to search
* `-D` the bindDN
* `-w admin` use admin as password

The result should be something like this:

```
# extended LDIF
#
# LDAPv3
# base <dc=example,dc=org> with scope subtree
# filter: (objectclass=*)
# requesting: ALL
#

# example.org
dn: dc=example,dc=org
objectClass: top
objectClass: dcObject
objectClass: organization
o: Example Inc.
dc: example

# admin, example.org
dn: cn=admin,dc=example,dc=org
objectClass: simpleSecurityObject
objectClass: organizationalRole
cn: admin
description: LDAP administrator
userPassword:: e1NTSEF9ZGdKR1g1YTBKQ2twZkZLY1J5cHB0LzYwZmMwVWNReW4=

# search result
search: 2
result: 0 Success

# numResponses: 3
# numEntries: 2
```

We see that we have one organisation and one admin user in that organisation.

Let's try to add a user. First create a file with the specifics of this new user:

```
# ldapentry
dn: cn=erik.winter,dc=example,dc=org
objectClass: person
cn: Erik Winter
sn: erik.winter
description: just some guy
```

Then add it:

```
$ ldapadd -x -H ldap://localhost -D "cn=admin,dc=example,dc=org" -w admin -f ldapentry
adding new entry "cn=erik.winter,dc=example,dc=org"
```

Now we must set the password:

```
ldappasswd -s welcome123 -w admin -D "cn=admin,dc=example,dc=org" -x "cn=erik.winter,dc=example,dc=org"
```

`-s welcome123` sets the password to `welcome123`.

Check that it was added:

```
$ ldapsearch -x -H ldap://localhost -b dc=example,dc=org -D "cn=admin,dc=example,dc=org" -w admin
# extended LDIF
#
# LDAPv3
# base <dc=example,dc=org> with scope subtree
# filter: (objectclass=*)
# requesting: ALL
#

# example.org
dn: dc=example,dc=org
objectClass: top
objectClass: dcObject
objectClass: organization
o: Example Inc.
dc: example

# admin, example.org
dn: cn=admin,dc=example,dc=org
objectClass: simpleSecurityObject
objectClass: organizationalRole
cn: admin
description: LDAP administrator
userPassword:: e1NTSEF9dnU4ZFo0YmVpMnRQYWN6UmpBVERoK1pRMkhUaDJYc2Q=

# erik.winter, example.org
dn: cn=erik.winter,dc=example,dc=org
objectClass: person
cn: Erik Winter
cn: erik.winter
sn: erik.winter
description: just some guy
userPassword:: e1NTSEF9NXZuQ1dwK1RNOThzMm9oRWF0U0cxRDZiMTF5RDhhbHk=

# search result
search: 2
result: 0 Success

# numResponses: 4
# numEntries: 3
```

Now, let's see if we can authenticate as this new user and see ourselves:

```
$ ldapsearch -x -H ldap://localhost -b "cn=erik.winter,dc=example,dc=org" -D "cn=erik.winter,dc=example
,dc=org" -w welcome123
# extended LDIF
#
# LDAPv3
# base <cn=erik.winter,dc=example,dc=org> with scope subtree
# filter: (objectclass=*)
# requesting: ALL
#

# erik.winter, example.org
dn: cn=erik.winter,dc=example,dc=org
objectClass: person
cn: Erik Winter
cn: erik.winter
sn: erik.winter
description: just some guy
userPassword:: e1NTSEF9NXZuQ1dwK1RNOThzMm9oRWF0U0cxRDZiMTF5RDhhbHk=

# search result
search: 2
result: 0 Success

# numResponses: 2
# numEntries: 1
```

Succes!

## Authenticating with a Go program

For Go, there a package that can do the heavy lifting for us, called `go-ldap`. The usual steps of authenticating users in a program are:

* Bind (authenticate) as an admin user
* Search for the user we want to authenticate
* Try to bind as that user with the supplied password to see if it is correct
* Do something useful with the result, such as initiating a session for the user or denying entry
* Switch back to the admin user

The package has example code in the `README.md` that follows exactly these steps. Adjusting for the values we used above, we get:

```
# main.go
package main

import (
	"fmt"
	"log"

	"github.com/go-ldap/ldap"
)

func main() {

	username := "cn=admin,dc=example,dc=org"
	password := "admin"

	bindusername := "cn=erik.winter,dc=example,dc=org"
	bindpassword := "welcome123"

	url := "ldap://localhost:389"

	fmt.Println("connect..")
	l, err := ldap.DialURL(url)
	if err != nil {
		log.Fatal(err)
	}

	fmt.Println("binding binduser..")
	if err := l.Bind(username, password); err != nil {
		log.Fatal(err)
	}

	fmt.Println("searching user...")
	searchRequest := ldap.NewSearchRequest(
		bindusername,
		ldap.ScopeWholeSubtree, ldap.NeverDerefAliases, 0, 0, false,
		fmt.Sprintf("(&(objectClass=person))"),
		[]string{"dn"},
		nil,
	)
	sr, err := l.Search(searchRequest)
	if err != nil {
		log.Fatal(err)
	}

	fmt.Printf("%+v\n", sr)
	if len(sr.Entries) != 1 {
		log.Fatal("User does not exist or too many entries returned")
	}

	userdn := sr.Entries[0].DN

	fmt.Println("binding user...")
	if err := l.Bind(userdn, bindpassword); err != nil {
		log.Fatal(err)
	}

	fmt.Println("switching back..")
	if err := l.Bind(username, password); err != nil {
		log.Fatal(err)
	}
}
```

Running it:

```
$ go run main.go
connect..
binding binduser..
searching user...
&{Entries:[0xc0001086c0] Referrals:[] Controls:[]}
binding user...
switching back..
```

Success again!

## Sources

* [ldap.com](https://ldap.com/basic-ldap-concepts/)
* [stackoverflow.com](https://stackoverflow.com/questions/18756688/what-are-cn-ou-dc-in-an-ldap-search)
* `man ldapsearch`, `man ldapadd` and `man ldappasswd`
* [www.forumsys.com](http://www.forumsys.com/tutorials/integration-how-to/ldap/online-ldap-test-server/)
* [serverfault.com](https://serverfault.com/questions/514870/how-do-i-authenticate-with-ldap-via-the-command-line)
* [github.com](https://github.com/osixia/docker-openldap)
* [www.thegeekstuff.com](https://www.thegeekstuff.com/2015/02/openldap-add-users-groups/)
* [pkg.go.dev](https://pkg.go.dev/github.com/go-ldap/ldap?tab=doc)
