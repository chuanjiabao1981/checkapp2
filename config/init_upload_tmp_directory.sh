function usage() {
    echo "usage: $0 nginx conf path"
}

if [ $# -lt 1 ] ; then
    usage
    exit 1
else
	NGINX_CONF=$1
	#echo $NGINX_CONF
fi
DIR_PREFIX=/tmp/
#sed  -i -e "s#[ ]*upload_store .*#          upload_store $DIR_PREFIX 1 ;#" $NGINX_CONF
for (( i=0; i<10; i++)); do
	mkdir -p $DIR_PREFIX/$i
	chown nobody $DIR_PREFIX/$i
done




echo "Please Restart Nginx !!!!!!!!!!!!!!!!!!!!!!!!!!"