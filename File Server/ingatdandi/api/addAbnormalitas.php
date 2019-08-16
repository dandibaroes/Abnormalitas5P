<?php

require "../config/connect.php";

if ($_SERVER['REQUEST_METHOD']=="POST") {
    # code...

    $responsee = array();
    $user_pelapor = $_POST['username'];
    $keterangan = $_POST['keterangan'];
    // $nama = $_POST['nama'];
    date_default_timezone_set("Asia/Jakarta");
    $date_input = date("Y-m-d");
    $idUsers = $_POST['idUsers'];
    $pic = "-";
    $status = 1;
    $gambarsesudah = "default.png";
    $prioritas = $_POST['prioritas'];
    $unit = $_POST['unit'];
    $lokasi = $_POST['lokasi'];
    // $unitkerja = $_POST['unit_kerja'];
    $koordinat = $_POST['koordinat'];
    $ketinggian = $_POST['ketinggian'];
    $tglselesai = $_POST['selesai'];

    $image = $_FILES['image']['name'];
    $imagePath = "../upload/".$image;
    move_uploaded_file($_FILES['image']['tmp_name'],$imagePath);

    $insert = "INSERT INTO abnormalitas VALUE(NULL,'$user_pelapor','$unit','$keterangan','$status','$prioritas','$image','$gambarsesudah','$lokasi','$koordinat','$ketinggian','$pic','$date_input','$tglselesai','$idUsers')";
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