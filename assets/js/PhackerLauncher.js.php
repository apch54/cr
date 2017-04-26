<?php
require_once dirname(__FILE__).'/../../config.php';
$type = $_GET['type'];
$reSpriteSheet = '/(.+)SPR([0-9]+).(png|jpg)/';
$reImage = '/(.+).(png|jpg)/';
$pathToGameAssets = 'products/'.PRODUCT.'/design/'.$type.'/'.$type.'_gameplay/game_objects/';
$fullPathToGameAssets = dirname(__FILE__)."/../../".$pathToGameAssets;
$colors = json_decode(file_get_contents(dirname(__FILE__).'/../../products/'.PRODUCT.'/design/colors.json'));

$audio_endpoint = dirname(__FILE__).'/../../products/'.PRODUCT.'/audio/';

function getDirContents($dir, $filter = '', &$results = array()) {
    $files = scandir($dir);

    foreach($files as $key => $value){
        $path = realpath($dir.DIRECTORY_SEPARATOR.$value);

        if(!is_dir($path)) {
            if(empty($filter) || preg_match($filter, $path)) $results[] = $path;
        } elseif($value != "." && $value != "..") {
            getDirContents($path, $filter, $results);
        }
    }

    return $results;
}

function getRelativePath($relativePath){
    if (strtoupper(substr(PHP_OS, 0, 3)) === 'WIN') :
        $relativePath = str_replace('\\', '/', $relativePath);
        $here = $_SERVER["DOCUMENT_ROOT"];
        
        $str = str_replace($here, '', $relativePath);
        
        $str = str_replace('\\', '/', $str);
        return $str;
    else :
        $here = str_replace( '/assets/js', '', dirname(__FILE__).'/' );

        return str_replace($here, '', $relativePath);
    endif;
}

?>
(function() {
    var game;

    game = new Phacker.Game(<?php print urldecode($_GET['p']); ?>);

    game.setGameState(YourGame);

    game.setSpecificAssets(function() {
        <?php
            foreach(getDirContents($fullPathToGameAssets, $reImage) as $file) :
                $fullFile = $file;
                $file = basename($file);
                if(preg_match($reImage, $file, $imgMatches)) :
                    if(preg_match($reSpriteSheet, $file, $sprMatches)) :
                        $sprName = $sprMatches[1];
                        $nbFrames = $sprMatches[2];
                        $size = getimagesize($fullFile);
                        $sprWidth = $size[0];
                        $sprHeight = $size[1];
                        print "this.game.load.spritesheet('".$sprName."', '".getRelativePath($fullFile)."', ".round($sprWidth/$nbFrames).", ".$sprHeight.");\n";
                    else :
                        print "this.game.load.image('".$imgMatches[1]."', '".getRelativePath($fullFile)."');\n";
                    endif;
                endif;
            endforeach;
        ?>

        this.game.load.audio('winSound', '<?php print file_get_contents($audio_endpoint.'good_action.txt'); ?>');
        this.game.load.audio('lostSound', '<?php print file_get_contents($audio_endpoint.'bad_action.txt'); ?>');
        this.game.load.audio('bonusSound', '<?php print file_get_contents($audio_endpoint.'bonus.txt'); ?>');
        this.game.load.audio('gameOverStateSound', '<?php print file_get_contents($audio_endpoint.'lose.txt'); ?>');
        this.game.load.audio('winStateSound', '<?php print file_get_contents($audio_endpoint.'win.txt'); ?>');

        this.game.load.audio('nextLevelSound', '<?php print file_get_contents($audio_endpoint.'next_level.txt'); ?>');
        this.game.load.audio('jumpSound', '<?php print file_get_contents($audio_endpoint.'jump.txt'); ?>');
        this.game.load.audio('loopSound', '<?php print file_get_contents($audio_endpoint.'loop.txt'); ?>');
    });

    game.setTextColorGameOverState('<?php print $colors->text_color_gameover ?>');
    game.setTextColorWinState('<?php print $colors->text_color_win ?>');
    game.setTextColorStatus('<?php print $colors->text_color_statusbar ?>');
    game.setOneTwoThreeColorLoading('<?php print $colors->text_color_onetwothree_loading ?>');
    game.setOneTwoThreeColorIntro('<?php print $colors->text_color_onetwothree_intro ?>');
    game.setLoaderColor(0x<?php print str_replace('#', '', $colors->color_loader) ?>);
    game.setTimerColor(0x<?php print str_replace('#', '', $colors->color_timer) ?>);
    game.setTimerBgColor(0x<?php print str_replace('#', '', $colors->color_timer_bg) ?>);

    this.pauseGame = function() {
        return game.game.paused = true;
    };

    this.replayGame = function() {
        return game.game.paused = false;
    };

    this.GCSRelaunch = function() {
        return game.GCSRelaunch();
    };

    this.GCSNotElig = function() {
        return game.GCSNotElig();
    };

    game.run();

}).call(this);
