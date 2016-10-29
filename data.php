<?php

error_reporting(0);
date_default_timezone_set('Europe/Moscow');
require 'PSR4Loader.php';
require 'config/database.php';


$interval = filter_input(INPUT_GET, "interval", FILTER_VALIDATE_INT);

//Initialize DB connection
$adapter = new NK\Conversion\DatabaseAdapter($db->host, $db->name, $db->user, $db->password);

//Call the procedure and get result
$statement = $adapter->conversion($interval);

//Convert to Google Charts JSON Datatable
$jsonTable = NK\Conversion\ConversionDataConverter::toJSON($statement);

echo $jsonTable;
