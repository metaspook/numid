# NumID
NumID is a command-line Number to and from ID Generator/Crypter application.<br>

><b>Requires:</b> Bash version 4+

### 🎈 Features
* Generate any product's unique order ID with cipher.
* Generate any Number to ID encrypted.
* Uses 10 unique alpha-numeric character pattern as key.
* Uses auto/manual rotation as extra key.
* Built-in ID to Number decrypter.
* Built-in unique alphabetic/numeric/alphanumeric pattern generator.
* Remotely executable by piping to Bash.
* Pure Bash without dependencies.

### 🎈 Usage
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
  
  
## Remote Usage
curl -sL https://git.io/numid.sh | bash -s - <options..> <pattern> <number|id>
OR
wget -qO- https://git.io/numid.sh | bash -s - <options..> <pattern> <number|id>

```

### 🎈 Examples
```shell
# Make 'numid.sh' executable first (optional).
~$ chmod +x ./numid.sh

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

# Let's generate an encrypted ID from a Number Remotely*.
~$ curl -sL https://git.io/numid.sh | bash -s - -e B1PY9Q86IH 3556
H11P

```

### 🎈 Branches
```
👉 main   - Master development branch before release.
👉 stable - Stable branch for release and remote usage.
```
