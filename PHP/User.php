<?php
require_once __DIR__ . '/PHPConnector.php';
function addUser($name, $password, $email) {
    $connector = new Connector();
    if (!$connector) die ("");
    $query = "INSERT INTO Users (username, password, email) VALUES ('$name', '$password', '$email')";
    $res = $connector->runQuery($query, $connector->dbName);
    if ( $res ) {
        return "Success";
    }
    return "Fail";
}

if (isset ( $_GET['q'] )) {
    if ($_GET['q'] == 'AddUser') {
         $res = array ( 'status' => addUser($_GET['name'], $_GET['password'], $_GET['email']) );
            echo json_encode($res, JSON_PRETTY_PRINT);
    }

}
?>