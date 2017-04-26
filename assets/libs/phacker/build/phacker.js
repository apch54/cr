(function() {
  this.Phacker = {};

}).call(this);

(function() {
  Phacker.Game = (function() {
    function Game(options) {
      this.gameOptions = options;
      this.gameState = Phacker.GameState;
      this.countGCSRelaunch = 0;
      if (options.gcs) {
        this.GCSElig = true;
      } else {
        this.GCSElig = false;
      }
      if (!this.gameOptions.nativeIntersticielPonderation) {
        this.gameOptions.nativeIntersticielPonderation = 1;
      }
      if (!options.fullscreen) {
        this.game = new Phaser.Game(768, 500, Phaser.CANVAS, 'game-container', null, true);
      } else {
        this.game = new Phaser.Game(375, 559, Phaser.CANVAS, 'game-container', null, true);
      }
      this.game.state.add('loader', Phacker.LoaderState);
      this.game.state.add('intro', Phacker.StartState);
      this.game.state.add('jeu', this.gameState);
      this.game.state.add('gameOver', Phacker.GameOverState);
      this.game.state.add('win', Phacker.WinState);
      this.game.state.add('nextLevel', Phacker.NextLevelState);
      this.game.gameOptions = options;
      this.game.ge = {};
      this.game.isAdmobEligible = false;
    }

    Game.prototype.setGameState = function(state) {
      this.gameState = state;
      return this.game.state.add('jeu', this.gameState);
    };

    Game.prototype.setSpecificAssets = function(cb) {
      Phacker.LoaderState.prototype.specificAssets = cb;
      return this.game.state.add('loader', Phacker.LoaderState);
    };

    Game.prototype.setTextColorGameOverState = function(color) {
      return Phacker.GameOverState.prototype.textColor = color;
    };

    Game.prototype.setTextColorWinState = function(color) {
      Phacker.WinState.prototype.textColor = color;
      return Phacker.NextLevelState.prototype.textColor = color;
    };

    Game.prototype.setTextColorStatus = function(color) {
      return Phacker.GameState.prototype.statusBarTextColor = color;
    };

    Game.prototype.setOneTwoThreeColorLoading = function(color) {
      return Phacker.LoaderState.prototype.OneTwoThreeColor = color;
    };

    Game.prototype.setOneTwoThreeColorIntro = function(color) {
      return Phacker.StartState.prototype.OneTwoThreeColor = color;
    };

    Game.prototype.setLoaderColor = function(color) {
      return Phacker.LoaderState.prototype.loaderColor = color;
    };

    Game.prototype.setTimerColor = function(color) {
      return Phacker.GameState.prototype.timerColor = color;
    };

    Game.prototype.setTimerBgColor = function(color) {
      return Phacker.GameState.prototype.timerBgColor = color;
    };

    Game.prototype.GCSNotElig = function() {
      return this.GCSElig = false;
    };

    Game.prototype.GCSRelaunch = function() {
      if (this.GCSElig) {
        if (this.countGCSRelaunch === 0) {
          this.gameOptions.duration = this.gameOptions.duration_refill;
          this.gameOptions.life = this.gameOptions.life_refill;
          this.game.state.start('jeu');
          return this.countGCSRelaunch++;
        }
      }
    };

    Game.prototype.IncentAdmobRelaunch = function() {
      if (isNativeMode && this.game.isAdmobEligible) {
        if (!this.gameOptions.incent_admob_life_refill) {
          this.game.ge.nb_life = 1;
        } else {
          this.game.ge.nb_life = this.gameOptions.incent_admob_life_refill;
        }
        if ((this.gameOptions.incent_admob_relaunch_preserve_time == null) || !this.gameOptions.incent_admob_relaunch_preserve_time) {
          delete this.game.ge.remainingTime;
        }
        return this.game.state.start('jeu');
      }
    };

    Game.prototype.IncentAdmobEligible = function() {
      if (isNativeMode) {
        return this.game.isAdmobEligible = true;
      }
    };

    Game.prototype.run = function() {
      return this.game.state.start('loader');
    };

    return Game;

  })();

}).call(this);

(function() {
  Phacker.BaseState = (function() {
    function BaseState() {}

    BaseState.prototype.create = function() {
      var fullscreen;
      if (this.game.gameOptions.fullscreen === false && detectmob()) {
        fullscreen = this.game.add.button(0, 0, 'view_full', function() {
          return onClickBackgroundHack();
        }, this, 0, 0, 0);
        fullscreen.x = this.game.width - fullscreen.width - 50;
        fullscreen.y = 50;
        return fullscreen.fixedToCamera = true;
      }
    };

    return BaseState;

  })();

}).call(this);

