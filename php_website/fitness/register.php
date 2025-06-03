<?php

header("Access-Control-Allow-Origin: *");

$dbHost = 'localhost';
    $dbUsername = 'root';
    $dbPassword = '';
    $dbName = 'fitness';

    $conn = new mysqli($dbHost, $dbUsername, $dbPassword, $dbName);

    if($conn->connect_errno){
        die("Connect Failed: ".$conn->connect_errno);
    }

$name = $_POST['name'];
$email = $_POST['email'];
$password = $_POST['password'];

$hash_password = password_hash($password, PASSWORD_DEFAULT);

$query = "INSERT INTO users (name, email, password) VALUES ('$name', '$email', '$hash_password')";

if(mysqli_query($conn, $query)) {
    $response["success"] = true;
    $response["message"] = "User registered successfully!";
}else{
    $response["success"] = false;
    $response["message"] = "Registration failed. Please try again!";
}

echo json_encode($response);

?>