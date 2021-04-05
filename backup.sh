# скрипт для создания бэкапов на удаленном ftp сервере
# пути к файлам и папкам строятся относительно файла скрипта, поэтому желательно всегда держать его в папке докера
# рядом с файлом обязательно надо создать файл backup.conf, который должен содержать параметры, описанные в файле backup.conf.sample
# нормальной проверки нет, поэтому если какой то параметр отсутствует, скрипт может отработать криво

configFile=`dirname $0`
configFile+="/backup.conf"
if [ ! -f $configFile ]
then
        exit 0
fi

source $configFile

script_dir=$(dirname ${BASH_SOURCE[0]})

server_ip=`curl http://ipecho.net/plain 2>/dev/null;`

upload()
{
        ftp -n <<EOF
                open ${ftp[host]}
                user ${ftp[user]} ${ftp[pass]}
                mkdir /$3
                mkdir /$3/$1
                put $2 "/$3/$1/$2"
EOF
}

for dirs in "${include_dirs[@]}"
do
        for dir in $script_dir/$dirs
        do
                if [ ! -d "$dir" ]
                then
                        continue
                fi
                folder=$(basename $dir)
                change_dir=$(dirname $dir)
                archive_name="$(date '+%d%m%Y').tar.gz"
                tar --ignore-failed-read -cz -f $archive_name -C $change_dir ${exclude_dirs[@]/#/--exclude=$@} $folder
                upload $folder $archive_name $server_ip
                rm $archive_name
        done
done
