<?php

require __DIR__ . DIRECTORY_SEPARATOR . ".." . DIRECTORY_SEPARATOR . "vendor" . DIRECTORY_SEPARATOR . "autoload.php";

if(strpos($_SERVER["REQUEST_URI"], "/adminer") === 0)
{
    require_once __DIR__ . DIRECTORY_SEPARATOR . "adminer.php";
    exit;
}

echo "Hello";

echo "<pre>";
print_r($_ENV);
echo "</pre>";

echo file_get_contents($_ENV["MYSQL_DATABASE_FILE"]);
echo file_get_contents($_ENV["MYSQL_PASSWORD_FILE"]);
echo file_get_contents($_ENV["MYSQL_ROOT_PASSWORD_FILE"]);
echo file_get_contents($_ENV["MYSQL_USER_FILE"]);