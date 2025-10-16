<?php
require_once __DIR__ . '/includes/db_connect.php';

$stmt = $pdo->query("SHOW TABLES");
$tables = $stmt->fetchAll(PDO::FETCH_COLUMN);

echo "<h2>✅ Connexion réussie à la base <em>runik_shop</em></h2>";
echo "<h3>Tables détectées :</h3>";
echo "<ul>";
foreach ($tables as $table) {
    echo "<li>$table</li>";
}
echo "</ul>";
?>
