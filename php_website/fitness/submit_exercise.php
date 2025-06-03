<?php 

if($_SERVER["REQUEST_METHOD"] == "POST") {
    $host = 'localhost'; // MySQL host
    $username = 'root'; // MySQL username
    $password = ""; // MySQL password
    $database = 'fitness'; // MySQL database name

    $conn = new mysqli($host, $username, $password, $database);
    // Check connection
    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }
    $stmt = $conn->prepare("INSERT INTO exercise (name, slogan, second, image_url) VALUES (?,?,?,?)");
    $stmt->bind_param("ssis", $name, $slogan, $second, $image_url);

    $name = $_POST['name'];
    $slogan = $_POST['slogan'];
    $second = intval($_POST['second']);

    $target_dir = "uploads/";
    $target_file = $target_dir.basename($_FILES["image"]["name"]);
    $imageFileType = strtolower(pathinfo($target_file, PATHINFO_EXTENSION));
    $image_url = $target_file;

    $check = getimagesize($_FILES["image"]["tmp_name"]);
    if ($check !== false) {
        if($_FILES["image"]["size"] > 5000000) {
            echo "Sorry, your file is too large";
            exit();
        }
        if($imageFileType != "jpg" && $imageFileType != "png" && $imageFileType != "jpeg" && $imageFileType != "gif") { 
            echo "Sorry, only JPG, JPEG, PNG and GIF are allowed";
            exit();
        }
        if(move_uploaded_file($_FILES["image"]["tmp_name"], $target_file)) {
            if($stmt->execute()){
                echo "Exercise added successfully!";
                header("Location:add_exercise.php");
            }else{
                echo "Sorry, there was problem uploading your file";
            }
        }
    }else{
        echo "File is not an image";
    }

    $stmt->close();
    $conn->close();

}else{
    echo"No form submitted";
}

?>