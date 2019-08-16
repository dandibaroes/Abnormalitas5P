<?php

require "../config/connect.php";

if ($_SERVER['REQUEST_METHOD']=="POST") {
    # code...

    $responsee = array();
    $idAbnormalitas = $_POST['id'];

    $insert = "DELETE FROM abnormalitas WHERE id='$idAbnormalitas'";

    if (mysqli_query($con,$insert)) {
        # code...

        $responsee['value'] = 1;
        $responsee['message']="Berhasil dihapus";
        echo json_encode($responsee);

    } else {
        # code...

        $responsee['value'] = 0;
        $responsee['message']="Gagal dihapus";
        echo json_encode($responsee);

    }

    }

?>