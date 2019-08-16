<?php

require "../config/connect.php";

if ($_SERVER['REQUEST_METHOD']=="POST") {
    # code...

    $responsee = array();
    $username = $_POST['username'];
    $password = md5($_POST['password']);
    // $nama = $_POST['nama'];
    date_default_timezone_set("Asia/Jakarta");
    $date = date("Y-m-d");

    $cek = "SELECT * FROM users WHERE username = '$username' and password='$password'";
    $result = mysqli_fetch_array(mysqli_query($con,$cek));

    if (isset($result)) {
        # code...
        $responsee['value'] = 1;
        $responsee['message']="Login berhasil";
        $responsee['username']=$result['username'];
        // $responsee['nama']=$result['nama'];
        $responsee['id']=$result['id'];
        $responsee['level']=$result['level'];
        $responsee['unit']=$result['unit_kerja'];
        echo json_encode($responsee);
    } else {
        # code...
        $responsee['value'] = 0;
        $responsee['message']="Login gagal";
        echo json_encode($responsee);
    }
}

?>