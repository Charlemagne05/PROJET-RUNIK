<?php

$host = 'localhost';
$dbname = 'runik-shop';
$username = 'root';
$password = 'root'; 

try {
  $pdo = new PDO("mysql:host=localhost;port=8889;dbname=runik-shop;charset=utf8", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
} catch (PDOException $e) {
    echo "❌ Erreur de connexion : " . $e->getMessage();
    die();
}
?>
