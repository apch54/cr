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
    'color_effect'      => true,
    
    'vx0'               => 120,   // velocity sprite
    'dvx0_per_level'    => 1.15,  // variation of vx0 per level; >1
    
    'dx'				=> 70, 	 // separation between 2 sweepers (stairs)
    'dx_step_per_score' => .2    // variation of step (sweepers) depending on score( 60)

);

//REGIEREPLACE
