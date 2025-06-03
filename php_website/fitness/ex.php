<?php 
// Aktifkan error reporting untuk debugging
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Database Connection Parameters
$servername = 'localhost';
$username = 'root';
$password = '';
$dbname = 'fitness';

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$sql = "SELECT * FROM exercise";
$result = $conn->query($sql);

header('Content-Type: application/json');

if($result && $result->num_rows > 0){
    $exercises = array();
    while($row = $result->fetch_assoc()) {
        $exercises[] = $row;
    }
    echo json_encode($exercises);
} else {
    echo json_encode(array('error' => 'No exercise found or query failed'));
}

$conn->close();
?>