# NumID
Number to and from ID Generator/Crypter.

NumID's algorithm uses an pattern consist of 10 unique
alpha-numeric characters and auto/manual rotation as the
key to encrypt Number to ID and decrypt ID to Number.

<b>Requires:</b> Bash version 4+

### Usage
```console
Usage: numid <options..> <pattern> <number|id>
   or: numid <options>

<options>          <details>
  -e               Encrypt Number to ID using pattern.
     -R[0-9]       Specify manual rotation to encrypt.
  -d               Decrypt ID to Number using pattern.
     -R[0-9]       Specify manual rotation encrypted with.
     
  -A|-a            Generate an unique alphabetic pattern, 
                   use '-a' for lowercase.
  -N               Generate an unique numeric pattern.
  -aN|-AN|-NA|-Na  Generate an unique alpha-numeric pattern.
  
  -h, --help       Display this help and exit.
```

### Examples
```shell
# Let's generate a unique alpha-numeric Pattern.
~$ ./numid.sh -AN
B1PY9Q86IH

# Let's generate an encrypted ID from a Number with pattern and auto rotation.
~$ ./numid.sh -e B1PY9Q86IH 3556
H11P

# Let's decrypt an ID to a Number with pattern and auto rotation.
~$ ./numid.sh -d B1PY9Q86IH H11P
3556

# Let's encrypt a Number to an ID with pattern and manual '7'th rotational
# position, it means our input number '3556' will be encrypted as '0223'.
~$ ./numid.sh -e -R7 B1PY9Q86IH 3556
YPPB

# Let's decrypt an ID to a Number with pattern and manual '7'th rotational
# position which encrypted with, it means our input ID 'YPPB' will be
# decrypted to '0223' then rotate to '3556'.
~$ ./numid.sh -d -R7 B1PY9Q86IH 3556
3556
```