(function() {
  var pointToLevel,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  pointToLevel = function(ptl1, ptnl, x) {
    if (x === 1) {
      return ptl1;
    }
    return pointToLevel(ptl1, ptnl, x - 1) + (pointToLevel(ptl1, ptnl, x - 1) * ptnl);
  };

  Phacker.GameOverState = (function(superClass) {
    extend(GameOverState, superClass);

    function GameOverState() {
      return GameOverState.__super__.constructor.apply(this, arguments);
    }

    GameOverState.prototype.textColor = '#ffffff';

    GameOverState.prototype.create = function() {
      var area, background, character, closeButton, duration, finalScoreTitle, gameOverStateSound, logo, nb_cvr, replayButton, videoIncent;
      if (typeof hackBottomFullScreen === "function") {
        hackBottomFullScreen('lose');
      }
      gameOverStateSound = this.game.add.audio('gameOverStateSound');
      gameOverStateSound.play();
      this.game.input.touch.preventDefault = false;
      duration = Math.round((this.game.ge.generalTimer._now - this.game.ge.generalTimer._started) / 1000);
      nb_cvr = Math.round(pointToLevel(this.game.gameOptions.pointToLevel1, this.game.gameOptions.percentToNextLevel, this.game.gameOptions.winningLevel));
      callback(this.game.gameOptions.loseCallback, this.game.ge.score, this.game.ge.nb_replay, this.game.ge.heart.length, duration, nb_cvr, false);
      background = this.game.add.image(0, 0, "gameover_bg");
      area = this.game.add.image(0, 0, "gameover_area");
      logo = this.game.add.image(0, 0, "gameover_logo");
      character = this.game.add.image(0, 0, "gameover_character");
      replayButton = this.game.add.button(0, 0, 'retry_button', null, 0, 1, 2);
      replayButton.events.onInputDown.addOnce((function() {
        this.game.ge.score = 0;
        if (this.game.gameOptions.pub_ads_game) {
          console.log("AFG");
          afg();
        }
        this.game.ge.nb_replay++;
        delete this.game.ge.nb_life;
        delete this.game.ge.remainingTime;
        this.game.ge.level = 0;
        return this.game.state.start('jeu');
      }).bind(this));
      closeButton = this.game.add.button(0, 0, 'close_btn', (function() {
        return window.location = this.game.gameOptions.closeRedirectLose;
      }), 0, 1, 0);
      area.x = this.game.width * 0.5 - area.width * 0.5;
      area.y = this.game.height * 0.5 - area.height * 0.5;
      replayButton.x = this.game.width * 0.5 - replayButton.width * 0.5;
      replayButton.y = this.game.height - replayButton.height - 22;
      logo.x = this.game.width * 0.5 - logo.width * 0.5;
      logo.y = area.y * 0.5 - logo.height * 0.5;
      character.x = this.game.width * 0.5 - character.width * 0.5;
      character.y = area.y + area.height - character.height;
      closeButton.x = area.x + area.width - (closeButton.width * 0.5);
      closeButton.y = area.y - closeButton.height * 0.5;
      finalScoreTitle = this.game.add.text(0, 0, "Score :\n" + this.game.ge.score, {
        font: 'normal 36pt Helvetica',
        fill: this.textColor,
        align: 'center'
      });
      finalScoreTitle.x = this.game.width * 0.5 - finalScoreTitle.width * 0.5;
      finalScoreTitle.y = area.y + (character.y - area.y) * 0.5 - finalScoreTitle.height * 0.5;
      if (isNativeMode && this.game.isAdmobEligible) {
        finalScoreTitle.setText("Score : " + this.game.ge.score);
        finalScoreTitle.fontSize = 30;
        finalScoreTitle.fontWeight = 'bold';
        finalScoreTitle.x = this.game.width * 0.5 - finalScoreTitle.width * 0.5;
        finalScoreTitle.y = area.y + 15;
        videoIncent = this.game.add.sprite(0, 0, 'incent_video');
        videoIncent.x = this.game.width * 0.5 - videoIncent.width * 0.5;
        videoIncent.y = finalScoreTitle.y + finalScoreTitle.height + 15;
        videoIncent.inputEnabled = true;
        videoIncent.events.onInputDown.add(function() {
          console.log('INCENT ADMOB');
          return videoIncent.destroy();
        }, this);
        videoIncent.animations.add('run');
        videoIncent.animations.play('run', 15, true);
      }
      return GameOverState.__super__.create.call(this);
    };

    return GameOverState;

  })(Phacker.BaseState);

}).call(this);

