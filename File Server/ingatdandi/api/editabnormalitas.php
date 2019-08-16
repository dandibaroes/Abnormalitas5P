<?php

require "../config/connect.php";

if ($_SERVER['REQUEST_METHOD']=="POST") {
    # code...

    $responsee = array();
    $pic = $_POST['pic'];
    $idProduk = $_POST['idProduk'];
    $status = $_POST['status'];

    $insert = "UPDATE abnormalitas SET pic = '$pic', status_abnormalitas='$status' WHERE id = '$idProduk'";

    if (mysqli_query($con,$insert)) {
        # code...

        $responsee['value'] = 1;
        $responsee['message']="Berhasil diubah";
        echo json_encode($responsee);

    } else {
        # code...

        $responsee['value'] = 0;
        $responsee['message']="Gagal diubah";
        echo json_encode($responsee);

    }

    }

?>