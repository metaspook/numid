#!/usr/bin/env bash

# NumID - Number to and from ID Generator/Crypter.
# Version: 0.2
# Written by Metaspook
# Copyright (c) 2020 Metaspook.

# Requires version 4+ of Bash.
if [ -z $BASH_VERSION ] || [ ${BASH_VERSINFO[0]} -lt 4 ]; then
echo -e "ERROR: Requires Bash version 4+\n";exit 1;fi

### VARIABLES/ARRAY ###
declare -A App=(
    [Name]=NumID
    [FName]=$([[ "numid.sh" == "numid[.sh]" ]] && echo numid.sh || echo numid)
    [Ver]=0.2
    [CRDate]=2020
)
declare -A RGX=(
    [option]="^-[aAdehN]+$"
    [repeat]="(.).*\1"
    [alnum10]="^[A-Za-z0-9]{10}+$"
    [alnum]="^[A-Za-z0-9]+$"
    [alpha]="^[A-Za-z]+$"
    [digit]="^[0-9]+$"
)
CharSet=("ABCDEFGHIJKLMNOPQRSTUVWXYZ" "0123456789")
[[ $(date +'%Y' 2>/dev/null) -gt ${App[CRDate]} ]] && ${App[CRDate]}=$(date +'%Y')

### FUNCTIONS ###
function ptrn_gen(){
    local AlCnt AlNum SChar UChar; case $1 in alnum) AlNum=$1; shift;; esac
    for ((i=10;i>${#UChar};i)); do
        SChar="${1:${RANDOM}%${#1}:1}"
        [[ "$AlNum" && "$SChar" =~ ${RGX[alpha]} && $((++AlCnt)) -lt 2 ]] && SChar="" || AlCnt=0
        [[ ! "$SChar" =~ ^[$UChar]+$ ]] && UChar="${UChar}${SChar}"
    done; echo $UChar
}
function interadd(){
    if ((${#1}==1)); then echo $1
    elif ((${#1}>1)); then
        local OutNum=0; for ((i=0;i<${#1};++i)); do ((OutNum+=${1:((i-1)):1}))
        done; ((${#OutNum}!=1)) && $FUNCNAME $OutNum || echo $OutNum
    fi
}
function is_odd(){ (( 10#$1%2!=0)); }
function revstr(){
    echo $(for ((i;i<=${#1};i++)); do printf '%s' "${1:((${#1}-i)):1}"; done)
}
function num2str(){
    # Number to String using character set.**
    # Usage: str2num <charset> <number>
    echo $(for ((i=1;i<=${#2};i++)); do local N="${2:((i-1)):1}"; printf '%s' "${1:N:1}"; done)
}
function str2num(){
    # String to Number using character set.**
    # Usage: str2num <charset> <string>
    echo $(for ((i=1;i<=${#2};i++)); do local P="${1#*${2:((i-1)):1}}"; printf '%s' "$((${#1}-${#P}-1))"; done)
}
function rotnum(){
    # Number rotator. [0-9]**
    # Usage: rotnum <rotation 0 to 9> <number>
    local InDgt=$2 Rot=$1 DgtCnt OutDgt
    while [[ ${#InDgt} -ge $((++DgtCnt)) ]]; do
        local SDgt=${InDgt:((DgtCnt-1)):1}
        if [ $Rot -ge 5 -a $SDgt -ge 5 ]; then
            OutDgt=${OutDgt}$((SDgt-((10-Rot))))
        else
            local OutDgtT=$((SDgt+Rot))
            [ $((SDgt+Rot)) -gt 9 ] && OutDgtT=${OutDgtT: -1:1}
            OutDgt=${OutDgt}$OutDgtT
        fi
    done; echo $OutDgt
}
function id_encrypt(){
    # Number -> ID.**
    local Rot CharSet InDgt
    case $# in
        3) CharSet=$2; InDgt=$3; Rot=$1;;
        2) CharSet=$1; InDgt=$2; Rot=$((10-$(interadd ${#InDgt})));;
        *) return 1
    esac
    InDgt=$(rotnum $Rot $InDgt)
    is_odd $(interadd $InDgt) && InDgt=$(revstr $InDgt)
    num2str $CharSet $InDgt
}
function id_decrypt(){
    # ID -> Number.**
    local Rot CharSet InDgt InStr
    case $# in
        3) CharSet=$2; InStr=$3; Rot=$(($1==0?0:10-$1));;
        2) CharSet=$1; InStr=$2; Rot=$(interadd ${#InStr});;
        *) return 1
    esac
    InDgt=$(str2num $CharSet $InStr)
    is_odd $(interadd $InDgt) && InDgt=$(revstr $InDgt)
    rotnum $Rot $InDgt
}
function chk(){
    # Error handler.**
    for X in $@; do local P K=${X/=*} V=${X#*=}; case $K in
        -opt) if [[ ! "$V" =~ ${RGX[option]} || "$V" =~ ${RGX[repeat]} ]]; then
            echo "ERROR: Invalid option! Use '-h' or '--help' for available options."
            exit 1; fi;;
        -rot) if [[ ${#V} -ne 1 || ! "$V" =~ ${RGX[digit]} ]]; then
            echo "ERROR: Rotation must in range of 0 to 9."
            exit 1; fi;;
        -ptrn) P=$V; if [[ ! "$V" =~ ${RGX[alnum10]} || "$V" =~ ${RGX[repeat]} ]]; then
            echo "ERROR: Pattern must consist of 10 unique alpha-numeric characters."
            exit 1; fi;;
        -num) if [[ ! "$V" =~ ${RGX[digit]} ]]; then
            echo "ERROR: Number must contain numeric characters."
            exit 1; fi;;
        -id) if [[ ! "$V" =~ ^[$P]+$ ]]; then
            echo "ERROR: Invalid ID or Pattern!"
            exit 1; fi;;
    esac; done
}
function Main_Usage(){
    echo "
NumID  (Number to and from ID Generator/Crypter)
Version: ${App[Ver]} | MIT License (Open Source)
Copyright © ${App[CRDate]} Metaspook.

   NumID's algorithm uses an pattern consist of 10 unique
   alpha-numeric characters and auto/manual rotation as the
   key to encrypt Number to ID and decrypt ID to Number.

Usage: ${App[FName]} <options..> <pattern> <number|id>
   or: ${App[FName]} <options>

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
"
}

#----< CALL CENTER >----#
#
# Cheack options.
(($#>=1)) && chk -opt="$1"
case $# in
0) Main_Usage;;
1) 
    case $1 in
        -h|--help) Main_Usage;;
        -*a*) CharSet[0]="${CharSet[0],,}";;&
        -a|-A) ptrn_gen "${CharSet[0]}";;
        -N) ptrn_gen "${CharSet[1]}";;
        -AN|-NA|-aN|-Na) ptrn_gen alnum "${CharSet[0]}${CharSet[1]}";;
        *) chk -opt;;
    esac;;
3|4) 
    case $1 in
        -e) NumId=num IdCrypt=id_encrypt;;
        -d) NumId=id IdCrypt=id_decrypt;;
        *) chk -opt;;
    esac;;&
3) chk -ptrn="$2" -${NumId}="$3"; ${IdCrypt} $2 $3;;
4) 
    case $2 in
        -R[0-9]) chk -rot="${2#-R}" -ptrn="$3" -${NumId}="$4"; ${IdCrypt} ${2#-R} $3 $4;;
        *) chk -opt;;
    esac;;
*) chk -opt;;
esac
exit 0