(function() {
  var pointToLevel,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  pointToLevel = function(ptl1, ptnl, x) {
    if (x === 1) {
      return ptl1;
    }
    return pointToLevel(ptl1, ptnl, x - 1) + (pointToLevel(ptl1, ptnl, x - 1) * ptnl);
  };

  Phacker.GameState = (function(superClass) {
    extend(GameState, superClass);

    function GameState() {
      return GameState.__super__.constructor.apply(this, arguments);
    }

    GameState.prototype.statusBarTextColor = 'white';

    GameState.prototype.timerColor = 0x666666;

    GameState.prototype.timerBgColor = 0xffffff;

    GameState.prototype.create = function() {
      if (typeof hackBottomFullScreen === "function") {
        hackBottomFullScreen('gameplay');
      }
      GameState.__super__.create.call(this);
      this.loopSound = this.game.add.audio('loopSound');
      this.loopSound.play('', 0, 1, true);
      this.game.input.touch.preventDefault = true;
      if (this.game.gameOptions.pub_ads_game && this.game.gameOptions.afg_start) {
        this.game.paused = true;
      }
      if (this.game.gameOptions.durationByLevel == null) {
        this.game.gameOptions.durationByLevel = true;
      }
      if (this.game.ge.remainingTime == null) {
        this.game.ge.remainingTime = this.game.gameOptions.duration;
      }
      this.game.ge.generalTimer = this.game.time.create();
      this.game.ge.generalTimer.add(this.game.ge.remainingTime * 1000, (function() {
        if (this.game.ge.level >= this.game.gameOptions.winningLevel && this.game.gameOptions.timingTemps === true && this.game.ge.generalTimer.duration === 0 && this.game.ge.nowinagain === true) {
          this.game.ge.nowinagain = false;
          this.game.state.start('win');
          return this.cutLoop();
        } else {
          if (this.game.ge.nb_replay % this.game.gameOptions.nativeIntersticielPonderation === 0) {
            console.log("native");
          }
          return this.endGame();
        }
      }).bind(this));
      this.game.ge.generalTimer.start();
      this.statusBar = this.game.add.image(0, 0, 'status_bar');
      this.statusBar.fixedToCamera = true;
      this.timerBase = this.game.add.graphics(0, 0);
      this.timerBase.beginFill(this.timerBgColor, 1);
      this.timerBase.drawRect(0, 0, this.statusBar.width * 0.25, 10);
      this.timerBase.graphicsData[0].shape.x = this.statusBar.width * 0.5 - this.timerBase.graphicsData[0].shape.width * 0.5;
      this.timerBase.graphicsData[0].shape.y = this.statusBar.height * 0.5 - this.timerBase.graphicsData[0].shape.height * 0.5;
      this.timerBase.fixedToCamera = true;
      this.remainingTime = this.game.add.graphics(0, 0);
      this.remainingTime.beginFill(this.timerColor, 1);
      this.remainingTime = this.remainingTime.drawRect(0, 0, 0, this.timerBase.graphicsData[0].shape.height);
      this.remainingTime.graphicsData[0].shape.x = this.timerBase.graphicsData[0].shape.x;
      this.remainingTime.graphicsData[0].shape.y = this.timerBase.graphicsData[0].shape.y;
      this.remainingTime.fixedToCamera = true;
      this.chronos = this.game.add.image(0, 0, 'chronos');
      this.chronos.x = this.timerBase.graphicsData[0].shape.x - this.chronos.width - 5;
      this.chronos.y = this.statusBar.height * 0.5 - this.chronos.height * 0.5;
      this.chronos.fixedToCamera = true;
      this.scoreIcon = this.game.add.image(0, 0, 'scoreicon');
      this.scoreIcon.x = this.statusBar.x + 20;
      this.scoreIcon.y = this.statusBar.height * 0.5 - this.scoreIcon.height * 0.5;
      this.scoreIcon.fixedToCamera = true;
      this.scoreText = this.game.add.text(0, 0, this.game.ge.score, {
        font: 'bold 18pt Lobster',
        fill: this.statusBarTextColor
      });
      this.scoreText.x = this.scoreIcon.x + this.scoreIcon.width + 10;
      this.scoreText.y = this.statusBar.height * 0.5 - this.scoreText.height * 0.5;
      this.scoreText.fixedToCamera = true;
      this.levelText = this.game.add.text(0, 0, this.game.ge.level, {
        font: 'bold 18pt Lobster',
        fill: this.statusBarTextColor
      });
      this.levelText.x = this.statusBar.x + this.statusBar.width - this.levelText.width - 20;
      this.levelText.y = this.statusBar.height * 0.5 - this.levelText.height * 0.5;
      this.levelText.fixedToCamera = true;
      this.levelIcon = this.game.add.image(0, 0, 'statusbarpump');
      this.levelIcon.x = this.levelText.x - this.levelIcon.width - 10;
      this.levelIcon.y = this.statusBar.height * 0.5 - this.levelIcon.height * 0.5;
      this.levelIcon.fixedToCamera = true;
      if (this.game.gameOptions.fullscreen) {
        this.timerBase.graphicsData[0].shape.y = 10;
        this.remainingTime.graphicsData[0].shape.y = 10;
      }
      this.deadlifeInit();
      return this.lifeInit();
    };

    GameState.prototype.nextLevel = function() {
      this.game.ge.level++;
      this.game.ge.remainingTime = Math.round(this.game.ge.generalTimer.duration / 1000);
      if (this.game.gameOptions.winningLevel > 1 && this.game.gameOptions.winningLevel !== this.game.ge.level) {
        this.game.state.start('nextLevel');
        return this.cutLoop();
      }
    };

    GameState.prototype.update = function() {
      this.remainingTime.graphicsData[0].shape.width = this.game.ge.generalTimer.duration * this.statusBar.width / 4 / (this.game.gameOptions.duration * 1000);
      if (this.game.ge.level >= this.game.gameOptions.winningLevel && this.game.gameOptions.timingTemps === false && this.game.ge.nowinagain === true) {
        this.game.ge.nowinagain = false;
        this.game.state.start('win');
        this.cutLoop();
      }
      if (this.game.ge.level === 0) {
        if (this.game.ge.score >= this.game.gameOptions.pointToLevel1) {
          return this.nextLevel();
        }
      } else {
        if (this.game.ge.score >= pointToLevel(this.game.gameOptions.pointToLevel1, this.game.gameOptions.percentToNextLevel, this.game.ge.level + 1)) {
          return this.nextLevel();
        }
      }
    };

    GameState.prototype.win = function() {
      var winSound;
      winSound = this.game.add.audio('winSound');
      winSound.play();
      this.game.ge.score += this.game.gameOptions.pointEarned;
      this.scoreText.setText(this.game.ge.score);
      this.scoreText.x = this.scoreIcon.x + this.scoreIcon.width + 10;
      return this.scoreText.y = this.statusBar.height * 0.5 - this.scoreText.height * 0.5;
    };

    GameState.prototype.winBonus = function() {
      var bonusSound;
      bonusSound = this.game.add.audio('bonusSound');
      bonusSound.play();
      this.game.ge.score += this.game.gameOptions.pointBonus;
      this.scoreText.setText(this.game.ge.score);
      this.scoreText.x = this.scoreIcon.x + this.scoreIcon.width + 10;
      return this.scoreText.y = this.statusBar.height * 0.5 - this.scoreText.height * 0.5;
    };

    GameState.prototype.lost = function() {
      var lostSound;
      lostSound = this.game.add.audio('lostSound');
      lostSound.play();
      this.game.ge.score = Math.max(0, this.game.ge.score - this.game.gameOptions.pointLost);
      this.scoreText.setText(this.game.ge.score);
      this.scoreText.x = this.scoreIcon.x + this.scoreIcon.width + 10;
      return this.scoreText.y = this.statusBar.height * 0.5 - this.scoreText.height * 0.5;
    };

    GameState.prototype.lostLife = function() {
      var lastElement;
      lastElement = this.game.ge.heart[this.game.ge.heart.length - 1];
      lastElement.destroy();
      this.game.ge.heart.pop();
      this.game.ge.nb_life--;
      this.lost();
      if (this.game.ge.heart.length === 0) {
        this.game.time.events.add(Phaser.Timer.SECOND * 2, this.endGame, this);
        if (this.game.ge.nb_replay % this.game.gameOptions.nativeIntersticielPonderation === 0) {
          console.log("native");
        }
      } else {
        this.game.time.events.add(Phaser.Timer.SECOND * 2, this.resetPlayer, this);
      }
    };

    GameState.prototype.jump = function() {
      var jumpSound;
      jumpSound = this.game.add.audio('jumpSound');
      return jumpSound.play();
    };

    GameState.prototype.endGame = function() {
      this.game.ge.remainingTime = Math.round(this.game.ge.generalTimer.duration / 1000);
      this.game.state.start('gameOver');
      return this.cutLoop();
    };

    GameState.prototype.cutLoop = function() {
      return this.loopSound.destroy();
    };

    GameState.prototype.isFullScreen = function() {
      return this.game.gameOptions.fullscreen;
    };

    GameState.prototype.lifeInit = function() {
      var heartImg;
      var heartImg, i, lastElement;
      if (this.game.ge.nb_life == null) {
        this.game.ge.nb_life = this.game.gameOptions.life;
      }
      this.game.ge.heart = [];
      i = 0;
      console.log(this.game.ge.nb_life);
      while (i < this.game.ge.nb_life) {
        if (this.game.gameOptions.fullscreen === false) {
          if (this.game.ge.heart.length === 0) {
            heartImg = this.game.add.image(0, this.statusBar.y + 15, 'heart');
            heartImg.x = this.timerBase.graphicsData[0].shape.x + this.timerBase.graphicsData[0].shape.width + 20;
            heartImg.y = this.statusBar.height * 0.5 - heartImg.height * 0.5;
          } else {
            lastElement = this.game.ge.heart[this.game.ge.heart.length - 1];
            heartImg = this.game.add.image(0, 0, 'heart');
            heartImg.x = lastElement.x + lastElement.width + 5;
            heartImg.y = lastElement.y;
            lastElement.fixedToCamera = true;
          }
          heartImg.fixedToCamera = true;
          this.game.ge.heart.push(heartImg);
          i++;
        } else {
          if (this.game.ge.heart.length === 0) {
            heartImg = this.game.add.image(0, 28, 'heart');
            heartImg.scale.setTo(0.7, 0.7);
            heartImg.x = 140;
          } else {
            lastElement = this.game.ge.heart[this.game.ge.heart.length - 1];
            heartImg = this.game.add.image(lastElement.x + lastElement.width + 2, 28, 'heart');
            lastElement.fixedToCamera = true;
          }
          heartImg.fixedToCamera = true;
          heartImg.scale.setTo(0.7, 0.7);
          this.game.ge.heart.push(heartImg);
          i++;
        }
      }
    };

    GameState.prototype.deadlifeInit = function() {
      var heartImg1;
      var heartImg1, i, lastElement;
      this.game.ge.deadheart = [];
      i = 0;
      if (this.game.gameOptions.fullscreen === false) {
        while (i < this.game.gameOptions.life) {
          if (this.game.ge.deadheart.length === 0) {
            heartImg1 = this.game.add.image(0, 0, 'dead');
            heartImg1.x = this.timerBase.graphicsData[0].shape.x + this.timerBase.graphicsData[0].shape.width + 20;
            heartImg1.y = this.statusBar.height * 0.5 - heartImg1.height * 0.5;
          } else {
            lastElement = this.game.ge.deadheart[this.game.ge.deadheart.length - 1];
            heartImg1 = this.game.add.image(0, 0, 'dead');
            heartImg1.x = lastElement.x + lastElement.width + 5;
            heartImg1.y = lastElement.y;
            lastElement.fixedToCamera = true;
          }
          heartImg1.fixedToCamera = true;
          this.game.ge.deadheart.push(heartImg1);
          i++;
        }
      } else {
        while (i < this.game.gameOptions.life) {
          if (this.game.ge.deadheart.length === 0) {
            heartImg1 = this.game.add.image(0, 28, 'dead');
            heartImg1.scale.setTo(0.7, 0.7);
            heartImg1.x = 140;
          } else {
            lastElement = this.game.ge.deadheart[this.game.ge.deadheart.length - 1];
            heartImg1 = this.game.add.image(lastElement.x + lastElement.width + 2, 28, 'dead');
            heartImg1.scale.setTo(0.7, 0.7);
            lastElement.fixedToCamera = true;
          }
          heartImg1.fixedToCamera = true;
          this.game.ge.deadheart.push(heartImg1);
          i++;
        }
      }
    };

    return GameState;

  })(Phacker.BaseState);

}).call(this);

