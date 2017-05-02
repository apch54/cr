<?php

//Name of product used by the socle
define('PRODUCT', 'witch-escape');

$gameOptions = array(
	'duration' => 60,
	'pointEarned' => 5,
    'pointLost' => 15,
	'pointToLevel1' => 200,
    'winningLevel' =>1,
    'timingTemps'=> false,
    'percentToNextLevel' => 1.5,
    'life' => 3,
    'pointBonus' => 10,

    //Here You can add new specific parameters
    'vx0'               => 115,  // velocity sprite
    'dvx0_per_level    '=> 1.1 , // variation of vx0 per level
    'dx_step_per_score' => 1.1   // variation of step (sweepers) depending on score( 60)

);

//REGIEREPLACE
