<?php

$x = 0;    
$y = 1; 
//define the variable n and asignt it the value that is gonna be passed in the URL
$n = $_GET['n'];

//Set the for loop so I can make and display the fibonacci series
if($n != null){
    for($i=0;$i<=$n;$i++)
    { 
        if($i == 0){
            echo $i."<br />";
        }

        $z = $x + $y;    
        echo $z."<br />";         
        $x=$y;       
        $y=$z;     
    } 

}

?>