(function() {
  Phacker.LoaderState = (function() {
    function LoaderState() {}

    LoaderState.prototype.loaderColor = 0x666666;

    LoaderState.prototype.OneTwoThreeColor = 'white';

    LoaderState.prototype.nextState = 'intro';

    LoaderState.prototype.specificAssets = function() {};

    LoaderState.prototype.create = function() {
      return typeof hackBottomFullScreen === "function" ? hackBottomFullScreen('loader') : void 0;
    };

    LoaderState.prototype.preload = function() {
      var i, loaderFiles, loaderFilesProgress, lvl, signalFile, type;
      this.game.load.enableParallel = false;
      this.game.scale.scaleMode = Phaser.ScaleManager.SHOW_ALL;
      this.game.input.touch.preventDefault = false;
      if (this.game.gameOptions.fullscreen === true) {
        type = "mobile";
      } else {
        type = "desktop";
      }
      this.game.load.spritesheet('loadinghack', root_design + type + '/' + type + '_states/' + type + '_loading/' + type + '_loading_sprite.jpg', this.game.width, this.game.height);
      this.game.load.image('intro_bg', root_design + type + '/' + type + '_states/' + type + '_intro/intro_bg.jpg');
      this.game.load.image('intro_logo', root_design + type + '/' + type + '_states/' + type + '_intro/intro_logo.png');
      this.game.load.image('intro_area', root_design + type + '/' + type + '_states/' + type + '_intro/intro_area.png');
      this.game.load.image('intro_vig', root_design + type + '/' + type + '_states/' + type + '_intro/intro_vig.jpg');
      this.game.load.spritesheet('startButton', root_design + type + '/' + type + '_states/' + type + '_intro/start_btn.png', 200, 58);
      this.game.load.image('gameover_bg', root_design + type + '/' + type + '_states/' + type + '_gameover/gameover_bg.jpg');
      this.game.load.image('gameover_area', root_design + type + '/' + type + '_states/' + type + '_gameover/gameover_area.png');
      this.game.load.image('gameover_logo', root_design + type + '/' + type + '_states/' + type + '_gameover/gameover_txt.png');
      this.game.load.image('gameover_character', root_design + type + '/' + type + '_states/' + type + '_gameover/gameover_character.png');
      this.game.load.spritesheet('retry_button', root_design + type + '/' + type + '_states/' + type + '_gameover/retry_btn.png', 200, 58);
      this.game.load.spritesheet('incent_video', root_design + 'mobile/mobile_states/mobile_gameover/onemore_lifeSPR6.png', 200, 85);
      this.game.load.image('close_btn', root_design + type + '/' + type + '_states/close_btn.png');
      this.game.load.image('view_full', root_design + type + '/' + type + '_states/view_full.png');
      this.game.load.image('win_bg', root_design + type + '/' + type + '_states/' + type + '_win/win_bg.jpg');
      this.game.load.image('win_area', root_design + type + '/' + type + '_states/' + type + '_win/win_area.png');
      this.game.load.image('win_logo', root_design + type + '/' + type + '_states/' + type + '_win/win_txt.png');
      this.game.load.image('win_character', root_design + type + '/' + type + '_states/' + type + '_win/win_reward_txt.png');
      this.game.load.spritesheet('continue_button', root_design + type + '/' + type + '_states/' + type + '_win/continue_btn.png', 200, 58);
      this.game.load.image('lock', root_design + type + '/' + type + '_states/' + type + '_level/box_lock.png');
      this.game.load.image('level_complete', root_design + type + '/' + type + '_states/' + type + '_level/level_completed.png');
      for (lvl = i = 1; i <= 9; lvl = ++i) {
        this.game.load.image('level' + lvl, root_design + type + '/' + type + '_states/' + type + '_level/box' + lvl + '.png');
        this.game.load.image('level_hover' + lvl, root_design + type + '/' + type + '_states/' + type + '_level/hover/box' + lvl + '.png');
      }
      this.game.load.image('status_bar', root_design + type + '/' + type + '_gameplay/statusbar_bg.png');
      this.game.load.image('scoreicon', root_design + type + '/' + type + '_gameplay/score_icon.png');
      this.game.load.image('chronos', root_design + type + '/' + type + '_gameplay/timer.png');
      this.game.load.image('statusbarpump', root_design + type + '/' + type + '_gameplay/level_icon.png');
      this.game.load.image('heart', root_design + type + '/' + type + '_gameplay/remaining_life.png');
      this.game.load.image('dead', root_design + type + '/' + type + '_gameplay/used_life.png');
      this.specificAssets();
      loaderFiles = this.game.add.graphics();
      loaderFiles.beginFill(0x00c6ff, 0);
      loaderFiles.drawRect(this.game.width / 2 - (this.game.width * 0.75) / 2, this.game.height * 0.5, this.game.width * 0.75, 30);
      loaderFilesProgress = this.game.add.graphics();
      loaderFilesProgress.beginFill(0x00c6ff, 1);
      loaderFilesProgress.drawRect(this.game.width / 2 - (this.game.width * 0.75) / 2, this.game.height * 0.5, 0, 30);
      return signalFile = this.game.load.onFileComplete.add((function(eta, key) {
        var background, fullscreen, style, txt1, txt2, txt3;
        if (key === "loadinghack") {
          background = this.game.add.sprite(0, 0, 'loadinghack');
          background.animations.add('play', [0, 1, 2, 3], 5, true);
          background.play('play');
          style = {
            font: 'Arial',
            fill: this.OneTwoThreeColor,
            align: 'center',
            fontSize: "16px"
          };
          txt1 = this.game.add.text(0, 0, tutoTexts.first, style);
          txt1.x = this.game.width * 0.5 - txt1.width * 0.5;
          txt1.y = 315;
          txt2 = this.game.add.text(0, 0, tutoTexts.second, style);
          txt2.x = this.game.width * 0.5 - txt2.width * 0.5;
          txt2.y = 340;
          txt3 = this.game.add.text(0, 0, tutoTexts.third, style);
          txt3.x = this.game.width * 0.5 - txt3.width * 0.5;
          txt3.y = 365;
        }
        if (key === "view_full") {
          if (this.game.gameOptions.fullscreen === false && detectmob()) {
            fullscreen = this.game.add.button(0, 0, 'view_full', function() {
              return onClickBackgroundHack();
            }, this, 0, 0, 0);
            fullscreen.x = this.game.width - fullscreen.width - 50;
            fullscreen.y = 50;
          }
        }
        if (eta === 100) {
          loaderFiles.destroy();
          loaderFilesProgress.destroy();
          signalFile.detach();
          return this.game.state.start(this.nextState);
        } else {
          loaderFilesProgress.destroy();
          loaderFilesProgress = this.game.add.graphics();
          loaderFilesProgress.beginFill(this.loaderColor, 1);
          if (this.game.gameOptions.fullscreen === false) {
            return loaderFilesProgress.drawRect(100, 400, loaderFiles.graphicsData[0].shape.width * eta / 100, 30);
          } else {
            return loaderFilesProgress.drawRect(50, 450, loaderFiles.graphicsData[0].shape.width * eta / 100, 20);
          }
        }
      }).bind(this));
    };

    return LoaderState;

  })();

}).call(this);

