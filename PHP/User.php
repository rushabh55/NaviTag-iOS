<?php
require_once __DIR__ . '/PHPConnector.php';
function addUser($name, $password, $email, $location) {
    $connector = new Connector();
    if (!$connector) die ("");
    $query = "INSERT INTO Users (username, password, email, location) VALUES ('$name', '$password', '$email', '$location')";
    $res = $connector->runQuery($query, $connector->dbName);
    if ( $res ) {
        return "Success";
    }
    return "Fail";
}
UPDATE table_name
SET column1=value1,column2=value2,...
WHERE some_column=some_value;
function edit_loc_id($id, $location){
	$connector = new Connector();
    if (!$connector) die ("");
    $query = "UPDATE Users SET location=".$location."WHERE id =".$id;
    $res = $connector->runQuery($query, $connector->dbName);
    if ( $res ) {
        return "Success";
    }
    return "Fail";
}
function edit_loc_name($name, $location){
$connector = new Connector();
    if (!$connector) die ("");
    $query = "UPDATE Users SET location=".$location."WHERE name =".$name;
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
    } else if
	{
	($_GET['q'] == 'editUser') {
		if(isset($_GET['id']))
		{
		$res = array ( 'status' => edit_loc_id($_GET['id'], $_GET['location']) );
            	echo json_encode($res, JSON_PRETTY_PRINT);
		} else if(isset($_GET['name']))
		{
		$res = array ( 'status' => edit_loc_name($_GET['name'], $_GET['location']) );
            	echo json_encode($res, JSON_PRETTY_PRINT);
		}
	}

}
?>
