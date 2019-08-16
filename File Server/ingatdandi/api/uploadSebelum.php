<?php

require "../config/connect.php";

if ($_SERVER['REQUEST_METHOD']=="POST") {
    # code...

  
    $id = $_POST['id'];
    $image = date('dmYHis').str_replace(" ","",basename($_FILES['image']['name']));
    $imagePath = "../upload/".$image;
    move_uploaded_file($_FILES['image']['tmp_name'],$imagePath);

    $insert = "UPDATE abnormalitas SET gambar_sesudah = '$image' WHERE id=$id";
    // $insert = "SELECT * FROM abnormalitas";

    if (mysqli_query($con,$insert)) {
        # code...

        $responsee['value'] = 1;
        $responsee['message']="Berhasil ditambahkan";
        echo json_encode($responsee);

    } else {
        # code...

        $responsee['value'] = 0;
        $responsee['message']="Gagal ditambahkan";
        echo json_encode($responsee);

    }

    }

?>