(function() {
  var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  Phacker.NextLevelState = (function(superClass) {
    extend(NextLevelState, superClass);

    function NextLevelState() {
      return NextLevelState.__super__.constructor.apply(this, arguments);
    }

    NextLevelState.prototype.textColor = '#ffffff';

    NextLevelState.prototype.update = function() {
      if (this.clickableLevel.alive) {
        if (this.nextLevelScaleDirection === 'up') {
          this.clickableLevel.scale.x += 0.005;
          this.clickableLevel.scale.y += 0.005;
          if (this.clickableLevel.scale.x > 1.1) {
            this.nextLevelScaleDirection = 'down';
          }
        }
        if (this.nextLevelScaleDirection === 'down') {
          this.clickableLevel.scale.x -= 0.005;
          this.clickableLevel.scale.y -= 0.005;
          if (this.clickableLevel.scale.x < 0.9) {
            return this.nextLevelScaleDirection = 'up';
          }
        }
      }
    };

    NextLevelState.prototype.create = function() {
      var area, background, button, col, duration, finalScoreTitle, i, key, logo, lvlNumber, nextLevelSound, replayButton, row, spacingButtons;
      this.nextLevelScaleDirection = 'up';
      if (typeof hackBottomFullScreen === "function") {
        hackBottomFullScreen('win');
      }
      nextLevelSound = this.game.add.audio('nextLevelSound');
      nextLevelSound.play();
      duration = Math.round((this.game.ge.generalTimer._now - this.game.ge.generalTimer._started) / 1000);
      this.game.input.touch.preventDefault = false;
      this.game.ge.resultTitle = this.game.add.text(0, 0, 'Score : ', {
        font: 'normal 17pt Helvetica',
        fill: '#585858'
      });
      this.game.ge.resultTitle.x = 200;
      this.game.ge.resultTitle.y = 200;
      background = this.game.add.image(0, 0, "win_bg");
      area = this.game.add.image(0, 0, "win_area");
      logo = this.game.add.image(0, 0, "level_complete");
      replayButton = this.game.add.button(0, 0, 'continue_button', function() {
        if (this.game.gameOptions.durationByLevel) {
          delete this.game.ge.remainingTime;
        }
        return this.game.state.start('jeu');
      }, 0, 1, 0);
      area.x = this.game.width * 0.5 - area.width * 0.5;
      area.y = this.game.height * 0.5 - area.height * 0.5;
      replayButton.x = this.game.width * 0.5 - replayButton.width * 0.5;
      replayButton.y = this.game.height - replayButton.height - 22;
      logo.x = this.game.width * 0.5 - logo.width * 0.5;
      logo.y = area.y * 0.5 - logo.height * 0.5;
      finalScoreTitle = this.game.add.text(0, 0, "Score : " + this.game.ge.score, {
        font: 'normal 30pt Helvetica',
        fill: this.textColor,
        align: 'center'
      });
      finalScoreTitle.x = this.game.width * 0.5 - finalScoreTitle.width * 0.5;
      finalScoreTitle.y = area.y + 15;
      row = 0;
      spacingButtons = 15;
      for (lvlNumber = i = 0; i <= 8; lvlNumber = ++i) {
        col = (lvlNumber % 3) + 1;
        if (lvlNumber >= this.game.ge.level) {
          key = 'lock';
        } else {
          if (lvlNumber < this.game.ge.level - 1) {
            key = 'level_hover' + (lvlNumber + 1);
          } else {
            key = 'level' + (lvlNumber + 1);
          }
        }
        button = this.game.add.image(0, 0, key);
        if (col === 1) {
          row++;
          button.x = area.x + area.width * 0.5 - button.width * 0.5 - button.width - spacingButtons;
        }
        if (col === 2) {
          button.x = area.x + area.width * 0.5 - button.width * 0.5;
        }
        if (col === 3) {
          button.x = area.x + area.width * 0.5 - button.width * 0.5 + button.width + spacingButtons;
        }
        if (row === 1) {
          button.y = finalScoreTitle.y + finalScoreTitle.height + spacingButtons;
        }
        if (row === 2) {
          button.y = finalScoreTitle.y + finalScoreTitle.height + spacingButtons + button.height + spacingButtons;
        }
        if (row === 3) {
          button.y = finalScoreTitle.y + finalScoreTitle.height + spacingButtons + button.height + spacingButtons + button.height + spacingButtons;
        }
        if (lvlNumber + 1 === this.game.ge.level) {
          button.anchor.setTo(0.5);
          button.inputEnabled = true;
          button.events.onInputDown.addOnce((function() {
            if (this.game.gameOptions.durationByLevel) {
              delete this.game.ge.remainingTime;
            }
            return this.game.state.start('jeu');
          }).bind(this));
          this.clickableLevel = button;
          button.y += button.height / 2;
          button.x += button.width / 2;
        }
      }
      return NextLevelState.__super__.create.call(this);
    };

    return NextLevelState;

  })(Phacker.BaseState);

}).call(this);

