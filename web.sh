#!/bin/sh
addr="127.0.0.1" post_port=8181 get_port=8181 post_ext="api/post" get_ext="api/get"
case $1 in
"-p"|"--post")
in_file=$(cat "$3")
if [ ${#in_file} -lt 31 ]
then
echo "Files must be >32 bytes in size"
exit 1
fi
openssl enc -aes-256-cbc -in "$3" -out .tmpenc -pbkdf2 -k "$4" -a
file1=$(cat .tmpenc)
curl -X POST -H "Content-Type: application/x-www-form-urlencoded; charset=\"UTF-8\"" --data-urlencode "msg=$file1" --data-urlencode "usrKey=$2" "http://$addr:$post_port/$post_ext"
rm .tmpenc
echo "$file1"
;;
"-g"|"--get")
if [ $# = 1 ]
then
curl "http://$addr:$get_port/$get_ext/all" && exit 0
fi
if [ $# = 4 ]
then
file_out="$4"
else
file_out="$2"
fi
curl "http://$addr:$get_port/$get_ext/$2" >> .tmpenc
echo "$file_out"
openssl enc -aes-256-cbc -d -in .tmpenc -out "$file_out" -pbkdf2 -k "$3" -a
rm .tmpenc
echo "File saved as $file_out"
;;
*)
echo "options:
./web.sh [-p / --post] [title*] [file*] [passwd*] - Post file
./web.sh [-g / --get] [title*] [passwd*] [out] - Retrieve file
./web.sh [-g / --get] - List files"
;;
esac
