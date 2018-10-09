<?php $x = 0; $y = 1; $n = $_GET[n]; for($i=0;$i<=$n;$i++) { if($i == 0){ echo $i; } $z = $x + $y; echo $z."<br />"; $x=$y; $y=$z;} ?>