(function() {
  var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  Phacker.StartState = (function(superClass) {
    extend(StartState, superClass);

    function StartState() {
      return StartState.__super__.constructor.apply(this, arguments);
    }

    StartState.prototype.OneTwoThreeColor = 'white';

    StartState.prototype.create = function() {
      var area, background, logo, startButton, style, txt1, txt2, txt3, vignette;
      if (typeof hackBottomFullScreen === "function") {
        hackBottomFullScreen('intro');
      }
      this.game.ge.nb_replay = 0;
      this.game.ge.score = 0;
      this.game.ge.level = 0;
      this.game.ge.nowinagain = true;
      this.game.input.touch.preventDefault = false;
      background = this.game.add.image(0, 0, 'intro_bg');
      logo = this.game.add.image(0, 0, 'intro_logo');
      area = this.game.add.image(0, 0, 'intro_area');
      vignette = this.game.add.sprite(0, 0, 'intro_vig');
      area.x = this.game.width * 0.5 - area.width * 0.5;
      area.y = this.game.height * 0.5 - area.height * 0.5;
      logo.x = this.game.width * 0.5 - logo.width * 0.5;
      logo.y = area.y * 0.5 - logo.height * 0.5;
      vignette.x = this.game.width * 0.5 - vignette.width * 0.5;
      vignette.y = area.y + area.height * 0.5 - vignette.height * 0.5;
      startButton = this.game.add.button(0, 0, 'startButton', function() {
        if (detectmob()) {
          onClickBackgroundHack();
        }
        if (this.game.gameOptions.pub_ads_game && this.game.gameOptions.afg_start) {
          console.log("AFG");
          afg();
        }
        return this.game.state.start('jeu');
      }, this, 1, 0, 1);
      startButton.x = this.game.width * 0.5 - startButton.width * 0.5;
      startButton.y = this.game.height - startButton.height - 22;
      startButton.onInputOver.add((function() {
        return this.game.canvas.style.cursor = "pointer";
      }).bind(this));
      startButton.onInputOut.add((function() {
        return this.game.canvas.style.cursor = "default";
      }).bind(this));
      style = {
        font: 'Arial',
        fill: this.OneTwoThreeColor,
        align: 'center',
        fontSize: "14px"
      };
      txt1 = this.game.add.text(0, 0, tutoTexts.first, style);
      txt2 = this.game.add.text(0, 0, tutoTexts.second, style);
      txt3 = this.game.add.text(0, 0, tutoTexts.third, style);
      vignette.y -= (txt1.height + txt2.height + txt3.height) / 2;
      txt1.x = this.game.width * 0.5 - txt1.width * 0.5;
      txt1.y = vignette.y + vignette.height + 5;
      txt2.x = this.game.width * 0.5 - txt2.width * 0.5;
      txt2.y = txt1.y + txt1.height;
      txt3.x = this.game.width * 0.5 - txt3.width * 0.5;
      txt3.y = txt2.y + txt2.height;
      return StartState.__super__.create.call(this);
    };

    return StartState;

  })(Phacker.BaseState);

}).call(this);

