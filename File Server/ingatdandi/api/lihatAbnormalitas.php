<?php

require "../config/connect.php";

$response = array();

$sql = mysqli_query($con,"SELECT * FROM abnormalitas ORDER BY id DESC");

while($a = mysqli_fetch_array($sql)){

    $b['id'] = $a['id'];
    $b['userpelapor'] = $a['user_pelapor'];
    $b['unitkerja'] = $a['unit_kerja'];
    $b['keterangan'] = $a['keterangan'];
    $b['statusabnormalitas'] = $a['status_abnormalitas'];
    $b['prioritas'] = $a['prioritas'];
    $b['gambar'] = $a['gambar'];
    $b['gambarsesudah'] = $a['gambar_sesudah'];
    $b['lokasi'] = $a['lokasi'];
    $b['koordinat'] = $a['koordinat'];
    $b['ketinggian'] = $a['ketinggian'];
    $b['pic'] = $a['pic'];
    $b['tanggalinput'] = $a['tanggal_input'];
    $b['tanggalselesai'] = $a['tanggal_selesai'];
    $b['idUsers'] = $a['idUsers'];

    array_push($response,$b);

}

echo json_encode($response);

?>