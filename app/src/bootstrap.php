<?php

require __DIR__ . DIRECTORY_SEPARATOR . ".." . DIRECTORY_SEPARATOR . "vendor" . DIRECTORY_SEPARATOR . "autoload.php";

if(strpos($_SERVER["REQUEST_URI"], "/adminer") === 0)
{
    require_once __DIR__ . DIRECTORY_SEPARATOR . "adminer.php";
    exit;
}

echo "Hello";