(function() {
  var pointToLevel,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  pointToLevel = function(ptl1, ptnl, x) {
    if (x === 1) {
      return ptl1;
    }
    return pointToLevel(ptl1, ptnl, x - 1) + (pointToLevel(ptl1, ptnl, x - 1) * ptnl);
  };

  Phacker.WinState = (function(superClass) {
    extend(WinState, superClass);

    function WinState() {
      return WinState.__super__.constructor.apply(this, arguments);
    }

    WinState.prototype.textColor = '#ffffff';

    WinState.prototype.isSubid = function() {
      var isSubid, s;
      isSubid = false;
      if (location.search !== "") {
        s = location.search.replace('?', '');
        s = s.split('&');
        s.forEach(function(param) {
          if (param.split('=')[0] === 'subid') {
            return isSubid = true;
          }
        });
      }
      return isSubid;
    };

    WinState.prototype.create = function() {
      var area, background, character, closeButton, duration, finalScoreTitle, logo, nb_cvr, replayButton, winStateSound;
      if (typeof hackBottomFullScreen === "function") {
        hackBottomFullScreen('win');
      }
      winStateSound = this.game.add.audio('winStateSound');
      winStateSound.play();
      duration = Math.round((this.game.ge.generalTimer._now - this.game.ge.generalTimer._started) / 1000);
      this.game.input.touch.preventDefault = false;
      if (this.isSubid()) {
        if (!this.game.ge.heart) {
          this.game.ge.heart = [];
        }
        nb_cvr = Math.round(pointToLevel(this.game.gameOptions.pointToLevel1, this.game.gameOptions.percentToNextLevel, this.game.gameOptions.winningLevel));
        if (this.game.gameOptions.secu_mini_percent_duration) {
          if (duration >= (this.game.gameOptions.duration * this.game.gameOptions.secu_mini_percent_duration / 100)) {
            if (callback2(this.game.gameOptions.winCallback, this.game.ge.score, this.game.ge.nb_replay, this.game.ge.heart.length, duration, nb_cvr, true)) {
              console.log("TNT");
            }
          }
        } else {
          if (callback2(this.game.gameOptions.winCallback, this.game.ge.score, this.game.ge.nb_replay, this.game.ge.heart.length, duration, nb_cvr, true)) {
            console.log("TNT");
          }
        }
      }
      this.game.ge.resultTitle = this.game.add.text(0, 0, 'Score : ', {
        font: 'normal 17pt Helvetica',
        fill: '#585858'
      });
      this.game.ge.resultTitle.x = 200;
      this.game.ge.resultTitle.y = 200;
      background = this.game.add.image(0, 0, "win_bg");
      area = this.game.add.image(0, 0, "win_area");
      logo = this.game.add.image(0, 0, "win_logo");
      character = this.game.add.image(0, 0, "win_character");
      if (!this.isSubid()) {
        character.visible = false;
      }
      replayButton = this.game.add.button(0, 0, 'continue_button', (function() {
        if (this.game.gameOptions.pub_ads_game) {
          console.log("AFG");
          afg();
        }
        this.game.ge.nb_replay++;
        delete this.game.ge.nb_life;
        delete this.game.ge.remainingTime;
        return this.game.state.start('nextLevel');
      }), 0, 1, 0);
      closeButton = this.game.add.button(0, 0, 'close_btn', (function() {
        return window.location = this.game.gameOptions.closeRedirectWin;
      }), 0, 1, 0);
      area.x = this.game.width * 0.5 - area.width * 0.5;
      area.y = this.game.height * 0.5 - area.height * 0.5;
      replayButton.x = this.game.width * 0.5 - replayButton.width * 0.5;
      replayButton.y = this.game.height - replayButton.height - 22;
      logo.x = this.game.width * 0.5 - logo.width * 0.5;
      logo.y = area.y * 0.5 - logo.height * 0.5;
      character.x = this.game.width * 0.5 - character.width * 0.5;
      character.y = area.y + area.height - character.height - 50;
      closeButton.x = area.x + area.width - (closeButton.width * 0.5);
      closeButton.y = area.y - closeButton.height * 0.5;
      finalScoreTitle = this.game.add.text(0, 0, "Score :\n" + this.game.ge.score, {
        font: 'normal 36pt Helvetica',
        fill: this.textColor,
        align: 'center'
      });
      finalScoreTitle.x = this.game.width * 0.5 - finalScoreTitle.width * 0.5;
      finalScoreTitle.y = area.y + (character.y - area.y) * 0.5 - finalScoreTitle.height * 0.5;
      return WinState.__super__.create.call(this);
    };

    return WinState;

  })(Phacker.BaseState);

}).call(this);
